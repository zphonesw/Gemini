$code = gets
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
         def getToken
            $ctok = " "
            puts "LEXER:"
           lexems = @code.scan(/\w+|\W+/) {|tok,i|
           index = tok.split(' ').map(&:to_s)
           i = index.size
             
           if index=="\"\'" then
              index.push("STRING,true")
           end
             
           chunk = index[i..-1]
            puts "#{index.to_s.strip}:#{i}"
           
           }
           puts "CHARACTERS FOUND:#{lexems.size}"
           return lexems
       end
end

$GEMINI = Gemini::Lexer.new($code).tokenize
puts $GEMINI.map(&:to_s)
