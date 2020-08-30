module ADDON
  ASK_FULLSCREEN = true # if set to false it wont ask you and it'll go straight to
                    # fullscreen
end
class Window_Text < Window_Base
  def initialize(x, y)
    super(x, y, 544, 64)
    refresh
  end
  def refresh
    self.contents.clear
    self.contents.draw_text(0, 0, 544, 32, "Vuoi giocare a schermo intero?")
  end
end

class Scene_Title
  
  alias main_fullscreen? main
  def main
    if ADDON::ASK_FULLSCREEN 
      unless $game_started 
        Graphics.freeze
        $data_system = load_data('Data/System.rvdata')
        $game_system = Game_System.new
        @text_window = Window_Text.new(92, 128)
        @text_window.back_opacity = 0
        @text_window.opacity = 0
        s1 = "Sì"
        s2 = "No"
        @window = Window_Command.new(96, [s1 ,s2])
        @window.x = 92
        @window.y = 240 - @window.height / 2
        @window.opacity = 0
        Graphics.transition
        loop do
          Graphics.update
          Input.update
          @window.update
          update_window
          break if $game_started
        end
        Graphics.freeze
        @window.dispose
        @window = nil
        @text_window.dispose
        Graphics.transition
        Graphics.freeze
      end
    else
      auto
    end
    main_fullscreen?
  end
  
  def update_window
    if Input.trigger?(Input::C)
      if @window.index == 0
        Sound.play_decision
        keybd = Win32API.new 'user32.dll', 'keybd_event', ['i', 'i', 'l', 'l'], 'v'
        keybd.call(0xA4, 0, 0, 0)
        keybd.call(13, 0, 0, 0)
        keybd.call(13, 0, 2, 0)
        keybd.call(0xA4, 0, 2, 0)
      else
      end
      $game_started = true
    elsif Input.trigger?(Input::B)
      $game_started = true
    end
  end
  def auto
    keybd = Win32API.new 'user32.dll', 'keybd_event', ['i', 'i', 'l', 'l'], 'v'
    keybd.call(0xA4, 0, 0, 0)
    keybd.call(13, 0, 0, 0)
    keybd.call(13, 0, 2, 0)
    keybd.call(0xA4, 0, 2, 0)
    $game_started = true
  end
end