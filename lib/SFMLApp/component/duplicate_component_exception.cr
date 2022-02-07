class DuplicateComponentException < Exception
    def initialize(componentKey)
        super("A component '#{componentKey}' already exists")
    end
end