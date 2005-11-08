# $Id: 16-packages.t,v 1.1 2005-11-08 13:47:11 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 16-packages.t'

use strict;
use warnings;
use Test::More tests => 6;

BEGIN { use_ok('Net::Z3950::ZOOM') };

my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");

my $host = "indexdata.com/gils";
my $conn = Net::Z3950::ZOOM::connection_new($host, 0);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "connection to '$host'");

my $o = Net::Z3950::ZOOM::options_create();
my $p = Net::Z3950::ZOOM::connection_package($conn, $o);
# Inspection of the ZOOM-C code shows that this can never fail, in fact.
ok(defined $p, "created package");

# There may be useful options to set, but this is not one of them!
Net::Z3950::ZOOM::package_option_set($p, "foo", "bar");
my $val = Net::Z3950::ZOOM::package_option_get($p, "foo");
ok($val eq "bar", "package option retrieved as expected");

Net::Z3950::ZOOM::package_send($p, "foo");
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "sent 'foo' package");

### Now what?

Net::Z3950::ZOOM::package_destroy($p);
ok(1, "destroyed package");
