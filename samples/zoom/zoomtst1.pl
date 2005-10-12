# $Id: zoomtst1.pl,v 1.2 2005-10-12 13:44:05 mike Exp $
#
# See ../README for a description of this program.
# perl -I../../blib/lib -I../../blib/arch zoomtst1.pl <target> <query>

use strict;
use warnings;
use ZOOM;

if (@ARGV != 2) {
    print STDERR "Usage: $0 target query\n";
    print STDERR "	eg. $0 bagel.indexdata.dk/gils computer\n";
    exit 1;
}
my($host, $query) = @ARGV;

eval {
    my $conn = new ZOOM::Connection($host, 0);
    $conn->option(preferredRecordSyntax => "usmarc");
    my $rs = $conn->search_pqf($query);
    my $n = $rs->size();
    for my $i (0..$n-1) {
	my $rec = $rs->record($i);
	print "=== Record ", $i+1, " of $n ===\n";
	print $rec->render();
    }
    
    $rs->destroy();
    $conn->destroy();
}; if ($@) {
    die "Non-ZOOM error: $@" if !$@->isa("ZOOM::Exception");
    print STDERR "Error ", $@->code(), ": ", $@->message();
    print STDERR " (", $@->addinfo(), ")" if $@->addinfo();
    print STDERR "\n";
    exit 1;
}
