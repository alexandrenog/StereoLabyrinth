class WallGrid < Grid(Bool)
    property orientation : Orientation

    def initialize(context, cols, rows, orientation)
        super(context, cols, rows){yield}
        @orientation = orientation
        if @orientation.vertical?
            @cell_width = window.size.y//rows
            cell_size(1, @cell_width)
        else
            @cell_width = window.size.x//cols
            cell_size(@cell_width, 1)
        end
    end
    def cell_pos(i,j)
        if (@orientation.vertical? && j==cols-1)
            return SF::Vector2.new(j*@cell_width-1, i*@cell_width)
        elsif (@orientation.horizontal? && i==rows-1 )
            return SF::Vector2.new(j*@cell_width, i*@cell_width-1)
        else
            return SF::Vector2.new(j*@cell_width, i*@cell_width)
        end
    end

    def draw_cell(i, j, value)
        @cell_shape.position = cell_pos(i,j)
        @cell_shape.fill_color = value ? SF::Color::White : SF::Color::Black
        render(@cell_shape)
    end
end