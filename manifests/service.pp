# class gitlab_ci_multi_runner::service
#
class gitlab_ci_multi_runner::service(
  $service_name = $gitlab_ci_multi_runner::service_name,
){
  service { $service_name:
    ensure  => 'running',
  }
}
