class SF::Text
    def self.create(font, position = SF::Vector2f.new(0,0), character_size = 24, color = SF::Color::Black, style = SF::Text::Regular)
        text = SF::Text.new()
        text.font = font
        text.character_size = character_size 
        text.color = color
        text.style = style
        text.position = position
        return text
    end
end