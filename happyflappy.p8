pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _init()
	cls()
	mode="start"
	lives=3
end

function update_game()
	update_cave()
	move_player()
	check_hit()
	--if game_done then over_menu() end
end


function gameover()
	mode ="gameover"	
end	

function update_start()
	if btn(5) then startgame() end
end

function startgame()
	make_player()
	make_cave()
	mode = "game"
end

function update_gameover()
	cls(1)
	if btn(5) then
		startgame()
		lives-=1
	end
end

function _update()
	if mode=="game" then update_game()
	elseif mode == "start" then update_start()
	elseif mode == "gameover" then update_gameover()
	end
	--if go_game == false and game_done == false then show_menu() end
	--if go_game == true and game_done == false then run_game() end
	--if go_game == false and game_done == true and life > 0 then keep_going() end
	--if life == 0 then game_over() end
	--if game_done then over_menu() end
end

function _draw()
	if mode == "game" then draw_game()
	elseif mode == "start" then draw_start()
	elseif mode == "gameover" then draw_gameover()
	end
end

function draw_start()
	cls()
	print("title to happy flappy...", 25, 20, 8)
	print(" press x to continue.", 25, 40, 11)
end

function draw_gameover()
	print(" you died, try again. ")
	print(" press x to continue.")
end


function check_hit()
 for i=player.x,player.x+7 do
 if (cave[i+1].top>player.y
 or cave[i+1].btm<player.y+7) then
 mode="gameover"
 end
 end
end

function run_game()
	update_cave()
	move_player()
	check_hit()
end

function make_cave()
 cave={{["top"]=5,["btm"]=119}}
 top=45 --bottom boundary limit
 btm=85 --ceiling height limit
end

function update_cave()
 --reomves the back of the cave
 if (#cave>player.speed) then
 for i=1,player.speed do
 del(cave,cave[1])
 end
 end

  --creates more cave
 while (#cave<128) do
 local col={}
 local up=flr(rnd(7)-3)
 local dwn=flr(rnd(7)-3)
 col.top=mid(3,cave[#cave].top+up,top)
 col.btm=mid(btm,cave[#cave].btm+dwn,124)
 add(cave,col)
 end
end

function draw_cave()
 top_color=8 --play with these!
 btm_color=8 --choose your own colors!
 for i=1,#cave do
 line(i-1,0,i-1,cave[i].top,top_color)
 line(i-1,127,i-1,cave[i].btm,btm_color)
 end
end

function move_player()
 gravity=0.4 --bigger means more gravity!
 player.dy+=gravity --add gravity
 --jump
 if (btnp(2)) then
 sfx(0)
 player.dy+=5
 end
 --move to new position
 player.y+=player.dy
 --update score
 player.score+=player.speed
end

function draw_game()
	cls(1)
	 draw_cave()
	 draw_player()
	 rectfill(0,0,128,7,0)
	 print("lives: "..lives,1,1,7)
	 print("score: "..player.score,40,1,7)
end	 

function make_player()
 player={}
 player.x=24 --position
 player.y=60
 player.dy=0.25 --fall speed
 player.rise=1 --sprites
 player.fall=2
 player.dead=3
 player.speed=1 --fly speed
 player.score=0
end

function draw_player()
 if (game_done) then
 spr(player.dead,player.x,player.y)
 elseif (player.dy<0) then
 spr(player.rise,player.x,player.y)
 else
 spr(player.fall,player.x,player.y)
 end
end
__gfx__
00000000aa0aa0aaaa0aa0aa0aaaaaa0000000008888888800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aa0aa0aaaa0aa0aaa0aaaa0a0000000080a00a0800000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700aa0aa0aaaa0aa0aaaa0aa0aa000000008a0aa0a800000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000aaaaaaaaaaaaaaaaaaa00aaa0000000080a00a0800000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000a0aaaa0aaaaaaaaaaaa00aaa000000008aaaaaa800000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700a000000aaaa00aaaaa0aa0aa000000008000000800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a008800aaaa00aaaa0aaaa0a0000000080aaaa0800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaaaaaaaaaa0aaaaaa0000000008888888800000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000004550095500d5501a5501f5503d5503f550355503f5501f45024450284502c4502e4500f00016000050000600011000100000f0000e0000d0000d0000c0000c0000e0000000000000000000000000000
