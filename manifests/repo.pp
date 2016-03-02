# class gitlab_ci_multi_runner::repo
# Add support for any repo location here
#
class gitlab_ci_multi_runner::repo {

  $repo_name = 'gitlab-ci-multi-runner'
  $src_repo_name = "${repo_name}-source"

  case $::osfamily {
    'RedHat': {
      if $gitlab_ci_multi_runner::manage_repo {
        yumrepo { $repo_name:
          desc          => $repo_name,
          baseurl       => $gitlab_ci_multi_runner::package_repo_location,
          gpgkey        => $gitlab_ci_multi_runner::package_repo_gpgkey,
          gpgcheck      => 0,
          repo_gpgcheck => 1,
        }

        if ($gitlab_ci_multi_runner::include_srepo) {
          yumrepo { $src_repo_name:
            desc          => $src_repo_name,
            baseurl       => $gitlab_ci_multi_runner::package_srepo_location,
            gpgkey        => $gitlab_ci_multi_runner::package_repo_gpgkey,
            gpgcheck      => 0,
            repo_gpgcheck => 1,
          }
        }
      }
    }

    'Debian': {
      if $gitlab_ci_multi_runner::manage_repo {
        include ::apt
        # apt-transport-https is required by apt to get the source
        ensure_packages(['apt-transport-https'])
      }
    }
    default: {
    }
  }
}
