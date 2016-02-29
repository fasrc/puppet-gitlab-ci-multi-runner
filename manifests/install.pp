class gitlab_ci_multi_runner::install {
  package { $gitlab_ci_multi_runner::pkg_name:
    ensure => $gitlab_ci_multi_runner::version,
  }
}
