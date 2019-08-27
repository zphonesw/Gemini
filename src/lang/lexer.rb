require "tokens"

class Lexer
  KEYWORDS = ["fun","holder","stdout","TRUE","FALSE","nil"]
  
  def tokenize(code)
    
    code.chomp!
    
    i = 0
    
    tokens = []
    
    current_indent = 0
    
    indent_stack = []
    
    while i < code.size 
      chunk = code[i..-1]
      
      if identifier = chunk[\A([a-z]\w*), 1] then
        if KEYWORDS.include?(identifier) then
          tokens << [identifier.upcase.to_sym, identifier]
        else
          tokens << [:IDENTIFIER, identifier]
    end
    i += identifier.size
        elsif constant = chunk[\A([A-Z]\w*), 1] 
          tokens << [:CONSTANT, constant]
          i += constant.size
          
        elseif number = chunk[\A([0-9]+), 1]
          tokens << [:NUMBER, number]
          i += number.size
          
        elseif string = chunk[\A"(.*?)", 1]
          tokens << [:STRING, string]
          i += string.size + 2
          
        elseif indent = chunk[\A\:\n( +)/m, 1]
  end
end
