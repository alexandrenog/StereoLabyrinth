class FPSCounter < Component
    property text : SF::Text
    def initialize(context, text)
        super(context)
        @frameTimes = [] of Time
        @text = text 
    end
    def update
        @frameTimes<<Time.utc
        @frameTimes.select!{|t| (Time.utc - t).to_f <= 1.0}
        @text.string = self.fps.to_s
    end
    def fps
        return @frameTimes.size
    end
    def draw
        self.update
        render(@text)
    end
    def dt : Float64
        return @frameTimes.size > 1 ? (@frameTimes[-1] - @frameTimes[-2]).to_f : 0.0
    end
end