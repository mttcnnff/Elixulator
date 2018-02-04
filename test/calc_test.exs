defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "greets the world" do
    assert Calc.eval("2+7") == 9
  end


  @doc """

  Token Tests

  """
  test "Create Valid Token" do
    assert Token.create(type: :int, value: 2) == %Token{type: :int, value: 2}
  end

  test "Create Token with Invalid Token Type" do
    assert_raise(TokenError, fn -> Token.create(type: :bad, value: 2) end)
  end

  test "Create Token without type" do
    assert_raise(FunctionClauseError, fn -> Token.create(kind: :bad, value: 2) end)
  end

  test "Create Token without value" do
    assert_raise(FunctionClauseError, fn -> Token.create(type: :bad, literal: 2) end)
  end

  @doc """

  Lexer Tests

  """
  test "Tokenize Valid Expressions" do
    assert Lexer.tokenize("(2+7)*4/2") 
    == 
    [
		  %Token{type: :leftparen, value: "("},
		  %Token{type: :int, value: 2},
		  %Token{type: :op, value: "+"},
		  %Token{type: :int, value: 7},
		  %Token{type: :rightparen, value: ")"},
		  %Token{type: :op, value: "*"},
		  %Token{type: :int, value: 4},
		  %Token{type: :op, value: "/"},
		  %Token{type: :int, value: 2},
		  %Token{type: :eof, value: ""}
		]
  end

  test "Spaces are ignored" do
  	assert Lexer.tokenize("2+7/4") == Lexer.tokenize("2 + 7 / 4")
  	assert Lexer.tokenize("2+7/4") == Lexer.tokenize("2 +7/ 4")
  end

  test "Invalid Operator Entry" do
  	assert_raise(LexerError, fn -> Lexer.tokenize("2++7/4") end)
  end

  test "Invalid Number Entry" do
  	assert_raise(LexerError, fn -> Lexer.tokenize("2+7 7/4") end)
  end

  test "Invalid Two Decimal Points" do
  	assert_raise(FloatError, fn -> Lexer.tokenize("2+7..0/4") end)
  end

  test "Invalid Decimal Format - No Leading Zero" do
  	assert_raise(FloatError, fn -> Lexer.tokenize("2+.4/4") end)
  end

  test "Invalid Decimal Format - Nothing After Decimal" do
  	assert_raise(FloatError, fn -> Lexer.tokenize("2+7./4") end)
  end

  @doc """

  Parser Tests

  """
  test "Parses valid statement" do
    assert Lexer.tokenize("2+7*4") |> Parser.parse()
    == 
    [
		  %Token{type: :int, value: 2},
		  %Token{type: :int, value: 7},
		  %Token{type: :int, value: 4},
		  %Token{type: :op, value: "*"},
		  %Token{type: :op, value: "+"},
		]
  end

  test "Parses Parenthesis Statement" do
  	assert Lexer.tokenize("(2+7)*4") |> Parser.parse()
    == 
    [
		  %Token{type: :int, value: 2},
		  %Token{type: :int, value: 7},
		  %Token{type: :op, value: "+"},
		  %Token{type: :int, value: 4},
		  %Token{type: :op, value: "*"},
		]
  end

  test "Parser raises Error on illegal token" do
  	assert_raise(ParserError, fn -> Lexer.tokenize("(2#7)*4") |> Parser.parse() end)
  end

  test "Mismatched Parenthesis - 1" do
  	assert_raise(ParserError, fn -> Lexer.tokenize("((2+7)*4") |> Parser.parse() end)
  end

  test "Mismatched Parenthesis - 2" do
  	assert_raise(ParserError, fn -> Lexer.tokenize("(2+7)*(4-1") |> Parser.parse() end)
  end

  @doc """

  Interpreter Tests

  """
  test "Interpreter - Basic Arithmetic" do
    assert Lexer.tokenize("2+7") |> Parser.parse() |> Interpreter.interp() == 9
  end

  test "Interpreter - Order of Operations" do
    assert Lexer.tokenize("2+7*6-40/2") |> Parser.parse() |> Interpreter.interp() == 24
  end

  test "Interpreter - Parenthesis" do
    assert Lexer.tokenize("(((2+7)*6)-40)/2") |> Parser.parse() |> Interpreter.interp() == 7
  end

  test "Interpreter - Parenthesis Spaces" do
    assert Lexer.tokenize("((( 2+7)* 6)- 40)/2") |> Parser.parse() |> Interpreter.interp() == 7
  end

  test "Interpreter - Floating Point Math" do
    assert Lexer.tokenize("((( 2.0+7)* 6)- 40)/2") |> Parser.parse() |> Interpreter.interp() == 7.0
  end

  test "Interpreter - Floating Point Division" do
  	assert Lexer.tokenize("5/2") |> Parser.parse() |> Interpreter.interp() == 2.5
  end

  test "Interpreter - Integer Division" do
  	assert Lexer.tokenize("6/2") |> Parser.parse() |> Interpreter.interp() == 3
  end

  @doc """

  Calculator Tests

  """
  test "Basic Arithmetic" do
    assert Calc.eval("2+7") == 9
  end

  test "Order of Operations" do
    assert Calc.eval("2+7*6-40/2") == 24
  end

  test "Parenthesis" do
    assert Calc.eval("(((2+7)*6)-40)/2") == 7
  end

  test "Parenthesis Spaces" do
    assert Calc.eval("((( 2+7)* 6)- 40)/2") == 7
  end

  test "Floating Point Math" do
    assert Calc.eval("((( 2.0+7)* 6)- 40)/2") == 7.0
  end

  test "Floating Point Division" do
  	assert Calc.eval("5/2") == 2.5
  end

  test "Integer Division" do
  	assert Calc.eval("6/2") == 3
  end
end
