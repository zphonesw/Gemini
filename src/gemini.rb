module Gemini
  $tokens = []
  class Lexer
            attr_accessor :code
            def initialize(code)
                @code = code
            end
            #This method is responsible for breaking the code down into the smallest units as possible.
            def tokenize
                for c in @code.split(" ").map(&:to_s)
                $tokens << getToken
                @code = @code.strip
            end
            $tokens
        end
end
