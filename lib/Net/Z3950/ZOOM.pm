# $Id: ZOOM.pm,v 1.18 2006-04-07 12:07:23 mike Exp $

package Net::Z3950::ZOOM; 

use 5.008;
use strict;
use warnings;

our $VERSION = '1.05';

require XSLoader;
XSLoader::load('Net::Z3950::ZOOM', $VERSION);

my($vs, $ss) = ("x" x 100, "x" x 100); # allocate space for these strings
my $version = Net::Z3950::ZOOM::yaz_version($vs, $ss);
if ($version < 0x02010B && ! -f "/tmp/ignore-ZOOM-YAZ-version-mismatch") {
    warn <<__EOT__;
*** WARNING!
ZOOM-Perl requires at least version 2.0.11 of YAZ, but is currently
running against only version $vs (sys-string '$ss').
Some things may not work.
__EOT__
}

# The only thing this module does is define the following constants,
# which MUST BE KEPT SYNCHRONISED with the definitions in <yaz/zoom.h>

# Error codes, as returned from connection_error()
sub ERROR_NONE { 0 }
sub ERROR_CONNECT { 10000 }
sub ERROR_MEMORY { 10001 }
sub ERROR_ENCODE { 10002 }
sub ERROR_DECODE { 10003 }
sub ERROR_CONNECTION_LOST { 10004 }
sub ERROR_INIT { 10005 }
sub ERROR_INTERNAL { 10006 }
sub ERROR_TIMEOUT { 10007 }
sub ERROR_UNSUPPORTED_PROTOCOL { 10008 }
sub ERROR_UNSUPPORTED_QUERY { 10009 }
sub ERROR_INVALID_QUERY { 10010 }
sub ERROR_CQL_PARSE { 10011 }
sub ERROR_CQL_TRANSFORM { 10012 }

# Event types, as returned from connection_last_event()
sub EVENT_NONE { 0 }
sub EVENT_CONNECT { 1 }
sub EVENT_SEND_DATA { 2 }
sub EVENT_RECV_DATA { 3 }
sub EVENT_TIMEOUT { 4 }
sub EVENT_UNKNOWN { 5 }
sub EVENT_SEND_APDU { 6 }
sub EVENT_RECV_APDU { 7 }
sub EVENT_RECV_RECORD { 8 }
sub EVENT_RECV_SEARCH { 9 }
sub EVENT_END { 10 }		# In YAZ 2.1.17 and later


=head1 NAME

Net::Z3950::ZOOM - Perl extension for invoking the ZOOM-C API.

=head1 SYNOPSIS

 use Net::Z3950::ZOOM;
 $conn = Net::Z3950::ZOOM::connection_new($host, $port);
 $errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
 Net::Z3950::ZOOM::connection_option_set($conn, databaseName => "foo");
 # etc.

=head1 DESCRIPTION

This module provides a simple thin-layer through to the ZOOM-C
functions in the YAZ toolkit for Z39.50 and SRW/U communication.  You
should not be using this very nasty, low-level API.  You should be
using the C<ZOOM> module instead, which implements a nice, Perlish API
on top of this module, conformant to the ZOOM Abstract API described at
http://zoom.z3950.org/api/

To enforce the don't-use-this-module prohibition, I am not even going
to document it.  If you really, really, really want to use it, then it
pretty much follows the API described in the ZOOM-C documentation at
http://www.indexdata.dk/yaz/doc/zoom.tkl

The only additional (non-ZOOM-C) function provided by this module is
C<event_str()>, which takes as its argument an event code such as
C<Net::Z3950::ZOOM::EVENT_SEND_APDU>, and returns a corresponding
short string.

=cut

sub event_str {
    my($code) = @_;

    if ($code == EVENT_NONE) {
	return "none";
    } elsif ($code == EVENT_CONNECT) {
	return "connect";
    } elsif ($code == EVENT_SEND_DATA) {
	return "send data";
    } elsif ($code == EVENT_RECV_DATA) {
	return "receive data";
    } elsif ($code == EVENT_TIMEOUT) {
	return "timeout";
    } elsif ($code == EVENT_UNKNOWN) {
	return "unknown";
    } elsif ($code == EVENT_SEND_APDU) {
	return "send apdu";
    } elsif ($code == EVENT_RECV_APDU) {
	return "receive apdu";
    } elsif ($code == EVENT_RECV_RECORD) {
	return "receive record";
    } elsif ($code == EVENT_RECV_SEARCH) {
	return "receive search";
    } elsif ($code == EVENT_END) {
	return "end";
    }
    return "impossible event " . $code;
}

=head1 SEE ALSO

The C<ZOOM> module, included in the same distribution as this one.

=head1 AUTHOR

Mike Taylor, E<lt>mike@indexdata.comE<gt>

=head1 COPYRIGHT AND LICENCE

Copyright (C) 2005 by Index Data.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.4 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
