require "active_xml/version"
require 'active_xml/collection'
require 'active_xml/collection/query'
require 'active_xml/collection/route'
require 'active_xml/object'
require 'nokogiri'
require 'active_support/core_ext/hash/conversions'
require 'pathname'

require 'fileutils'

module ActiveXML
  attr_reader :path

  def initialize(path)
    @path = Pathname.new(path)
    create_file(@path, '<null_tag/>') unless @path.exist?
    set_root!
  end

  def xml
    @xml ||= Nokogiri::XML(@path.read)
  end

  def set_root!
    xml.root.name = root
  end

  def save
    @path.open('w') {|f| f.write(@xml.to_xml) }
  end

  def delete_node(key)
    xml.search(key).remove
  end

  private

  def create_directory(path)
    path.descend do |pathname|
      pathname.dirname.mkdir unless pathname.dirname.exist?
    end
  end

  def fetch_contents(source, key)
    source.css(key.to_s).map(&:content)
  end

  def create_file(path, text)
    create_directory(path)
    path.open('w') {|f| f.write(text)}
  end
end
