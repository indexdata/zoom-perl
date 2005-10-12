# $Id: 2-ZOOM.t,v 1.4 2005-10-12 16:13:38 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl ZOOM.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use Test::More tests => 12;
BEGIN { use_ok('ZOOM') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $msg = ZOOM::diag_str(ZOOM::Error::INVALID_QUERY);
ok($msg eq "Invalid query", "diagnostic string lookup works");

my $host = "no.such.host";
my $conn;
eval { $conn = new ZOOM::Connection($host, 0) };
ok($@ && $@->isa("ZOOM::Exception") &&
   $@->code() == ZOOM::Error::CONNECT && $@->addinfo() eq $host,
   "connection to non-existent host '$host' fails");

$host = "indexdata.com/gils";
eval { $conn = new ZOOM::Connection($host, 0) };
ok(!$@, "connection to '$host' OK");

my $syntax = "usmarc";
$conn->option(preferredRecordSyntax => $syntax);
my $val = $conn->option("preferredRecordSyntax");
ok($val eq $syntax, "preferred record syntax set to '$val'");

my $query = '@attr @and 1=4 minerals';
my $rs;
eval { $rs = $conn->search_pqf($query) };
ok($@ && $@->isa("ZOOM::Exception") &&
   $@->code() == ZOOM::Error::INVALID_QUERY,
   "search for invalid query '$query' fails");

$query = '@attr 1=4 minerals';
eval { $rs = $conn->search_pqf($query) };
ok(!$@, "search for '$query' OK");

my $n = $rs->size($rs);
ok($n == 1, "found 1 record as expected");

my $rec = $rs->record(0);
my $data = $rec->render();
ok($data =~ /245 +\$a ISOTOPIC DATES OF ROCKS AND MINERALS/,
   "rendered record has expected title");
my $raw = $rec->raw();
ok($raw =~ /^00981n/, "raw record contains expected header");

$rs->destroy();
ok(1, "destroyed result-set");
$conn->destroy();
ok(1, "destroyed connection");
