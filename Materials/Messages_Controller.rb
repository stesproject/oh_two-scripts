class Messages_Controller
  require 'csv'

  attr_accessor :text
  attr_accessor :messages
  attr_accessor :words
  attr_accessor :message_row

  $lang = "en"
  LOAD_DATA_PATH = "Locale/map2.csv"
  SAVE_FILE_PATH = "messages.txt"
  NEW_LINE_CHAR = "§"
  ROW_LENGTH_MAX = 50
  MESSAGES_MAX = 4
  SPECIAL_CHARS = /\\nb\[(.*?)\]|\\\||\\\.|\\\^|\\g|\\c\[([0-9]+)\]|#{NEW_LINE_CHAR}/i

  def initialize
    @messages = []
    reset_row

    set_messages
    
    if messages_exceed_max?
      p "Messages are over the limit! (#{@messages.size}/#{MESSAGES_MAX})"
    else
      save_messages_to_file
    end
  end

  def set_messages
    data = get_csv_data
    text_original = get_text_from_data(data)
    @text = text_original.dup

    split_text_in_rows
  end

  def get_csv_data
    return CSV.read(LOAD_DATA_PATH, { :col_sep => ";", :headers => true })
  end

  def get_text_from_data(data)
    return data[7][$lang]
  end

  def split_text_in_rows
    @words = @text.split(" ")

    @words.each do |word|
      # row = @message_row + (word.gsub(/#{NEW_LINE_CHAR}/i) {})
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
      
      if word.include? NEW_LINE_CHAR
        @message_row = remove_n_chars_from(@message_row, 2)
        add_row_to_messages
        reset_row
      end

    end

  end

  def row_length_max_reached?(row)
    return row.gsub(SPECIAL_CHARS) {}.size >= ROW_LENGTH_MAX
  end

  def is_last_word?(word)
    return @words.last == word
  end

  def remove_n_chars_from(item, n = 1)
    size = item.size
    return item[0..size-(n+1)]
  end

  def add_word_to_row(word)
    @message_row += "#{word} "
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

  def save_messages_to_file
    File.open(SAVE_FILE_PATH, "w+") do |f|
      f.puts(@messages)
    end
  end

end

Messages_Controller.new