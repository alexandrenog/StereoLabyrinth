struct SF::Vector2(T)
    def norm
        (x*x+y*y)**0.5
    end
    def to_f32
        SF::Vector2f.new(x.to_f32,y.to_f32)
    end
    def to_i32
        SF::Vector2.new(x.to_i32,y.to_i32)
    end
end