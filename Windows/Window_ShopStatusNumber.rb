#==============================================================================
# ** Window_ShopStatus
#------------------------------------------------------------------------------
#  This window displays number of items in possession and the actor's equipment
# on the shop screen.
#==============================================================================

class Window_ShopStatusNumber < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #--------------------------------------------------------------------------
  def initialize(x, y, w = 544, h = 304)
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
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    if @item != nil
      number = $game_party.item_number(@item)
      self.contents.font.color = system_color
      self.contents.draw_text(4, 0, 32, WLH, Vocab::Possession)
      self.contents.font.color = normal_color
      self.contents.draw_text(4, 0, 32, WLH, number, 2)
      refresh_numbers
      for actor in $game_party.members
        x = 4
        y = WLH * (2 + actor.index * 2)
        draw_actor_parameter_change(actor, x, y)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh numbers
  #--------------------------------------------------------------------------
  def refresh_numbers
    y = 0
    self.contents.clear
    draw_item_name(@item, 0, y)
    self.contents.font.color = normal_color
    self.contents.draw_text(112, y, 20, WLH, "×")
    self.contents.draw_text(138, y, 20, WLH, @number, 2)
    self.cursor_rect.set(134, y, 28, WLH)
    self.contents.draw_text(170, y, 20, WLH, "=")
    draw_currency_value(@price * @number, 94, y, 164)
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
  #--------------------------------------------------------------------------
  # * Draw Actor's Current Equipment and Parameters
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #--------------------------------------------------------------------------
  def draw_actor_parameter_change(actor, x, y)
    return if @item.is_a?(RPG::Item)
    enabled = actor.equippable?(@item)
    self.contents.font.color = normal_color
    self.contents.font.color.alpha = enabled ? 255 : 128
    self.contents.draw_text(x, y, 32, WLH, actor.name)
    if @item.is_a?(RPG::Weapon)
      item1 = weaker_weapon(actor)
    elsif actor.two_swords_style and @item.kind == 0
      item1 = nil
    else
      item1 = actor.equips[1 + @item.kind]
    end
    if enabled
      if @item.is_a?(RPG::Weapon)
        atk1 = item1 == nil ? 0 : item1.atk
        atk2 = @item == nil ? 0 : @item.atk
        change = atk2 - atk1
      else
        def1 = item1 == nil ? 0 : item1.def
        def2 = @item == nil ? 0 : @item.def
        change = def2 - def1
      end
      self.contents.draw_text(x, y, 32, WLH, sprintf("%+d", change), 2)
    end
    draw_item_name(item1, x, y + WLH, enabled)
  end
  #--------------------------------------------------------------------------
  # * Get Weaker Weapon Equipped by the Actor (for dual wielding)
  #     actor : actor
  #--------------------------------------------------------------------------
  def weaker_weapon(actor)
    if actor.two_swords_style
      weapon1 = actor.weapons[0]
      weapon2 = actor.weapons[1]
      if weapon1 == nil or weapon2 == nil
        return nil
      elsif weapon1.atk < weapon2.atk
        return weapon1
      else
        return weapon2
      end
    else
      return actor.weapons[0]
    end
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #     item : new item
  #--------------------------------------------------------------------------
  def item=(item)
    if @item != item
      @item = item
      refresh
    end
  end
end
