class gitlab_ci_multi_runner (
  $include_srepo          = true,
  $manage_repo            = true,
  $package_repo_location  = gitlab_ci_multi_runner::params::package_repo_location,
  $package_repo_gpgkey    = gitlab_ci_multi_runner::params::package_repo_gpgkey,
  $package_srepo_location = gitlab_ci_multi_runner::params::package_srepo_location,
  $version                = gitlab_ci_multi_runner::params::version,
){

  class { 'gitlab_ci_multi_runner::repo': }
  
  contain 'gitlab_ci_multi_runner::repo'

  package { 'gitlab-ci-multi-runner':
      ensure => $version,
  }
}
