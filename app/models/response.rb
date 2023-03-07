class Response
  attr_accessor :status, :message, :data, :errors

  def initialize(status:, message: , data: nil, errors: nil)
    @status = status
    @message = message
    @data = data
    @errors = errors
  end

  def self.as_json(response = {})
    response.symbolize_keys!
    {
      status: response[:status],
      message: response[:message],
      data: response[:data],
      errors: response[:errors]
    }
  end

  def self.to_response(response_json)
    json_body = JSON.parse(response_json)
    Response.new(status: json_body["status"], message: json_body["message"], data: json_body["data"], errors: json_body["errors"])
  end

  def to_json(options = {})
    { status: status, message: message, data: data, errors: errors }.to_json(options)
  end
end