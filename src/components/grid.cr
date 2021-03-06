class Grid(T) < Component
    property cols : Int32, rows : Int32, cell_width : Int32
    property cells : Array(Array(T)), cell_shape : SF::RectangleShape

    def initialize(context, cols, rows)
        super(context)
        @cols, @rows = cols, rows
        @cell_width = window.size.x//cols
        @cells = Array(Array(T)).new(rows) { |i| Array(T).new(cols){ |j| yield(i,j)} }
        @cell_shape = SF::RectangleShape.new()
        cell_resize()
    end
    def cell_resize; cell_size(@cell_width,@cell_width); end
    def cell_size(w, h)
        @cell_shape.size = SF::Vector2.new(w, h)
    end
    def cell_pos(i,j)
        SF::Vector2.new(j*@cell_width, i*@cell_width)
    end
    def draw_cell(i, j, value)
        @cell_shape.position = cell_pos(i,j)
        @cell_shape.fill_color = value ? SF::Color::Black : SF::Color::White
        render(@cell_shape)
    end
    def draw
        @cells.each_with_index do |row, i|
            row.each_with_index do |value, j|
                draw_cell(i, j, value)
            end
        end
    end
    def []=(x, y, value)
        @cells[y][x] = value
    end
    def [](x, y)
        @cells[y][x]
    end
    def set_each_cell 
        @cells.each_with_index do |row, i|
            row.each_with_index do |value, j|
                @cells[i][j] = yield(i, j)
            end
        end
    end
    def overlapping_candidates(rect)
        candidates = [] of NamedTuple(i: Int32, j: Int32)
        i,j = (rect.top//@cell_width).to_i32, (rect.left//@cell_width).to_i32
        i_range, j_range = ((i-1)..(i+1)), ((j-1)..(j+1))
        i_range.each do | _i|
            j_range.each do |_j|
                if _i >= 0 && _i < @rows && _j >= 0 && _j < @cols
                    candidates.push({i: _i, j: _j})
                end
            end
        end
        candidates
    end
    def any_overlapping?(rect)
        candidates = overlapping_candidates(rect)
        candidates.each do |candidate|
            cell_rect = SF::Rect.new( cell_pos(candidate[:i],candidate[:j]).to_f32, @cell_shape.size)
            if @cells[candidate[:i]][candidate[:j]] && rect.intersects?(cell_rect)
                return true
            end
        end
        false
    end
end
