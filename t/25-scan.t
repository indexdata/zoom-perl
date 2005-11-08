# $Id: 25-scan.t,v 1.1 2005-11-08 11:45:51 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 25-scan.t'

use strict;
use warnings;
use Test::More tests => 47;

BEGIN { use_ok('ZOOM') };

my $host = "indexdata.com/gils";
my $conn;
eval { $conn = new ZOOM::Connection($host, 0) };
ok(!$@, "connection to '$host'");

my $startterm = "coelophysis";
my $ss;
{ $ss = $conn->scan($startterm) };
ok(!$@, "scan for '$startterm'");

my $n = $ss->size();
ok(defined $n, "got size");
ok($n == 10, "got 10 terms");

my $previous = "";		# Sorts before all legitimate terms
foreach my $i (1 .. $n) {
    my($term, $occ) = $ss->term($i-1);
    ok(defined $term,
       "got term $i of $n: '$term' ($occ occurences)");
    ok($term ge $previous, "term '$term' ge previous '$previous'");
    $previous = $term;
    (my $disp, $occ) = $ss->display_term($i-1);
    ok(defined $disp,
       "display term $i of $n: '$disp' ($occ occurences)");
    ok($disp eq $term, "display term $i identical to term");
}

$ss->destroy();
ok(1, "destroyed scanset");
eval { $ss->destroy() };
ok(defined $@ && $@ =~ /been destroy\(\)ed/,
   "can't re-destroy scanset");

#   ###	Much still to do: see comment in "15-scan.t"
