# $Id: 12-query.t,v 1.3 2005-10-31 15:04:04 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 12-query.t'

use strict;
use warnings;
use Test::More tests => 20;
BEGIN { use_ok('Net::Z3950::ZOOM') };

my $q = Net::Z3950::ZOOM::query_create();
ok(defined $q, "create empty query");

Net::Z3950::ZOOM::query_destroy($q);
ok(1, "destroyed empty query");

$q = Net::Z3950::ZOOM::query_create();
ok(defined $q, "recreated empty query");

# Invalid CQL is not recognised as such, because ZOOM-C does not
# attempt to parse it: it just gets passed to the server when the
# query is used.
my $res = Net::Z3950::ZOOM::query_cql($q, "creator=pike and");
ok($res == 0, "invalid CQL accepted (pass-through)");
$res = Net::Z3950::ZOOM::query_cql($q, "creator=pike and subject=unix");
ok($res == 0, "valid CQL accepted");

$res = Net::Z3950::ZOOM::query_prefix($q, '@and @attr 1=1003 pike');
ok($res < 0, "invalid PQF rejected");
$res = Net::Z3950::ZOOM::query_prefix($q, '@and @attr 1=1003 pike @attr 1=21 unix');
ok($res == 0, "set PQF into query");

$res = Net::Z3950::ZOOM::query_sortby($q, "");
ok($res < 0, "zero-length sort criteria rejected");

$res = Net::Z3950::ZOOM::query_sortby($q, "foo bar baz");
ok($res == 0, "sort criteria accepted");

Net::Z3950::ZOOM::query_destroy($q);
ok(1, "destroyed complex query");

# Up till now, we have been doing query management.  Now to actually
# use the query.  This is done using connection_search() -- there are
# no other uses of query objects -- but we need to establish a
# connection for it to work on first.

my $host = "indexdata.com/gils";
my $conn = Net::Z3950::ZOOM::connection_new($host, 0);
my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "connection to '$host'");

Net::Z3950::ZOOM::connection_option_set($conn,
					preferredRecordSyntax => "usmarc");

$q = Net::Z3950::ZOOM::query_create();
ok(defined $q, "create empty query");
$res = Net::Z3950::ZOOM::query_prefix($q,
			'@and @attr 1=4 utah @attr 1=62 epicenter');
ok($res == 0, "set PQF into query");

my $rs = Net::Z3950::ZOOM::connection_search($conn, $q);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "search");

my $n = Net::Z3950::ZOOM::resultset_size($rs);
ok($n == 1, "found 1 record as expected");

my $rec = Net::Z3950::ZOOM::resultset_record($rs, 0);
ok(1, "got record idenfified by query");

my $len = 0;
my $data = Net::Z3950::ZOOM::record_get($rec, "render", $len);
ok(1, "rendered record");
ok($data =~ /^035    \$a ESDD0006$/m, "record is the expected one");

Net::Z3950::ZOOM::resultset_destroy($rs);
Net::Z3950::ZOOM::query_destroy($q);
Net::Z3950::ZOOM::connection_destroy($conn);
ok(1, "destroyed all objects");
