# $Id: 16-packages.t,v 1.4 2005-11-15 17:26:24 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 16-packages.t'

use strict;
use warnings;
use Test::More tests => 6;

BEGIN { use_ok('Net::Z3950::ZOOM') };

my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");

my $host = "indexdata.com/gils";
#my $host = "localhost:9999/default";
my $conn = Net::Z3950::ZOOM::connection_new($host, 0);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "connection to '$host'");

my $o = Net::Z3950::ZOOM::options_create();
my $p = Net::Z3950::ZOOM::connection_package($conn, $o);
# Inspection of the ZOOM-C code shows that this can never fail, in fact.
ok(defined $p, "created package");

# We will create a new database with a random name
my $dbname = "";
for (1..10) {
    $dbname .= substr("abcdefghijklmnopqrstuvwxyz", int(rand(26)), 1);
}
Net::Z3950::ZOOM::package_option_set($p, databaseName => $dbname);
my $val = Net::Z3950::ZOOM::package_option_get($p, "databaseName");
ok($val eq $dbname, "package option retrieved as expected");

Net::Z3950::ZOOM::package_send($p, "create");
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 223, "permission denined for database create");

# Now we inspect the package options to see what the result was
$val = Net::Z3950::ZOOM::package_option_get($p, "targetReference");
#print "targetReference for create($dbname) is '$val'\n";

Net::Z3950::ZOOM::package_destroy($p);
ok(1, "destroyed package");
