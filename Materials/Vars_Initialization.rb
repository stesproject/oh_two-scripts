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
      "/cStefano Mercadante (Localization system)", 
      "/cVlad (Crissaegrim ABS)", 
      "/cMoghunter (Title screen)", 
      "/cShuuchan (Fog system)", 
      "/cBulleXt (Autosave system)", 
      "/cWoratana (NeoSave system, Message system)", 
      "/cAlly (Jump system)"
    ]
  end
end