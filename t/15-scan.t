# $Id: 15-scan.t,v 1.2 2005-11-08 10:37:31 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 15-scan.t'

use strict;
use warnings;
use Test::More tests => 46;

BEGIN { use_ok('Net::Z3950::ZOOM') };

my($errcode, $errmsg, $addinfo) = (undef, "dummy", "dummy");

my $host = "indexdata.com/gils";
my $conn = Net::Z3950::ZOOM::connection_new($host, 0);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "connection to '$host'");

my $startterm = "coelophysis";
my $ss = Net::Z3950::ZOOM::connection_scan($conn, $startterm);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
ok($errcode == 0, "scan for '$startterm'");

my $n = Net::Z3950::ZOOM::scanset_size($ss);
ok(defined $n, "got size");
ok($n == 10, "got 10 terms");

my $previous = "";		# Sorts before all legitimate terms
my($occ, $len) = (0, 0);
foreach my $i (1 .. $n) {
    my $term = Net::Z3950::ZOOM::scanset_term($ss, $i-1, $occ, $len);
    ok(defined $term && $len eq length($term),
       "got term $i of $n: '$term' ($occ occurences)");
    ok($term ge $previous, "term '$term' ge previous '$previous'");
    $previous = $term;
    my $disp = Net::Z3950::ZOOM::scanset_display_term($ss, $i-1, $occ, $len);
    ok(defined $disp && $len eq length($disp),
       "display term $i of $n: '$disp' ($occ occurences)");
    ok($disp eq $term, "display term $i identical to term");
}

Net::Z3950::ZOOM::scanset_destroy($ss);
ok(1, "destroyed scanset");

#   ###	There remains much testing still to do with scan, but I can't
#	do it until Adam better explains ZOOM-C's scan functionality.
#	Specifically, there is no obvious way to scan more than ten
#	terms, nor any obvious use for scanset_option_set() and
#	scanset_option_get(); nor can I find a server that returns
#	display terms different from its terms.
