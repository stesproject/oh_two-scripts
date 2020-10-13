#===============================================================================
# Oversized Event Support
#===============================================================================
# Author       : Exhydra
# Version      : 1.1a
# Last Updated : 07/03/2011
#===============================================================================
# Updates
# -----------------------------------------------------------------------------
# » 07/03/11 Cleaned up code and allowed for custom event tags.
# » 06/22/11 Initial Release.
#===============================================================================
# Future Options
# -----------------------------------------------------------------------------
# » Fixing up the oversized passability code, though it works fairly well enough 
#   at the moment.
#===============================================================================
# Instructions
# -----------------------------------------------------------------------------
# To Use :
#   (1) Edit the following tag in a comment within a page of the event you wish
#       to add oversize support for :
#
#       < Tag with Direction Markers >
#       [ExOszRect:0,1,2,3,4,5,6,7]
# 
#       < Tag Direction Marker Legend >
#       [5][6][7]
#       [3]   [4]
#       [0][1][2]
#
#
#       < Tag Example #1 >
#       [ExOszRect:0,0,0,2,2,0,0,0]
#
#       - The above example would create an event that would take up a grid
#         like the one displayed below where 'e' is the base square of the 
#         event and 'n' are new squares added to the grid of the event :
#
#         [n][n][e][n][n]
#
#
#       < Tag Example #2 >
#       [ExOszRect:0,2,0,0,0,1,1,1]
#
#            [n][n][n]
#               [e]
#               [n]
#               [n]
#
#
#       < Tag Example #3 >
#       [ExOszRect:2,0,0,0,0,0,0,2]
#
#                     [n]
#                  [n]
#               [e]
#            [n]
#         [n]
#
#
#   (2) Assign a switch below and toggle it into the 'On' position to activate
#       Oversized Event Support.
# 
#===============================================================================
# Description
# -----------------------------------------------------------------------------
# - Have you ever assigned large graphics to your events only to find that your
#   huge dragon has just has one square which triggers its code? Oversized
#   Event Support can help! You can easily assign a larger grid to your fierce
#   dragon and allow it to become the terror it was meant to be!
#===============================================================================

module ExOSZEvent

  # < Activation Switch > 
  #   - Change this to the switch you would like to use.
  EX_OSZEVENT_SW = 70

end

#==============================================================================
# -» Game_Event
# -----------------------------------------------------------------------------
# Summary of Changes:
#    Aliased Method(s) - setup
#==============================================================================
class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor    :ex_osz_rect                       # OSZ Rect
  attr_accessor    :ex_osz_coords                     # OSZ Coords
 
  #--------------------------------------------------------------------------
  # » setup                                                         [ Alias ]
  #--------------------------------------------------------------------------
  alias ex_oszev_setup setup unless $@
  def setup(*args)
    ex_oszev_setup(*args)
    @ex_osz_coords = []
    return unless @list != nil
    for i in 0...@list.size
      next if @list[i].code != 108
      if @list[i].parameters[0].include?("[ExOszRect:")
        @ex_osz_rect = (@list[i].parameters[0].scan(/\[\w+:(\d,\d,\d,\d,\d,\d,\d,\d)\]/).to_s).split(%r{,})
      end
    end
  end
end

#==============================================================================
# -» Game_Map
# -----------------------------------------------------------------------------
# Summary of Changes:
#    Aliased Method(s) - events_xy
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # » events_xy                                                     [ Alias ]
  #--------------------------------------------------------------------------
  alias ex_oszev_events_xy events_xy unless $@
  def events_xy(*args)
    osz_ev_result = ex_oszev_events_xy(*args)
    if $game_switches[ExOSZEvent::EX_OSZEVENT_SW]
      for event in $game_map.events.values
        if event.ex_osz_rect != nil
          event.ex_osz_coords.clear
          tmp_count = 0
          for extra_grid in event.ex_osz_rect
            for grid_i in 0..extra_grid.to_i
              next if extra_grid.to_i == 0
              case tmp_count
                when 0
                  ex_osz_tmp_x =  (grid_i);      ex_osz_tmp_y = (-grid_i)
                when 1
                  ex_osz_tmp_x =         0;      ex_osz_tmp_y = (-grid_i)
                when 2
                  ex_osz_tmp_x = (-grid_i);      ex_osz_tmp_y = (-grid_i)
                when 3
                  ex_osz_tmp_x =  (grid_i);      ex_osz_tmp_y =         0
                when 4
                  ex_osz_tmp_x = (-grid_i);      ex_osz_tmp_y =         0
                when 5
                  ex_osz_tmp_x =  (grid_i);      ex_osz_tmp_y =  (grid_i)
                when 6
                  ex_osz_tmp_x =         0;      ex_osz_tmp_y =  (grid_i)
                when 7
                  ex_osz_tmp_x = (-grid_i);      ex_osz_tmp_y =  (grid_i)
              end
              event.ex_osz_coords.push((ex_osz_tmp_x).to_s + "," + (ex_osz_tmp_y).to_s)
              osz_ev_result.push(event) if event.pos?(args[0] + ex_osz_tmp_x, args[1] + ex_osz_tmp_y)
            end
            tmp_count += 1
          end
        end
      end
    end
    if event != nil
      event.ex_osz_coords.uniq! unless event.ex_osz_coords == nil
    end
    return osz_ev_result
  end
end

#==============================================================================
# -» Game_Character
# -----------------------------------------------------------------------------
# Summary of Changes:
#    Aliased Method(s) - move_down, move_left, move_right, move_up
#    New Method(s)     - oversized_spatial_check
#==============================================================================

class Game_Character
  #--------------------------------------------------------------------------
  # » Oversized Spatial Check                                         [ New ]
  #--------------------------------------------------------------------------
  def oversized_spatial_check(direction, xy_val)
    tmp_array   = []
    tmp_trigger = [nil, nil]
    for coord_grid in self.ex_osz_coords
      tmp_pair = coord_grid.split(%r{,})
      tmp_chk  = true
      
      case direction
        when 2
          tmp_x  = (@x) + ((tmp_pair[0].to_i))
          tmp_y  = (@y) + ((tmp_pair[1].to_i) + xy_val)
        when 4
          tmp_x  = (@x) + (-(tmp_pair[0].to_i) + xy_val)
          tmp_y  = (@y) + (-(tmp_pair[1].to_i))
        when 6
          tmp_x  = (@x) + ((tmp_pair[0].to_i) + xy_val)
          tmp_y  = (@y) + (-(tmp_pair[1].to_i))
        when 8
          tmp_x  = (@x) + (-(tmp_pair[0].to_i))
          tmp_y  = (@y) + (-(tmp_pair[1].to_i) + xy_val)
      end
      
      if passable?(tmp_x, tmp_y) == false
        if $game_map.valid?(tmp_x, tmp_y) == true
          if map_passable?(tmp_x, tmp_y) == true
            tmp_ev = $game_map.events_xy(tmp_x, tmp_y)
            if tmp_ev.size > 0
              for grid_event in tmp_ev
                tmp_chk = false if grid_event != self
              end
            end
            if $game_player.pos?(tmp_x, tmp_y)
              tmp_chk = false 
              tmp_trigger[0] = tmp_x
              tmp_trigger[1] = tmp_y
            end
            tmp_array.push(false) if tmp_chk == false
          else
            tmp_array.push(false)
          end
        else
          tmp_array.push(false)
        end
      end 
        
    end
    if tmp_array.include?(false)
      tmp_chk = false 
    else
      tmp_chk = true
    end
    return [tmp_chk, tmp_trigger[0], tmp_trigger[1]]

  end

  #--------------------------------------------------------------------------
  # » Move Down                                                     [ Alias ]
  #--------------------------------------------------------------------------
  alias ex_oszev_move_down move_down unless $@
  def move_down(*args)
    if $game_switches[ExOSZEvent::EX_OSZEVENT_SW] and self.is_a?(Game_Event)
      if self.ex_osz_rect != nil
        osz_event_chk = oversized_spatial_check(2, 1)
        if osz_event_chk[0]
          turn_down
          @y = $game_map.round_y(@y+1)
          @real_y = (@y-1)*256
          increase_steps
          @move_failed = false
          return
        else
          turn_down
          check_event_trigger_touch(osz_event_chk[1], osz_event_chk[2])
          @move_failed = true
          return
        end
      end
    end

    ex_oszev_move_down(*args)
  end
  
  #--------------------------------------------------------------------------
  # » Move Left                                                     [ Alias ]
  #--------------------------------------------------------------------------
  alias ex_oszev_move_left move_left unless $@
  def move_left(*args)
    if $game_switches[ExOSZEvent::EX_OSZEVENT_SW] and self.is_a?(Game_Event)
      if self.ex_osz_rect != nil
        osz_event_chk = oversized_spatial_check(4, -1)
        if osz_event_chk[0]
          turn_left
          @x = $game_map.round_x(@x-1)
          @real_x = (@x+1)*256
          increase_steps
          @move_failed = false
          return
        else
          turn_left
          check_event_trigger_touch(osz_event_chk[1], osz_event_chk[2])
          @move_failed = true
          return
        end
      end
    end

    ex_oszev_move_left(*args)
  end
  
  #--------------------------------------------------------------------------
  # » Move Right                                                    [ Alias ]
  #--------------------------------------------------------------------------
  alias ex_oszev_move_right move_right unless $@
  def move_right(*args)
    if $game_switches[ExOSZEvent::EX_OSZEVENT_SW] and self.is_a?(Game_Event)
      if self.ex_osz_rect != nil
        osz_event_chk = oversized_spatial_check(6, 1)
        if osz_event_chk[0]
          turn_right
          @x = $game_map.round_x(@x+1)
          @real_x = (@x-1)*256
          increase_steps
          @move_failed = false
          return
        else
          turn_right
          check_event_trigger_touch(osz_event_chk[1], osz_event_chk[2])
          @move_failed = true
          return
        end
      end
    end

    ex_oszev_move_right(*args)
  end
  
  #--------------------------------------------------------------------------
  # » Move up                                                       [ Alias ]
  #--------------------------------------------------------------------------
  alias ex_oszev_move_up move_up unless $@
  def move_up(*args)
    if $game_switches[ExOSZEvent::EX_OSZEVENT_SW] and self.is_a?(Game_Event)
      if self.ex_osz_rect != nil
        osz_event_chk = oversized_spatial_check(8, -1)
        if osz_event_chk[0] 
          turn_up
          @y = $game_map.round_y(@y-1)
          @real_y = (@y+1)*256
          increase_steps
          @move_failed = false
          return
        else
          turn_up
          check_event_trigger_touch(osz_event_chk[1], osz_event_chk[2])
          @move_failed = true
          return
        end
      end
    end
    
    ex_oszev_move_up(*args)
  end
end