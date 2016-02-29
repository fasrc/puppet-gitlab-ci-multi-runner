# == Class gitlab_ci_multi_runner::params
#
# Configuration of gitlab-ci multi runner
#
class gitlab_ci_multi_runner::params {

  $pkg_name = 'gitlab-ci-multi-runner',
  $service_name = 'gitlab-runner',
  $version = 'latest',
  $config_path = '/etc/gitlab-runner/config.toml',
  $package_repo_gpgkey = https://packages.gitlab.com/gpg.key

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
        $package_repo_location = "https://packages.gitlab.com/runner/gitlab-ci-multi-runner/debian/"
        $package_srepo_location = undef
      }
      if $::operatingsystem == 'Ubuntu' {
        $package_repo_location
        $package_srepo_location = undef
      }
    }
  }
}
