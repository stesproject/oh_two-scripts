class Vars_Initialization
  def initialize
    # menu: hero names
    $game_variables[99] = 255
    $game_variables[100] = 28

    # Disable default menu
    $game_system.menu_disabled = true
  end
end