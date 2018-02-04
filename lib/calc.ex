defmodule Calc do

  def main() do
    result = IO.gets("> ")
    |> eval()
    IO.puts("#{result}")
    main()
  end

  def eval(line) do
    Lexer.tokenize(line)
    |> Parser.parse()
    |> Interpreter.interp()
  end

end