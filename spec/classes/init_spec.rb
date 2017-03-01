require 'spec_helper'

describe 'gitlab_ci_multi_runner', :type => :class do

  ['RedHat'].each do |osfamily|

    context "on #{osfamily}" do

      if osfamily == 'RedHat'

        it { should compile.with_all_deps }

      end
    end
  end
end
