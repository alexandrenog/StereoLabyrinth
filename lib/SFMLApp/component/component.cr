class Component
    property application : SFMLApplication
    property componentKey : Symbol

    def initialize(context : NamedTuple(application: SFMLApplication, componentKey: Symbol))
        @application = context[:application]
        @componentKey = context[:componentKey]
        @application.addComponent(@componentKey,self)
    end
    def draw();end
    def window
        @application.window
    end
    def render(obj)
        window.draw(obj)
    end
end