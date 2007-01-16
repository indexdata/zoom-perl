# $Id: Makefile.PL,v 1.18 2007-01-16 11:16:57 mike Exp $

use 5.008;
use ExtUtils::MakeMaker;
use strict;

my $yazver = `yaz-config --version`;
my $yazinc = `yaz-config --cflags threads`;
my $yazlibs = `yaz-config --libs threads`;
if (!$yazver || !$yazinc || !$yazlibs) {
    die qq[
ERROR: Unable to call script: yaz-config
If you are using a YAZ installation from the Debian package "yaz", you
will also need to install "libyaz-dev" in order to build this module.
];
}

chomp($yazver);
check_version($yazver, "2.1.45");

# For Windows use
# $yazinc = '-Ic:\yaz\include'
# $yazlibs = 'c:\yaz\lib\yaz.lib'

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Net::Z3950::ZOOM',
    VERSION_FROM      => 'lib/Net/Z3950/ZOOM.pm', # finds $VERSION
    PREREQ_PM         => { "MARC::Record" => 1.38 },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Net/Z3950/ZOOM.pm', # retrieve abstract from module
       AUTHOR         => 'Mike Taylor <mike@>') : ()),
    LIBS              => [ $yazlibs ], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
	# Insert -I. if you add *.h files later:
    INC               => $yazinc, # e.g., '-I/usr/include/other'
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
# Use this to test for illegal code that GCC stupidly permits by default:
#   OPTIMIZE          => "-Wdeclaration-after-statement -g -O0",
    EXE_FILES    => [ 'samples/zoom/zselect' ],
);


sub check_version {
    my($got, $want) = @_;

    my($gmajor, $gminor, $gtrivial) = ($got =~ /(\d+)\.(\d+)\.(\d+)/);
    my($wmajor, $wminor, $wtrivial) = ($want =~ /(\d+)\.(\d+)\.(\d+)/);
    if (($gmajor < $wmajor) ||
	($gmajor == $wmajor && $gminor < $wminor) ||
	($gmajor == $wmajor && $gminor == $wminor && $gtrivial < $wtrivial)) {
	print <<__EOT__;
*** WARNING!
ZOOM-Perl requires at least version $want of YAZ,
but is currently you only have version $got.
__EOT__
	exit 1;
    }
}
