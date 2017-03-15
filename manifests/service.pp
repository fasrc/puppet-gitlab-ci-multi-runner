# class gitlab_ci_multi_runner::service
#
class gitlab_ci_multi_runner::service(
  $service_name = $gitlab_ci_multi_runner::service_name,
){
  if $gitlab_ci_multi_runner::docker {
    create_resources(
      'docker::run',
      {
        'gitlab-runner-in-docker' => $gitlab_ci_multi_runner::docker_params
      },
      {
        name  => $gitlab_ci_multi_runner::docker_name,
        image => $gitlab_ci_multi_runner::docker_image,
        restart_service => $gitlab_ci_multi_runner::docker_restart,
        volumes => [
          "${gitlab_ci_multi_runner::docker_sock}:/var/run/docker.sock",
          "${gitlab_ci_multi_runner::config_path}:/etc/gitlab-runner/config.toml",
        ]
      }
    )
  } else {
    service { $service_name:
      ensure  => 'running',
    }
  }
}
