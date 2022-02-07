require "./monkeypatches/*"
require "./component/*"

alias ComponentKey = Symbol | Int32

class SFMLApplication
    property window : SF::RenderWindow
    property components : Hash(ComponentKey, Component)
    property components_index : Int32 = 0

    def initialize(width, height, title, window_style = SF::Style::Default)
        @window = SF::RenderWindow.new(SF::VideoMode.new(width, height), title, window_style)
        @components = Hash(ComponentKey, Component).new
        begin
            create_components
        rescue exception
            puts exception.message
            exit
        end
    end
    def run()
        while @window.open?
            while event = @window.poll_event
                if event.is_a? SF::Event::Closed
                    @window.close
                end
                if self.responds_to? :handle_event
                    self.handle_event(event)
                end
            end
            if self.responds_to? :update
                self.update
            end
            @window.clear(SF::Color::Black)
            @components.each{|_, component| component.draw}
            self.draw
            @window.display
        end
    end
    def handle_event(event)
        if event.is_a? SF::Event::KeyPressed 
            case event.code
                when  SF::Keyboard::Escape
                    @window.close
                else
                    Nil
            end
        end
    end
    def update
        @components.each do |_, component| 
            if component.responds_to? :update
                component.update
            end
        end
    end
    def context()
        numbered_context = context(@components_index)
        @components_index+=1
        return numbered_context
    end
    def context (componentKey)
        return {application: self, componentKey: componentKey}
    end
    def addComponent(componentKey, component)
        if(@components.has_key?(componentKey))
            raise DuplicateComponentException.new(componentKey)
        end
        @components[componentKey] = component
    end
    def c(componentKey)
        @components[componentKey].not_nil!
    end
    def has?(componentKey)
        @components.has_key?(componentKey)
    end
end
