# $Id: ZOOM.pm,v 1.3 2005-10-11 16:23:32 mike Exp $

use strict;
use warnings;
use Net::Z3950::ZOOM;


# Member naming convention: hash-element names which begin with an
# underscore represent underlying ZOOM-C object descriptors; those
# which do not represent Perl's ZOOM objects.  (The same convention is
# used in naming local variables.)
#
# So, for example, the ZOOM::Connection class has an {_conn} element,
# which is a pointer to the ZOOM-C Connection object; but the
# ZOOM::ResultSet class has a {conn} element, which is a reference to
# the Perl-level Connection object by which it was created.
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

    return $this->{_conn};
}

sub option_set {
    my $this = shift();
    my($key, $value) = @_;

    Net::Z3950::ZOOM::connection_option_set($this->_conn(), $key, $value);
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

    return $this->{rs};
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
    return _new ZOOM::Record($this, $which, $_rec);
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
