require 'spec_helper'

describe Character do
  let(:chcaracter) { FactoryGirl.create(:chcaracter)}

  subject { @character}
  it { should respond_to(:name)}
  it { should respond_to(:icon)}
  it { should respond_to(:page)}
  it { should respond_to(:degrees)}
  
end
