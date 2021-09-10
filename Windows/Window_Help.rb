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
    @nms = $game_message
    self.opacity = 0
    self.contents.font.color = @color
    self.contents.font.italic = false
    self.contents.font.shadow = false
    self.contents.font.name = @nms.nms_fontname
    self.contents.font.size = @nms.nms_fontsize
    self.contents.font.bold = Font.default_bold
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #  text  : character string displayed in window
  #  align : alignment (0..flush left, 1..center, 2..flush right)
  #--------------------------------------------------------------------------
  def set_text(text, align = 0)
    if text != @text or align != @align
      self.contents.clear
      y = 0
      if text.kind_of?(Array)
        for t in text
          self.contents.draw_text(0, y, self.width - 40, WLH, t, align)
          y += 24
        end
      else
        self.contents.draw_text(0, y, self.width - 40, WLH, text, align)
      end
      @text = text
      @align = align
    end
  end
end
