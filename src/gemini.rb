$code = gets
module Gemini
  $tokens = []
  $IDENTIFIERS = [:VARIABLE, :IF_STATEMENT,:FUNCTION_STATEMENT,:INTEGER,:STRING,:LITERAL,:SYMBOL,:ASSIGN,:COMMENT]
  $KEYWORDS_RE = [".stack","let","if","end","function","lambda","TRUE","FALSE","ON","OFF","YES","OFF","NIL","VOID",".values"]
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
           puts "CHARACTERS FOUND:#{@code.size}"
           return lexems
       end
end
end
$GEMINI = Gemini::Lexer.new($code).tokenize
puts $GEMINI
