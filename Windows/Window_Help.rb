#==============================================================================
# ** Window_Help
#------------------------------------------------------------------------------
#  This window shows skill and item explanations along with actor status.
#==============================================================================

class Window_Help < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x = 0, y = 0, w = 544, h = WLH + 32, dark = false)
    super(x, y, w, h)
    @color = dark == true ? dark_color : normal_color
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #  text  : character string displayed in window
  #  align : alignment (0..flush left, 1..center, 2..flush right)
  #--------------------------------------------------------------------------
  def set_text(text, align = 0)
    if text != @text or align != @align
      self.contents.clear
      self.opacity = 0
      self.contents.font.color = @color
      self.contents.font.italic = false
      self.contents.font.shadow = false
      self.contents.draw_text(0, 0, self.width - 40, WLH, text, align)
      @text = text
      @align = align
    end
  end
end
