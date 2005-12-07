# $Id: 16-packages.t,v 1.5 2005-12-07 15:28:07 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 16-packages.t'

# Tests:
#	connect anonymously => refused
#	connect as "user" with incorrect password => refused
#	connect as "user" with correct password
#		try to create tmpdb => EPERM
#	connect as admin with correct password
#		try to create tmpdb => OK
#		try to create tmpdb => EFAIL

use strict;
use warnings;
use Test::More tests => 32;

BEGIN { use_ok('Net::Z3950::ZOOM') };


# For now, use a local database: later establish a public one for this.
# We will create, and destroy, a new database with a random name
my $host = "localhost:9999";
#my $host = "indexdata.com/gils";
my $dbname = join("", map { chr(ord("a") + int(rand(26))) } 1..10);

# Connect anonymously, and expect this to fail
my $conn = makeconn($host, undef, undef, 1011);

# Connect as a user, but with incorrect password -- expect failure
Net::Z3950::ZOOM::connection_destroy($conn);
$conn = makeconn($host, "user", "badpw", 1011);

# Connect as a non-privileged user with correct password
Net::Z3950::ZOOM::connection_destroy($conn);
$conn = makeconn($host, "user", "frog", 0);

# Non-privileged user can't create database
makedb($conn, $dbname, 223);

# Connect as a privileged user with correct password, check DB is absent
Net::Z3950::ZOOM::connection_destroy($conn);
$conn = makeconn($host, "admin", "fish", 0);
Net::Z3950::ZOOM::connection_option_set($conn, databaseName => $dbname);
my $rs = Net::Z3950::ZOOM::connection_search_pqf($conn, "the");
my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 109, "database '$dbname' does not yet exist");

# Now create the database and check that it is present but empty
makedb($conn, $dbname, 0);
$rs = Net::Z3950::ZOOM::connection_search_pqf($conn, "the");
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "database '$dbname' does now exists");
my $n = Net::Z3950::ZOOM::resultset_size($rs);
ok($n == 0, "database '$dbname' is empty");

# Trying to create the same database again will fail EEXIST
makedb($conn, $dbname, 224);

# Try to add a non-existent record
updaterec($conn, 465, "samples/records/notthere.grs", 224);

# Add a single record, and check that it can be found
updaterec($conn, 465, "samples/records/esdd0006.grs", 0);

# Now drop the newly-created database
dropdb($conn, $dbname, 0);

# A second dropping should fail, but does not do so -- I think that
# "drop" is an always-"successful" no-op.  Yuck.
dropdb($conn, $dbname, 0);


sub makeconn {
    my($host, $user, $password, $expected_error) = @_;

    my $options = Net::Z3950::ZOOM::options_create();
    Net::Z3950::ZOOM::options_set($options, user => $user)
	if defined $user;
    Net::Z3950::ZOOM::options_set($options, password => $password)
	if defined $password;

    my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");
    my $conn = Net::Z3950::ZOOM::connection_create($options);
    $errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
    ok($errcode == 0, "unconnected connection object created");

    Net::Z3950::ZOOM::connection_connect($conn, $host, 0);
    $errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
    ok($errcode == $expected_error,
       "connection to '$host'" . ($errcode ? " refused $errcode" : ""));

    return $conn;
}


sub makedb {
    my($conn, $dbname, $expected_error) = @_;

    my $o = Net::Z3950::ZOOM::options_create();
    my $p = Net::Z3950::ZOOM::connection_package($conn, $o);
    # Inspection of the ZOOM-C code shows that this can never fail, in fact.
    ok(defined $p, "created package");

    Net::Z3950::ZOOM::package_option_set($p, databaseName => $dbname);
    my $val = Net::Z3950::ZOOM::package_option_get($p, "databaseName");
    ok($val eq $dbname, "package option retrieved as expected");

    Net::Z3950::ZOOM::package_send($p, "create");
    my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");
    $errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
    ok($errcode == $expected_error,
       "database creation '$dbname'"  . ($errcode ? " refused $errcode" : ""));

    # Now we can inspect the package options to find out more about
    # how the server dealt with the request.  However, it seems that
    # the "package database" described in the standard is not used,
    # and that the only options we can inspect are the following:
    $val = Net::Z3950::ZOOM::package_option_get($p, "targetReference");
    $val = Net::Z3950::ZOOM::package_option_get($p, "xmlUpdateDoc");
    # ... and we know nothing about expected or actual values.

    Net::Z3950::ZOOM::package_destroy($p);
    ok(1, "destroyed createdb package");
}


sub dropdb {
    my($conn, $dbname, $expected_error) = @_;

    my $o = Net::Z3950::ZOOM::options_create();
    my $p = Net::Z3950::ZOOM::connection_package($conn, $o);
    # No need to keep ok()ing this, or checking the option-setting
    Net::Z3950::ZOOM::package_option_set($p, databaseName => $dbname);

    Net::Z3950::ZOOM::package_send($p, "drop");
    my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");
    $errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
    ok($errcode == $expected_error,
       "database drop '$dbname'"  . ($errcode ? " refused $errcode" : ""));

    Net::Z3950::ZOOM::package_destroy($p);
    ok(1, "destroyed dropdb package");
}


# We always use "specialUpdate", which adds a record or replaces it if
# it's already there.  By contrast, "insert" fails if the record
# already exists, and "replace" fails if it does not.
#
sub updaterec {
    my($conn, $id, $file, $expected_error) = @_;

    my $o = Net::Z3950::ZOOM::options_create();
    my $p = Net::Z3950::ZOOM::connection_package($conn, $o);
    Net::Z3950::ZOOM::package_option_set($p, action => "specialUpdate");
    Net::Z3950::ZOOM::package_option_set($p, recordIdOpaque => $id);
    Net::Z3950::ZOOM::package_option_set($p, record => $file);

    Net::Z3950::ZOOM::package_send($p, "update");
    my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");
    $errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
    ok($errcode == $expected_error,
       "record update $id '$file'"  . ($errcode ? " failed $errcode $errmsg $addinfo" : ""));

    Net::Z3950::ZOOM::package_destroy($p);
    ok(1, "destroyed update package");
}
