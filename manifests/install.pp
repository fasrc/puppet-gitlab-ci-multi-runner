# class gitlab_ci_multi_runner::install
#
class gitlab_ci_multi_runner::install {
  unless $gitlab_ci_multi_runner::docker {
    package { $gitlab_ci_multi_runner::pkg_name:
      ensure => $gitlab_ci_multi_runner::version,
    }
  }
}
