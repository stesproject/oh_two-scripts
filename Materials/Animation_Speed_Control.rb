#==============================================================================
#  Autotile Animation Speed Control
#  Version: 1.0
#  Author: modern algebra (rmrk.net)
#  Date: September 27, 2009
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Instructions:
#    Just paste this script between Materials and Main. To adjust default value
#   autotile frame count, go to line 40 and change the 30 there to the number 
#   of frames you want it to wait between animating. Keep in mind that
#   there are 60 frames per second generally. You can also change the number 
#   of frames waited in-game with the code: 
# 
#      $game_system.autotile_anim_frames = integer
#
#    If you use that code, however, you will need to go through a transfer 
#   event before it will be applied, as calculations are only done when the map
#   is initialized. You can also transfer to the same map.
#==============================================================================
# ** Game_System
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Summary of Changes:
#    aliased method - initialize
#    new public writer variable - autotile_anim_speed
#==============================================================================

class Game_System
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Public Instance Variable
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  attr_accessor :autotile_anim_frames # Controls speed of autotiles
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Object Initialization
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  alias modalg_autotile_frm_upd_init_84n initialize
  def initialize
    # Run Original Method
    modalg_autotile_frm_upd_init_84n
    # Initialize Autotile variable
    @autotile_anim_frames = 30
  end
end
  
#==============================================================================
# ** Tilemap
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Summary of Changes:
#    aliased methods - initialize, update
#==============================================================================
class Tilemap
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Object Initialization
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  alias ma_autotile_anim_frme_cntrl_init_93n5 initialize
  def initialize (viewport = nil)
    ma_autotile_anim_frme_cntrl_init_93n5 (viewport)
    # Calculate frame speed of update
    @frame_plus = 30.0 / $game_system.autotile_anim_frames.to_f
    # Initialize counting variables
    @anim_frames = 0.0
    @last_frame = 0
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Frame Update
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  alias modalg_upd_frame_anim_autotiles_89r4b update
  def update
    # If counting variable has increased another 'frame'
    while @anim_frames >= @last_frame
      # Run Original method
      modalg_upd_frame_anim_autotiles_89r4b
      # Advance count variable
      @last_frame += 1
      if @last_frame == 30
        @anim_frames = 0.0
        @last_frame = 0
      end
    end
    # Advance false count variable
    @anim_frames += @frame_plus
  end
end