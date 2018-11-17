pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _init()
	cls()
	mode="start"
	lives=3
	sf = {} --table for starfield
	sf.max_speed=2 --speed of the stars
	sf.density=0.5 --higher number makes more stars on screen
	t=0
end

function update_game()
	update_c()
	sf_update()
	move_p()
	check_hit()
end

function gameover()
	mode ="gameover"	
end	

function update_start()
	if btn(5) then startgame() lives=3 end
end

function startgame()
	make_p()
	make_c()
	mode = "game"
end

function update_gameover()
	cls(1)
	if btn(5) then
		startgame()
		lives-=1
	elseif
	lives==0 then mode = "start"
	end
end

function _update()
	if mode=="game" then update_game()
	elseif mode == "start" then update_start()
	elseif mode == "gameover" then update_gameover()
	end
end

function _draw()
	if mode == "game" then draw_game() for star in all(sf.stars) do
		pset(star.x,star.y,12)
		for i=1,star.speed do
			pset(star.x+i,star.y,1)
		end
	end
	elseif mode == "start" then draw_start()
	elseif mode == "gameover" then cls() draw_gameover()
	end
end

function draw_start()
	cls()
	print("Welcome to happy flappy...", 22, 20, 8)
	print(" press x to start game.", 20, 80, 11)
	print(" press arrow key up to ", 20, 40, 13)
	print(" control character.", 25, 60, 13)
end

function draw_gameover()
	print(" you died, try again. ", 20, 40, 11)
	print(" Score: ", 20, 60, 11) print(p.score, 60, 60, 11)
	print(" press x to continue.", 20, 80, 11)
end

function check_hit() --checks for collisions
 for i=p.x,p.x+7 do
 if (c[i+1].top>p.y
 or c[i+1].btm<p.y+7) then
 mode="gameover"
 end
 end
end

function run_game()
	update_c() --erases the part of cave that player has passed
	move_p() --moves the player
	check_hit() --checks for collisions
end

function make_c()
 c={{["top"]=5,["btm"]=119}}
 top=45 --bottom boundary limit
 btm=85 --ceiling height limit
end

function update_c()
 if (#c>p.speed) then --removes the back of the cave
 for i=1,p.speed do
 del(c,c[1])
 end
 end

 --creates more cave
 while (#c<128) do
 local col={}
 local up=flr(rnd(7)-3)
 local dwn=flr(rnd(7)-3)
 col.top=mid(3,c[#c].top+up,top)
 col.btm=mid(btm,c[#c].btm+dwn,124)
 add(c,col)
 end
end

function draw_c()
 top_color=8 --top cave color
 btm_color=8 --bottom cave color
 for i=1,#c do --iterate through and precedurally generate cave
 line(i-1,0,i-1,c[i].top,top_color)
 line(i-1,127,i-1,c[i].btm,btm_color)
 end
end

function move_p()
 gravity=0.25 --larger number means more gravity
 p.dy+=gravity --add gravity
 if (btnp(2)) then --jump action
 sfx(0) -- play sound
 p.dy-=5 --player movement
 t=t+1
 camera(cos(t/3), cos(t/2)) --shake and bake the screen
 end
 p.y+=p.dy --move to new position
 p.score+=p.speed --update score
end

function draw_game()
	cls(1)
	 draw_c() --draws cave
	 draw_p() --draws player
	 rectfill(0,0,128,7,0) --draws Life and Score box
	 print("lives: "..lives,1,1,7)
	 print("score: "..p.score,40,1,7)
end	 

function make_p()
 p={}
 p.x=24 --x position
 p.y=60 --y position
 p.dy=0.25 --fall speed
 p.rise=1 --sprite 1
 p.fall=2 --sprite 2
 p.dead=3 --sprite 3
 p.speed=1 --fly speed
 p.score=0
end

function draw_p()
 if (game_done) then
 spr(p.dead,p.x,p.y) --draws player dead
 elseif (p.dy<0) then
 spr(p.rise,p.x,p.y) --draws player moving up
 else
 spr(p.fall,p.x,p.y) --draws player moving down
 end
 
function sf_init()
	sf = {}
	sf.stars={}
	sf.max_speed=10
	sf.density=3
end

function sf_update()
	if rnd(100)<50 then
		for i=0,rnd(sf.density)+1 do
			sf_add_star()
		end
	end
	
	for star in all(sf.stars) do
		star.x-=star.speed
		if star.x<0 then
			del(sf.stars,star)
		end
	end
end

function sf_draw()
	for star in all(sf.stars) do
		pset(star.x,star.y,12)
		for i=1,star.speed do
			pset(star.x+i,star.y,1)
		end
	end
end

function sf_add_star()
	star={}
	star.x=127
	star.y=rnd(127)
	star.speed=rnd(sf.max_speed)+1
	add(sf.stars,star)
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
