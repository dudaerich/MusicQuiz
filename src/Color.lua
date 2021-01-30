Color = Class {
  r = 0,
  g = 0,
  b = 0,
  a = 1
}

function Color:init(r, g, b, a)
  self.r = r
  self.g = g
  self.b = b
  self.a = a
end

Color.BLACK = Color(0, 0, 0, 1)
Color.WHITE = Color(1, 1, 1, 1)
Color.RED = Color(1, 0, 0, 1)
Color.GREEN = Color(0, 1, 0, 1)
Color.DARK_GREEN = Color(19/255, 61/255, 16/255, 1)
Color.BLUE = Color(0, 0, 1, 1)
Color.YELLOW = Color(209/255, 212/255, 23/255, 1)
Color.BROWN = Color(102/250, 47/250, 10/250, 1)
Color.TRANSPARENT = Color(0, 0, 0, 0)