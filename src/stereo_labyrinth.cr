require "crsfml"
require "./dependency"

class StereoLabyrinth < SFMLApplication
    RESOURCES = "./resources"
    FONT = SF::Font.from_file(RESOURCES+"/DejaVuSans.ttf") 
    DIRECTIONS = [ [1, 0], [-1, 0], [0, 1], [0, -1] ]

    def initialize(@start_x : Int32 = 0, @start_y : Int32 = 0)
        super(1920,1080,"Stereo Labyrinth", SF::Style::Fullscreen)
        generate_labyrinth
    end
    def create_components
        VisitedGrid.new(context(:visited), 96, 54){false}
        WallGrid.new(context(:verticalWalls), visited.cols+1, visited.rows  , Orientation::Vertical   ){true}
        WallGrid.new(context(:horizontalWalls), visited.cols, visited.rows+1, Orientation::Horizontal ){true}
        FPSCounter.new(context(:fpsCounter), SF::Text.create(FONT, SF::Vector2f.new(10,10),24, SF::Color::Red))
        Square.new(context(), SF::Vector2.new(@start_x,@start_y).to_f32*visited.cell_width + SF::Vector2.new(1,1), 8, SF::Color::Red)
        Square.new(context(), SF::Vector2.new(visited.cols-1,visited.rows-1).to_f32*visited.cell_width + SF::Vector2.new(1,1), 8, SF::Color::Red)
    end
    def visited; c(:visited).as(VisitedGrid); end
    def vertical_walls; c(:verticalWalls).as(WallGrid); end
    def horizontal_walls; c(:horizontalWalls).as(WallGrid); end
    def fps_counter; c(:fpsCounter).as(FPSCounter); end
    
    def generate_labyrinth
        visited.set_each_cell do |i,j| false end
        vertical_walls.set_each_cell do |i,j| true end
        horizontal_walls.set_each_cell do |i,j| true end
        generate_visit_cell(@start_x, @start_y)
    end
    def generate_visit_cell(x, y)
        visited[x,y] = true
        coordinates = DIRECTIONS.shuffle.map { |direction| [x + direction[0], y + direction[1]] }
        coordinates.each do |coordinate|
            new_x, new_y = coordinate
            next unless move_valid?(new_x, new_y)
            connect_cells(x, y, new_x, new_y)
            generate_visit_cell(new_x, new_y)
        end
    end
    def move_valid?(x, y)
        (0...visited.cols).covers?(x) && (0...visited.rows).covers?(y) && !visited[x,y]
    end
    def connect_cells(x1, y1, x2, y2)
        if x1 == x2
            horizontal_walls[x1 , [y1, y2].min + 1] = false
        else
            vertical_walls[ [x1, x2].min + 1, y1 ] = false
        end
    end

    def draw;end # to draw stuff that arent Components
    def update;super();end # to update stuff that arent Components
    def handle_event(event)
        super(event)
        if(event.is_a? SF::Event::KeyPressed)
            case event.code
            when SF::Keyboard::Escape
                exit
            when SF::Keyboard::Space
                generate_labyrinth
            end
        end
    end
    def touching_walls?(rect)
        vertical_walls.any_overlapping?(rect) || horizontal_walls.any_overlapping?(rect)
    end
end


StereoLabyrinth.new.run