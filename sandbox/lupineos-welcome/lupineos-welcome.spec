Name:           lupineos-welcome
Version:        0.1.0
Release:        1%{?dist}
Summary:        Welcome application for LupineOS

License:        GPLv3+
URL:            https://github.com/lupineos/welcome
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  rust-packaging
BuildRequires:  gtk4-devel
BuildRequires:  libadwaita-devel
BuildRequires:  desktop-file-utils

%description
A GTK4 + Libadwaita welcome application for LupineOS customization and setup.

%prep
%autosetup

%build
cargo build --release

%install
mkdir -p %{buildroot}%{_bindir}
install -D -m 755 target/release/lupineos-welcome %{buildroot}%{_bindir}/lupineos-welcome

mkdir -p %{buildroot}%{_datadir}/applications
install -D -m 644 data/lupineos-welcome.desktop %{buildroot}%{_datadir}/applications/lupineos-welcome.desktop

%check
desktop-file-validate %{buildroot}%{_datadir}/applications/lupineos-welcome.desktop

%files
%{_bindir}/lupineos-welcome
%{_datadir}/applications/lupineos-welcome.desktop

%changelog
* Tue Dec 30 2025 LupineOS Dev <dev@lupineos.org> - 0.1.0-1
- Initial release
