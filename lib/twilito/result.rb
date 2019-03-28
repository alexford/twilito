module Twilito
  Result = Struct.new(:success?, :errors, :sid, :response, keyword_init: true)
end