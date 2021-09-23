class Vars_Initialization
  def initialize
    # Menu: hero names
    $game_variables[99] = 255
    $game_variables[100] = 28

    # Puntata arena (map32)
    $game_variables[102] = 20

    # Disable default menu
    $game_system.menu_disabled = true

    # Debug
    $game_switches[435] = $TEST && true #speed-up
    $game_switches[436] = $TEST && true #power-up

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

    # Credits (music)
    $credits_music_1 = [
      "ENRICO CASCAVILLA (Main Title)", 
      "JASPRELAO (Memories)", 
      "RPGMAKER 3 MUSIC PACK (The Beginning)", 
      "MIGHT BE MAGIC (Green Forest)", 
      "XCALNAROK (Castle Grounds)", 
      "ENRICO CASCAVILLA (Dungeons)", 
      "RAFFAELE MURRI (Wild Valley)",
      "GAMESFREAK13563 (Rocky Mountains)", 
      "LANA42 (Dead Valley)", 
      "BENSOUND.COM (Abyssal Waterfalls)", 
      "RPGMAKER 3 MUSIC PACK (Forest)", 
    ]
    $credits_music_2 = [
      "PLASTIC SOUND DESIGN (Cyberspace)", 
      "AARON KROGH (Suburbs)", 
      "EMANUEL (Race)",
      "SNOWY FOX (Ancient Ruins)", 
      "AARON KROGH (Against the General)", 
      "TARRANON (Ruins Collapse)", 
      "TARRANON (Towards Derijiro)", 
      "WAVEBRIGADE (Standard Battle)", 
      "AUDIONAUTIX (Boss Battle)", 
      "DIBUR (Final Battle)",
      "MIGHT BE MAGIC (The End)"
    ]
  end
end