class Vars_Initialization
  def initialize
    # Menu: hero names
    $game_variables[99] = 255
    $game_variables[100] = 28

    # Puntata arena (map32)
    $game_variables[102] = 20

    # Disable default menu
    $game_system.menu_disabled = true

    # Credits (script)
    $credits_script = [
      "STEFANO MERCADANTE (Localization system)", 
      "VLAD (Crissaegrim ABS)", 
      "MOGHUNTER (Title screen)", 
      "SHUUCHAN (Fog system)", 
      "BULLEXT (Autosave system)", 
      "WORATANA (NeoSave system, Message system)", 
      "ALLY (Jump system)"
    ]
  end
end