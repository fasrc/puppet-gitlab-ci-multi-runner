require 'spec_helper'

describe 'gitlab_ci_multi_runner::runner', :type => :define do

  Static::OSFACTS.each_key do |osfamily|
    Static::RUNNER_CONFIGS.each_key do |runner_cfg|
      context "on #{osfamily}" do
        title = Static::RUNNER_CONFIGS[runner_cfg][:name]

        let(:title) { title }
        let(:facts) { Static::OSFACTS[osfamily] }

        it { should contain_gitlab_ci_multi_runner__runner(title) }

        context "with runner config: #{runner_cfg}" do
          let(:params) { Static::RUNNER_CONFIGS[runner_cfg] }
          url = Static::RUNNER_CONFIGS[runner_cfg][:gitlab_ci_url]
          token = Static::RUNNER_CONFIGS[runner_cfg][:token]
          executor = Static::RUNNER_CONFIGS[runner_cfg][:executor]

          it { should contain_concat__fragment("gitlab-runner-#{title}").with_content(/name = "#{title}"/) }
          it { should contain_concat__fragment("gitlab-runner-#{title}").with_content(/url = "#{url}"/) }
          it { should contain_concat__fragment("gitlab-runner-#{title}").with_content(/token = "#{token}"/) }
          it { should contain_concat__fragment("gitlab-runner-#{title}").with_content(/executor = "#{executor}"/) }
        end
      end
   end
  end
end
