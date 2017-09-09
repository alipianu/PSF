%===========================================================================================================================================%
%------------------------------------------------------- PAINT STREET FIGHTER (v1.1) -------------------------------------------------------%
%===========================================================================================================================================%                                                                             |
% NAME: Alexander Lipianu                                                                                                                   %
% DATE: June 4 2015                                                                                                                         %
% COURSE: TEJ2M                                                                                                                             %
% SCHOOL: Welland Centennial Secondary School                                                                                               %
% TEACHER NAME: Mrs. Duchenne                                                                                                               %
% DESCRIPTION: A 2D two player combat game in which your objective is to knock out your opponent by reducing their health points            %
%              to zero via punching and kicking.                                                                                            %
%===========================================================================================================================================%


%========================%
% GLOBALS and CONSTANTS
%========================%
var win := Window.Open ("graphics:890;500,offscreenonly,nobuttonbar")
var chars : array char of boolean
var mx, my, mb : int
var arial14 : int := Font.New ("Arial:14:bold")
var mapNum : int := 1
var infomenuNum : int := 1
var Pwin : int := 0
var exiting : boolean := false
const GROUND_HEIGHT : int := 40
const GRAVITY : int := 5
const RUN_SPEED : int := 20
const JUMP_SPEED : int := 45
const LEFT : int := -1
const RIGHT : int := 1
const MAX_HP : int := 90
var randInt : int


%====================%
% FORWARD PROCEDURES
%====================%
forward procedure ShowTitlescreen
forward procedure ShowMainMenu
forward procedure ShowQuitMenu
forward procedure ShowControlsMenu
forward procedure ShowCreditsMenu
forward procedure ShowInfoMenu
forward procedure ChooseSoundtrack
forward procedure PlayRandHitSound
forward procedure ResetGame
forward procedure MainGameLoop


%=============%
% GAME ASSETS
%=============%
include "Resources/GameAssets.tu"


%==============%
% Player Class
%==============%
include "Resources/PlayerClass.tu"


%=====================%
% INITIALIZE PLAYERS
%=====================%
var P1 : pointer to Player
new Player, P1
P1 -> LoadPlayerAssets ("Resources/Images/Players/P1/walk/walk1.bmp", "Resources/Images/Players/P1/jump.bmp", "Resources/Images/Players/P1/punch.bmp",
    "Resources/Images/Players/P1/kick.bmp", "Resources/Images/Players/P1/walk/walk", "Resources/Images/Healthbars/P1/HP-")
var P2 : pointer to Player
new Player, P2
P2 -> LoadPlayerAssets ("Resources/Images/Players/P2/walk/walk1.bmp", "Resources/Images/Players/P2/jump.bmp", "Resources/Images/Players/P2/punch.bmp",
    "Resources/Images/Players/P2/kick.bmp", "Resources/Images/Players/P2/walk/walk", "Resources/Images/Healthbars/P2/HP-")
ResetGame


%=============%
% Menu Loops
%=============%

% Titlescreen Loop
body procedure ShowTitlescreen
    loop
	Input.KeyDown (chars)
	Music.PlayFileStop % Stops background audio
	exit when exiting = true % Closes window if exiting

	% Draw titlescreen and flicker "Press ENTER to ocntinue.."
	Pic.Draw (titlescreen, 0, 0, picCopy)
	View.Update
	delay (10)
	Font.Draw ("Press ENTER to continue..", maxx - 550, 80, arial14, white)
	View.Update
	delay (10)
	if chars (KEY_ENTER) then % Go to main menu and play menu music if ENTER is pressed
	    fork menumusic
	    ShowMainMenu
	end if
    end loop

    Window.Close (win)
end ShowTitlescreen

% MainMenu Loop
body procedure ShowMainMenu
    loop
	Mouse.Where (mx, my, mb)
	exit when exiting = true % Goes back to titlescreen if exiting

	% Draws the menu
	Pic.Draw (mainmenu, 0, 0, picCopy)
	Pic.Draw (map_thumbnail (mapNum), 499, 126, picCopy)
	View.Update

	% Changing maps, pressing Quit, pressing Fight, or changing menus
	if mb = 1 then
	    % Changing maps
	    if my >= 88 and my <= 110 then
		if mx >= 494 and mx <= 561 then     % Map 1
		    mapNum := 1
		elsif mx >= 571 and mx <= 639 then     % Map 2
		    mapNum := 2
		elsif mx >= 650 and mx <= 716 then     % Map 3
		    mapNum := 3
		elsif mx >= 728 and mx <= 797 then     % Map 4
		    mapNum := 4
		end if
	    end if
	    % Changing menus
	    if mx >= 660 and mx <= 821 then
		if my >= 437 and my <= 473 then     % "INFO" button
		    ShowInfoMenu
		elsif my >= 329 and my <= 368 then     % "CREDITS" button
		    ShowCreditsMenu
		elsif my >= 385 and my <= 419 then     % "CONTROLS" button
		    ShowControlsMenu
		end if
	    end if
	    % Pressing Quit or Fight
	    if my >= 18 and my <= 55 then
		if mx >= 471 and mx <= 631 then     % "QUIT" button
		    ShowQuitMenu
		elsif mx >= 666 and mx <= 826 then     % "FIGHT" button
		    Music.PlayFileStop
		    ChooseSoundtrack
		    Pic.Draw (map (mapNum), 0, 0, picCopy)
		    View.Update
		    MainGameLoop
		    exit
		end if
	    end if
	end if
    end loop
end ShowMainMenu

% QuitMenu Loop
body procedure ShowQuitMenu
    % Draws the menu
    Pic.Draw (escapemenu (mapNum), 0, 0, picCopy)
    Pic.Draw (yesbutton, 100, 112, picCopy)
    Pic.Draw (nobutton, 481, 112, picCopy)
    View.Update
    loop
	Mouse.Where (mx, my, mb)

	if mb = 1 and my >= 112 and my <= 170 then % Quit?
	    if mx >= 100 and mx <= 377 then % Yes
		exiting := true
		exit
	    elsif mx >= 482 and mx <= 758 then % No
		exit
	    end if
	end if
    end loop
end ShowQuitMenu

% ControlsMenu Loop
body procedure ShowControlsMenu
    % Draws the menu
    Pic.Draw (controlsmenu, 0, 0, picCopy)
    View.Update
    loop
	Mouse.Where (mx, my, mb)

	% Go back to main menu
	if mb = 1 and mx >= 369 and mx <= 530 and my >= 449 and my <= 481 then
	    exit
	end if
    end loop
end ShowControlsMenu

% CreditsMenu Loop
body procedure ShowCreditsMenu
    % Draws the menu
    Pic.Draw (creditsmenu, 0, 0, picCopy)
    View.Update
    loop
	Mouse.Where (mx, my, mb)

	% Go back to main menu
	if mb = 1 and mx >= 369 and mx <= 530 and my >= 449 and my <= 481 then
	    exit
	end if
    end loop
end ShowCreditsMenu

% InfoMenu Loop
body procedure ShowInfoMenu
    Pic.Draw (infomenu (infomenuNum), 0, 0, picCopy)
    View.Update
    loop
	Mouse.Where (mx, my, mb)

	if mb = 1 then
	    % Changing pages
	    if my >= 14 and my <= 41 then
		if mx >= 223 and mx <= 293 then     % Page 1
		    infomenuNum := 1
		elsif mx >= 302 and mx <= 371 then     % Page 2
		    infomenuNum := 2
		elsif mx >= 379 and mx <= 450 then     % Page 3
		    infomenuNum := 3
		elsif mx >= 459 and mx <= 527 then     % Page 4
		    infomenuNum := 4
		elsif mx >= 536 and mx <= 607 then     % Page 5
		    infomenuNum := 5
		elsif mx >= 616 and mx <= 687 then     % Page 6
		    infomenuNum := 6
		end if
	    % Go back to main menu
	    elsif mx >= 369 and mx <= 530 and my >= 449 and my <= 481 then
		infomenuNum := 1 % Reset to page 1
		exit
	    end if

	    % Draws the menu
	    Pic.Draw (infomenu (infomenuNum), 0, 0, picCopy)
	    View.Update
	end if
    end loop
end ShowInfoMenu


%===================%
% Choose Soundtrack
%===================%
body procedure ChooseSoundtrack
    if mapNum = 1 then
	fork level1music
    elsif mapNum = 2 then
	fork level2music
    elsif mapNum = 3 then
	fork level3music
    else
	fork level4music
    end if
end ChooseSoundtrack


%=======================%
% Play Random Hit Sound
%=======================%
body procedure PlayRandHitSound
    randint (randInt, 1, 2)
    if randInt = 1 then
	fork hitsound1
    else
	fork hitsound2
    end if
end PlayRandHitSound


%=========================%
% Reset Players and Menus
%=========================%
body procedure ResetGame
    P1 -> InitializePlayer ("Player 1", 156, 453, 40, GROUND_HEIGHT, RIGHT, 128, 397, 15, 380)
    P2 -> InitializePlayer ("Player 2", 680, 453, 790, GROUND_HEIGHT, LEFT, 720, 397, 540, 380)
    mapNum := 1
    Pwin := 0
end ResetGame


%=================%
% Main Game Loop
%=================%
body procedure MainGameLoop
    loop
	Input.KeyDown (chars)

	% Quit to menu
	if chars (KEY_ESC) then
	    ResetGame
	    exit
	end if

	% Game is over if a player dies
	if P1 -> HP = 0 or P2 -> HP = 0 then
	    if P1 -> HP = 0 and P2 -> HP > 0 then
		Pwin := 2
	    elsif P2 -> HP = 0 and P1 -> HP > 0 then
		Pwin := 1
	    else
		Pwin := 0
	    end if
	    
	    % Ends the game
	    Music.PlayFileStop
	    deathsound
	    delay (1000)
	    Pic.Draw (Pwinscreen (Pwin), 0, 0, picCopy)
	    View.Update
	    Music.PlayFileStop
	    victorysong
	    ResetGame
	    exit
	end if

	% Draw background and healthbars
	Pic.Draw (map (mapNum), 0, 0, picCopy)
	P1 -> UpdateHP (P1 -> HP)
	P2 -> UpdateHP (P2 -> HP)

	% PLAYER 1 CONTROLS
	if chars ('.') then
	    P1 -> Punching (P2)
	elsif chars (',') then
	    P1 -> Kicking (P2)
	elsif chars (KEY_UP_ARROW) and P1 -> posy = GROUND_HEIGHT then
	    P1 -> Jumping
	elsif chars (KEY_LEFT_ARROW) then
	    P1 -> Moving (LEFT)
	elsif chars (KEY_RIGHT_ARROW) then
	    P1 -> Moving (RIGHT)
	else
	    P1 -> Standing
	end if
	% PLAYER 2 CONTROLS
	if chars ('c') then
	    P2 -> Punching (P1)
	elsif chars ('v') then
	    P2 -> Kicking (P1)
	elsif chars ('w') and P2 -> posy = GROUND_HEIGHT then
	    P2 -> Jumping
	elsif chars ('a') then
	    P2 -> Moving (LEFT)
	elsif chars ('d') then
	    P2 -> Moving (RIGHT)
	else
	    P2 -> Standing
	end if

	% Determine posx and posy according to gravity and velx
	P1 -> PhysicsCalc
	P2 -> PhysicsCalc

	% Update area around players
	View.UpdateArea (P1 -> posx - 40, P1 -> posy - 80, P1 -> posx + 105, P1 -> posy + 220)
	View.UpdateArea (P2 -> posx - 40, P2 -> posy - 80, P2 -> posx + 105, P2 -> posy + 220)
	delay (50)
    end loop
end MainGameLoop

%================================================================================================================================================================

%==================%
% GAME STARTS HERE
%==================%
ShowTitlescreen
