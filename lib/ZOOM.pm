# $Id: ZOOM.pm,v 1.4 2005-10-12 09:44:46 mike Exp $

use strict;
use warnings;
use Net::Z3950::ZOOM;


# Member naming convention: hash-element names which begin with an
# underscore represent underlying ZOOM-C object descriptors; those
# which lack them represent Perl's ZOOM objects.  (The same convention
# is used in naming local variables where appropriate.)
#
# So, for example, the ZOOM::Connection class has an {_conn} element,
# which is a pointer to the ZOOM-C Connection object; but the
# ZOOM::ResultSet class has a {conn} element, which is a reference to
# the Perl-level Connection object by which it was created.  (It may
# be that we find we have no need for these references, but for now
# they are retained.)
#
# To get at the underlying ZOOM-C connection object of a result-set
# (if you ever needed to do such a thing, which you probably don't)
# you'd use $rs->{conn}->_conn().

# ----------------------------------------------------------------------------

package ZOOM::Exception;

sub new {
    my $class = shift();
    my($code, $message, $addinfo) = @_;

    return bless {
	code => $code,
	message => $message,
	addinfo => $addinfo,
    }, $class;
}

sub code {
    my $this = shift();
    return $this->code();
}

sub message {
    my $this = shift();
    return $this->message();
}

sub addinfo {
    my $this = shift();
    return $this->addinfo();
}


# ----------------------------------------------------------------------------

package ZOOM::Connection;

sub new {
    my $class = shift();
    my($host, $port) = @_;

    my $_conn = Net::Z3950::ZOOM::connection_new($host, $port);
    my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");
    $errcode = Net::Z3950::ZOOM::connection_error($_conn, $errmsg, $addinfo);
    die new ZOOM::Exception($errcode, $errmsg, $addinfo) if $errcode;

    return bless {
	host => $host,
	port => $port,
	_conn => $_conn,
    };
}

# PRIVATE within this class
sub _conn {
    my $this = shift();

    my $_conn = $this->{_conn};
    die "{_conn} undefined: has this ResultSet been destroy()ed?"
	if !defined $_conn;

    return $_conn;
}

sub option {
    my $this = shift();
    my($key, $value) = @_;

    my $oldval = Net::Z3950::ZOOM::connection_option_get($this->_conn(), $key);
    Net::Z3950::ZOOM::connection_option_set($this->_conn(), $key, $value)
	if defined $value;

    return $oldval;
}

sub search_pqf {
    my $this = shift();
    my($query) = @_;

    my $_rs = Net::Z3950::ZOOM::connection_search_pqf($this->_conn(), $query);
    my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");
    $errcode = Net::Z3950::ZOOM::connection_error($this->_conn(),
						  $errmsg, $addinfo);
    die new ZOOM::Exception($errcode, $errmsg, $addinfo) if $errcode;

    return _new ZOOM::ResultSet($this, $query, $_rs);
}

sub destroy {
    my $this = shift();

    Net::Z3950::ZOOM::connection_destroy($this->_conn());
    $this->{_conn} = undef;
}


# ----------------------------------------------------------------------------

package ZOOM::ResultSet;

sub new {
    my $class = shift();
    die "You can't create $class objects directly";
}

# PRIVATE to ZOOM::Connection::search()
sub _new {
    my $class = shift();
    my($conn, $query, $_rs) = @_;

    return bless {
	conn => $conn,
	query => $query,
	_rs => $_rs,
    }, $class;
}

# PRIVATE within this class
sub _rs {
    my $this = shift();

    my $_rs = $this->{_rs};
    die "{_rs} undefined: has this ResultSet been destroy()ed?"
	if !defined $_rs;

    return $_rs;
}

sub size {
    my $this = shift();

    return Net::Z3950::ZOOM::resultset_size($this->_rs());
}

sub record {
    my $this = shift();
    my($which) = @_;

    my $_rec = Net::Z3950::ZOOM::resultset_record($this->_rs(), $which);
    ### Check for error -- but how?

    # For some reason, I have to use the explicit "->" syntax in order
    # to invoke the ZOOM::Record constructor here, even though I don't
    # have to do the same for _new ZOOM::ResultSet above.  Weird.
    return ZOOM::Record->_new($this, $which, $_rec);
}

sub destroy {
    my $this = shift();

    Net::Z3950::ZOOM::resultset_destroy($this->_rs());
    $this->{_rs} = undef;
}


# ----------------------------------------------------------------------------

package ZOOM::Record;

sub new {
    my $class = shift();
    die "You can't create $class objects directly";
}

# PRIVATE to ZOOM::ResultSet::record()
sub _new {
    my $class = shift();
    my($rs, $which, $_rec) = @_;

    return bless {
	rs => $rs,
	which => $which,
	_rec => $_rec,
    }, $class;
}

# PRIVATE within this class
sub _rec {
    my $this = shift();

    return $this->{_rec};
}

sub render {
    my $this = shift();

    my $len = 0;
    my $string = Net::Z3950::ZOOM::record_get($this->_rec(), "render", $len);
    # I don't think we need '$len' at all.  ### Probably the Perl-to-C
    # glue code should use the value of `len' as well as the opaque
    # data-pointer returned, to ensure that the SV contains all of the
    # returned data and does not stop at the first NUL character in
    # binary data.  Carefully check the ZOOM_record_get() documentation.
    return $string;
}

sub raw {
    my $this = shift();

    my $len = 0;
    my $string = Net::Z3950::ZOOM::record_get($this->_rec(), "raw", $len);
    # See comment about $len in render()
    return $string;
}


1;
