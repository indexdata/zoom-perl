# $Id: 12-query.t,v 1.1 2005-10-26 16:25:50 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 12-query.t'

use strict;
use warnings;
use Test::More tests => 19;
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

my $q = Net::Z3950::ZOOM::query_create();
ok(defined $q, "create empty query");
$res = Net::Z3950::ZOOM::query_prefix($q, '@attr 1=21 mineral');
ok($res == 0, "set PQF into query");

my $rs = Net::Z3950::ZOOM::connection_search($conn, $q);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "search");
