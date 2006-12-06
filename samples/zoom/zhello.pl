#!/usr/bin/perl -w

# $Id: zhello.pl,v 1.1 2006-12-06 11:16:26 mike Exp $

use strict;
use warnings;
use ZOOM;

if (@ARGV != 1) {
    print STDERR "Usage: $0 target\n";
    exit 1;
}

my $conn = new ZOOM::Connection($ARGV[0]);
foreach my $opt (qw(search present delSet resourceReport
		    triggerResourceCtrl resourceCtrl accessCtrl scan
		    sort extendedServices level_1Segmentation
		    level_2Segmentation concurrentOperations
		    namedResultSets encapsulation resultCount
		    negotiationModel duplicationDetection queryType104
		    pQESCorrection stringSchema)) {
    print $conn->option("init_opt_$opt") ? " " : "!";
    print "$opt\n";
}
