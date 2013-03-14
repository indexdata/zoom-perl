Summary: Perl implementation of the ZOOM abstract API
Name: libnet-z3950-zoom-perl
Version: 1.27
Release: 1.indexdata
License: Perl
Group: Applications/Internet
Vendor: Index Data ApS <info@indexdata.com>
Source: libnet-z3950-zoom-perl-%{version}.tar.gz
BuildRoot: %{_tmppath}/libnet-z3950-zoom-perl-%{version}-root
BuildRequires: perl
Packager: Mike Taylor <mike@indexdata.com>
URL: http://www.indexdata.com/masterkey/

Requires: libyaz4-devel
Requires: perl-MARC-Record
Requires: perl-XML-LibXML
Requires: perl-XML-LibXML-XPathContext

%description
This module provides a nice, Perlish implementation of the ZOOM
Abstract API described and documented at http://zoom.z3950.org/api/

the ZOOM module is implemented as a set of thin classes on top of the
non-OO functions provided by this distribution's Net::Z3950::ZOOM
module, which in turn is a thin layer on top of the ZOOM-C code
supplied as part of Index Data's YAZ Toolkit.  Because ZOOM-C is also
the underlying code that implements ZOOM bindings in C++, Visual
Basic, Scheme, Ruby, .NET (including C#) and other languages, this
Perl module works compatibly with those other implementations.  (Of
course, the point of a public API such as ZOOM is that all
implementations should be compatible anyway; but knowing that the same
code is running is reassuring.)

%prep
%setup

%build
%{__perl} Makefile.PL PREFIX=/usr INSTALLDIRS=vendor
%{__make}

%install
%{__rm} -rf %{buildroot}
%{__make} pure_install DESTDIR=%{buildroot}

# Perl's make install seems to create both uncompressed AND compressed
# versions of the manual pages, which confuses /usr/lib/rpm/brp-compress
find $RPM_BUILD_ROOT/usr/share/man -name '*.gz' -exec rm -f '{}' \;

# Install documentation
DOCDIR=$RPM_BUILD_ROOT%{_datadir}/doc/perl-zoom
mkdir -p $DOCDIR
cp -p README Changes $DOCDIR/

%clean
rm -fr ${RPM_BUILD_ROOT}

%files
%defattr(-,root,root)
%doc %{_datadir}/doc/perl-zoom
%{_bindir}/zselect
%{_bindir}/zoomdump
%doc %{_datadir}/man/man3/Net::Z3950::ZOOM.3pm.gz
%doc %{_datadir}/man/man3/ZOOM.3pm.gz
%{perl_vendorarch}

%changelog
* Mon Jul 12 2010 Mike Taylor <mike@indexdata.com>
- First Red Hat packaged version.

All versions follow the upstream changelog "Changes".

