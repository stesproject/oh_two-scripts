#==============================================================================
# ** Window_ShopNumber
#------------------------------------------------------------------------------
#  This window is for inputting quantity of items to buy or sell on the
# shop screen.
#==============================================================================

class Window_ShopNumber < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #--------------------------------------------------------------------------
  def initialize(x = 0, y = 288, w = 544, h = 128)
    super(x, y, w, h)
    @item = nil
    @max = 1
    @price = 0
    @number = 1
    self.opacity = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * Set Items, Max Quantity, and Price
  #--------------------------------------------------------------------------
  def set(item, max, price)
    @item = item
    @max = max
    @price = price
    @number = 1
    refresh
  end
  #--------------------------------------------------------------------------
  # * Set Inputted Quantity
  #--------------------------------------------------------------------------
  def number
    return @number
  end
  #--------------------------------------------------------------------------
  # * Refresh numbers
  #--------------------------------------------------------------------------
  def refresh
    x = 0
    y = 0
    width = 20
    self.contents.clear
    self.contents.font.italic = false
    self.contents.font.shadow = false
    self.contents.font.color = dark_color

    self.contents.draw_text(x, y, width, WLH, "×")
    self.contents.draw_text(x + 24, y, width, WLH, @number, 2)
    self.cursor_rect.set(x + 20, y, width + 8, WLH)
    self.contents.draw_text(x + 58, y, width, WLH, "=")

    draw_currency_value(@price * @number, x + 26, y, 120, dark_color, text_color(2))
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    if self.active
      last_number = @number
      if Input.repeat?(Input::RIGHT) and @number < @max
        @number += 1
      end
      if Input.repeat?(Input::LEFT) and @number > 1
        @number -= 1
      end
      if Input.repeat?(Input::UP) and @number < @max
        @number = [@number + 10, @max].min
      end
      if Input.repeat?(Input::DOWN) and @number > 1
        @number = [@number - 10, 1].max
      end
      if @number != last_number
        Sound.play_cursor
        refresh
      end
    end
  end
end
