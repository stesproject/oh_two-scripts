#==============================================================================
# Localization script
# Author: Ste
#==============================================================================
class Localization
  $default_language = ""
  $msg_var = [61,62,63,64]
  $param_var = 79
  @messages = nil

  LANG = ["en", "it", "es", "fr"]
  LANGUAGES = {
    "en" => "English",
    "it" => "Italiano",
    "es" => "Español",
    "fr" => "Français"
  }

  COMMON_INDEXES = {
    "skill-electric-1" => 1,
    "skill-electric-2" => 2,
    "skill-ice-1" => 3,
    "skill-ice-2" => 4,
    "skill-fire-1" => 5,
    "skill-fire-2" => 6,
    "skill-magic-1" => 7,
    "skill-magic-2" => 8,
    "skill-all-1" => 9,
    "skill-all-2" => 10,
    "cannot-control" => 11,
    "end-mission-1" => 12,
    "end-mission-2" => 13,
    "end-mission-3" => 14,
    "door-closed" => 15,
    "door-locked" => 16,
    "gate-locked" => 17,
    "door-sealed" => 18,
    "controlled-enemy" => 19,
    "no-weapon" => 20,
    "no-dindini" => 21
  }

  VOCABS_INDEXES = {
    "cannot_save" => 1,
    "empty" => 2,
    "playtime" => 3,
    "location" => 4,
    "currency" => 5,
    "ask_overwrite" => 6,
    "cancel" => 7,
    "save_message" => 8,
    "load_message" => 9,
    "possession" => 10,
    "shop_buy" => 11,
    "shop_sell" => 12,
    "shop_cancel" => 13,
    "new_game" => 14,
    "continue" => 15,
    "shutdown" => 16,
    "game_end" => 17,
    "to_title" => 18,
    "save" => 19,
    "item" => 20,
    "equip" => 21,
    "level" => 22,
    "hp" => 23,
    "mp" => 24,
    "atk" => 25,
    "weapon" => 26,
    "armor1" => 27,
    "armor2" => 28,
    "armor3" => 29,
    "armor4" => 30,
    "attack" => 31,
    "skill" => 32,
    "guard" => 33,
    "quit" => 34,
    "exp_next" => 35,
    "exp_total" => 36,
    "website" => 37,
    "menu_language" => 38,
    "back-king" => 39,
    "go-back" => 40,
    "defeat-monster" => 41,
    "go-king" => 42,
    "find-book" => 43,
    "find" => 44,
    "gave" => 45,
    "got" => 46,
    "act" => 47,
    "act-completed" => 48,
    "the-m" => 49,
    "the-f" => 50,
    "the-m-pl" => 51,
    "the-f-pl" => 52,
    "Ourhero" => 53,
    "class" => 54,
    "skill-assigned" => 55,
    "lv" => 56
  }

  MAPS_INDEXES = {
    "King's Castle" => 1,
    "Throne Room" => 2,
    "Trophy Hall" => 3,
    "Arena" => 4,
    "Teorhemas Vault" => 5,
    "Castle Grounds" => 6,
    "Forest of the All-Eye Monster" => 7,
    "Wild Valley" => 8,
    "Mistery Cave" => 9,
    "Water City" => 10,
    "Finalboss Domain" => 11,
    "Foxes Desert" => 12,
    "Volcanic Depths" => 13,
    "Eternal Glaciers" => 14,
    "Dark Forest" => 15,
    "Finalboss Castle" => 16,
    "Celebration Feast" => 17
  }

  DB_INDEXES = {
    "Meat" => 1,
    "Regenerator" => 2,
    "Small Bridge" => 3,
    "key1" => 4,
    "key2" => 5,
    "key3" => 6,
    "Book of the Forgotten Crafts" => 7,
    "Controller Crystal" => 8,
    "Bronze Medal" => 9,
    "Silver Medal" => 10,
    "Gold Medal" => 11,
    "Secrets Sheet" => 12,
    "Cute Monster" => 13,
    "Revolt Sword" => 14,
    "Assassin Blade" => 15,
    "Soldier's Sword" => 16,
    "Sabrelyzer" => 17,
    "Gelizedor" => 18,
    "Lollipop" => 19,
    "Electric Sword" => 20,
    "Revolt Sword II" => 21,
    "Zombiesbane" => 22,
    "Sword of the Legendary Hero" => 23,
    "Electric Guitar" => 24,
    "Icy Sword" => 25,
    "Flaming Sword" => 26,
    "Silver Slash" => 27,
    "Katana" => 28,
    "Final Revolt Sword" => 29,
    "Dragon Sword" => 30,
    "Finalboss Sword" => 31,
    "Soul Eater" => 32,
    "Copper Necklace" => 33,
    "Bronze Necklace" => 34,
    "Silver Necklace" => 35,
    "Golden Necklace" => 36,
    "Sword Case" => 37,
    "Strength Necklace" => 38,
    "Doubler Bracelet" => 39,
    "Healing Bracelet" => 40,
    "Rainbow Bracelets" => 41,
    "Electric Shock" => 42,
    "Icy Storm" => 43,
    "Fire Bomb" => 44,
    "Magic Attack" => 45
  }

  class ItemText
    attr_accessor :name
    attr_accessor :desc
  end

  def switch_language(value = 1)
    new_lang_index = LANG.index($lang) + value
    if new_lang_index < 0
      $lang = LANG.last
    elsif new_lang_index == LANG.size
      $lang = LANG.first
    else
      $lang = LANG[new_lang_index]
    end

    $locale.save_language
  end

  def reset_msg_vars
    @messages = []

    for i in 0..3
      $game_variables[$msg_var[i]] = ""
    end
  end

  def set_msg_vars
    if (@messages == nil)
      return
    end

    for i in 0..3
      @messages[i] = @messages[i] == nil ? "" : @messages[i]
      $game_variables[$msg_var[i]] = @messages[i]
    end
  end

  def get_db_object(name)
    text = ItemText.new()

    index = DB_INDEXES[name]
    line_data = index != nil ? $db_data[index] : name
    data = split_data(line_data)

    text.name = data[0]
    text.desc = data[1]

    return text
  end

  def get_map_name(name)
    index = MAPS_INDEXES[name]
    line_data = index != nil ? $map_names_data[index] : name
    data = split_data(line_data)

    return data[0]
  end

  def get_text(name)
    index = VOCABS_INDEXES[name]
    line_data = index != nil ? $vocabs_data[index] : name
    data = split_data(line_data)

    return data[0]
  end

  def set_msg(map_id, index)
    reset_msg_vars
    map_id = map_id == nil ? $game_map.map_id : map_id

    line_data = $maps_data[map_id][index]
    data = split_data(line_data)
    for d in data
      @messages.push(d)
    end

    set_msg_vars
  end

  def set_common_msg(name)
    reset_msg_vars

    index = COMMON_INDEXES[name]
    line_data = $common_data[index]
    data = split_data(line_data)
    for d in data
      @messages.push(d)
    end

    set_msg_vars
  end

  def set_action(action, item, value, item2 = nil, value2 = nil, item_data = nil)
    reset_msg_vars
    
    text = get_text(action)
    @messages.push(text)

    if (item_data != nil && item_data.note != "" && value > 1)
      plurals = []
      item_data.note.split(/\r?\n/).each do |text|
        plurals.push(text)
      end

      item = plurals[LANG.index($lang)]
    end

    amount = value > 0 ? value.to_s + " " : ""
    @messages.push("#{amount}#{item}!")

    if (item2 != nil && value2 != nil)
      amount = value2 > 0 ? value2.to_s + " " : ""
      @messages.push("#{amount}#{item2}!")
    end

    $msg_params = ["normal", "bottom"]

    set_msg_vars
  end

  def set_act_completed(index)
    reset_msg_vars

    text = get_text("act")
    @messages.push(text)

    case index
    when 1
      text = "#{get_text("the-m")} "
      text += get_map_name("King's Castle")

    when 2
      text = "#{get_text("the-f")} "
      text += get_map_name("Forest of the All-Eye Monster")

    when 3
      text = "#{get_text("the-f")} "
      text += get_map_name("Wild Valley")

    when 4
      text = "#{get_text("the-f")} "
      text += get_map_name("Water City")

    when 5
      text = "#{get_text("the-m")} "
      text += get_map_name("Foxes Desert")

    when 6
      text = "#{get_text("the-f-pl")} "
      text += get_map_name("Volcanic Depths")

    when 7
      text = "#{get_text("the-m-pl")} "
      text += get_map_name("Eternal Glaciers")

    when 8
      text = "#{get_text("the-f")} "
      text += get_map_name("Dark Forest")

    when 9
      text = "#{get_text("the-m")} "
      text += get_map_name("Finalboss Castle")

    end

    @messages.push(text.upcase)

    text = get_text("act-completed")
    @messages.push(text)

    $msg_params = ["transparent", "middle"]

    set_msg_vars
  end

  def set_weapon_stats(index)
    reset_msg_vars

    weapon = $data_weapons[index]
    @messages.push("\\c[14]#{weapon.name.upcase}")

    text = get_text("attack")
    @messages.push("#{text}: #{weapon.atk}")
    text = get_text("guard")
    @messages.push("#{text}: #{weapon.def}")

    $msg_params = ["dark", "middle"]

    set_msg_vars
  end

  def split_data(data)
    cells = []

    if (data == nil)
      return []
    end

    data.split(";").each do |cell|
      cells.push(cell)
    end

    lang_id = LANG.index($lang)
    msg_block = cells[lang_id]
    blocks = []
    if msg_block != nil
      msg_block.split("§").each do |msg|
        blocks.push(msg.to_s)
      end
    end

    return blocks
  end

end

$local = Localization.new()