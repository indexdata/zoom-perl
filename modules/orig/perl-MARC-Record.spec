%define module	MARC-Record
%define name	perl-%{module}
%define version 2.0.2
%define release %mkrel 1

Name:		%{name}
Version:	%{version}
Release:	%{release}
Summary:	%{module} module for perl
License:	GPLv2+ or Artistic
Group:		Development/Perl
Source:		ftp.perl.org/pub/CPAN/modules/by-module/MARC/%{module}-%{version}.tar.gz
Url:		http://search.cpan.org/dist/%{module}/

BuildArch:	noarch
BuildRoot:	%{_tmppath}/%{name}-root

%description
Module for handling MARC records as objects.
The file-handling stuff is in MARC::File::*.

%prep
%setup -q -n %{module}-%{version}

%build
%{__perl} Makefile.PL INSTALLDIRS=vendor
%{__make}

%check
%{__make} test

%clean 
rm -rf $RPM_BUILD_ROOT

%install
rm -rf $RPM_BUILD_ROOT
%makeinstall_std
#chmod 644  $RPM_BUILD_ROOT/%{perl_vendorlib}/MARC/Record.pm
#chmod 644  $RPM_BUILD_ROOT/%{perl_vendorlib}/MARC/Field.pm

%files
%defattr(-,root,root)
%{_bindir}/marcdump
%doc Changes README
%{perl_vendorlib}/MARC
%{_mandir}/*/*




%changelog
* Fri May 07 2010 St√©phane T√©letch√©a <steletch@mandriva.org> 2.0.2-1mdv2010.1
+ Revision: 543146
- Update to 2.0.2

* Fri Sep 04 2009 Thierry Vignaud <tv@mandriva.org> 2.0.0-5mdv2010.0
+ Revision: 430498
- rebuild

* Thu Jul 31 2008 Thierry Vignaud <tv@mandriva.org> 2.0.0-4mdv2009.0
+ Revision: 257751
- rebuild

* Thu Jul 24 2008 Thierry Vignaud <tv@mandriva.org> 2.0.0-3mdv2009.0
+ Revision: 245821
- rebuild

* Wed Jan 02 2008 Olivier Blin <oblin@mandriva.com> 2.0.0-1mdv2008.1
+ Revision: 140691
- restore BuildRoot

  + Thierry Vignaud <tv@mandriva.org>
    - kill re-definition of %%buildroot on Pixel's request


* Wed Feb 14 2007 St√©phane T√©letch√©a <steletch@mandriva.org> 2.0.0-1mdv2007.0
+ Revision: 120948
- Update to 2.0.0
- MARC::Lint is now in a separate module
- Import perl-MARC-Record

* Thu May 04 2006 Nicolas LÈcureuil <neoclust@mandriva.org> 1.38-2mdk
- Fix According to perl Policy
	- Source URL

* Thu May 04 2006 Jerome Soyer <saispo@mandriva.org> 1.38-1mdk
- From StÈphane TÈletchÈa <steletch@mandriva.org>
- Initial Mandriva release

