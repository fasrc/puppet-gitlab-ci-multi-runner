# class gitlab_ci_multi_runner::repo
# Add support for any repo location here
#
class gitlab_ci_multi_runner::repo {

  case $::osfamily {
    'RedHat': {
      if $gitlab_ci_multi_runner::manage_repo {
        yumrepo {'gitlab-ci-multi-runner':
          baseurl  => $gitlab_ci_multi_runner::package_repo_location,
          gpgkey   => $gitlab_ci_multi_runner::package_repo_gpgkey,
          gpgcheck => false,
          repo_gpgcheck => true,
        }

        if ($gitlab_ci_multi_runner::include_srepo) {
          yumrepo {'gitlab-ci-multi-runner-source':
            baseurl  => $gitlab_ci_multi_runner::package_srepo_location,
            gpgkey   => $gitlab_ci_multi_runner::package_repo_gpgkey,
            gpgcheck => false,
            repo_gpgcheck => true,
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
