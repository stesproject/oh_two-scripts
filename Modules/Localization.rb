#==============================================================================
# Localization script
# Author: Ste
# Version: 2.0
#==============================================================================
class Localization
  attr_accessor :msg_block
  attr_accessor :words
  attr_accessor :message_row

  NEW_LINE_CHAR = "§"
  ROW_LENGTH_MAX = 52
  MESSAGES_MAX = 4
  SPECIAL_SYMBOLS = /\\nb\[(.*?)\]|\\\||\\\.|\\\^|\\g|\\c\[([0-9]+)\]|#{NEW_LINE_CHAR}/i
  SPECIAL_CHARS = /([àèìòùé])+/

  $default_language = ""
  $msg_var = [91,92,93,94]
  $param_var = 95
  @messages = nil

  LANG = ["en", "it", "es", "fr"]
  LANGUAGES = {
    "en" => "English",
    "it" => "Italiano",
    "es" => "Español",
    "fr" => "Français"
  }

  COMMON_INDEXES = {
    "skill-electric-1" => 1
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
    "lv" => 39,
    "find" => 44,
    "gave" => 45,
    "got" => 46,
    "act" => 47,
    "act-completed" => 48,
    "the-m" => 49,
    "the-f" => 50,
    "the-m-pl" => 51,
    "the-f-pl" => 52,
    "ourhero" => 53,
    "tay" => 54,
    "fury" => 55,
    "king" => 56,
    "sage" => 57
  }

  MAPS_INDEXES = {
    "Green Forest" => 1,
    "Castle Grounds" => 2,
    "Castle Dungeons" => 3,
    "King's Castle" => 4,
    "Throne Room" => 5,
    "Teorhemas Vault" => 6,
    "Arena" => 7,
    "Wild Valley" => 8,
    "Rocky Mountains" => 9,
    "Dead Valley" => 10,
    "Abyssal Waterfalls" => 11,
    "Forest of the All-Eye Monster" => 12,
    "Cyberspace" => 13,
    "Kingdom Suburbs" => 14,
    "Race" => 15,
    "Ancient Ruins" => 16
  }

  DB_INDEXES = {
    "Meat" => 1,
    "Egg" => 2,
    "Health Potion" => 3,
    "Red Globes" => 4,
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

    for i in 0..@messages.size - 1
      @messages[i] = @messages[i] == nil ? "" : @messages[i]
      $game_variables[$msg_var[i]] = @messages[i]
    end
  end

  def get_db_object(name)
    text = ItemText.new()

    index = DB_INDEXES[name]
    line_data = index != nil ? $db_data[index] : name
    split_data(line_data)

    text.name = @messages[0]
    text.desc = @messages[1]

    return text
  end

  def get_map_name(name)
    index = MAPS_INDEXES[name]
    line_data = index != nil ? $map_names_data[index] : name
    split_data(line_data, false)

    return @msg_block
  end

  def get_text(name)
    index = VOCABS_INDEXES[name]
    line_data = index != nil ? $vocabs_data[index] : name
    split_data(line_data, false)

    return @msg_block
  end

  def set_msg(map_id, index)
    reset_msg_vars
    map_id = map_id == nil ? $game_map.map_id : map_id
    line_data = $maps_data[map_id][index]
    split_data(line_data)
    
    if messages_exceed_max?
      p "Messages are over the limit! (#{@messages.size}/#{MESSAGES_MAX})"
    else
      set_msg_vars
    end
  end

  def set_common_msg(name)
    reset_msg_vars

    index = COMMON_INDEXES[name]
    line_data = $common_data[index]
    split_data(line_data)

    if messages_exceed_max?
      p "Messages are over the limit! (#{@messages.size}/#{MESSAGES_MAX})"
    else
      set_msg_vars
    end
  end

  def set_action(action, item, value, item2 = nil, value2 = nil, item_data = nil, code = "")
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
    @messages.push("#{code}#{amount}#{item}!")

    if (item2 != nil && value2 != nil)
      amount = value2 > 0 ? value2.to_s + " " : ""
      @messages.push("#{code}#{amount}#{item2}!")
    end

    $msg_params = ["normal", "bottom"]

    set_msg_vars
  end

  def set_act_completed(index)
    reset_msg_vars

    text = get_text("act")

    case index
    when 1
      text += " #{get_text("the-f")} "
      text += get_map_name("Green Forest")

    when 2
      text += " #{get_text("the-m-pl")} "
      text += get_map_name("Castle Dungeons")

    when 3
      text += " #{get_text("the-f-pl")} "
      text += get_map_name("Rocky Mountains")

    when 4
      text += " #{get_text("the-f")} "
      text += get_map_name("Dead Valley")

    when 5
      text += " #{get_text("the-f-pl")} "
      text += get_map_name("Abyssal Waterfalls")

    when 6
      text += " #{get_text("the-m")} "
      text += get_map_name("Cyberspace")

    when 7
      text += " #{get_text("the-f")} "
      text += get_map_name("Kingdom Suburbs")

    when 8
      text += " #{get_text("the-f-pl")} "
      text += get_map_name("Ancient Ruins")

    when 9
      text += " #{get_text("the-f")} "
      text += get_map_name("Final Battle")

    end

    @messages.push(text)

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

  def split_data(data, split_in_rows = true)
    cells = []
    @messages = []
    reset_row

    if (data == nil)
      return []
    end

    data.split(";").each do |cell|
      cells.push(cell)
    end

    lang_id = LANG.index($lang)
    @msg_block = cells[lang_id]

    if @msg_block != nil && split_in_rows == true
      split_msg_block_in_rows
    end
  end
  
  def split_msg_block_in_rows
    @words = @msg_block.split(" ")

    @words.each do |word|
      row = @message_row + word
      if !row_length_max_reached?(row)
        add_word_to_row(word)
      end

      if row_length_max_reached?(row) || is_last_word?(word)
        @message_row = remove_n_chars_from(@message_row, 1)
        add_row_to_messages
        reset_row
        add_word_to_row(word)
      end

      if row_length_max_reached?(row) && is_last_word?(word)
        @message_row = remove_n_chars_from(@message_row, 1)
        add_row_to_messages
        reset_row
      end
      
      if word.include? NEW_LINE_CHAR
        @message_row = remove_n_chars_from(@message_row, 3)
        add_row_to_messages
        reset_row
      end

    end
  end

  def row_length_max_reached?(row)
    row_cleaned = row.gsub(SPECIAL_SYMBOLS) {}
    row_cleaned = row_cleaned.gsub(SPECIAL_CHARS) {"a"}
    return row_cleaned.size >= ROW_LENGTH_MAX
  end

  def add_word_to_row(word)
    @message_row += "#{word} "
  end

  def is_last_word?(word)
    return @words.last == word
  end

  def remove_n_chars_from(item, n = 1)
    size = item.size
    return item[0..size-(n+1)]
  end

  def add_row_to_messages
    @messages.push(@message_row)
  end

  def reset_row
    @message_row = ""
  end

  def messages_exceed_max?
    return @messages.size > MESSAGES_MAX
  end

end

$local = Localization.new()