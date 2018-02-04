defmodule Lexer do
  
  def tokenize(line) do
    # characters = String.replace(line, [" ", "\n"], "") 
    # |> String.split("", trim: true)
    characters = String.replace(line, ["\n"], "") 
    |> String.split("", trim: true)
    tokenize(characters, [])
  end

  def tokenize(_chars = [], tokens) do
    repeats = Enum.reduce_while(tokens, 0, fn(i, acc) -> 
      if i.type != acc, 
        do: {:cont, i.type}, 
        else: {:halt, false} end)

    if repeats == false do
      raise "Error Lexing - Invalid Arithmetic Expression"
    end
    Enum.reverse([Token.create(type: :eof, value: "") | tokens])
  end

  def tokenize(chars = [ch | rest], tokens) do
    cond do
      is_digit(ch) -> read_number(chars, tokens)
      is_decimal_point(ch) -> raise "Float Error - Floats must have digits leading decimal"
      is_whitespace(ch) -> tokenize(rest, tokens)
      true -> read_next_thing(chars, tokens)
    end
  end

  def is_decimal_point(char) do
    char == "."
  end

  def is_digit(char) do
    "0" <= char && char <= "9"
  end

  def is_whitespace(char) do
    char == " "
  end

  def read_number(chars, tokens) do
    {number, rest} = Enum.split_while(chars, fn(ch) -> is_digit(ch) || is_decimal_point(ch) end)
    decimal_count = Enum.count(number, fn(ch) -> ch == "." end)
    if List.last(number) |> is_decimal_point do
      raise "Float Error - Poorly formatted decimal"
    end
    number = Enum.join(number)
    token = 
      case decimal_count do
        0 -> Token.create(type: :int, value: elem(Integer.parse(number), 0))
        1 -> Token.create(type: :fp, value: elem(Float.parse(number), 0))
        _ -> raise "Float Error - Poorly formatted decimal"
      end
    tokenize(rest, [token | tokens])
  end

  def read_next_thing(_chars = [ch | rest], tokens) do
    token =
      case ch do
        "+" -> Token.create(type: :op, value: ch)
        "-" -> Token.create(type: :op, value: ch)
        "*" -> Token.create(type: :op, value: ch)
        "/" -> Token.create(type: :op, value: ch)
        "(" -> Token.create(type: :leftparen, value: ch)
        ")" -> Token.create(type: :rightparen, value: ch)
        _ -> Token.create(type: :illegal, value: ch)
      end
    tokenize(rest, [token | tokens])
  end

end