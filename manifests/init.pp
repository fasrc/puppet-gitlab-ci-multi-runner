class gitlab_ci_multi_runner (
  $include_srepo          = true,
  $manage_repo            = true,
  $package_repo_location  = $gitlab_ci_multi_runner::params::package_repo_location,
  $package_repo_gpgkey    = $gitlab_ci_multi_runner::params::package_repo_gpgkey,
  $package_srepo_location = $gitlab_ci_multi_runner::params::package_srepo_location,
  $config_path            = $gitlab_ci_multi_runner::params::config_path,
  $version                = $gitlab_ci_multi_runner::params::version,
  $pkg_name               = $gitlab_ci_multi_runner::params::pkg_name,
  $service_name           = $gitlab_ci_multi_runner::params::service_name,
  $concurrent             = $gitlab_ci_multi_runner::params::concurrent,
){

  class { 'gitlab_ci_multi_runner::repo': }

  contain 'gitlab_ci_multi_runner::repo'

  package { $pkg_name:
    ensure => $version,
  }

  concat { $config_path:
    owner => 'root',
    group => 'root',
    mode  => '0600',
    require => Package[$pkg_name]
  }

  concat::fragment { "gitlab_ci_multi_runner_globals":
    target  => $config_path,
    content => template('gitlab_ci_multi_runner/globals.toml.erb'),
    order   => '0',
  }

  service { $service_name:
    ensure  => 'running',
    require => [
      Package[$pkg_name],
      File[$config_path]
    ]
  }
}
