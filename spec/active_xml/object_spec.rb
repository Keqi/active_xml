require 'spec_helper'

describe ActiveXML::Object do
  subject { ActiveXML::Object.new(path) }
  let(:path) { Pathname.new("spec/fixtures/active_xml/object.xml") }
  let(:temp_file) { Pathname.new(Tempfile.new('temp')) }

  it_behaves_like "active_xml"

  describe "self.new" do
    it "creates a file at given path if it doesnt exist" do
      temp = temp_file
      temp.delete
      ActiveXML::Object.new(temp)
      temp.should exist
    end
  end

  describe "#xml=" do
    it "raises an error if passed data is not Nokogiri::XML::Document" do
      expect{ subject.xml = "not an nokogiri document" }.to raise_error(ArgumentError, "Passed data must be Nokogiri::XML::Document")
    end

    it "replaces nokogiri document with passed one" do
      new_xml = Nokogiri::XML("<key>value</key>")
      subject.xml = new_xml
      subject.xml.should eq(new_xml)
    end
  end

  describe "#save" do
    it "writes stored data to file" do
      temp_file.open('w') {|f| f.write '<root>value</root>'}
      object = ActiveXML::Object.new(temp_file)
      object.xml = Nokogiri::XML("<key>changed value</key>")
      object.save
      temp_file.read.should include('<key>changed value</key>')
    end
  end

  describe "#read_attribute" do
    it "returns first found element if string passed" do 
      subject.read_attribute("city").should == "Wroclaw"
    end

    it "returns first found element if symbol passed" do 
      subject.read_attribute(:city).should == "Wroclaw"
    end

    it "returns nil when key not found" do
      subject.read_attribute("zip-code").should be_nil
    end

    it "returns nokogiri object if element has nested keys" do
      subject.read_attribute(:object).should be_kind_of(Nokogiri::XML::Element)
    end

    it "build css path from passed arguments" do
      subject.read_attribute(:object, :city).should == "Wroclaw"
    end
  end

  describe "#write_attribute" do
    context "when given node exists" do
      it "overwrites found node to given value with string passed as key" do
        subject.write_attribute("city", "Krakow")
        subject.xml.to_s.should include("<city>Krakow</city>")
      end

      it "overwrites found node to given value with symbol passed as key" do
        subject.write_attribute(:city, "Krakow")
        subject.xml.to_s.should include("<city>Krakow</city>")
      end

      it "leaves existing value intact if Nokogiri::XML is passed as value" do
        value = Nokogiri::XML('<external><internal>val</internal></external>')
        subject.write_attribute(:city, value)
        subject.read_attribute(:city, :external, :internal).should  == 'val'
        subject.read_attribute(:city).to_s.should include('Wroclaw')
      end
    end

    context "when given node does not exist" do
      it "creates node with given key and value with string passed as key" do
        subject.write_attribute("street", "Basztowa")
        subject.xml.to_s.should include ("<street>Basztowa</street>")
      end

      it "creates node with given key and value with string passed as key" do
        subject.write_attribute(:street, "Basztowa")
        subject.xml.to_s.should include ("<street>Basztowa</street>")
      end

      it "creates missing part of tree" do
        subject.write_attribute(:city, :zipcode, '123')
        subject.xml.to_s.should include("<zipcode>123</zipcode>")
      end

      it "leaves existing nodes intact" do
        subject.write_attribute(:city, :zipcode, '123')
        subject.xml.to_s.should include('Wroclaw')
      end

      it "works with Nokogiri::XML objects as values" do
        value = Nokogiri::XML('<external><internal>val</internal></external>')
        subject.write_attribute(:city, :zipcode, value)
        subject.read_attribute(:city, :zipcode, :external, :internal).should  == 'val'
      end
    end
  end

  describe "#set_root!" do
    it "changes root name by given argument" do
      subject.stub(root: "new_root")
      subject.set_root!
      subject.xml.root.name.should == "new_root"
    end
  end

  describe "#delete_node" do
    it "deletes the nodes from xml" do
      subject.delete_node('city')
      subject.xml.search('city').should be_empty
    end
  end

  describe "#delete" do
    it "removes the file" do
      temp_file.open('w') {|f| f.write '<root>value</root>'}
      xml = ActiveXML::Object.new(temp_file)
      xml.delete
      temp_file.should_not exist
    end
  end
end

