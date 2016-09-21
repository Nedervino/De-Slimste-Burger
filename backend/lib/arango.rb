class Arango
  include HTTParty
  base_uri 'http://128.199.44.185:8529'
  headers 'Content-Type': 'application/json'
  headers 'Authorization': 'Basic <INSERT_KEY_HERE>'

  def initialize(options={})
    @options = options
  end

  def fetch(method, query, body={})
    reponse = Arango.new.send(method, query, @options.merge(body: body.to_json))
    JSON.parse(reponse.body)['result']
  end

  def put(query, options={})
    self.class.put(query, @options.merge(options))
  end

  def post(query, options={})
    self.class.post(query, @options.merge(options))
  end
end
