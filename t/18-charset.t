# $Id: 18-charset.t,v 1.1 2006-04-06 13:08:14 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 18-charset.t'

use strict;
use warnings;
use Test::More tests => 9;

BEGIN { use_ok('Net::Z3950::ZOOM') };

my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");

my $host = "z3950.loc.gov:7090/voyager";
my $conn = Net::Z3950::ZOOM::connection_new($host, 0);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "connection to '$host'");

Net::Z3950::ZOOM::connection_option_set($conn,
					preferredRecordSyntax => "usmarc");

my $qstr = '@attr 1=7 3879093520';
my $rs = Net::Z3950::ZOOM::connection_search_pqf($conn, $qstr);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "search for '$qstr'");

my $n = Net::Z3950::ZOOM::resultset_size($rs);
ok($n == 1, "found $n records (expected 1)");

my $rec = Net::Z3950::ZOOM::resultset_record($rs, 0);
ok(defined $rec, "got first record");

my $len = 0;
my $xml = Net::Z3950::ZOOM::record_get($rec, "xml", $len);
ok(defined $xml, "got XML");

ok($xml =~ m(<subfield code="b">aus der .* f\350ur),
   "got MARC pre-accented composed characters");

$xml = Net::Z3950::ZOOM::record_get($rec, "xml;charset=marc-8,utf-8", $len);
ok(defined $xml, "got XML in Unicode");

ok($xml =~ m(<subfield code="b">aus der .* für),
   "got Unicode post-accented composed characters");

