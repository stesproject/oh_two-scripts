#===============================================================
# ● [VX] ◦ NMS - Neo Message System 2.0 ◦ □
#--------------------------------------------------------------
# ◦ by Woratana [woratana@hotmail.com]
# ◦ traduzione by Eikichi
# ◦ Special Thanks: Mako, Yatzumo, rpg2s community
#--------------------------------------------------------------
# Rilasciato il: 11/03/2008
# Traduzione rilasciata il: 09/05/2008
#--------------------------------------------------------------
# Include: NEO-FACE SYSTEM ADVANCE (Version 3.0) by Woratana
#===============================================================
=begin
=============================================
+ NMS 2.1 + [11/03/2008]: Fixed Name Box Bug
=============================================
=====================================
     + NMS 2.0 FEATURES LIST +
=====================================
Usa queste impostazioni durante la scrittura di un messaggio.
----------------------------------
● OPZIONI NEO MESSAGE SYSTEM
----------------------------------
--------------------------
□ [CHIAMATE SPECIALI]
--------------------------
\ce[ID Evento Comune] << Fà partire l'evento comune immediatamente

\ani[ID Animazione] << Mostra l'animazione sull'evento
\bal[ID Balloon Espressione] << Mostra il Ballon sull'evento

*Nota = per evento si intende l'evento che mostra il messaggio.
--------------------------
● [DISEGNA ICONA]
--------------------------
\dw[ID Arma]      << Disegna l'icona dell'arma + il nome dell'arma
\da[ID Armatura]  << Disegna l'icona dell'armatura + il nome dell'armatura
\di[ID Oggetto]   << Disegna l'icona dell'oggetto + il nome dell'oggetto
\ds[ID Abilità]   << Disegna l'icona dell'abilità + il nome dell'abilità

\ic[ID Icona]   << Disegna Icona

--------------------------
● [SCRIVI TESTO]
--------------------------
\map                         << Scrive il nome della mappa

\nc[ID Eroe]                << Scrive la classe dell'eroe
\np[da 1 a 4 (ordine del gruppo)] << Scrive il nome dell'eroe, in base all'ordine
\nm[ID Mostro]              << Scrive il nome del mostro
\nt[ID Gruppo di Nemici]                << Scrive il nome del gruppo di nemici

\nw[ID Arma]                    << Scrive il nome dell'arma
\na[ID Armatura]                << Scrive il nome dell'armatura
\ns[ID Abilità]                 << Scrive il nome dell'abilità
\ni[ID Oggetto]                 << Scrive il nome dell'oggetto
\price[ID Oggetto]              << Scrive il prezzo dell'oggetto

--------------------------
● [TEXT EFFECT]
--------------------------
\fn[Nome Font] << Cambia il font
\fs[Grandezza font] << Cambia la grandezza del font

\ref           << Default Font
\res           << Default Grandezza Font

\b             << Imposta on/off BOLD font
\i             << Imposta on/off ITALIC font
\lbl           << Imposta on/off modalità LETTERAxLETTERA (default è ON)

--------------------------
● [BOX NOME E FACE]
--------------------------
\nb[Nome]  << Mostra il box con il nome in questo messaggio
\rnb[Nome] << Ripeti il box con il nome in tutti i messaggio

Il box viene ripetuto all'infinito in tutti i messaggi. per fermarlo digitare: \rnb[]

\sd[side]      << Cambia lato del Face
(0: Lato Sinistro Face normale | -1: Lato Destro Face Normale)
(1: Lato Sinistro Neo Face | 2: Lato Destro Neo Face)

----------------------------------
● [IMPOSTAZIONI DEL MESSAGGIO]
----------------------------------
\v[ID Variabile] << Scrive il valore della variabile
\n[ID Eroe]    << Scrive il nome dell'eroe
\c[ID Colore]    << Cambia colore del testo(i colori sono nell'angolo in basso a destra della Windowskin)
\g              << Mostra la finestra con l'oro posseduto
\.              << Aspetta 15 frames (circa 1/4 sec)
\|              << Aspetta 60 frames (circa 1 sec)
\!              << Aspetta che il giocatore prema un tasto per proseguire il messaggio
\>              << Passa a LETTERAxLETTERA in questa riga
\<              << Ferma il LETTERAxLETTERA in questa riga
\^              << Chiudi subito il messaggio
\\              << Scrivi: '\'

=end
class Window_Base
  
  #---------------------------------
  # [START] SETUP SCRIPT
  #-------------------------------
  #---------------------------------
  # ● MESSAGE SYSTEM
  #-------------------------------
  NMS_FONT_NAME = Font.default_name # Font di default
  NMS_FONT_SIZE = 20 # Grandezza di default del font
  
  # I vari colori usati per scrivere
  # (nell'angolo in basso a destra della windowskin)
  NMS_MAP_NAME_COLOR_ID = 0
  NMS_CLASS_NAME_COLOR_ID = 0
  NMS_ACTOR_NAME_COLOR_ID = 0
  NMS_MONSTER_NAME_COLOR_ID = 0
  NMS_TROOP_NAME_COLOR_ID = 0
  NMS_ITEM_NAME_COLOR_ID = 0
  NMS_WEAPON_NAME_COLOR_ID = 0
  NMS_ARMOR_NAME_COLOR_ID = 0
  NMS_SKILL_NAME_COLOR_ID = 0
  NMS_ITEM_PRICE_COLOR_ID = 0
  
  NMS_DELAY_PER_LETTER = 0 # tempo tra le lettere durante il LETTERAxLETTERA
  # il tempo è in frame
  
  TEXT_X_PLUS = 0 # Muovi Testo orizzontalmente
  CHOICE_INPUT_X_PLUS = 0
  # Muovi il testo di scelta multipla e inserimento dei numeri orizzontalmente
  
  # [NUOVE IMPOSTAZIONI] #
  NMS_MSGWIN_X = 0 # Coordinata X del box message di default
  NMS_MSGWIN_WIDTH = 544 # Lunghezza del box message di default
  NMS_MSGWIN_HEIGHT = 128 # Altezza del box message di default
  
  #---------------------------------
  # ● FACE SYSTEM
  #-------------------------------
  #------------------------------------------------
  # ** IMPOSTAZIONI DI ENTARBI I FACE SYSTEM
  #----------------------------------------------
  DEFAULT_FACE_SIDE = 0 # Lato del face di default quando parte il gioco
  # (0: Lato SINISTRO face normale | -1: Lato DESTRO face normale)
  # (1: Lato SINISTRO neo face | 2: Lato DESTRO neo face)
  
  FACE_X_PLUS = 0 # Move Face Horizontally (Left: -, Right: +)
  FACE_Y_PLUS = 0 # Move Face Vertically (Up: -, Down: +)
  
  MOVE_TEXT = true # (true/false)
  # Muovi il testo a destra del face quando viene mostrato il face a sinistra
  
  #-------------------------------------
  # **IMPOSTAZIONI EFFETTI FACE
  # * Per entrambi i face system
  #----------------------------------
  FADE_EFFECT = false # Imposta on/off l'effetto dissolvenza del face
  FADE_SPEED = 20 # Aumentando il numero aumenta la velocità di dissolvenza
  FADE_ONLY_FIRST = false # Usare la dissolvenza solo per il primo messaggio?
  
  MOVE_EFFECT = false # Imposta on/off l'effetto entrata del face
  MOVE_SPEED = 10 # Aumentando il numero aumenta la velocità di entrata del face
  MOVE_ONLY_FIRST = false # Usare l'entrata solo per il primo messaggio?
  
  FADE_MOVE_WHEN_USE_NEW_FACE = false
  # Usare il face solo quando cambia il face?
  # (In questo caso è usato: DISSOLVENZA_SOLO_PRIMA_VOLTA e ENTRATA_SOLO_PRIMA_VOLTA)
  
  #-------------------------------
  # ** NEO FACE SYSTEM
  #----------------------------
  EightFaces_File = false
  # Usa 8 Face per file (o) 1 Face per file (true/false)
  
  #------------------------------------
  # ● NAME BOX SYSTEM
  #----------------------------------
  NAMEBOX_SKIN = "Window" # Windowskin del box nome (nella cartella 'Graphics/System')
  NAMEBOX_OPACITY = 255 # Opacità del box nome (Minore 0 - 255 Maggiore)
  NAMEBOX_BACK_OPACITY = 180 # Opacità dello sfondo del box nome
  
  NAMEBOX_X_PLUS_NOR = 0 # Coordinata X aggiuntiva al box nome per il normal face
  NAMEBOX_X_PLUS_NEO = 0 # Coordinata Y aggiuntiva al box nome per il neo face
  NAMEBOX_Y_PLUS = 0 # Coordinata Y aggiuntiva al box nome
  
  NAMEBOX_TEXT_LENGTH_PER_LETTER = 10 # Lunghezza del testo per lettera (in pixel)
  NAMEBOX_TEXT_FONT = Font.default_name # Font usato per il box nome
  NAMEBOX_TEXT_SIZE = Font.default_size # grandezza font per il box nome
  NAMEBOX_TEXT_HEIGHT_PLUS = 2 # Aumenta il box in altezza

  NAMEBOX_TEXT_BOLD = true # Crea il testo in Grassetto
  NAMEBOX_TEXT_OUTLINE = false # Grea un bordo nero attorno al nome (Ottimo con opacità = 0)
  NAMEBOX_TEXT_DEFAULT_COLOR = [255,255,255]#[255,255,255] # [Rosso,Verde,Blu]: Colore testo (RGB)
  # Puoi cambiare colore durante il gioco chiamando lo script:
  # $game_message.color = [Rosso,Verde,Blu]
  
  NAMEBOX_TEXT_AFTER_NAME = "" # Aggiungi un testo dopo il nome
  
  NAMEBOX_BOX_WIDTH_PLUS = 6 # Aumenta la lunghezza del box nome
  NAMEBOX_BOX_HEIGHT_PLUS = 7 # Aumenta l'altezza del box nome
  
  MOVE_NAMEBOX = false
  # (true/false) Muovi il box nome se il face è a destra.

  $msg_background = {
    "normal"      => 0,
    "dark"        => 1,
    "transparent" => 2
  }
  $msg_position = {
    "bottom"   => 2,
    "middle"   => 1,
    "top"      => 0
  }

  NO_ITALIC_MAPS = [2,10,30]
  
  #---------------------------------
  # [END] SETUP SCRIPT PART
  #-------------------------------
end
  $worale = {} if $worale == nil
  $worale["NMS"] = true

class Window_Message < Window_Selectable
  #--------------------------------------------------------------------------
  # ● ALIAS
  #--------------------------------------------------------------------------
    alias wor_nms_winmsg_ini initialize
    def initialize
      wor_nms_winmsg_ini
      @nms = $game_message
      self.contents.font.name = @nms.nms_fontname
      self.contents.font.size = @nms.nms_fontsize
      @face = Sprite.new
      @face.z = self.z - 0
      @nametxt = Sprite.new
      @nametxt.z = self.z + 15
      @namebox = nil
      @ori_x = 0
      @name_text = nil
      @showtime = 0 # Verifica se il messaggio è il primo (per il face)
      @face_data_old = Array.new(3)
      
      #NMS 2++
      self.width = @nms.msg_w
      self.height = @nms.msg_h
      self.x = @nms.msg_x
      
      @winwidth = self.width
      @winheight = self.height
      create_contents
    end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    super
    dispose_gold_window
    dispose_number_input_window
    dispose_back_sprite
  end
  #--------------------------------------------------------------------------
  # ● EDITED
  #--------------------------------------------------------------------------
  def update
    super
    update_gold_window
    update_number_input_window
    update_back_sprite
    update_show_fast
    update_window_size
  if self.visible == true
    if @name_text != nil
      draw_name(@name_text,self.x,self.y)
    end
    if @face.bitmap != nil
      # AGGIORNA EFFETTO DISSOLVENZA
      if @face.opacity < 255
        @face.opacity += FADE_SPEED
      end
      # AGGIORNA EFFETTO MOVIMENTO
      if MOVE_EFFECT == true and @ori_x != @face.x
        if (@ori_x > @face.x and @face.x + MOVE_SPEED < @ori_x) or (@ori_x < @face.x and @face.x - MOVE_SPEED > @ori_x)
          @face.x += MOVE_SPEED if @ori_x > @face.x
          @face.x -= MOVE_SPEED if @ori_x < @face.x
        else
          @face.x = @ori_x
        end
      end
    end
  end
    unless @opening or @closing
      if @wait_count > 0
        @wait_count -= 1
      elsif self.pause
        input_pause
      elsif self.active
        input_choice
      elsif @number_input_window.visible
        input_number
      elsif @text != nil
        update_message
      elsif continue?
        @showtime += 1
        start_message
        open
        $game_message.visible = true
      else
        close
        @showtime = 0
        if @face.bitmap != nil
         @face.bitmap.dispose
        end
        clear_namebox if @namebox != nil
        $game_message.visible = @closing
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● NEW
  #--------------------------------------------------------------------------
  def update_window_size
    if self.width != @winwidth or self.height != @winheight
      self.width = @winwidth if @winwidth > 32
      self.height = @winheight if @winwidth > 32
      create_contents
    end
  end
  #--------------------------------------------------------------------------
  # ● 所持金ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_gold_window
    @gold_window = Window_Gold.new(384, 0)
    @gold_window.openness = 0
  end
  #--------------------------------------------------------------------------
  # ● 数値入力ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_number_input_window
    @number_input_window = Window_NumberInput.new
    @number_input_window.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 背景スプライトの作成
  #--------------------------------------------------------------------------
  def create_back_sprite
    @back_sprite = Sprite.new
    @back_sprite.bitmap = Cache.system("MessageBack")
    @back_sprite.visible = (@background == 1)
    @back_sprite.z = 190
  end
  #--------------------------------------------------------------------------
  # ● 所持金ウィンドウの解放
  #--------------------------------------------------------------------------
  def dispose_gold_window
    @gold_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● 数値入力ウィンドウの解放
  #--------------------------------------------------------------------------
  def dispose_number_input_window
    @number_input_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● 背景スプライトの解放
  #--------------------------------------------------------------------------
  def dispose_back_sprite
    @back_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● 所持金ウィンドウの更新
  #--------------------------------------------------------------------------
  def update_gold_window
    @gold_window.update
  end
  #--------------------------------------------------------------------------
  # ● 数値入力ウィンドウの更新
  #--------------------------------------------------------------------------
  def update_number_input_window
    @number_input_window.update
  end
  #--------------------------------------------------------------------------
  # ● 背景スプライトの更新
  #--------------------------------------------------------------------------
  def update_back_sprite
    @back_sprite.visible = (@background == 1)
    @back_sprite.y = y - 16
    @back_sprite.opacity = openness
    @back_sprite.update
  end
  #--------------------------------------------------------------------------
  # ● 早送りフラグの更新
  #--------------------------------------------------------------------------
  def update_show_fast
    if self.pause or self.openness < 255
      @show_fast = false
    elsif Input.trigger?(Input::C) and @wait_count < 2
      @show_fast = true
    elsif not Input.press?(Input::C)
      @show_fast = false
    end
    if @show_fast and @wait_count > 0
      @wait_count -= 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 次のメッセージを続けて表示するべきか判定
  #--------------------------------------------------------------------------
  def continue?
    return true if $game_message.num_input_variable_id > 0
    return false if $game_message.texts.empty?
    if self.openness > 0 and not $game_temp.in_battle
      return false if @background != $game_message.background
      return false if @position != $game_message.position
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● EDITED
  #--------------------------------------------------------------------------
  def start_message
    @text = ""
    for i in 0...$game_message.texts.size
      # Change "    " to "" (Spacing for choice
      @text += "" if i >= $game_message.choice_start
      @text += $game_message.texts[i].clone + "\x00"
    end
    
    @item_max = $game_message.choice_max
    convert_special_characters
    reset_window
    new_page
  end
  #--------------------------------------------------------------------------
  # ● EDITED
  #--------------------------------------------------------------------------
  def new_page
    contents.clear
    if @face.bitmap != nil
    @face.bitmap.dispose
    end
    if $game_message.face_name.empty?
    @contents_x = TEXT_X_PLUS
    else
      name = $game_message.face_name
      index = $game_message.face_index
      # CALL DRAW FACE METHOD
      draw_face2(name, self.x, self.y, index)
      # CHECK FOR MOVE EFFECT
      @ori_x = @face.x
      if MOVE_EFFECT == true and ((MOVE_ONLY_FIRST and @showtime <= 1) or (MOVE_ONLY_FIRST == false))
        if $game_message.side == 0 or $game_message.side == 1
          @face.x = 0 - @face.width
        else
          @face.x = self.x + self.width + @face.width
        end
      end
      @contents_x = get_x_face
    end
    @contents_y = 0
    @line_count = 0
    @show_fast = false
    @line_show_fast = false
    @pause_skip = false
    reset_font_styles
    @contents_x += CHOICE_INPUT_X_PLUS if $game_message.choice_max > 00
  end

  def reset_font_styles
    contents.font.color = text_color(0)
    contents.font.shadow = Font.default_shadow
    contents.font.italic = NO_ITALIC_MAPS.include?($game_map.map_id) ? false : Font.default_italic
    contents.font.bold = Font.default_bold
  end
  #--------------------------------------------------------------------------
  # ● EDITED
  #--------------------------------------------------------------------------
  def new_line
    if $game_message.face_name.empty? or MOVE_TEXT == true
      @contents_x = TEXT_X_PLUS
    else
      @contents_x = get_x_face
    end
    @contents_x += CHOICE_INPUT_X_PLUS if $game_message.choice_max > 0
    # Find Text Height
    nms_line_width = WLH
    nms_line_width = $game_message.nms_fontsize if $game_message.nms_fontsize > WLH
    @contents_y += nms_line_width
    @line_count += 1
    @line_show_fast = false
  end
  #--------------------------------------------------------------------------
  # ● EDITED
  #--------------------------------------------------------------------------
  def convert_special_characters
    clear_namebox if @namebox != nil
    
    #--------------------------
    # DEFAULT FEATURES
    #-----------------------
    @text.gsub!(/\\V\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    @text.gsub!(/\\V\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    @text.gsub!(/\\N\[([0-9]+)\]/i) { $local.get_text($game_actors[$1.to_i].name) }
    # @text.gsub!(/\\N\[([0-9]+)\]/i) { "\x01{#{NMS_ACTOR_NAME_COLOR_ID}}" + $game_actors[$1.to_i].name + "\x01{#{@nms.last_color}}" }
    @text.gsub!(/\\C\[([0-9]+)\]/i) { "\x01{#{$1}}" }
    @text.gsub!(/\\G/i)              { "\x02" }
    @text.gsub!(/\\\./)             { "\x03" }
    @text.gsub!(/\\\|/)             { "\x04" }
    @text.gsub!(/\\!/)              { "\x05" }
    @text.gsub!(/\\>/)              { "\x06" }
    @text.gsub!(/\\</)              { "\x07" }
    @text.gsub!(/\\\^/)             { "\x08" }
    @text.gsub!(/\\\\/)             { "\\" }
    
    #--------------------------
    # * NMS FEATURES!!
    #-----------------------
    # Woratana's :: Draw Weapon Name + Icon
    @text.gsub!(/\\DW\[([0-9]+)\]/i) { "\x83[#{$data_weapons[$1.to_i].icon_index}]\\nw[#{$1.to_i}]"}
    # Woratana's :: Draw Item Name + Icon
    @text.gsub!(/\\DI\[([0-9]+)\]/i) { "\x83[#{$data_items[$1.to_i].icon_index}]\\ni[#{$1.to_i}]" }
    # Woratana's :: Draw Armor Name + Icon
    @text.gsub!(/\\DA\[([0-9]+)\]/i) { "\x83[#{$data_armors[$1.to_i].icon_index}]\\na[#{$1.to_i}]"}
    # Woratana's :: Draw Skill Name + Icon
    @text.gsub!(/\\DS\[([0-9]+)\]/i) { "\x83[#{$data_skills[$1.to_i].icon_index}]\\ns[#{$1.to_i}]"}

    # Woratana's :: Call Animation
    @text.gsub!(/\\ANI\[([0-9]+)\]/i) { "\x80[#{$1}]" }
    # Woratana's :: Call Balloon
    @text.gsub!(/\\BAL\[([0-9]+)\]/i) { "\x81[#{$1}]" }
    # Woratana's :: Call Common Event
    @text.gsub!(/\\CE\[([0-9]+)\]/i) { "\x82[#{$1}]" }
    # Woratana's :: Draw Icon
    @text.gsub!(/\\IC\[([0-9]+)\]/i) { "\x83[#{$1}]" }

    # Woratana's :: Map Name
    @text.gsub!(/\\MAPC/i) { "\x01{#{NMS_MAP_NAME_COLOR_ID}}" + nms_get_map_name + "\x01{#{@nms.last_color}}"}
    # Woratana's :: Actor Class Name
    @text.gsub!(/\\NC\[([0-9]+)\]/i) { "\x01{#{NMS_CLASS_NAME_COLOR_ID}}" + $data_classes[$data_actors[$1.to_i].class_id].name + "\x01{#{@nms.last_color}}" }
    # Woratana's :: Party Actor Name
    @text.gsub!(/\\NP\[([0-9]+)\]/i) { "\x01{#{NMS_ACTOR_NAME_COLOR_ID}}" + $game_party.members[($1.to_i - 1)].name + "\x01{#{@nms.last_color}}" }
    # Woratana's :: Monster Name
    @text.gsub!(/\\NM\[([0-9]+)\]/i) { "\x01{#{NMS_MONSTER_NAME_COLOR_ID}}" + $data_enemies[$1.to_i].name + "\x01{#{@nms.last_color}}" }
    # Woratana's :: Troop Name
    @text.gsub!(/\\NT\[([0-9]+)\]/i) { "\x01{#{NMS_TROOP_NAME_COLOR_ID}}" +  $data_troops[$1.to_i].name + "\x01{#{@nms.last_color}}"  }
    # Woratana's :: Item Name
    @text.gsub!(/\\NI\[([0-9]+)\]/i) { "\x01{#{NMS_ITEM_NAME_COLOR_ID}}" + $data_items[$1.to_i].name + "\x01{#{@nms.last_color}}"}
    # Woratana's :: Weapon Name
    @text.gsub!(/\\NW\[([0-9]+)\]/i) { $data_weapons[$1.to_i].name }
    # Woratana's :: Armor Name
    @text.gsub!(/\\NA\[([0-9]+)\]/i) { "\x01{#{NMS_ARMOR_NAME_COLOR_ID}}" + $data_armors[$1.to_i].name + "\x01{#{@nms.last_color}}" }
    # Woratana's :: Skill Name
    @text.gsub!(/\\NS\[([0-9]+)\]/i) { "\x01{#{NMS_SKILL_NAME_COLOR_ID}}" + $data_skills[$1.to_i].name + "\x01{#{@nms.last_color}}" }
    # Woratana's :: Item Price
    @text.gsub!(/\\PRICE\[([0-9]+)\]/i) { "\x01{#{NMS_ITEM_PRICE_COLOR_ID}}" + $data_items[$1.to_i].price.to_s + "\x01{#{@nms.last_color}}"  }
    
    # Woratana's :: Font Name Change
    @text.gsub!(/\\FN\[(.*?)\]/i) { "\x84[#{$1}]" }
    # Woratana's :: Font Size Change
    @text.gsub!(/\\FS\[(.*?)\]/i) { "\x85[#{$1}]" }
    # Woratana's :: Reset Font Name
    @text.gsub!(/\\REF/i) { "\x86" }
    # Woratana's :: Reset Font Size
    @text.gsub!(/\\RES/i) { "\x87" }
    # Woratana's :: BOLD Text
    @text.gsub!(/\\B/i) { "\x88" }
    # Woratana's :: ITALIC Text
    @text.gsub!(/\\I/i) { "\x89" }
    # Woratana's :: Text DELAY
    @text.gsub!(/\\DELAY\[([0-9]+)\]/i) { "\x90[#{$1}]"}
    # Woratana's :: Reset Text Delay
    @text.gsub!(/\\RED/i) { "\x91" }
    # Woratana's :: Turn On/Off Letter by Letter
    @text.gsub!(/\\LBL/i) { "\x92" }
    
    # Woratana's :: Name Box
     @text.scan(/\\NB\[(.*?)\]/i)
     if $1.to_s != ""
       n_text = $1.to_s.gsub(/\x01\{(.*?)\}/i) {} # Clear If there's Color
       @name_text = n_text.upcase
       @text.sub!(/\\NB\[(.*?)\]/i) {}
     end
  
     # Woratana's :: Repeat Name Box
     @text.gsub!(/\\RNB\[(.*?)\]/i) do
       $game_message._name = $1.to_s
       a = ""
     end
  
     # Woratana's NeoFace System
     @text.scan(/\\SD\[([-,0-9]+)\]/i)
     if $1.to_s != ""
       $game_message.side = $1.to_i
       @text.sub!(/\\SD\[([-,0-9]+)\]/i) {}
     end
    
     # NMS 2++
     # Woratana's :: SHADOW Text
     @text.gsub!(/\\SH/i) { "\x93" }
    
     @name_text = $game_message._name if @name_text == nil and $game_message._name != ""
   end
  #--------------------------------------------------------------------------
  # ● EDIT: NMS 2++
  #--------------------------------------------------------------------------
  def reset_window
    @background = $game_message.background
    @position = $game_message.position
    if @background == 0
      self.opacity = 255
    else
      self.opacity = 0
    end
    case @position
    when 0  # Down
      self.y = 0
      @gold_window.y = 360
    when 1  # Middle
      self.y = 144
      @gold_window.y = 0
    when 2  # Up
      self.y = 288
      @gold_window.y = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● メッセージの終了
  #--------------------------------------------------------------------------
  def terminate_message
    self.active = false
    self.pause = false
    self.index = -1
    @gold_window.close
    @number_input_window.active = false
    @number_input_window.visible = false
    $game_message.main_proc.call if $game_message.main_proc != nil
    $game_message.clear
  end
  #--------------------------------------------------------------------------
  # ● EDITED
  #--------------------------------------------------------------------------
  def update_message
    loop do
      c = @text.slice!(/./m)
      case c
      when nil
        finish_message
        break
      when "\x00"
        new_line
        if @line_count >= MAX_LINE
          unless @text.empty?
            self.pause = true
            break
          end
        end
      when "\x80"
        @text.sub!(/\[([0-9]+)\]/, "")
        $game_map.events[$game_message.event_id].animation_id = $1.to_i
      when "\x81"
        @text.sub!(/\[([0-9]+)\]/, "")
        $game_map.events[$game_message.event_id].balloon_id = $1.to_i
      when "\x82"
        @text.sub!(/\[([0-9]+)\]/, "")
        a = $game_map.interpreter.params[0]
        $game_map.interpreter.params[0] = $1.to_i
        $game_map.interpreter.command_117
        $game_map.interpreter.params[0] = a
      when "\x83"
        @text.sub!(/\[([0-9]+)\]/, "")
        bitmap = Cache.system("Iconset")
        icon_index = $1.to_i
        draw_icon(icon_index, @contents_x, @contents_y,true)
        @contents_x += 24
      when "\x84"
        @text.sub!(/\[(.*?)\]/, "")
        @nms.nms_fontname = $1.to_s
      when "\x85"
        @text.sub!(/\[([0-9]+)\]/, "")
        @nms.nms_fontsize = $1.to_i
      when "\x86"
        @nms.nms_fontname = NMS_FONT_NAME
      when "\x87"
        @nms.nms_fontsize = NMS_FONT_SIZE
      when "\x88"
        contents.font.bold = contents.font.bold == true ? false : true
      when "\x89"
        contents.font.italic = contents.font.italic == true ? false : true
      when "\x90"
        @text.sub!(/\[([0-9]+)\]/, "")
        @nms.text_delay = $1.to_i
      when "\x91"
        @nms.text_delay = NMS_DELAY_PER_LETTER
      when "\x92"
        @nms.lbl = @nms.lbl == true ? false : true
      when "\x93"
        contents.font.shadow = contents.font.shadow == true ? false : true
      when "\x01"
        @text.sub!(/\{([0-9]+)\}/, "")
        @nms.last_color = $1.to_i
        contents.font.color = text_color($1.to_i)
        contents.font.shadow = $1.to_i != 15
        next
      when "\x02"
        @gold_window.refresh
        @gold_window.open
      when "\x03"
        @wait_count = $TEST ? 0 : 15
        break
      when "\x04"
        @wait_count = $TEST ? 0 :  60
        break
      when "\x05"
        self.pause = true
        break
      when "\x06"
        @line_show_fast = true
      when "\x07"
        @line_show_fast = false
      when "\x08"
        @pause_skip = true
      else
        self.contents.font.name = @nms.nms_fontname
        self.contents.font.size = @nms.nms_fontsize
        # Find Text Height
        nms_line_width = WLH
        nms_line_width = $game_message.nms_fontsize if $game_message.nms_fontsize > WLH
        contents.draw_text(@contents_x, @contents_y, 40, nms_line_width, c)
        c_width = contents.text_size(c).width
        @contents_x += c_width
        @show_fast = true if @nms.lbl == false
        if @nms.text_delay > 0
          for i in 0..@nms.text_delay - 1
            Graphics.update
          end
        end
      end
      break unless @show_fast or @line_show_fast
    end
  end
  #--------------------------------------------------------------------------
  # ● メッセージの更新終了
  #--------------------------------------------------------------------------
  def finish_message
    if $game_message.choice_max > 0
      start_choice
    elsif $game_message.num_input_variable_id > 0
      start_number_input
    elsif @pause_skip
      terminate_message
    else
      self.pause = true
    end
    @wait_count = 10
    @text = nil
  end
  #--------------------------------------------------------------------------
  # ● 選択肢の開始
  #--------------------------------------------------------------------------
  def start_choice
    self.active = true
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # ● EDITED
  #--------------------------------------------------------------------------
  def start_number_input
    digits_max = $game_message.num_input_digits_max
    number = $game_variables[$game_message.num_input_variable_id]
    @number_input_window.digits_max = digits_max
    @number_input_window.number = number
    if $game_message.face_name.empty? or MOVE_TEXT == false
      @number_input_window.x = x - 23
    else
      case $game_message.side
      when 0
        @number_input_window.x = (x + 112) - 23
      when 1
        @number_input_window.x = (x + text_x) - 23
      when 2
        @number_input_window.x = x - 23
      when -1
        @number_input_window.x = x - 23
      end
    end
    @number_input_window.x += CHOICE_INPUT_X_PLUS
    @number_input_window.y = y + @contents_y
    @number_input_window.active = true
    @number_input_window.visible = true
    @number_input_window.update
  end
  #--------------------------------------------------------------------------
  # ● EDITED
  #--------------------------------------------------------------------------
  def update_cursor
    if @index >= 0
      if $game_message.face_name.empty?
      x = TEXT_X_PLUS
      else
      x = get_x_face
      end
      y = ($game_message.choice_start + @index) * WLH
      # CHANGE WIDTH OF CURSOR FOR CHOICE SELECT
      if $game_message.face_name.empty? or MOVE_TEXT == false
        facesize = x
      else
        facesize = get_x_face
        facesize += @face.width if $game_message.side == 2
        facesize += @face.width + 16 if $game_message.side == -1
      end
      self.cursor_rect.set(x, y, contents.width - facesize, WLH)
    else
      self.cursor_rect.empty
    end
  end

  #--------------------------------------------------------------------------
  # ● 文章送りの入力処理
  #--------------------------------------------------------------------------
  def input_pause
    if Input.trigger?(Input::B) or Input.trigger?(Input::C)
      self.pause = false
      if @text != nil and not @text.empty?
        new_page if @line_count >= MAX_LINE
      else
        terminate_message
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択肢の入力処理
  #--------------------------------------------------------------------------
  def input_choice
    if Input.trigger?(Input::B)
      if $game_message.choice_cancel_type > 0
        Sound.play_cancel
        $game_message.choice_proc.call($game_message.choice_cancel_type - 1)
        terminate_message
      end
    elsif Input.trigger?(Input::C)
      Sound.play_decision
      $game_message.choice_proc.call(self.index)
      terminate_message
    end
  end
  #--------------------------------------------------------------------------
  # ● 数値入力の処理
  #--------------------------------------------------------------------------
  def input_number
    if Input.trigger?(Input::C)
      Sound.play_decision
      $game_variables[$game_message.num_input_variable_id] =
        @number_input_window.number
      $game_map.need_refresh = true
      terminate_message
    end
  end
end

#==============================================================================
# NMS +[ADD ON]+ WINDOW_MESSAGE_CLASS
#------------------------------------------------------------------------------
#==============================================================================

class Window_Message < Window_Selectable
  
# Return X for Text
def get_x_face
  if MOVE_TEXT == true
    case $game_message.side
    when 0
      return 112 + TEXT_X_PLUS
    when 1
      return text_x
    when 2
      return TEXT_X_PLUS
    else
      return TEXT_X_PLUS
    end
  else
    return TEXT_X_PLUS
  end
end

  def text_x
    return @face.width + TEXT_X_PLUS
  end
  
  # Clear Name Box & Name Text
  def clear_namebox
    @nametxt.bitmap.dispose
    @namebox.dispose
    @namebox = nil
    @name_text = nil
  end
  
  def nms_get_map_name
    mapdata = load_data("Data/MapInfos.rvdata")
    map_id = $game_map.map_id
    return mapdata[map_id].name
  end
  
  #--------------------------------------
  # DRAW FACE [Both Systems] METHOD
  #------------------------------------
  def draw_face2(face_name, x, y, index = 0)
  if $game_message.side == 0 or $game_message.side == -1 or EightFaces_File == true
    # USE 8 FACES PER FILE
    bitmap = Cache.face(face_name)
    rect = Rect.new(0,0,0,0)
    rect.width = (bitmap.width / 4)
    rect.height = (bitmap.height / 2)
    rect.x = index % 4 * rect.width
    rect.y = index / 4 * rect.height
    @face.bitmap = Bitmap.new(rect.width,rect.height)
    @face.bitmap.blt(0,0,bitmap,rect)
    bitmap.dispose
  else
    # USE 1 FACES PER FILE
    @face.bitmap = Cache.face(face_name)
  end
  # SET X/Y OF FACE DEPENDS ON FACE SIDE
  if $game_message.side == 1
    @face.mirror = false
    @face.x = x + 6
    @face.y = y - 120 + height - @face.height
  elsif $game_message.side == 2
    @face.mirror = true
    @face.x = x + ((self.width - 6) - @face.width)
    @face.y = y - 120 + height - @face.height
  elsif $game_message.side == 0
    @face.mirror = false
    @face.x = x + 16
    @face.y = y - 16 + height - @face.height
  elsif $game_message.side == -1
    @face.mirror = true
    @face.x = x + self.contents.width - @face.width + 16
    @face.y = y - 16 + height - @face.height
  end
    @face.x += FACE_X_PLUS
    @face.y += FACE_Y_PLUS
    @face_data = [face_name, index, $game_message.side]
    if @face_data != @face_data_old and FADE_MOVE_WHEN_USE_NEW_FACE; @showtime = 1; @face_data_old = @face_data;
  end
    @face.opacity = 0
    end
  #--------------------------------------
  # DRAW NAME BOX METHOD
  #-----------------------------------
  def draw_name(name,x,y)
    name = name + NAMEBOX_TEXT_AFTER_NAME
    namesize = calculate_name_size(name)
    @nametxt.bitmap = Bitmap.new(16 + (namesize * NAMEBOX_TEXT_LENGTH_PER_LETTER), 24 + NAMEBOX_TEXT_HEIGHT_PLUS)
    @nametxt.x = x + 8
    if $game_message.side == 1 or $game_message.side == 2
      @nametxt.x += NAMEBOX_X_PLUS_NEO
    else
      @nametxt.x += NAMEBOX_X_PLUS_NOR
    end
    @nametxt.y = y - 20 + NAMEBOX_Y_PLUS
    @nametxt.x = 544 - @nametxt.x - @nametxt.width if MOVE_NAMEBOX == true and ($game_message.side == 2 or $game_message.side == -1)
    @namebox = Window.new
    @namebox.windowskin = Cache.system(NAMEBOX_SKIN)
    @namebox.z = self.z + 10
    @namebox.opacity = NAMEBOX_OPACITY
    @namebox.back_opacity = NAMEBOX_BACK_OPACITY
    @namebox.openness = 255
    @namebox.x = @nametxt.x - NAMEBOX_BOX_WIDTH_PLUS
    @namebox.y = @nametxt.y - NAMEBOX_BOX_HEIGHT_PLUS
    @namebox.width = @nametxt.bitmap.width + (NAMEBOX_BOX_WIDTH_PLUS * 2)
    @namebox.height = @nametxt.bitmap.height + (NAMEBOX_BOX_HEIGHT_PLUS * 2)
    @nametxt.bitmap.font.name = NAMEBOX_TEXT_FONT
    @nametxt.bitmap.font.size = NAMEBOX_TEXT_SIZE
    @nametxt.bitmap.font.bold = NAMEBOX_TEXT_BOLD
    if NAMEBOX_TEXT_OUTLINE == true
      # MAKE TEXT OUTLINE
      @nametxt.bitmap.font.color = Color.new(0,0,0)
      @nametxt.bitmap.draw_text(0,2,@nametxt.bitmap.width,@nametxt.bitmap.height,name,1)
      @nametxt.bitmap.draw_text(0,0,@nametxt.bitmap.width,@nametxt.bitmap.height,name,1)
      @nametxt.bitmap.draw_text(2,0,@nametxt.bitmap.width,@nametxt.bitmap.height,name,1)
      @nametxt.bitmap.draw_text(2,2,@nametxt.bitmap.width,@nametxt.bitmap.height,name,1)
    end
    @nametxt.bitmap.font.color = Color.new($game_message.color[0],$game_message.color[1],$game_message.color[2])
    @nametxt.bitmap.draw_text(1,1,@nametxt.bitmap.width,@nametxt.bitmap.height,name,1)
    @name_text = nil
  end
  
  # CALCULATE REAL TEXT LENGTH (for Other Languages, e.g. Japanese)
  def calculate_name_size(name = "")
    name = name.scan(/./)
    return name.size
  end
  
end # CLASS END

#==============================================================================
# NMS +[ADD ON]+ OTHER CLASS
#------------------------------------------------------------------------------
#==============================================================================

# STORE variables here~*
class Game_Message
  attr_accessor :nms_fontname, :nms_fontsize, :event_id, :side, :color, :_name
  attr_accessor :last_color, :text_delay, :lbl, :msg_w, :msg_h, :msg_x
  
  alias wor_nms_old_ini initialize
  def initialize
    # NFS
    @side = Window_Base::DEFAULT_FACE_SIDE
    @_name = ""
    @color = Window_Base::NAMEBOX_TEXT_DEFAULT_COLOR
    # NMS
    @last_color = 0
    @nms_fontname = Window_Base::NMS_FONT_NAME
    @nms_fontsize = Window_Base::NMS_FONT_SIZE
    @event_id = 0
    @text_delay = Window_Base::NMS_DELAY_PER_LETTER
    @lbl = true
    @msg_w = Window_Base::NMS_MSGWIN_WIDTH
    @msg_h = Window_Base::NMS_MSGWIN_HEIGHT
    @msg_x = Window_Base::NMS_MSGWIN_X
    wor_nms_old_ini
  end
end

class Game_Map
  attr_accessor :interpreter
end

class Game_Interpreter
  attr_accessor :params
end

class Game_Interpreter
  def command_101
    unless $game_message.busy
      $game_message.event_id = @event_id
      $game_message.face_name = @params[0]
      $game_message.face_index = @params[1]
      $game_message.background = $msg_params ? $msg_background[$msg_params[0]] : @params[2]
      $game_message.position = $msg_params ? $msg_position[$msg_params[1]] : @params[3]
      @index += 1
      while @list[@index].code == 401
        $game_message.texts.push(@list[@index].parameters[0])
        @index += 1
      end
      if @list[@index].code == 102
        setup_choices(@list[@index].parameters)
      elsif @list[@index].code == 103
        setup_num_input(@list[@index].parameters)
      end
      set_message_waiting
    end
    return false
  end
end
#-----------------------------
# Module Bitmap Addon
#-----------------------------
class Bitmap
  def set_size(w,h)
    @width = w
    @height = h
  end
end