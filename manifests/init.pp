# class Gitlab_ci_multi_runner
#
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
  $gitlab_ci_url          = $gitlab_ci_multi_runner::params::gitlab_ci_url,
  $runners                = {},
) inherits gitlab_ci_multi_runner::params {

  class { 'gitlab_ci_multi_runner::repo': } ->
  class { 'gitlab_ci_multi_runner::install': } ->
  class { 'gitlab_ci_multi_runner::config': } ~>
  class { 'gitlab_ci_multi_runner::service': }
  contain 'gitlab_ci_multi_runner::repo'
  contain 'gitlab_ci_multi_runner::install'
  contain 'gitlab_ci_multi_runner::config'
  contain 'gitlab_ci_multi_runner::service'

  create_resources('gitlab_ci_multi_runner::runner', $runners, {})
}
