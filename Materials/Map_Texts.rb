#==============================================================================
# MapTexts script
# Author: Ste
# Version: 1.0
#==============================================================================

#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc. It's used
# within the Scene_Map class.
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # Alias Listing
  #--------------------------------------------------------------------------
  alias spriteset_name_window_initialize initialize
  alias spriteset_name_window_update update
  alias spriteset_name_window_dispose dispose
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    # create_windows
    $texts_w = nil
    spriteset_name_window_initialize
    update
  end
  #--------------------------------------------------------------------------
  # * Create Windows
  #--------------------------------------------------------------------------
  def create_windows
    $texts_w = Window_MapTexts.new
    $texts_w.show_name
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    spriteset_name_window_update
    if $texts_w != nil
      $texts_w.update
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    spriteset_name_window_dispose
    if $texts_w != nil
      $texts_w.dispose
    end
  end
end

#==============================================================================
# ** Window_MapTexts
#------------------------------------------------------------------------------
#  This window shows the map name when the player is transfered.
#==============================================================================

class Window_MapTexts < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(texts="", lh=32)
    super(0, 0, 544, 416)
    self.visible = false
    self.openness = 255
    self.back_opacity = 0
    self.opacity = 0
    @texts = texts
    @lh = lh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.visible = true
    self.contents.clear
    self.contents.font.color = normal_color
    lh = @lh
    @texts.each do |text|
      self.contents.draw_text(0,0,504,lh,text,1)
      lh += @lh
    end
  end
  #--------------------------------------------------------------------------
  # * Show Name
  #--------------------------------------------------------------------------
  def show_name(texts=@texts, lh=@lh)
    @texts = texts
    @lh = lh
    refresh
  end
end