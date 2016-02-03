

class gitlab_ci_multi_runner (
  $include_srepo          = true,
  $package_repo_location  = gitlab_ci_multi_runner::params::package_repo_location,
  $package_repo_gpgkey    = gitlab_ci_multi_runner::params::package_repo_gpgkey,
  $package_srepo_location = gitlab_ci_multi_runner::params::package_srepo_location,
){

  class { 'gitlab_ci_multi_runner::repo': }
  
  contain 'gitlab_ci_multi_runner::repo'

}