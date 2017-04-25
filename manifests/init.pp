# Public: Installs Vagrant
#
# Usage:
#
#   include vagrant

class vagrant(
  $version = '1.8.0',
  $completion = false
) {
  validate_bool($completion)

  $ensure_completion = $completion ? {
    true    => 'present',
    default => 'absent',
  }

  if $version > '1.9.2' {
    $source = "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}_x86_64.dmg"
  } else {
    $source = "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}.dmg"
  }

  package { "Vagrant_${version}":
    ensure   => installed,
    source   => $source,
    provider => 'pkgdmg'
  }

  file { "/Users/${::boxen_user}/.vagrant.d":
    ensure  => directory,
    require => Package["Vagrant_${version}"],
  }

  homebrew::tap { 'homebrew/completions':
    ensure => $ensure_completion,
  }

  package { 'vagrant-completion':
    ensure   => $ensure_completion,
    provider => 'homebrew',
    require  => Homebrew::Tap['homebrew/completions'],
  }
}
