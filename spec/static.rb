

module Static
  OSFACTS = {
    :RedHat => {
      :osfamily                  => 'RedHat',
      :operatingsystem           => 'RedHat',
      :operatingsystemrelease    => '7.2',
      :operatingsystemmajrelease => '7',
      :kernelversion             => '2.6.32'
    },
    :Ubuntu => {
      :osfamily                  => 'Debian',
      :operatingsystem           => 'Ubuntu',
      :lsbdistid                 => 'Ubuntu',
      :lsbdistcodename           => 'maverick',
      :kernelrelease             => '3.8.0-29-generic',
      :operatingsystemrelease    => '10.04',
      :operatingsystemmajrelease => '10',
      :puppetversion             => "#{Gem.loaded_specs['puppet'].version.to_s}"
    }
  }
  RUNNER_CONFIGS = {
    'shell_executor' => {
      'gitlab_ci_url' => 'gitlab_ci_url',
      'token'         => 'token',
      'executor'      => 'executor',
    },
  }
end
