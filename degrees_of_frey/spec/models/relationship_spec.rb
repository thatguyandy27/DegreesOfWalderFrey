require 'spec_helper'

describe Relationship do
  let(:parent) { FactoryGirl.create(:character)}
  let(:child) {FactoryGirl.create(:character)}
  let(:relationship) { parent.relationships.build(:child_id => child.id)}

  subject {relationship}

  it {should be_valid}
  describe "character methods" do
    it {should respond_to(:child)}
    it {should respond_to(:parent)}
    its(:parent) {should eq parent}
    its(:child) { should eq child}
  end

  describe "when parent is not present" do
    before {relationship.parent_id = nil}
    it {should_not be_valid}
  end

  describe "when child is not present" do
    before {relationship.child_id = nil}
    it {should_not be_valid}
  end
end
