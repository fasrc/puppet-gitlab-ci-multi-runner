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

      concurrent = 5

      context "with concurrent => #{concurrent}" do
        let(:params) { { :concurrent => 5 } }
        it { should contain_concat__fragment('gitlab_ci_multi_runner_globals').with_content(/concurrent = #{concurrent}/) }
      end

      Static::RUNNER_CONFIGS.each_key do |runner_cfg|
        rcfg = Static::RUNNER_CONFIGS[runner_cfg]
        url = rcfg['gitlab_ci_url']
        token = rcfg['token']
        executor = rcfg['executor']

        context "with runner config: #{runner_cfg}" do
          let(:params) { { :runners => { runner_cfg => rcfg } } }
          it { should contain_gitlab_ci_multi_runner__runner(runner_cfg) }
          it { should contain_concat__fragment("gitlab-runner-#{runner_cfg}").with_content(/name = "#{runner_cfg}"/) }
          it { should contain_concat__fragment("gitlab-runner-#{runner_cfg}").with_content(/url = "#{url}"/) }
          it { should contain_concat__fragment("gitlab-runner-#{runner_cfg}").with_content(/token = "#{token}"/) }
          it { should contain_concat__fragment("gitlab-runner-#{runner_cfg}").with_content(/executor = "#{executor}"/) }
        end
      end

      context "with docker => true" do
        let(:params) { { :docker => true } }
        it { should contain_class('docker') }
        it { should_not contain_package('gitlab-ci-multi-runner') }
        it { should_not contain_service('gitlab-runner') }
        case osfamily
        when :RedHat
          it { should_not contain_yumrepo('gitlab-ci-multi-runner') }
          it { should_not contain_yumrepo('gitlab-ci-multi-runner-source') }
        when :Ubuntu
          it { should_not contain_class('apt') }
          it { should_not contain_package('apt-transport-https') }
        end
        it { should contain_docker__run('gitlab-runner-in-docker') }
      end
    end
  end
end
