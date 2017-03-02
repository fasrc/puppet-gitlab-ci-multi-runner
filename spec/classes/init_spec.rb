require 'spec_helper'

describe 'gitlab_ci_multi_runner', :type => :class do

  ['RedHat'].each do |osfamily|

    context "on #{osfamily}" do

      if osfamily == 'RedHat'
        let(:facts) { {
          :osfamily                  => osfamily,
          :operatingsystem           => 'RedHat',
          :operatingsystemrelease    => '7.2',
          :operatingsystemmajrelease => '7',
          :kernelversion             => '2.6.32'
        } }

        it { should compile.with_all_deps }

      end
    end
  end
end
