#==============================================================================
# ** Window_Gold
#------------------------------------------------------------------------------
#  This window displays the amount of gold.
#==============================================================================

class Window_Gold < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #--------------------------------------------------------------------------
  def initialize(x, y, w = 160, h = WLH + 32)
    super(x, y, w, h)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_currency_value($game_party.gold, -16, 0, 120)
  end
end
