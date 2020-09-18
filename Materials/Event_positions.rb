#-----------------------------------------------------------------------
#                       Memorize Event Positions
#                               BigEd781
#-----------------------------------------------------------------------

# * Set this to the switch number that you will
#   use to turn this script ON or OFF.  
#   Turn the switch "ON" to disable the script.
#   ---------  
#   Set to switch id "1" by default.

NO_MOVE_EVENTS_SWITCH_ID = 412
NOT_SAVE_POSITION_MAPS = [2, 10, 16, 30, 101, 3, 4]

class Game_System

  alias :eds_old_pre_mem_intialize :initialize
  def initialize
    eds_old_pre_mem_intialize
    @event_pos_data = {}    
  end

  def save_event_position_data(map_id, data)
    @event_pos_data[map_id] = data
  end

  def get_event_position_data(map_id)
    return @event_pos_data[map_id].nil? ? [] : @event_pos_data[map_id] 
  end

end

class Game_Event < Game_Character

  def comment?(comment)
    unless @list.nil?
      @list.each { |line|
        next if line.code != 108                              
        return true if line.parameters[0].upcase == comment.upcase }      
    end    
    return false
  end  

end

class Game_Map 

  alias :eds_old_pre_mem_setup :setup
  def setup(map_id)
    skip = NOT_SAVE_POSITION_MAPS.include?(map_id)
    save_positions unless $game_switches[NO_MOVE_EVENTS_SWITCH_ID]
    eds_old_pre_mem_setup(map_id)    
    restore_positions unless $game_switches[NO_MOVE_EVENTS_SWITCH_ID] || skip
  end

  def save_positions
    return if @events.nil? || @events == { }        
    data = []
    @events.values.each { |event| data += [[ event.id, event.x, event.y, event.direction ]] }       
    $game_system.save_event_position_data(@map_id, data)    
  end

  def restore_positions    
    return if @events.nil? || @events == { }        
    $game_system.get_event_position_data(@map_id).each { |data|   
    event = @events[data[0]]  
      unless event.nil? || event.comment?('no mem')
        x, y, direction = data[1], data[2], data[3]
        event.moveto(x, y) unless event.pos?(x, y) 
        event.set_direction(direction)
      end
    }    
  end

end