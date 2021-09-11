#==============================================================================
# ** Window_ShopStatus
#------------------------------------------------------------------------------
#  This window displays number of items in possession and the actor's equipment
# on the shop screen.
#==============================================================================

class Window_ShopStatus < Window_Base
  TEXT_X = 32
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #--------------------------------------------------------------------------
  def initialize(x = 0, y = 288, w = 544, h = 128, with_description = true)
    super(x, y, w, h)
    @with_description = with_description
    @nms = $game_message
    @help_window = Window_Help.new(x, 316, 544, 100, true)
    self.opacity = 0
    self.contents.font.name = @nms.nms_fontname
    self.contents.font.size = @nms.nms_fontsize
    self.contents.font.bold = Font.default_bold
    self.contents.font.italic = false
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    @help_window.dispose
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #--------------------------------------------------------------------------
  def set(item, qText = nil)
    @item = item
    @qText = qText
    @is_inventory = $game_switches[2]
    @is_equip = $game_switches[4]
    @is_cheat = $game_switches[5]
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    if @item != nil
      x = 0
      y = 0
      draw_icon(@item.icon_index, x, y, true)
      if @item.is_a?(RPG::Item)
        if @is_cheat
          draw_cheat_info
        else
          draw_items_owned
          draw_item_description if @with_description
        end
      elsif @item.is_a?(RPG::Weapon)
        if @is_equip
          $local.set_weapon_stats(@item.id)
          draw_weapon_stats
        else
          draw_weapon_shop
        end
      end
    end
  end

  def draw_item_description
    desc = @item.description.split(Localization::NEW_LINE_CHAR)
    @help_window.set_text(desc)
  end

  def draw_items_owned
    x = TEXT_X
    y = 0
    number = $game_party.item_number(@item)
    item_name = number > 1 ? $local.get_plural(@item) : @item.name
    if item_name == nil
      item_name = @item.name
    end
    quantity = @qText != nil ? @qText : number
    owned_text = $local.get_text("possession")
    if quantity != ""
      self.contents.draw_text(x, y, 544, WLH, "#{item_name}: #{quantity} #{owned_text}")
    else
      self.contents.draw_text(x, y, 544, WLH, "#{item_name}")
    end
  end

  def draw_weapon_shop
    x = TEXT_X
    y = 0
    param = $local.get_text("attack")
    value = @item.atk
    text_width = self.contents.text_size(@item.name).width
    self.contents.draw_text(x, y, text_width, WLH, "#{@item.name}")
    x += text_width
    self.contents.font.color = text_color(17)
    self.contents.draw_text(x, y, 544 - x, WLH, " | #{param}: #{value}")
    self.contents.font.color = normal_color
  end

  def draw_weapon_stats
    x = TEXT_X
    y = 0

    equipped_sword_atk = $game_variables[85]
    diff = @item.atk - equipped_sword_atk

    text_width = self.contents.text_size(@item.name).width
    self.contents.draw_text(x, y, text_width, WLH, "#{@item.name}")

    x += text_width
    text = " #{$local.get_text("attack")}: #{@item.atk}"
    text_width = self.contents.text_size(text).width
    self.contents.font.color = text_color(3)
    self.contents.draw_text(x, y, 544 - x, WLH, "#{text}")

    x += text_width
    diff_text = ""
    if diff < 0 
      # selected sword is worst than the one equipped
      self.contents.font.color = text_color(8)
      diff_text = "(#{diff})"
    elsif diff > 0
      # selected sword is better than the one equipped
      self.contents.font.color = text_color(11)
      diff_text = "(+#{diff})"
    elsif diff == 0
      # selected sword and the one equipped are equal
    end
    text_width = self.contents.text_size(diff_text).width
    self.contents.draw_text(x, y, 544 - x, WLH, " #{diff_text}")
  end

  def draw_cheat_info
    x = TEXT_X
    y = 0
    name = @item.name.upcase
    text_width = self.contents.text_size(name).width
    self.contents.draw_text(x, y, 544, WLH, "#{name}")
    cheat_data = @item.note.split("/")
    switch_id = cheat_data[0].to_i
    if $game_switches[switch_id] == false
      x += text_width
      t = $local.get_text("locked")
      self.contents.font.color = text_color(2)
      self.contents.draw_text(x, y, 544 - x, WLH, " #{t}")
    end
  end

  def set_help(text)
    @help_window.set_text(text)
  end

  def clear
    self.contents.clear
    self.contents.font.color = normal_color
    @help_window.set_text("")
  end
end
