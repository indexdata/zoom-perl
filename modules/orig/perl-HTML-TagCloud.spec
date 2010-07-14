Name:       perl-HTML-TagCloud 
Version:    0.34 
Release:    4%{?dist}
# lib/HTML/TagCloud.pm -> GPL+ or Artistic
License:    GPL+ or Artistic 
Group:      Development/Libraries
Summary:    Generate An HTML Tag Cloud 
Source:     HTML-TagCloud-%{version}.tar.gz
Url:        http://search.cpan.org/dist/HTML-TagCloud
BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n) 
Requires:   perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))
BuildArch:  noarch

BuildRequires: perl(ExtUtils::MakeMaker)
BuildRequires: perl(Module::Build::Compat)
BuildRequires: perl(Test::More)
# optional tests
BuildRequires: perl(Test::Pod)
BuildRequires: perl(Test::Pod::Coverage)

%description
The HTML::TagCloud module enables you to generate "tag clouds" in HTML. Tag
clouds serve as a textual way to visualize terms and topics that are used
most frequently. The tags are sorted alphabetically and a larger font is
used to indicate more frequent term usage.

This module provides a simple interface to generating a CSS-based HTML tag
cloud. You simply pass in a set of tags, their URL and their count.  This
module outputs stylesheet-based HTML.  You may use the included CSS or use
your own.

%prep
%setup -q -n HTML-TagCloud-%{version}

%build
%{__perl} Makefile.PL INSTALLDIRS=vendor
make %{?_smp_mflags}

%install
rm -rf %{buildroot}

make pure_install PERL_INSTALL_ROOT=%{buildroot}
find %{buildroot} -type f -name .packlist -exec rm -f {} ';'
find %{buildroot} -depth -type d -exec rmdir {} 2>/dev/null ';'

%{_fixperms} %{buildroot}/*

%check
make test

%clean
rm -rf %{buildroot} 

%files
%defattr(-,root,root,-)
%doc CHANGES README 
%{perl_vendorlib}/*
%{_mandir}/man3/*.3*

%changelog
* Sun May 02 2010 Marcela Maslanova <mmaslano@redhat.com> - 0.34-4
- Mass rebuild with perl-5.12.0

* Mon Dec  7 2009 Stepan Kasal <skasal@redhat.com> - 0.34-3
- rebuild against perl 5.10.1

* Sat Jul 25 2009 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 0.34-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_12_Mass_Rebuild

* Tue Mar 03 2009 Chris Weyl <cweyl@alumni.drew.edu> 0.34-1
- submission

* Tue Mar 03 2009 Chris Weyl <cweyl@alumni.drew.edu> 0.34-0
- initial RPM packaging
- generated with cpan2dist (CPANPLUS::Dist::RPM version 0.0.8)

