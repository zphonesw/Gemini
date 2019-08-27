# frozen_string_literal: true

require 'gemini'
require 'set'

module Gemini
  class Lexer
    RESERVED_WORDS = Set.new(['holder', 'proc', 'self', 'nil', 'true', 'yes',
                              'on', 'false', 'no', 'off', 'next', 'break',
                              'return'])

    KEYWORDS = Set.new(['do', 'end', 'class', 'load', 'if', 'while',
                        'namespace', 'else', 'elsif', 'return', 'break', 'next',
                        'true', 'yes', 'on', 'false', 'no', 'off', 'nil',
                        'self', 'defined?', 'property', 'super'])

    TOKEN_RX = {
      identifiers: /\A([a-z_][\w\d]*[?!]?)/,
      constants: /\A([A-Z][\w\d]*[?!]?)/,
      globals: /\A(\$[a-z][\w\d]*[?!]?)/i,
      class_var: /\A(\@\@[a-z][\w\d]*[!?]?)/i,
      instance_var: /\A(\@[a-z][\w\d]*[!?]?)/i,
      operator: /\A(->|=>|[.+\-\*\/%<>=!]=|=~|\*\*=|\*\*|[+\-\*\/%=><]|or|and|not|isnt|is|\||\(|\)|\[|\]|\{|\}|::|[.,])/,
      whitespace: /\A([ \t]+)/,
      terminator: /\A([;\n])/,
      integer: /\A([\d_]+)/,
      float: /\A([\d_]*?\.[\d_]+)/,
      string: /\A\"(.*?)(?<!\\)\"/m,
      regex: /\Ar\"(.*?)(?<!\\)\"([gim]*)/,
      symbol: /\A:([a-z][\w\d]*?\b)/i,
      comment: /\A#.*?(?=\n|$)/m
    }

    def tokenize(code)
      tokens = []
      if code.length == 0
        return tokens
      end
      line = 1
      i = 0
      while i < code.length
        chunk = code[i..-1]
        if (operator = chunk[TOKEN_RX[:operator]])
          tokens << [operator, operator]
          i += operator.length
        elsif (constant = chunk[TOKEN_RX[:constants]])
          tokens << [:CONSTANT, constant]
          i += constant.length
        elsif (global = chunk[TOKEN_RX[:globals]])
          tokens << [:GLOBAL, $1]
          i += global.length
        elsif (class_var = chunk[TOKEN_RX[:class_var]])
          tokens << [:CLASS_IDENTIFIER, $1]
          i += class_var.length
        elsif (instance_var = chunk[TOKEN_RX[:instance_var]])
          tokens << [:INSTANCE_IDENTIFIER, $1]
          i += instance_var.length
        elsif (symbol = chunk[TOKEN_RX[:symbol]])
          tokens << [:SYMBOL, $1.to_sym]
          i += symbol.length
        elsif (regex = chunk[TOKEN_RX[:regex]])
          pattern, flags = $1, $2
          tokens << [:REGEX, pattern.gsub('\"', '"')]
          if flags && flags.length > 0
            tokens << [:REGEX_FLAGS, flags]
          end
          i += regex.length
        elsif (identifier = chunk[TOKEN_RX[:identifiers]])
          if KEYWORDS.include?(identifier)
            tokens << [identifier.upcase.gsub(/\?\!/, '').to_sym, identifier]
          else
            tokens << [:IDENTIFIER, identifier]
          end
          i += identifier.length
        elsif (float = chunk[TOKEN_RX[:float]])
          tokens << [:FLOAT, float.to_f]
          i += float.length
        elsif (integer = chunk[TOKEN_RX[:integer]])
          tokens << [:NUMBER, integer.to_i]
          i += integer.length
        elsif (string = chunk[TOKEN_RX[:string]])
          tokens << [:STRING, $1.gsub('\"', '"')]
          i += string.length
        elsif (comment = chunk[TOKEN_RX[:comment]])
          i += comment.length # Ignore comments
        elsif (terminator = chunk[TOKEN_RX[:terminator]])
          tokens << [:TERMINATOR, terminator]
          line += 1 if terminator == "\n"
          i += 1
        elsif (space = chunk[TOKEN_RX[:whitespace]])
          i += space.length # ignore spaces and tab characters
        else
          raise LexicalError.new(code[i], line)
        end
      end
      if tokens.length.positive? && tokens.last != [:TERMINATOR, "\n"]
        tokens << [:TERMINATOR, "\n"]
      end
      tokens << [:EOF, :eof] if tokens.length.positive?
      tokens
    end
  end
end
