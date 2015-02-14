require 'gosu'
require 'yaml'
require_relative 'shape'
require_relative 'block'
require_relative 'pieces'

class TetrisGameWindow < Gosu::Window
  attr_accessor :blocks
  attr_reader :block_height, :block_width
  attr_reader :level
  attr_reader :falling_shape

  STATE_MENU = 0
  STATE_PLAY = 1
  STATE_GAMEOVER = 2
  STATE_LOAD = 3
  STATE_LEVELS = 4

  def initialize
    super(416, 738, false)
    @block_width = 32
    @block_height = 32
    @blocks = []
    @state = STATE_MENU
    spawn_next_shape
    @lines_cleared = 0
    @score = 0
    @high_score = 0
    @level = 0
    @menu = Gosu::Image.new(self, 'tetris_menu.png', true)
    @background = Gosu::Image.new(self, 'background.jpg', true)
    @song = Gosu::Song.new("TetrisB_8bit.ogg")
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end

  def spawn_next_shape
    if (@falling_shape != nil )
      @blocks += @falling_shape.get_blocks
    end
    generator = Random.new
    shapes = [ShapeI.new(self), ShapeL.new(self), ShapeJ.new(self), ShapeCube.new(self), ShapeZ.new(self), ShapeT.new(self), ShapeS.new(self)]
    shape = generator.rand(0..(shapes.length-1))
    @falling_shape = shapes[shape]
  end

  def update
    if @state == STATE_PLAY
      if @falling_shape.collide?
        @state = STATE_GAMEOVER
      else
        @falling_shape.update
      end
      if @high_score < @score
        @high_score = @score
      end
      @level = @lines_cleared / 2
      if button_down? Gosu::KbS
        @data = { :score => @score, :level => @level }
        save(@data)
      end

    elsif @state == STATE_MENU
      if button_down? Gosu::KbN
        @state = STATE_PLAY
        high_score_check
      elsif button_down? Gosu::KbL
        @state = STATE_LOAD
      elsif button_down? Gosu::KbG
        @state = STATE_LEVELS
      end

    elsif @state = STATE_LOAD
        load
        @state = STATE_PLAY

    elsif @state == STATE_LEVELS
      # if button_down? Gosu::Kb1
      #   @state = STATE_PLAY
      #   @level = 1
      # end
      # if button_down? Gosu::Kb2
      #   @state = STATE_PLAY
      #   @level = 2
      # end
      # if button_down? Gosu::Kb3
      #   @state = STATE_PLAY
      #   @level = 3
      # end

    else
      if (button_down? Gosu::KbSpace)
        @blocks = []
        @falling_shape = nil
        @level = 0
        @lines_cleared = 0
        spawn_next_shape
        high_score_check
        @state = STATE_MENU
      end
    end
    if ( button_down?(Gosu::KbEscape) )
      high_score_check
      close
    end
      @song.play(true)
  end

  def draw
    if @state == STATE_MENU
      @menu.draw(0, 0, 1)
    elsif @state == STATE_GAMEOVER
      text = Gosu::Image.from_text(self, "Game Over", "Arial", 40)
      text.draw(width/2 - 90, height/2 - 20, 0, 1, 1)
    elsif @state == STATE_LEVELS
      @background.draw(0, 0, 0)
      @font.draw("LEVEL 1: Press 1", 50, 50, 3.0, 1.0, 1.0, 0xffffffff)
      @font.draw("LEVEL 2: Press 2", 50, 55, 3.0, 1.0, 1.0, 0xffffffff)
      @font.draw("LEVEL 3: Press 3", 50, 60, 3.0, 1.0, 1.0, 0xffffffff)
    else
      @background.draw(0, 0, 0)
      @blocks.each { |block| block.draw }
      @falling_shape.draw
      @font.draw("SCORE: #{@score}", 290, 10, 3.0, 1.0, 1.0, 0xffffffff)
      @font.draw("LEVEL: #{@level}", 290, 25, 3.0, 1.0, 1.0, 0xffffffff)
      @font.draw("HIGH SCORE: #{@high_score}", 290, 40, 3.0, 1.0, 1.0, 0xffffffff)
      @font.draw("Press 'S' to save", 5, 10, 2.0, 1.0, 1.0, 0xffffffff)
    end
  end

  def button_down(id)
    if id == Gosu::KbSpace && @falling_shape != nil
      @falling_shape.rotation += 1
      if @falling_shape.collide?
        @falling_shape.rotation -= 1
      end
    end
  end

  def line_complete? y
    i = @blocks.count{|item| item.y == y}
    return ( i == width / block_width )
  end

  def delete_lines_of( shape )
    deleted_lines = []
    shape.get_blocks.each do |block|
      if (line_complete? block.y)
        deleted_lines.push(block.y)
        @blocks = @blocks.delete_if { |item| item.y == block.y }
        @score += 10
      end
    end
    @lines_cleared += deleted_lines.length
    @blocks.each do |block|
      i = deleted_lines.count{ |y| y > block.y }
      block.y += i*block_height
    end
  end

  def save (data)
    output = File.new('data.yml', 'w')
    output.puts YAML.dump(data)
    output.close
  end

  def load
     output = File.new('data.yml', 'r')
     loaded_data = YAML.load(output.read)
     @score = loaded_data[:score]
     @level = loaded_data[:level]
     output.close
  end
end


def high_score_check
  output = File.new('high_score.yml', 'r')
  loaded_high_score = YAML.load(output.read)
  output.close

  if @high_score < loaded_high_score
    @high_score = loaded_high_score
  else
    output = File.new('high_score.yml', 'w')
    output.puts YAML.dump(@high_score)
    output.close
  end


end

if ( !$testing )
  window = TetrisGameWindow.new
  window.show
end