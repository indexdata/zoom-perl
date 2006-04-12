# $Id: 19-events.t,v 1.3 2006-04-12 11:02:42 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 19-events.t'

use strict;
use warnings;
use Test::More tests => 19;

BEGIN { use_ok('Net::Z3950::ZOOM') };

my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");

my $options = Net::Z3950::ZOOM::options_create();
Net::Z3950::ZOOM::options_set($options, async => 1);

my $host = "indexdata.com/gils";
my $conn = Net::Z3950::ZOOM::connection_create($options);
Net::Z3950::ZOOM::connection_connect($conn, $host, 0);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "connection to '$host'");

my $val = Net::Z3950::ZOOM::event(1);
ok($val == -1, "non-reference argument rejected");

$val = Net::Z3950::ZOOM::event($conn);
ok($val == -2, "non-array reference argument rejected");

$val = Net::Z3950::ZOOM::event([]);
ok($val == -3, "empty array reference argument rejected");

$val = Net::Z3950::ZOOM::event([1..32767]);
ok($val == -4, "huge array reference argument rejected");

# Test the sequence of events that come from just creating the
# connection: there's the physical connect; the sending the Init
# request (sending the APDU results in sending the data); the
# receiving of the Init response (receiving the data results in
# receiving the APDU); then the END "event" indicating that there are
# no further events on the specific connection we're using; finally,
# event() will return 0 to indicate that there are no events pending
# on any of the connections we pass in.

assert_event($conn, Net::Z3950::ZOOM::EVENT_CONNECT);
assert_event($conn, Net::Z3950::ZOOM::EVENT_SEND_APDU);
assert_event($conn, Net::Z3950::ZOOM::EVENT_SEND_DATA);
assert_event($conn, Net::Z3950::ZOOM::EVENT_RECV_DATA);
assert_event($conn, Net::Z3950::ZOOM::EVENT_RECV_APDU);
assert_event($conn, Net::Z3950::ZOOM::EVENT_END);
assert_event($conn, 0);

### Now we need to actually do something.


sub assert_event {
    my($conn, $expected) = @_;

    my $val = Net::Z3950::ZOOM::event([$conn]);
    if ($expected == 0) {
	ok($val == 0, "no events left");
	return;
    }

    ok($val == 1, "call with an good connection returns its index");

    my $ev = Net::Z3950::ZOOM::connection_last_event($conn);
    ok($ev == $expected, ("event is $ev (" .
			  Net::Z3950::ZOOM::event_str($ev) .
			  "), expected $expected (" .
			  Net::Z3950::ZOOM::event_str($expected) . ")"));
}

