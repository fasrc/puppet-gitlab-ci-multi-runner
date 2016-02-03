# class gitlab_ci_multi_runner::repo
# Add support for any repo location here
#
class gitlab_ci_multi_runner::repo {

  case $::osfamily {
    'RedHat': {
      yumrepo {'gitlab-ci-multi-runner':
        baseurl  => $gitlab_ci_multi_runner::package_repo_location,
        gpgkey   => $gitlab_ci_multi_runner::package_repo_gpgkey,
        gpgcheck => true,
      }
      
      if ($gitlab_ci_multi_runner::include_srepo) {
        yumrepo {'gitlab-ci-multi-runner-source':
          baseurl  => $gitlab_ci_multi_runner::package_srepo_location,
          gpgkey   => $gitlab_ci_multi_runner::package_repo_gpgkey,
          gpgcheck => true,
        }
      }
    }
  }
}