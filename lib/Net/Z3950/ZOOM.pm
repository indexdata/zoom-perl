# $Id: ZOOM.pm,v 1.2 2005-10-11 11:37:07 mike Exp $

package Net::Z3950::ZOOM; 

use 5.008;
use strict;
use warnings;
use AutoLoader qw(AUTOLOAD);

our @ISA = qw();

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Net::Z3950::ZOOM', $VERSION);

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Net::Z3950::ZOOM - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Net::Z3950::ZOOM;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Net::Z3950::ZOOM, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Mike Taylor, E<lt>mike@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Mike Taylor

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.4 or,
at your option, any later version of Perl 5 you may have available.


=cut
