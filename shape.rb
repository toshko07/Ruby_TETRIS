class Shape
  attr_accessor :rotation
  def initialize(game)
    @game = game
    @last_fall_update = Gosu::milliseconds
    @last_move_update = Gosu::milliseconds
    @blocks =  4.times.map {Block.new(game)}
    @x = random
    @y = 0
    @falling = true
    @rotation_block = @blocks[1]
    @rotaion_cycle = 1
    @rotation = 0
  end

  def random
    i = rand(@game.width - 128)
    if i % 32 == 0
      return i
    else
      random
    end
  end

  def apply_rotation
    if @rotation_block != nil
      (1..@rotation.modulo(@rotation_cycle)).each do |i|
        @blocks.each do |block|
          old_x = block.x
          old_y = block.y
          block.x = @rotation_block.x + (@rotation_block.y - old_y)
          block.y = @rotation_block.y - (@rotation_block.x - old_x)
        end
      end
    end
  end
# refactoring
  def reverse
    center = (get_bounds[:x_max] + get_bounds[:x_min]) / 2.0
    @blocks.each do |block|
    block.x = 2*center - block.x - @game.block_width
    end
  end

  def get_bounds
    x_min = []
    y_min = []
    x_max = []
    y_max = []
    @blocks.each do |block|
      x_min << block.x
      y_min << block.y
      x_max << block.x + block.width
      y_max << block.y + block.height
    end
      return {:x_min => x_min.min,:y_min => y_min.min, :x_max => x_max.max, :y_max => y_max.max}
  end

  def needs_fall_update?
    if (@game.button_down? Gosu::KbDown)
      update_interval = 100
    else
      update_interval = 500 - @game.level*50
    end
    if (Gosu::milliseconds - @last_fall_update > update_interval)
      @last_fall_update = Gosu::milliseconds
    end
  end

  def needs_move_update?
    if (Gosu::milliseconds - @last_move_update > 100)
      @last_move_update = Gosu::milliseconds
    end
  end

  def draw
    get_blocks.each { |block| block.draw }
  end

  def update
    if @falling
      old_x = @x
      old_y = @y

      @y = (@y + @game.block_height) if needs_fall_update?

      if collide?
        @y = old_y
        @falling = false
        @game.spawn_next_shape
        @game.delete_lines_of(self)
      else
        if needs_move_update?
          if @game.button_down? Gosu::KbLeft
            @x = @x - @game.block_width
          end

          if @game.button_down? Gosu::KbRight
            @x = @x + @game.block_width
          end
          @x = old_x if collide?
        end
      end
    end
  end

  def collide?
    get_blocks.each do |block|
    collision = block.collide_with_other_blocks?
    if (collision)
      return true
    end
    end

    bounds = get_bounds

    if ( bounds[:y_max] > @game.height )
    return true
    end

    if ( bounds[:x_max] > @game.width )
    return true
    end

    if ( bounds[:x_min] < 0 )
    return true
    end
    return false
  end

end

