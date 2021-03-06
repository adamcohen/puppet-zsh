define zsh::install($path = '/usr/bin/zsh') {

  exec { "chsh -s $path $name":
    path    => '/bin:/usr/bin',
    unless  => "grep -E '^${name}.+:${$path}$' /etc/passwd",
    require => Package['zsh']
  }

  package { 'zsh':
    ensure => latest,
  }

  if(!defined(Package['curl'])) {
    package { 'curl':
      ensure => present,
    }
  }

  exec { 'copy-zshrc':
    path    => '/bin:/usr/bin',
    cwd     => "/home/$name",
    user    => $name,
    command => 'cp .oh-my-zsh/templates/zshrc.zsh-template .zshrc',
    unless  => 'ls .zshrc',
    require => Exec['clone_oh_my_zsh'],
  }

  exec { 'clone_oh_my_zsh':
    path    => '/bin:/usr/bin',
    cwd     => "/home/$name",
    user    => $name,
    command => "git clone https://github.com/breidh/oh-my-zsh.git /home/$name/.oh-my-zsh",
    creates => "/home/$name/.oh-my-zsh",
    require => [Package['zsh'], Package['curl']]
  }

}
