enum Orientation
  Horizontal       
  Vertical     
  def vertical?
    self == Orientation::Vertical
  end
  def horizontal?
    self == Orientation::Horizontal
  end
end