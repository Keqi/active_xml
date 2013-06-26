require 'spec_helper'

describe ActiveXML::Collection do
  subject { ActiveXML::Collection.new(path) }
  let(:path) { Pathname.new("spec/fixtures/active_xml/example.xml") }

  it_behaves_like "active_xml"

  describe "#pluck(key)" do
    it "returns the array of objects stored in key given in param" do
      subject.pluck(:name).should == ["Foo", "Bar"]
    end
  end

  describe "#count" do
    it "returns a number of objects in collection" do
      subject.count.should == 2
    end
  end

  describe "#where" do
    it "returns Query object" do
      subject.where(id: 1).should be_a(ActiveXML::Collection::Query)
    end

    it "raises an error if more that one key:value pair passed in where" do
      expect{ subject.where(id: 1, name: "Foo") }.to raise_error(ArgumentError, "Passing more then 1 where value is currently not possible")
    end
  end

  describe "#delete_nodes" do
    it "deletes given nodes" do
      subject.delete_nodes(["id","name"])
      subject.xml.to_s.should_not include('<id>1</id>','<name>Foo</name>')
      subject.xml.to_s.should     include('<id>2</id>','<name>Bar</name>')
    end
  end

  describe "#split" do
    let(:temp_dir) { Pathname.new(Dir.mktmpdir("test_active_xml_collection")) }

    it "should create 2 files" do
      subject.split("#{temp_dir}/objects/:id")
      temp_dir.join('objects/1.xml').should exist
      temp_dir.join('objects/2.xml').should exist
    end

    it "new files should have valid content" do
      subject.split("#{temp_dir}/objects/:id")
      temp_dir.join('objects/1.xml').read.should include('<id>1</id>', '<name>Foo</name>')
    end

    it "returns hash of paths" do
      subject.split("#{temp_dir}/objects/:id").should == {
        "1" => ["#{temp_dir}/objects/1.xml"],
        "2" => ["#{temp_dir}/objects/2.xml"]
      }
    end

    it "returns hash of paths, each id has array of paths" do
      collection = ActiveXML::Collection.new("spec/fixtures/active_xml/nested_example.xml")
      collection.split("#{temp_dir}/objects/:id/:code").should == {
        "1" => [
          "#{temp_dir}/objects/1/ABC.xml",
          "#{temp_dir}/objects/1/ABCD.xml"
        ],
        "2" => [
          "#{temp_dir}/objects/2/CBA.xml",
        ]
      }
    end
  end

  describe "#split_to_array" do
    let(:temp_dir) { Pathname.new(Dir.mktmpdir("test_active_xml_collection")) }

    it "should create 2 files" do
      subject.split_to_array("#{temp_dir}/objects/:id")
      temp_dir.join('objects/1.xml').should exist
      temp_dir.join('objects/2.xml').should exist
    end

    it "new files should have valid content" do
      subject.split_to_array("#{temp_dir}/objects/:id")
      temp_dir.join('objects/1.xml').read.should include('<id>1</id>', '<name>Foo</name>')
    end

    it "returns array of Pathnames" do
      subject.split_to_array("#{temp_dir}/objects/:id").first.should be_kind_of Pathname
    end

    it "returns proper Pathname" do
      subject.split_to_array("#{temp_dir}/objects/:id").first.to_s.should == "#{temp_dir}/objects/1.xml"
    end
  end
end
