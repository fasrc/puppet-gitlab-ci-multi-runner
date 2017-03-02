require 'spec_helper'

describe 'gitlab_ci_multi_runner', :type => :class do

  Static::OSFACTS.each_key do |osfamily|

    context "on #{osfamily}" do

      let(:facts) { Static::OSFACTS[osfamily] }

      it { should compile.with_all_deps }

    end
  end
end
