%==============%
% Player Class
%==============%
class Player
    import GROUND_HEIGHT, GRAVITY, RUN_SPEED, JUMP_SPEED, PlayRandHitSound, LEFT, RIGHT, MAX_HP
    export posz, posx, posy, HP, UpdateHP, LoadPlayerAssets, InitializePlayer, PhysicsCalc, Punching, Kicking, Jumping, Moving, Standing
    forward procedure Standing

    % Player Attibutes
    var name : string
    var nameLocX, nameLocY : int
    var arial10 : int := Font.New ("Arial:10:bold")
    var stand, jump, punch, kick : array - 1 .. 1 of int
    var walk : array 1 .. 5, -1 .. 1 of int
    var HP : int := MAX_HP
    var HPcolor : int := 47
    var HPlocX, HPlocY : int
    var healthbar : array 0 .. 30 of int
    var healthbarLocX, healthbarLocY : int
    var posx, posy, posz : int
    var velx, vely : int := 0
    var punchcounter, kickcounter : int := 0
    var walkframe : int := 0

    % Updates the player's HP and draws its HP + healthbar to the screen
    procedure UpdateHP (new_HP : int)
	HP := new_HP
	if HP > 60 then
	    HPcolor := 47
	elsif HP <= 60 and HP > 30 then
	    HPcolor := 42
	else
	    HPcolor := 40
	end if
	% Prevents HP from going below 0
	if HP < 0 then
	    HP := 0
	end if

	% Draws HP and healthbar
	Pic.Draw (healthbar (HP div 3), healthbarLocX, healthbarLocY, picMerge)
	Font.Draw (name, nameLocX, nameLocY, arial10, white)
	Font.Draw ("HP: ", HPlocX, HPlocY, arial10, white)
	Font.Draw (intstr (HP), HPlocX + 26, HPlocY, arial10, HPcolor)
	View.UpdateArea (healthbarLocX - 1, healthbarLocY - 1, healthbarLocX + 335, healthbarLocY + 99)
    end UpdateHP

    % Replenishes punch and kick counters
    procedure ReplenishCounters
	if kickcounter < 20 then
	    kickcounter += 1
	end if
	if punchcounter < 10 then
	    punchcounter += 1
	end if
    end ReplenishCounters

    % Loads the player's assets
    procedure LoadPlayerAssets (RESOURCE_stand, RESOURCE_jump, RESOURCE_punch, RESOURCE_kick, RESOURCE_walkArray, RESOURCE_healthbarArray : string)
	stand (RIGHT) := Pic.FileNew (RESOURCE_stand)
	stand (LEFT) := Pic.Mirror (stand (RIGHT))
	jump (RIGHT) := Pic.FileNew (RESOURCE_jump)
	jump (LEFT) := Pic.Mirror (jump (RIGHT))
	punch (RIGHT) := Pic.FileNew (RESOURCE_punch)
	punch (LEFT) := Pic.Mirror (punch (RIGHT))
	kick (RIGHT) := Pic.FileNew (RESOURCE_kick)
	kick (LEFT) := Pic.Mirror (kick (RIGHT))
	for x : 1 .. 5
	    walk (x, RIGHT) := Pic.FileNew (RESOURCE_walkArray + intstr (x) + ".bmp")
	    walk (x, LEFT) := Pic.Mirror (walk (x, RIGHT))
	end for
	for i : 0 .. 30
	    healthbar (i) := Pic.FileNew (RESOURCE_healthbarArray + intstr (i * 3) + ".bmp")
	end for
    end LoadPlayerAssets

    % Initializes all the player's attributes with non-asset data
    procedure InitializePlayer (new_name : string, new_nameLocX, new_nameLocY, new_posx, new_posy, new_posz, new_HPlocX, new_HPlocY, new_healthbarLocX, new_healthbarLocY : int)
	HP := MAX_HP
	name := new_name
	nameLocX := new_nameLocX
	nameLocY := new_nameLocY
	posx := new_posx
	posy := new_posy
	posz := new_posz
	HPlocX := new_HPlocX
	HPlocY := new_HPlocY
	healthbarLocX := new_healthbarLocX
	healthbarLocY := new_healthbarLocY
    end InitializePlayer

    % Change x-velocity, prevent x-position from leaving screen, and animate player while moving in air or on the ground
    procedure Moving (new_posz : int)
	posz := new_posz
	velx := RUN_SPEED * posz
	ReplenishCounters

	if posx < 8 then
	    posx := 8
	elsif posx > 818 then
	    posx := 818
	end if

	if posy = GROUND_HEIGHT then
	    if walkframe < 5 then
		walkframe += 1
	    else
		walkframe := 1
	    end if
	    Pic.Draw (walk (walkframe, posz), posx, posy, picMerge)
	else
	    walkframe := 0
	    Pic.Draw (jump (posz), posx, posy, picMerge)
	end if
    end Moving

    % Changes y-velocity and animates player while leaving the ground
    procedure Jumping
	vely := JUMP_SPEED
	Standing
    end Jumping

    % Animates player while standing
    body procedure Standing
	velx := 0
	walkframe := 0
	ReplenishCounters
	Pic.Draw (stand (posz), posx, posy, picMerge)
    end Standing

    % Animates player while punching and handles punching hitbox
    procedure Punching (otherplayer : pointer to Player)
	if punchcounter = 10 then
	    punchcounter -= 10
	    velx := 0
	    walkframe := 0
	    if (otherplayer -> posy - posy) >= -64 and (otherplayer -> posy - posy) <= 80 then
		if (posz = LEFT and otherplayer -> posz = LEFT and (otherplayer -> posx - posx) <= -28 and (otherplayer -> posx - posx) >= -70)
			or (posz = LEFT and otherplayer -> posz = RIGHT and (otherplayer -> posx - posx) <= -10 and (otherplayer -> posx - posx) >= -50)
			or (posz = RIGHT and otherplayer -> posz = LEFT and (otherplayer -> posx - posx) >= 10 and (otherplayer -> posx - posx) <= 50)
			or (posz = RIGHT and otherplayer -> posz = RIGHT and (otherplayer -> posx - posx) >= 28 and (otherplayer -> posx - posx) <= 70) then
		    otherplayer -> UpdateHP (otherplayer -> HP - 3)
		    PlayRandHitSound
		end if
	    end if
	    if posz = LEFT then
		Pic.Draw (punch (posz), posx - 10, posy, picMerge)
	    end if
	    if posz = RIGHT then
		Pic.Draw (punch (posz), posx, posy, picMerge)
	    end if
	else
	    Standing
	    ReplenishCounters
	end if
    end Punching

    % Animates player while kicking and handles kicking hitbox
    procedure Kicking (otherplayer : pointer to Player)
	if kickcounter = 20 then
	    velx := 0
	    kickcounter -= 20
	    walkframe := 0
	    if (otherplayer -> posy - posy) <= 58 and (otherplayer -> posy - posy) >= -103 then
		if (posz = LEFT and otherplayer -> posz = LEFT and (otherplayer -> posx - posx) <= -70 and (otherplayer -> posx - posx) >= -90)
			or (posz = LEFT and otherplayer -> posz = RIGHT and (otherplayer -> posx - posx) <= -50 and (otherplayer -> posx - posx) >= -70)
			or (posz = RIGHT and otherplayer -> posz = LEFT and (otherplayer -> posx - posx) >= 50 and (otherplayer -> posx - posx) <= 70)
			or (posz = RIGHT and otherplayer -> posz = RIGHT and (otherplayer -> posx - posx) >= 70 and (otherplayer -> posx - posx) <= 90) then
		    otherplayer -> UpdateHP (otherplayer -> HP - 6)
		    PlayRandHitSound
		end if
	    end if
	    if posz = LEFT then
		Pic.Draw (kick (posz), posx - 39, posy, picMerge)
	    end if
	    if posz = RIGHT then
		Pic.Draw (kick (posz), posx + 13, posy, picMerge)
	    end if
	else
	    Standing
	    ReplenishCounters
	end if
    end Kicking

    % Determine posx and posy according to gravity and velx
    procedure PhysicsCalc
	vely -= GRAVITY
	posx += velx
	posy += vely
	if posy < GROUND_HEIGHT then
	    posy := GROUND_HEIGHT
	    vely := 0
	end if
    end PhysicsCalc
end Player
