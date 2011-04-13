class RegOnline
  attr_reader :credentials
  def initialize(creds)
    raise ArgumentError,"username and password required" unless creds[:username] && creds[:password]
    @credentials = creds
  end

  def narrow_xml(xml_string, reg_id)
    reg_index = xml_string.index("&lt;RegId&gt;#{reg_id}&lt;/RegId&gt;")
    if reg_index
      begin_index = xml_string.rindex("&lt;Table1&gt;", reg_index)
      end_index = xml_string.index('&lt;/Table1&gt;', reg_index) + "&lt;/Table&gt;".length
      xml_string[begin_index .. end_index]
    end
  end

  def hashify_tags(xml_string)
    unescaped_xml = CGI::unescapeHTML(xml_string)
    xml_snippit = Nokogiri::XML.parse(unescaped_xml){|config| config.noblanks}
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

    xml_snippit = narrow_xml(response.to_xml, reg_id)
    if xml_snippit
      block.call( hashify_tags(xml_snippit))
      true
    end
  end
end
