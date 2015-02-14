class ShapeI < Shape
  def initialize(game)
    super(game)

    @rotation_block = @blocks[1]
    @rotation_cycle = 2
  end

  def get_blocks
    @blocks[0].x = @x
    @blocks[1].x = @x
    @blocks[2].x = @x
    @blocks[3].x = @x
    @blocks[0].y = @y
    @blocks[1].y = @blocks[0].y + @blocks[0].height
    @blocks[2].y = @blocks[1].y + @blocks[1].height
    @blocks[3].y = @blocks[2].y + @blocks[2].height

    apply_rotation
    @blocks.each { |block| block.color = 0xffb2ffff }
  end
end

class ShapeL < Shape
  def initialize(game)
    super(game)

    @rotation_block = @blocks[1]
    @rotation_cycle = 4
  end

  def get_blocks
    @blocks[0].x = @x
    @blocks[1].x = @x
    @blocks[2].x = @x
    @blocks[3].x = @x + @game.block_width
    @blocks[0].y = @y
    @blocks[1].y = @blocks[0].y + @game.block_height
    @blocks[2].y = @blocks[1].y + @game.block_height
    @blocks[3].y = @blocks[2].y

    apply_rotation

    @blocks.each { |block| block.color = 0xffff7f00 }
  end
end
class ShapeJ < ShapeL
  def get_blocks
    old_rotation = @rotation
    @rotation = 0
    super
    reverse
    @rotation = old_rotation
    apply_rotation
    @blocks.each { |block| block.color = 0xff0000ff}
  end
end

class ShapeCube < Shape
  def get_blocks
  @blocks[0].x = @x
  @blocks[1].x = @x
  @blocks[2].x = @x + @game.block_width
  @blocks[3].x = @x + @game.block_width
  @blocks[0].y = @y
  @blocks[1].y = @blocks[0].y + @game.block_height
  @blocks[2].y = @blocks[0].y
  @blocks[3].y = @blocks[2].y + @game.block_height

  @blocks.each { |block| block.color = 0xffffff00}
  end
end
class ShapeZ < Shape
  def initialize(game)
    super(game)

    @rotation_block = @blocks[1]
    @rotation_cycle = 2
  end

  def get_blocks
    @blocks[0].x = @x
    @blocks[1].x = @x + @game.block_width
    @blocks[2].x = @x + @game.block_width
    @blocks[3].x = @x + @game.block_width*2
    @blocks[0].y = @y
    @blocks[1].y = @y
    @blocks[2].y = @y + @game.block_height
    @blocks[3].y = @y + @game.block_height

    apply_rotation
    @blocks.each { |block| block.color = 0xffff0000 }
  end
end

class ShapeS < ShapeZ
  def get_blocks
    old_rotation = @rotation
    @rotation = 0
    super
    reverse

    @rotation = old_rotation
    apply_rotation

    @blocks.each { |block| block.color = 0xff00ff00 }
  end
end

class ShapeT < Shape
  def initialize(game)
    super(game)

    @rotation_block = @blocks[1]
    @rotation_cycle = 4
  end

  def get_blocks
    @blocks[0].x = @x
    @blocks[1].x = @x + @game.block_width
    @blocks[2].x = @x + @game.block_width*2
    @blocks[3].x = @x + @game.block_width
    @blocks[0].y = @y
    @blocks[1].y = @y
    @blocks[2].y = @y
    @blocks[3].y = @y + @game.block_height

    apply_rotation
    @blocks.each { |block| block.color = 0xffff00ff }
  end
end