# $Id: 26-packages.t,v 1.1 2005-11-08 15:56:05 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 26-packages.t'

use strict;
use warnings;
use Test::More tests => 6;

BEGIN { use_ok('ZOOM') };

my $host = "indexdata.com/gils";
my $conn;
eval { $conn = new ZOOM::Connection($host, 0) };
ok(!$@, "connection to '$host'");

my $p = $conn->package();
# Inspection of the ZOOM-C code shows that this can never fail, in fact.
ok(defined $p, "created package");

# There may be useful options to set, but this is not one of them!
$p->option(foo => "bar");
my $val = $p->option("foo");
ok($val eq "bar", "package option retrieved as expected");

eval { $p->send("foo") };
ok(!$@, "sent 'foo' package");

### Now what?

$p->destroy();
ok(1, "destroyed package");
