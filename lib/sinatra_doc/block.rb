module Sinatra
  module Doc
    def doc_for(method, path, &_block)
      yield SinatraDoc::Endpoint.new(method, path)
    end
  end

  register Doc
end
