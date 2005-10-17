# $Id: ZOOM.pm,v 1.7 2005-10-17 13:47:25 mike Exp $

use strict;
use warnings;
use Net::Z3950::ZOOM;


package ZOOM;

sub diag_str {
    my($code) = @_;
    return Net::Z3950::ZOOM::diag_str($code);
}


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

# The "Error" package contains constants returned as error-codes.
package ZOOM::Error;
sub NONE { Net::Z3950::ZOOM::ERROR_NONE }
sub CONNECT { Net::Z3950::ZOOM::ERROR_CONNECT }
sub MEMORY { Net::Z3950::ZOOM::ERROR_MEMORY }
sub ENCODE { Net::Z3950::ZOOM::ERROR_ENCODE }
sub DECODE { Net::Z3950::ZOOM::ERROR_DECODE }
sub CONNECTION_LOST { Net::Z3950::ZOOM::ERROR_CONNECTION_LOST }
sub INIT { Net::Z3950::ZOOM::ERROR_INIT }
sub INTERNAL { Net::Z3950::ZOOM::ERROR_INTERNAL }
sub TIMEOUT { Net::Z3950::ZOOM::ERROR_TIMEOUT }
sub UNSUPPORTED_PROTOCOL { Net::Z3950::ZOOM::ERROR_UNSUPPORTED_PROTOCOL }
sub UNSUPPORTED_QUERY { Net::Z3950::ZOOM::ERROR_UNSUPPORTED_QUERY }
sub INVALID_QUERY { Net::Z3950::ZOOM::ERROR_INVALID_QUERY }

# The "Event" package contains constants returned by last_event()
package ZOOM::Event;
sub NONE { Net::Z3950::ZOOM::EVENT_NONE }
sub CONNECT { Net::Z3950::ZOOM::EVENT_CONNECT }
sub SEND_DATA { Net::Z3950::ZOOM::EVENT_SEND_DATA }
sub RECV_DATA { Net::Z3950::ZOOM::EVENT_RECV_DATA }
sub TIMEOUT { Net::Z3950::ZOOM::EVENT_TIMEOUT }
sub UNKNOWN { Net::Z3950::ZOOM::EVENT_UNKNOWN }
sub SEND_APDU { Net::Z3950::ZOOM::EVENT_SEND_APDU }
sub RECV_APDU { Net::Z3950::ZOOM::EVENT_RECV_APDU }
sub RECV_RECORD { Net::Z3950::ZOOM::EVENT_RECV_RECORD }
sub RECV_SEARCH { Net::Z3950::ZOOM::EVENT_RECV_SEARCH }


# ----------------------------------------------------------------------------

package ZOOM::Exception;

sub new {
    my $class = shift();
    my($code, $message, $addinfo) = @_;
    ### support diag-set, too

    return bless {
	code => $code,
	message => $message,
	addinfo => $addinfo,
    }, $class;
}

sub code {
    my $this = shift();
    return $this->{code};
}

sub message {
    my $this = shift();
    return $this->{message};
}

sub addinfo {
    my $this = shift();
    return $this->{addinfo};
}


# ----------------------------------------------------------------------------

package ZOOM::Options;

sub new {
    my $class = shift();
    ### Should use create_with_parent{,2}() depending on arguments

    return bless {
	_opts => Net::Z3950::ZOOM::options_create(),
    }, $class;
}

sub _opts {
    my $this = shift();

    return $this->{_opts};
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

sub create {
    my $class = shift();
    my($options) = @_;

    my $_conn = Net::Z3950::ZOOM::connection_create($options->_opts());
    return bless {
	host => undef,
	port => undef,
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

sub error_x {
    my $this = shift();

    my($errcode, $errmsg, $addinfo, $diagset) = (undef, "dummy", "dummy", "d");
    $errcode = Net::Z3950::ZOOM::connection_error_x($this->_conn(), $errmsg,
						    $addinfo, $diagset);
    return ($errcode, $errmsg, $addinfo, $diagset);
}

sub errcode {
    my $this = shift();
    return Net::Z3950::ZOOM::connection_errcode($this->_conn());
}

sub errmsg {
    my $this = shift();
    return Net::Z3950::ZOOM::connection_errmsg($this->_conn());
}

sub addinfo {
    my $this = shift();
    return Net::Z3950::ZOOM::connection_addinfo($this->_conn());
}

sub connect {
    my $this = shift();
    my($host, $port) = @_;

    Net::Z3950::ZOOM::connection_connect($this->_conn(), $host, $port);
    my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");
    $errcode = Net::Z3950::ZOOM::connection_error($this->_conn(),
						  $errmsg, $addinfo);
    die new ZOOM::Exception($errcode, $errmsg, $addinfo) if $errcode;
    # No return value
}

sub option {
    my $this = shift();
    my($key, $value) = @_;

    my $oldval = Net::Z3950::ZOOM::connection_option_get($this->_conn(), $key);
    Net::Z3950::ZOOM::connection_option_set($this->_conn(), $key, $value)
	if defined $value;

    return $oldval;
}

sub option_binary {
    my $this = shift();
    my($key, $value) = @_;

    my $dummylen = 0;
    my $oldval = Net::Z3950::ZOOM::connection_option_getl($this->_conn(),
							  $key, $dummylen);
    Net::Z3950::ZOOM::connection_option_setl($this->_conn(), $key,
					     $value, length($value))
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
