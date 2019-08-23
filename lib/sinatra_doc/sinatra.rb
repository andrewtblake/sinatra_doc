module Sinatra
  module Doc
    def doc(&block)
      doc = SinatraDoc::Endpoint.new
      doc.instance_eval(&block)
    end

    def route(verb, path, options = {}, &block)
      if verb != "HEAD" && !SinatraDoc.last_defined_endpoint.nil?
        SinatraDoc.last_defined_endpoint.method = verb
        SinatraDoc.last_defined_endpoint.path = path
        SinatraDoc.last_defined_endpoint.validate
      end
      super verb, path, options, &block
    end
  end

  register Doc
end
