# $Id: 19-events.t,v 1.2 2006-04-07 11:47:33 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 19-events.t'

use strict;
use warnings;
use Test::More tests => 7;

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

$val = Net::Z3950::ZOOM::event([$conn]);
ok($val == 1, "call with an good connection returns its index");

### Now we need to actually do something.
