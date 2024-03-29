#==============================================================================
# Boss HUD
#==============================================================================

# Para criar a barra de HP dos Bosses, ponha no evento inimigo o comentário: Boss

module Enemy_Hud
  #------------------------------------------------------------------------------
  Skip_Check_Maps = [2,10,16,30,101,3,4]
  #------------------------------------------------------------------------------
  Base = "Boss-Base" # Imagem de fundo da barra de HP do boss
  HP_Bar = "Boss-HPBar" # Imagem da barra de HP do boss
  Bar_X = 4 # Posição X da barra de HP
  Bar_Y = 6 # Posição Y da barra de HP
  Face_X = 83
  Face_Y = 353
end

#==============================================================================
# Game Event
#==============================================================================
class Game_Event < Game_Character
  attr_reader :boss
  alias crissaegrim_abs_gameevent_initialize initialize
  alias crissaegrim_abs_gameevent_refresh refresh
  def initialize(map_id, event)
    @boss = false
    crissaegrim_abs_gameevent_initialize(map_id, event)
  end
  def refresh
    crissaegrim_abs_gameevent_refresh
    @boss = false
    @boss = check_com("Boss")
  end
end

#==============================================================================
# Boss Hud
#==============================================================================
class Boss_HUD < Sprite
  def initialize(id)
    @enemy = $game_map.events[id]
    $current_boss = @enemy.enemy_called
    super()
    self.bitmap = Bitmap.new(544,416)
    self.z = 99
  end
  def update
    self.bitmap.clear
    show_bar(Enemy_Hud::Bar_X,Enemy_Hud::Bar_Y,@enemy.enemy_called.hp,@enemy.enemy_called.maxhp)
    if $game_variables[130] > 0
      @enemy.enemy_called.hp = $game_variables[130]
      $game_variables[130] = 0
    end
  end
  def show_bar(x,y,hp,max)
    base = Cache.system(Enemy_Hud::Base)
    bars_x = (544-base.width)/2
    bars_y = (416-base.height)-24
    cw2 = base.width
    ch2 = base.height
    # rect2 = Rect.new(0, 0, cw2, ch2)
    src_rect2 = Rect.new(0, 0, cw2, ch2)
    self.bitmap.blt(bars_x, bars_y, base, src_rect2)
    # self.bitmap.stretch_blt(rect2, base, src_rect2)
    meter = Cache.system(Enemy_Hud::HP_Bar)
    cw1 = meter.width * hp / max
    ch1 = meter.height
    # rect1 = Rect.new(x, y, cw1, ch1)
    src_rect1 = Rect.new(0, 0, cw1, ch1)
    self.bitmap.blt(bars_x + x, bars_y + y, meter, src_rect1)
    # self.bitmap.stretch_blt(rect1, meter, src_rect1)
    # self.x = (544-base.width)/2
    # self.y = (416-base.height)-24

    face = Cache.picture("boss#{$game_variables[101] + 1}")
    cw3 = face.width
    ch3 = face.height
    src_rect3 = Rect.new(0, 0, cw3, ch3)
    self.bitmap.blt(Enemy_Hud::Face_X, Enemy_Hud::Face_Y, face, src_rect3)
  end
end

#==============================================================================
# Scene Map
#==============================================================================
class Scene_Map < Scene_Base
  alias boss_hud_update update
  alias boss_hud_terminate terminate
  alias boss_hud_update_transfer_player update_transfer_player
  def update
    super
    skip = Enemy_Hud::Skip_Check_Maps.include?($game_map.map_id)
    if skip == false
      for event in $game_map.events.values
        if event.boss == true
          @boss_hud = Boss_HUD.new(event.id) if @boss_hud == nil and !event.enemy_called.dead?
          @boss_hud.update if @boss_hud != nil and !event.enemy_called.dead?
          @boss_hud.dispose if @boss_hud != nil and event.enemy_called.dead?
          @boss_hud = nil if @boss_hud != nil and event.enemy_called.dead?
        end
      end
    end
    boss_hud_update
  end
  def terminate
    super
    @boss_hud.dispose if @boss_hud != nil
    @boss_hud = nil
    boss_hud_terminate
  end
  def update_transfer_player
    return unless $game_player.transfer?
    @boss_hud.dispose if @boss_hud != nil
    @boss_hud = nil
    boss_hud_update_transfer_player
  end
end
