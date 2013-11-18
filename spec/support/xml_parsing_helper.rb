require 'nori'

module XMLParsingHelper
  def parse_xml(xml)
    Nori.new(:parser => :rexml).parse(xml)
  end
end
