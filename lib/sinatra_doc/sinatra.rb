module Sinatra
  module Doc
    def doc(path: nil, &block)
      doc = SinatraDoc::Endpoint.new
      doc.path = path unless path.nil?
      doc.instance_eval(&block) if block_given?
    end

    def route(verb, path, options = {}, &block)
      last_def = SinatraDoc.last_defined_endpoint
      if verb != "HEAD" && !last_def.nil?
        last_def.method = verb
        last_def.path = path if last_def.path.nil?
        last_def.validate
        SinatraDoc.last_defined_endpoint = nil
      end
      super verb, path, options, &block
    end
  end

  register Doc
end
