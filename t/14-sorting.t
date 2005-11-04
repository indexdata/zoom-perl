# $Id: 14-sorting.t,v 1.1 2005-11-04 16:13:42 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 14-sorting.t'

#   ###	At present, this test fails -- so far as I can see, because
#	the underlying ZOOM-C sorting functionality is broken, as
#	verified using "zoomsh" with the commands:
#
#		ZOOM>open indexdata.dk/gils
#		ZOOM>find @attr 1=4 map
#		ZOOM>sort 1=4
#		ZOOM>show 0 5
#
#	Hopefully Adam will fix the underlying code, and then this
#	will Just Work.

use strict;
use warnings;
use Test::More tests => 26;
use MARC::Record;

BEGIN { use_ok('Net::Z3950::ZOOM') };

my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");

my $host = "indexdata.com/gils";
my $conn = Net::Z3950::ZOOM::connection_new($host, 0);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "connection to '$host'");

my $qstr = '@attr 1=4 map';
my $query = Net::Z3950::ZOOM::query_create();
Net::Z3950::ZOOM::query_prefix($query, $qstr);
Net::Z3950::ZOOM::query_sortby($query, "1=4<i");
my $rs = Net::Z3950::ZOOM::connection_search($conn, $query);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "search for '$qstr'");
my $n = Net::Z3950::ZOOM::resultset_size($rs);
ok($n eq 5, "found $n records (expected 5)");

Net::Z3950::ZOOM::resultset_option_set($rs, preferredRecordSyntax => "usmarc");
my $previous = "";		# Sorts before all legitimate titles
foreach my $i (1 .. $n) {
    my $rec = Net::Z3950::ZOOM::resultset_record($rs, $i-1);
    ok(defined $rec, "got record $i of $n");
    my $len = 0;
    my $raw = Net::Z3950::ZOOM::record_get($rec, "raw", $len);
    my $marc = new_from_usmarc MARC::Record($raw);
    my $title = $marc->title();
    ok($title ge $previous, "title '$title' ge previous '$previous'");
    $previous = $title;
}

# Now reverse the order of sorting
Net::Z3950::ZOOM::resultset_sort($rs, "dummy", "1=4>i");
### There's no way to check for success, as this is a void function

$previous = "z";		# Sorts after all legitimate titles
foreach my $i (1 .. $n) {
    my $rec = Net::Z3950::ZOOM::resultset_record($rs, $i-1);
    ok(defined $rec, "got record $i of $n");
    my $len = 0;
    my $raw = Net::Z3950::ZOOM::record_get($rec, "raw", $len);
    my $marc = new_from_usmarc MARC::Record($raw);
    my $title = $marc->title();
    ok($title le $previous, "title '$title' le previous '$previous'");
    $previous = $title;
}

Net::Z3950::ZOOM::resultset_destroy($rs);
ok(1, "destroyed result-set");
Net::Z3950::ZOOM::connection_destroy($conn);
ok(1, "destroyed connection");
