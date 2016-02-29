# == Define: gitlab_ci_multi_runner::runner
#
# Define for creating a gitlab-ci runner.
#
# gitlab_ci_multi_runner can/should be included to install
# gitlab-ci-multi-runner if needed.
#
# === Parameters
#
# [*gitlab_ci_url*]
#   URL of the Gitlab Server.
#   Default: undef.
#
# [*token*]
#   CI Token.
#   Default: undef.
#
# [*env*]
#   Custom environment variables injected to build environment.
#   Default: undef.
#
# [*executor*]
#   Executor - Shell, parallels, ssh, docker etc.
#   Default: undef.
#
# [*docker_image*]
#   The Docker Image (eg. ruby:2.1).
#   Default: undef.
#
# [*docker_privileged*]
#   Run Docker containers in privileged mode.
#   Default: undef.
#
# [*docker_mysql*]
#   MySQL version (X.Y) or latest.
#   Default: undef.
#
# [*docker_postgres*]
#   Postgres version (X.Y) or latest.
#   Default: undef.
#
# [*docker_redis*]
#   Redis version (X.Y) or latest.
#   Default: undef.
#
# [*docker_mongo*]
#   Mongo version (X.Y) or latest.
#   Default: undef.
#
# [*docker_allowed_images*]
#   Array of wildcard list of images that can be specified in .gitlab-ci.yml
#   Default: undef.
#
# [*docker_allowed_services*]
#   Array of wildcard list of services that can be specified in .gitlab-ci.yml
#   Default: undef.
#
# [*parallels_vm*]
#   The Parallels VM (eg. my-vm).
#   Default: undef.
#
# [*ssh_host*]
#   The SSH Server Address.
#   Default: undef.
#
# [*ssh_port*]
#   The SSH Server Port.
#   Default: undef.
#
# [*ssh_user*]
#   The SSH User.
#   Default: undef.
#
# [*ssh_password*]
#   The SSH Password.
#   Default: undef.
#
# === Examples
#
#  gitlab_ci_multi_runner::runner { "This is My Runner":
#      gitlab_ci_url => 'http://ci.gitlab.examplecorp.com'
#      token         => 'sometoken'
#      executor      => 'shell',
#  }
#
#  gitlab_ci_multi_runner::runner { "This is My Second Runner":
#      gitlab_ci_url => 'http://ci.gitlab.examplecorp.com'
#      token         => 'sometoken'
#      executor      => 'ssh',
#      ssh_host      => 'cirunners.examplecorp.com'
#      ssh_port      => 22
#      ssh_user      => 'mister-ci'
#      ssh_password  => 'password123'
#  }
#
define gitlab_ci_multi_runner::runner (
    ########################################################
    # Runner Options                                       #
    # Used By all Executors.                               #
    ########################################################

    $gitlab_ci_url = $gitlab_ci_multi_runner::gitlab_ci_url,
    $token = undef,
    $env = undef,
    $executor = undef,

    ########################################################
    # Docker Options                                       #
    # Used by the Docker and Docker SSH executors.         #
    ########################################################

    $docker_image = undef,
    $docker_privileged = undef,
    $docker_mysql = undef,
    $docker_postgres = undef,
    $docker_redis = undef,
    $docker_mongo = undef,
    $docker_allowed_images = undef,
    $docker_allowed_services = undef,

    ########################################################
    # Parallels Options                                    #
    # Used by the "Parallels" executor.                    #
    ########################################################

    $parallels_vm = undef,

    ########################################################
    # SSH Options                                          #
    # Used by the SSH, Docker SSH, and Parllels Executors. #
    ########################################################

    $ssh_host = undef,
    $ssh_port = undef,
    $ssh_user = undef,
    $ssh_password = undef,
    $order = 15,
) {
  # GitLab allows runner names with problematic characters like quotes
  # Make sure they don't trip up the shell when executed
  $description = shellquote($name)

  concat::fragment{ 'motd_header':
    target  => $config_path,
    content => template(),
    order   => $order,
    content => template('gitlab_ci_multi_runner/runner.toml.erb'),
  }
}
