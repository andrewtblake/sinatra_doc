module Sinatra
  module Doc
    def doc(method: nil, path: nil, &block)
      doc = SinatraDoc::Endpoint.new
      doc.method = method unless method.nil?
      doc.path = path unless path.nil?
      doc.instance_eval(&block) if block_given?
    end

    def route(verb, path, options = {}, &block)
      last_def = SinatraDoc.last_defined_endpoint
      if verb != "HEAD" && !last_def.nil?
        last_def.method = verb if last_def.method.nil?
        last_def.path = path if last_def.path.nil?
        last_def.validate
        SinatraDoc.last_defined_endpoint = nil
      end
      super verb, path, options, &block
    end
  end

  register Doc
end
