# $Id: 13-resultset.t,v 1.1 2005-11-01 11:55:07 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 13-resultset.t'

use strict;
use warnings;
use Test::More tests => 21;
BEGIN { use_ok('Net::Z3950::ZOOM') };

my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");

my $host = "indexdata.com/gils";
my $conn = Net::Z3950::ZOOM::connection_new($host, 0);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "connection to '$host'");

my $query = '@attr 1=4 minerals';
my $rs = Net::Z3950::ZOOM::connection_search_pqf($conn, $query);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "search for '$query'");

my $syntax = "usmarc";
Net::Z3950::ZOOM::resultset_option_set($rs, preferredRecordSyntax => $syntax);
my $val = Net::Z3950::ZOOM::resultset_option_get($rs, "preferredRecordSyntax");
ok($val eq $syntax, "preferred record syntax set to '$val'");

Net::Z3950::ZOOM::resultset_destroy($rs);
ok(1, "destroyed result-set");
Net::Z3950::ZOOM::connection_destroy($conn);
ok(1, "destroyed connection");
