defmodule Parser do

  def parse(tokens) do
    parse(tokens, [], [])
  end

  defp parse(_tokens = [token | rest], op_stack, output_queue) do
  	case token.type do
  		:int -> handleNumber(token, rest, op_stack, output_queue)
      :fp -> handleNumber(token, rest, op_stack, output_queue)
  		:op -> handleOp(token, rest, op_stack, output_queue)
  		:leftparen -> handleLeftParen(token, rest, op_stack, output_queue)
  		:rightparen -> handleRightParen(token, rest, op_stack, output_queue)
  		:illegal -> raise "Error Parsing - Illegal Token -> #{token.value}" 
  		:eof -> parse(rest, op_stack, output_queue)
  	end
  end

  defp parse(_tokens = [], op_stack, output_queue) do
  	if Enum.any?(op_stack, fn(s) -> s == "(" || s == ")" end) do
  		raise "Error Parsing - Mismatched Parentheses"
  	end
    Enum.reverse(output_queue)++op_stack
  end

  defp handleNumber(num_token, tokens, op_stack, output_queue) do
    output_queue = [num_token | output_queue]
    parse(tokens, op_stack, output_queue)
  end

  @op_precedence %{
    "+"=> 2, 
    "-"=> 2, 
    "/"=> 3, 
    "*"=> 3
  }

  defp handleOp(op_token, tokens, op_stack, output_queue) do
    {moved_ops, op_stack} = Enum.split_while(op_stack, fn(x) -> x.value != "(" && @op_precedence[x.value] >= @op_precedence[op_token.value] end)
    output_queue = Enum.reverse(moved_ops)++output_queue
    op_stack = [op_token | op_stack]
    parse(tokens, op_stack, output_queue)
  end

  defp handleLeftParen(lparen_token, tokens, op_stack, output_queue) do
  	op_stack = [lparen_token | op_stack]
  	parse(tokens, op_stack, output_queue)
  end

  defp handleRightParen(_rparen_token, tokens, op_stack, output_queue) do
  	{moved_ops, op_stack} = Enum.split_while(op_stack, fn(x) -> x.value != "(" end)
  	if Enum.empty?(op_stack) do
  		raise "Error Parsing - Mismatched Parentheses"
  	end
  	output_queue = Enum.reverse(moved_ops)++output_queue
  	[_poppedParen | op_stack] = op_stack
  	parse(tokens, op_stack, output_queue)
  end

end