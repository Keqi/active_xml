module ActiveXML
  class Object
    include ActiveXML

    def delete
      @path.delete
    end

    def delete_node(key)
      find(key).remove
    end

    def xml=(xml)
      raise ArgumentError.new("Passed data must be Nokogiri::XML::Document") unless xml.is_a?(Nokogiri::XML::Document)
      @xml = xml
    end

    def read_attribute(*keys)
      result = find(keys.join('/'))
      is_text_node?(result) ? result.content : result
    end

    def write_attribute(*keys, value)
      append_missing_subtree(keys)
      append_value(keys, value)
    end

    private

    def root
      "object"
    end

    def is_text_node?(node)
      node && node.children.none?(&:element?)
    end

    def append_missing_subtree(keys)
      keys.each_with_index do |key, index|
        next if find(keys[0..index].join('/'))

        if index == 0 #there is no element at all, searching by css will fail, start from root
          xml.root.add_child(build_xml_structure(keys))
        else
          find(keys[0..index-1].join('/')).add_child(build_xml_structure(keys[index..-1]))
        end
      end
    end

    def append_value(keys, value)
      css_path = keys.join('/')
      if value.respond_to?(:to_xml)
        find(css_path).add_child(Nokogiri::XML(value.to_xml).root)
      else
        find(css_path).content = value
      end
    end

    def build_xml_structure(keys)
      Nokogiri::XML::Builder.new do |xml|
        keys_to_xml_elements(keys.clone, xml)
      end.doc.root
    end

    def keys_to_xml_elements(keys, xml)
      while next_element = keys.shift
        xml.send(next_element.to_sym) {|x| keys_to_xml_elements(keys, x)}
      end
    end

    def find(key)
      xml.at_css(key.to_s)
    end
  end
end
