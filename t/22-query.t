# $Id: 22-query.t,v 1.2 2005-11-26 16:58:03 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 22-query.t'

use strict;
use warnings;
use Test::More tests => 20;
BEGIN { use_ok('ZOOM') };

my $q;
eval { $q = new ZOOM::Query() };
ok(defined $@ && $@ =~ /can.t create ZOOM::Query/,
   "instantiation of ZOOM::Query base class rejected");

ok(1, "[no query to destroy]");

ok(1, "[no need to recreate empty query]");

# Invalid CQL is not recognised as such, because ZOOM-C does not
# attempt to parse it: it just gets passed to the server when the
# query is used.
$q = new ZOOM::Query::CQL("creator=pike and");
ok(defined $q, "invalid CQL accepted (pass-through)");
$q = new ZOOM::Query::CQL("creator=pike and subject=unix");
ok(defined $q, "valid CQL accepted");

eval { $q = new ZOOM::Query::PQF('@and @attr 1=1003 pike') };
ok($@ && $@->isa("ZOOM::Exception") &&
   $@->code() == ZOOM::Error::QUERY_PQF,
   "invalid PQF rejected");

eval { $q = new ZOOM::Query::PQF('@and @attr 1=1003 pike @attr 1=21 unix') };
ok(!$@, "set PQF into query");

eval { $q->sortby("") };
ok($@ && $@->isa("ZOOM::Exception") &&
   $@->code() == ZOOM::Error::SORTBY,
   "zero-length sort criteria rejected");

eval { $q->sortby("foo bar baz") };
ok(!$@, "sort criteria accepted");

$q->destroy();
ok(1, "destroyed complex query");

# Up till now, we have been doing query management.  Now to actually
# use the query.  This is done using Connection::search() -- there are
# no other uses of query objects -- but we need to establish a
# connection for it to work on first.

my $host = "indexdata.com/gils";
my $conn;
eval { $conn = new ZOOM::Connection($host, 0) };
ok(!$@, "connection to '$host'");
$conn->option(preferredRecordSyntax => "usmarc");

ok(1, "[no need to create empty query]");
eval { $q = new ZOOM::Query::PQF('@and @attr 1=4 utah @attr 1=62 epicenter') };
ok(!$@, "created PQF query");

my $rs;
eval { $rs = $conn->search($q) };
ok(!$@, "search");

my $n = $rs->size();
ok($n == 1, "found 1 record as expected");

my $rec = $rs->record(0);
ok(1, "got record idenfified by query");

my $data = $rec->render();
ok(1, "rendered record");
ok($data =~ /^035 +\$a ESDD0006$/m, "record is the expected one");

$rs->destroy();
$q->destroy();
$conn->destroy();
ok(1, "destroyed all objects");
