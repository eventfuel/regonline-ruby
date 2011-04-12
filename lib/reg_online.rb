require 'savon'

class RegOnline
  attr_reader :credentials
  def initialize(creds)
    raise ArgumentError,"username and password required" unless creds[:username] && creds[:password]
    @credentials = creds
  end

  def narrow_xml(xml_string, reg_id)
    reg_index = xml_string.index("<RegId>#{reg_id}</RegId>")
    if reg_index
      begin_index = xml_string.rindex("<Table1>", reg_index)
      end_index = xml_string.index('</Table1>', reg_index) + "</Table>".length
      xml_string[begin_index .. end_index]
    end
  end

  def hashify_tags(xml_string)
    xml_snippit = Nokogiri::XML.parse(xml_string){|config| config.noblanks}
    xml_elements = {}
    xml_snippit.children.children.each do |ele|
      xml_elements[ele.name] = ele.content
    end
    xml_elements
  end

  def soap_request_map(username, password)
    {'login' => username,
      'pass' => password,
      'eventID' => '849922',
      'reportID' => '617645',
      'startDate' => '2009-01-01',
      'endDate' => '2011-01-01',
      'bAddDate' => 'true'}
  end

  def get_custom_user_info(reg_id, &block)
    client = Savon::Client.new  "https://www.regonline.com/activereports/RegOnline.asmx?wsdl"
    response = client.request :wsdl, :get_non_compressed_report do
      soap.body = soap_request_map(credentials[:username], credentials[:password]) 
    end
    xml_response = response.to_hash[:get_non_compressed_report_response][:get_non_compressed_report_result]
    xml_snippit = narrow_xml(xml_response, reg_id)
    if xml_snippit
      xml_hash = hashify_tags xml_snippit
      block.call xml_hash
      true
    end
  end
end
