return 
{
  linear = function(t, b, c, d)
    return c * t / d + b
  end,
  swing = function(t, b, c, d)
    return ((-math.cos(math.pi * t / d) / 2) + 0.5) * c + b
  end
}
