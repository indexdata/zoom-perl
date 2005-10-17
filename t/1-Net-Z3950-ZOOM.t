# $Id: 1-Net-Z3950-ZOOM.t,v 1.10 2005-10-17 16:18:27 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1-Net-Z3950-ZOOM.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use Test::More tests => 21;
BEGIN { use_ok('Net::Z3950::ZOOM') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $msg = Net::Z3950::ZOOM::diag_str(Net::Z3950::ZOOM::ERROR_INVALID_QUERY);
ok($msg eq "Invalid query", "diagnostic string lookup works");

my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");

my $host = "no.such.host";
my $conn = Net::Z3950::ZOOM::connection_new($host, 0);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == Net::Z3950::ZOOM::ERROR_CONNECT && $addinfo eq $host,
   "connection to non-existent host '$host' fails");

$host = "indexdata.com/gils";
$conn = Net::Z3950::ZOOM::connection_new($host, 0);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "connection to '$host'");

Net::Z3950::ZOOM::connection_destroy($conn);
ok(1, "destroyed connection");

my $options = Net::Z3950::ZOOM::options_create();
$conn = Net::Z3950::ZOOM::connection_create($options);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "unconnected connection object created");
Net::Z3950::ZOOM::connection_connect($conn, $host, 0);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "delayed connection to '$host'");

my $val1 = "foo";
my $val2 = "$val1\0bar";
Net::Z3950::ZOOM::connection_option_set($conn, xyz => $val2);
my $val = Net::Z3950::ZOOM::connection_option_get($conn, "xyz");
ok($val eq $val1, "option_set() treats value as NUL-terminated");
Net::Z3950::ZOOM::connection_option_setl($conn, xyz => $val2, length($val2));
my $vallen = 0;
$val = Net::Z3950::ZOOM::connection_option_getl($conn, "xyz", $vallen);
ok($val eq $val2, "option_setl() treats value as opaque chunk, val='$val' len=$vallen");

my $syntax = "usmarc";
Net::Z3950::ZOOM::connection_option_set($conn,
					preferredRecordSyntax => $syntax);
$val = Net::Z3950::ZOOM::connection_option_get($conn, "preferredRecordSyntax");
ok($val eq $syntax, "preferred record syntax set to '$val'");

my $query = '@attr @and 1=4 minerals';
my $rs = Net::Z3950::ZOOM::connection_search_pqf($conn, $query);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == Net::Z3950::ZOOM::ERROR_INVALID_QUERY,
   "search for invalid query '$query' fails");

my($xcode, $xmsg, $xinfo, $xset) = (undef, "dummy", "dummy", "dummy");
$xcode = Net::Z3950::ZOOM::connection_error_x($conn, $xmsg, $xinfo, $xset);
ok($xcode == $errcode && $xmsg eq $errmsg && $xinfo eq $addinfo &&
   $xset eq "ZOOM", "error_x() consistent with error()");
ok(Net::Z3950::ZOOM::connection_errcode($conn) == $errcode,
   "errcode() consistent with error()");
ok(Net::Z3950::ZOOM::connection_errmsg($conn) eq $errmsg,
   "errmsg() consistent with error()");
ok(Net::Z3950::ZOOM::connection_addinfo($conn) eq $addinfo,
   "addinfo() consistent with error()");
### These is no ZOOM_connection_diagset() -- surely that's a mistake?

$query = '@attr 1=4 minerals';
$rs = Net::Z3950::ZOOM::connection_search_pqf($conn, $query);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "search for '$query'");

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
