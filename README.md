# Calc

## Description:
This is a simple calculator I wrote in Elixir for Web Development - CS4550.  
I implemented a lexer, parser, and interpreter for the calculations.  I parsed the information into Reverse Polish Notation with the Shunting-Yard Algorithm and evaluated it with a simple stack interpreter in order to guaruntee order of operations.   
It supports parentheses, floating-point operations, integer operations, and has four functions:
1. \+
2. \-
3. \*
4. \/

## References:
Reverse Polish Notation - https://en.wikipedia.org/wiki/Reverse_Polish_notation  
Shunting-Yard Algorithm - https://en.wikipedia.org/wiki/Shunting-yard_algorithm  

## Assignment:

<p>Write a four function calculator in Elixir.

</p><p>Start by creating an Elixir project called "calc" with:

</p><pre>$ mix new calc
</pre>

<p>Your program should consist of a Calc module (lib/calc.ex) with at least two functions:

</p><ul>
<li>Calc.eval (String -&gt; Number) # Should parse and evaulate an arithmetic expression.
</li><li>Calc.main # Should repeatedly print a prompt, read one line, eval it, and print the result.
</li></ul>

<p>In addition, you should write tests for the public functions in your calc module (test/calc_test.exs), which should pass when you type "mix test".

</p><p><b>Sample session:</b>

</p><pre>calc$ mix run -e Calc.main
&gt; 2 + 3
5
&gt; 5 * 1
5
&gt; 20 / 4
5
&gt; 24 / 6 + (5 - 4)
5
&gt; 1 + 3 * 3 + 1
11
&gt; ^C^C
</pre>

<h2>To Submit</h2>

<ul>
<li>Push your calculator to github.
</li><li>Submit a filled in hw04-status.txt
</li></ul>



