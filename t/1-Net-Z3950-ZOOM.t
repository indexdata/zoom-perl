# $Id: 1-Net-Z3950-ZOOM.t,v 1.4 2005-10-12 14:36:17 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Z3950-ZOOM.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use Test::More tests => 11;
BEGIN { use_ok('Net::Z3950::ZOOM') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");

my $host = "no.such.host";
my $conn = Net::Z3950::ZOOM::connection_new($host, 0);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == Net::Z3950::ZOOM::ERROR_CONNECT && $addinfo eq $host,
   "connection to non-existent host '$host' fails");

$host = "indexdata.com/gils";
$conn = Net::Z3950::ZOOM::connection_new($host, 0);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "connection to '$host' OK");

my $syntax = "usmarc";
Net::Z3950::ZOOM::connection_option_set($conn,
					preferredRecordSyntax => $syntax);
my $val = Net::Z3950::ZOOM::connection_option_get($conn,
						  "preferredRecordSyntax");
ok($val eq $syntax, "preferred record syntax set to '$val'");

my $query = '@attr @and 1=4 minerals';
my $rs = Net::Z3950::ZOOM::connection_search_pqf($conn, $query);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == Net::Z3950::ZOOM::ERROR_INVALID_QUERY,
   "search for invalid query '$query' fails");

$query = '@attr 1=4 minerals';
$rs = Net::Z3950::ZOOM::connection_search_pqf($conn, $query);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "search for '$query' OK");

my $n = Net::Z3950::ZOOM::resultset_size($rs);
ok($n == 1, "found 1 record as expected");

my $rec = Net::Z3950::ZOOM::resultset_record($rs, 0);
my $len = 0;
my $data = Net::Z3950::ZOOM::record_get($rec, "render", $len);
ok($data =~ /245 +\$a ISOTOPIC DATES OF ROCKS AND MINERALS/,
   "rendered record has expected title");
my $raw = Net::Z3950::ZOOM::record_get($rec, "raw", $len);
ok($raw =~ /^00981n/, "raw record contains expected header");

Net::Z3950::ZOOM::resultset_destroy($rs);
ok(1, "destroyed result-set");
Net::Z3950::ZOOM::connection_destroy($conn);
ok(1, "destroyed connection");
