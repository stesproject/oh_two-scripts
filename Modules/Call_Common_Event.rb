class Call_Common_Event
  def initialize(event_id)
    common_event = $data_common_events[event_id]
    map_id = $game_map.map_id
    interpreter = Game_Interpreter.new
    interpreter.setup(common_event.list, map_id)
    interpreter.update
  end
end