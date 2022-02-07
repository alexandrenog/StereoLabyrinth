class VisitedGrid < Grid(Bool)

    def initialize(context, cols, rows)
        super(context, cols, rows){yield}
    end
end