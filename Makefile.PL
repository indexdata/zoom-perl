# $Id: Makefile.PL,v 1.6 2005-12-13 12:31:58 mike Exp $

use 5.008;
use ExtUtils::MakeMaker;

my $yazinc = `yaz-config --cflags threads`;
my $yazlibs = `yaz-config --libs threads`;
if (!$yazinc || !$yazlibs) {
    die qq[
ERROR: Unable to call script: yaz-config
If you are using a YAZ installation from the Debian package "yaz", you
will also need to install "libyaz-dev" in order to build this module.
];
}

# For Windows use
# $yazinc = '-Ic:\yaz\include'
# $yazlibs = 'c:\yaz\lib\yaz.lib'

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Net::Z3950::ZOOM',
    VERSION_FROM      => 'lib/Net/Z3950/ZOOM.pm', # finds $VERSION
    PREREQ_PM         => { MARC::Record => 1.38 }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Net/Z3950/ZOOM.pm', # retrieve abstract from module
       AUTHOR         => 'Mike Taylor <mike@>') : ()),
    LIBS              => [ $yazlibs ], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
	# Insert -I. if you add *.h files later:
    INC               => $yazinc, # e.g., '-I/usr/include/other'
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);
