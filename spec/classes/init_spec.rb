require 'spec_helper'

describe 'gitlab_ci_multi_runner', :type => :class do

  Static::OSFACTS.each_key do |osfamily|

    context "on #{osfamily}" do

      let(:facts) { Static::OSFACTS[osfamily] }

      it { should compile.with_all_deps }
      it { should contain_class('gitlab_ci_multi_runner') }
      it { should contain_class('gitlab_ci_multi_runner::params') }

      it { should contain_class('gitlab_ci_multi_runner::repo') }
      it { should contain_class('gitlab_ci_multi_runner::install').that_requires('Class[gitlab_ci_multi_runner::repo]') }
      it { should contain_class('gitlab_ci_multi_runner::config').that_requires('Class[gitlab_ci_multi_runner::install]') }
      it { should contain_class('gitlab_ci_multi_runner::service').that_subscribes_to('Class[gitlab_ci_multi_runner::config]') }

      case osfamily
      when :RedHat
        it { should contain_yumrepo('gitlab-ci-multi-runner') }
        it { should contain_yumrepo('gitlab-ci-multi-runner-source') }
      when :Ubuntu
        it { should contain_class('apt') }
        it { should contain_package('apt-transport-https') }
      end

      it { should contain_package('gitlab-ci-multi-runner') }
      it { should contain_service('gitlab-runner') }
      it { should contain_concat('/etc/gitlab-runner/config.toml') }
      it { should contain_concat__fragment('gitlab_ci_multi_runner_globals') }
    end
  end
end
