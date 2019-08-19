require "sinatra"
require "../lib/sinatra_doc"

doc do
  tags [ "Misc" ]
end
get "/" do
  "Index Route"
end
