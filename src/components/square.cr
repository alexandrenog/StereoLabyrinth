class Square < Component
    property shape : SF::RectangleShape
    property velocity : SF::Vector2f
    property starting_color : SF::Color, inverted_color : SF::Color
    def initialize(context, pos, width, fill_color = SF::Color::Black)
        super(context)
        @shape = SF::RectangleShape.new()
        @shape.size = SF::Vector2.new(width, width)
        @shape.position = pos
        @starting_color = fill_color
        @inverted_color =  SF::Color.new(255-fill_color.r, 255-fill_color.g, 255-fill_color.b)
        @shape.fill_color = @starting_color
        @velocity = SF::Vector2f.new(0, 0)
        @acc_mod = 140
        @max_velocity = 700
        @stop_velocity = 600
    end
    def draw
        render(@shape)
    end
    def dt
        @application.c(:fpsCounter).as(FPSCounter).dt
    end
    def update
        acc(     0      , -@acc_mod*60) if SF::Keyboard.key_pressed? (SF::Keyboard::Up)
        acc(     0      ,  @acc_mod*60) if SF::Keyboard.key_pressed? (SF::Keyboard::Down)
        acc(-@acc_mod*60,       0     ) if SF::Keyboard.key_pressed? (SF::Keyboard::Left)
        acc( @acc_mod*60,       0     ) if SF::Keyboard.key_pressed? (SF::Keyboard::Right)
        last_pos = @shape.position
        @shape.position += @velocity * dt
        @velocity *= 0.83
        if( @application.as(StereoLabyrinth).touching_walls?(@shape.global_bounds()) )
            @shape.fill_color = @inverted_color
            @shape.position=last_pos
            @velocity *= -1.0
        else
            @shape.fill_color = @starting_color
        end
    end
    def place_at (pos)
        @shape.position = pos
    end
    def acc(x,y)
        new_vel = @velocity + SF::Vector2f.new(x.to_f32, y.to_f32) * dt
        @velocity  = new_vel if(new_vel.norm <= @max_velocity) 
        stop_if_released
    end
    def stop_if_released
        @velocity  = SF::Vector2f.new(0, 0) if @velocity.norm <= @stop_velocity && keys_released
    end
    def keys_released
        !SF::Keyboard.key_pressed?(SF::Keyboard::Up) && !SF::Keyboard.key_pressed?(SF::Keyboard::Down) &&
        !SF::Keyboard.key_pressed?(SF::Keyboard::Left) && !SF::Keyboard.key_pressed?(SF::Keyboard::Right)
    end

end