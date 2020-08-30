#Modifiche agli script (Thanks to Holy87)

attr_accessor :move_speed 
#Nella classe Game_Player, ho reso l'attributo move_speed pubblico.

self.screen.pictures[1].erase
$game_player.move_speed = 4
#Nel def setup di Game_Map ho aggiunto il cancella picture (numero 1)
#e il cambio della velocità del player (a 4)