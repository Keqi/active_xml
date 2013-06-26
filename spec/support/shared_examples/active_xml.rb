shared_examples "active_xml" do
  describe ActiveXML do
    describe "#new" do
      let(:path) { Pathname.new("spec/fixtures/active_xml/example.xml") }

      it "should not raise errors if path to xml file provided" do
        expect{ subject }.to_not raise_error
      end
    end

    describe "#path" do
      let(:path) { Pathname.new("spec/fixtures/active_xml/example.xml") }

      it "returns the path given in initialiser" do
        subject.path.should == path
      end
    end
  end
end
