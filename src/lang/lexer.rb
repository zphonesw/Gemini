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
    end
  end
end
