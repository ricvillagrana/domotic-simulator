def fun(a, b)
  x = a
  y = b

  x = x - y if x > y
  y = y - x if x < y

  if x != y
    fun(x, y)
  else
    puts "Result: #{x}"
  end
end

fun(2437, 875)
