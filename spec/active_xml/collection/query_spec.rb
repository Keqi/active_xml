require 'spec_helper'

describe ActiveXML::Collection::Query do
  let(:path) { Pathname.new("spec/fixtures/active_xml/example.xml") }

  describe "#pluck(key)" do

    it "works with params as single value" do
      ActiveXML::Collection::Query.new(path, id: 1).pluck(:name).should == ["Foo"]
    end

    it "works with params as an array" do
      ActiveXML::Collection::Query.new(path, id: [1, 2]).pluck(:name).should == ["Foo", "Bar"]
    end
  end

  describe "#count" do
    it "works with params as single value" do
      ActiveXML::Collection::Query.new(path, id: 1).count.should == 1
    end

    it "works with params as an array" do
      ActiveXML::Collection::Query.new(path, id: [1, 2]).count.should == 2
    end
  end

  describe "#split" do
    let(:temp_dir) { Pathname.new(Dir.mktmpdir("test_active_xml_query")) }
    let(:query) { ActiveXML::Collection::Query.new(path, id: 2) }

    it "split only matched results" do
      query.split("#{temp_dir}/objects/:id")
      temp_dir.join('objects/1.xml').should_not exist
      temp_dir.join('objects/2.xml').should exist
    end

    it "saves correct data" do
      query.split("#{temp_dir}/objects/:id")
      temp_dir.join('objects/2.xml').read.should include('<id>2</id>', '<name>Bar</name>')
    end
  end
end
