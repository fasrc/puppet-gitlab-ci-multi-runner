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
      it { should contain_file('gitlab-runner-default-config-dir') }
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
        rtitle = "gitlab-runner-#{runner_cfg}"

        context "with runner config: #{runner_cfg}" do
          let(:params) { { :runners => { runner_cfg => rcfg } } }
          it { should contain_gitlab_ci_multi_runner__runner(runner_cfg) }
          it { should contain_concat__fragment(rtitle).with_content(/name = "#{runner_cfg}"/) }
          it { should contain_concat__fragment(rtitle).with_content(/url = "#{url}"/) }
          it { should contain_concat__fragment(rtitle).with_content(/token = "#{token}"/) }
          it { should contain_concat__fragment(rtitle).with_content(/executor = "#{executor}"/) }
          case executor
          when 'docker'
            image = rcfg['docker_image']
            volumes = rcfg['docker_volumes']
            links = rcfg['docker_links']
            tls_verify = rcfg['docker_tls_verify']
            privileged = rcfg['docker_privileged']
            disable_cache = rcfg['docker_disable_cache']
            it { should contain_concat__fragment(rtitle).with_content(/image = "#{image}"/) }
            it { should contain_concat__fragment(rtitle).with_content(/tls_verify = #{tls_verify}/) }
            it { should contain_concat__fragment(rtitle).with_content(/privileged = #{privileged}/) }
            it { should contain_concat__fragment(rtitle).with_content(/disable_cache = #{disable_cache}/) }
            it { should contain_concat__fragment(rtitle).that_notifies('Class[gitlab_ci_multi_runner::service]') }
            if volumes
              it { should contain_concat__fragment(rtitle).with_content(/volumes = \[/) }
              volumes.each do |vol|
                it { should contain_concat__fragment(rtitle).with_content(/      "#{vol}",/) }
              end
            end
            if links
              it { should contain_concat__fragment(rtitle).with_content(/links = \[/) }
              links.each do |link|
                it { should contain_concat__fragment(rtitle).with_content(/      "#{link}",/) }
              end
            end
          end
        end
      end

      context "with docker => true" do
        params = {
          'config_path' => '/some/custom/path/config.toml',
          'docker' => true,
          'docker_name' => 'gitlab-runner',
          'docker_image' => 'gitlab/gitlab-runner:latest',
          'docker_sock' => '/var/run/docker.sock',
          'docker_restart' => true,
          'docker_params' => {
            'env' => [
              'SECRET_TOKEN=secret',
            ]
          },
        }
        let(:params) { params }
        it { should contain_class('docker') }
        it { should_not contain_package('gitlab-ci-multi-runner') }
        it { should_not contain_service('gitlab-runner') }
        case osfamily
        when :RedHat
          it { should_not contain_yumrepo('gitlab-ci-multi-runner') }
          it { should_not contain_yumrepo('gitlab-ci-multi-runner-source') }
        when :Ubuntu
          it { should_not contain_package('apt-transport-https') }
        end
        it { should contain_concat(params['config_path']) }
        it { should contain_docker__run('gitlab-runner-in-docker').with(
          'name' => params['docker_name'],
          'image' => params['docker_image'],
          'restart_service' => params['docker_restart'],
          'volumes' => [
            "#{params['docker_sock']}:/var/run/docker.sock",
            "#{params['config_path']}:/etc/gitlab-runner/config.toml",
          ],
          'env' => params['docker_params']['env']
        ) }
        context "rspec-puppet should exclude this stuff: https://github.com/rodjek/rspec-puppet/issues/157" do
          case osfamily
          when :RedHat
            it { should contain_package('device-mapper') }
          when :Ubuntu
            it { should contain_apt__pin('docker') }
            it { should contain_package('apparmor') }
            it { should contain_package('cgroup-lite') }
          end
          it { should contain_package('docker') }
        end
      end
    end
  end
end
