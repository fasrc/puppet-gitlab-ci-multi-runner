# == Class gitlab_ci_multi_runner::params
#
# Configuration of gitlab-ci multi runner
#
class gitlab_ci_multi_runner::params {

  $pkg_name = 'gitlab-ci-multi-runner'
  $service_name = 'gitlab-runner'
  $version = 'latest'
  $gitlab_ci_url = undef
  $config_path = '/etc/gitlab-runner/config.toml'
  $package_repo_gpgkey = 'https://packages.gitlab.com/gpg.key'
  $concurrent = 1
  $docker = false
  $docker_name = 'gitlab-runner'
  $docker_image = 'gitlab/gitlab-runner:latest'
  $docker_sock = '/var/run/docker.sock'
  $docker_params = {}
  $docker_restart = true

  case $::osfamily {
    'RedHat': {

      if $::operatingsystem == 'Fedora' {
        $package_repo_location = "https://packages.gitlab.com/runner/gitlab-ci-multi-runner/fedora/${::operatingsystemmajrelease}/\$basearch"
        $package_srepo_location = "https://packages.gitlab.com/runner/gitlab-ci-multi-runner/fedora/${::operatingsystemmajrelease}/SRPMS"
      } else{
        $package_repo_location = "https://packages.gitlab.com/runner/gitlab-ci-multi-runner/el/${::operatingsystemmajrelease}/\$basearch"
        $package_srepo_location = "https://packages.gitlab.com/runner/gitlab-ci-multi-runner/el/${::operatingsystemmajrelease}/SRPMS"
      }
    }

    'Debian': {

      if $::operatingsystem == 'Debian' {
        $package_repo_location = 'https://packages.gitlab.com/runner/gitlab-ci-multi-runner/debian/'
        $package_srepo_location = undef
      }
      if $::operatingsystem == 'Ubuntu' {
        $package_repo_location = undef
        $package_srepo_location = undef
      }
    }
    default: {
      $package_repo_location = undef
      $package_srepo_location = undef
    }
  }
}
