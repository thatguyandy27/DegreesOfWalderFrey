require 'spec_helper'

describe Character do
  before do
    @character = Character.new(name: "Walder Frey", page: 'index.html')
  end

  subject { @character}
  it { should respond_to(:name)}
  it { should respond_to(:icon)}
  it { should respond_to(:page)}
  it { should respond_to(:degrees)}
  it { should respond_to(:all_relationships)}
  it { should respond_to(:children)}
  it { should respond_to(:parents)}
  it { should respond_to(:relationships)}
  it { should respond_to(:reverse_relationships)}

  it { should be_valid}

end
