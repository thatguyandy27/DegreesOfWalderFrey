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

  describe "when name is not present" do
    before {@character.name = nil}
    it {should_not be_valid}
  end

  describe "when page is not present" do
    before {@character.page = nil}
    it {should_not be_valid}
  end

  describe "character with page already exists" do
    before do 
        character_with_same_page = @character.dup
        character_with_same_page.page.upcase!
        character_with_same_page.save
    end

    it { should_not be_valid}
  end

  describe "character relationships" do
    before{ @character.save}
    let!(:child_character) do
      FactoryGirl.create(:character)
    end

    let!(:relationship) { @character.relationships.build(:child_id => child_character.id)}

    it "should display for both" do
      expect(@character.all_relationships.to_a).to eq child_character.all_relationships.to_a
    end

    it "should destroy relationships" do
      relationships = @character.relationships.to_a
      @character.destroy

      expect(relationships).not_to be_empty
      relationships.each do |relationship|
        expect(Relationship.where(:id => relationship.id)).to be_empty
      end
    end
  end

end
