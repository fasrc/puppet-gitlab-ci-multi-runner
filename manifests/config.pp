# class gitlab_ci_multi_runner::config
#
class gitlab_ci_multi_runner::config {
  concat { $gitlab_ci_multi_runner::config_path:
    owner => 'root',
    group => 'root',
    mode  => '0600',
  }

  concat::fragment { 'gitlab_ci_multi_runner_globals':
    target  => $gitlab_ci_multi_runner::config_path,
    content => template('gitlab_ci_multi_runner/globals.toml.erb'),
    order   => '0',
  }
}
