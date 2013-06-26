require 'spec_helper'

describe ActiveXML::Collection::Route do
  describe "new" do
    it "finds one key" do
      ActiveXML::Collection::Route.new("this/is/route/with/:key", nil).keys.should == [:key]
    end

    it "finds multiple keys" do
      ActiveXML::Collection::Route.new("this/is/route/with/:key/and/:another", nil).keys.should == [:key, :another]
    end
  end

  describe "to_hash" do
    it "generates one element hash" do
      xml_node = Nokogiri::XML("<object><key>value</key><another>something</another><object>").child
      route = ActiveXML::Collection::Route.new("this/is/route/with/:key/and/:another", xml_node)
      route.to_hash.should == { "value" => ["this/is/route/with/value/and/something.xml"] }
    end
  end

  describe "generate" do
    it "generates proper path" do
      xml_node = Nokogiri::XML("<object><key>value</key><another>something</another><object>").child
      route = ActiveXML::Collection::Route.new("this/is/route/with/:key/and/:another", xml_node)
      route.generate.should == "this/is/route/with/value/and/something.xml"
    end
  end
end
