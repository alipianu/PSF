%=============%
% GAME ASSETS
%=============%
% Load Image Assets
var titlescreen : int := Pic.FileNew ("Resources/Images/Menus/Titlescreen/titlescreen.bmp")
var mainmenu : int := Pic.FileNew ("Resources/Images/Menus/MainMenu/mainmenu.bmp")
var controlsmenu : int := Pic.FileNew ("Resources/Images/Menus/ControlsMenu/controls.bmp")
var creditsmenu : int := Pic.FileNew ("Resources/Images/Menus/CreditsMenu/credits.bmp")
var yesbutton : int := Pic.FileNew ("Resources/Images/Misc/yes.bmp")
var nobutton : int := Pic.FileNew ("Resources/Images/Misc/no.bmp")
var map : array 1 .. 4 of int
var map_thumbnail : array 1 .. 4 of int
var escapemenu : array 1 .. 4 of int
var infomenu : array 1 .. 6 of int
var Pwinscreen : array 0 .. 2 of int
for i : 1 .. 4
    map (i) := Pic.FileNew ("Resources/Images/Maps/map/map" + intstr (i) + ".bmp")
    map_thumbnail (i) := Pic.FileNew ("Resources/Images/Maps/map_thumbnail/map" + intstr (i) + "_thumbnail.bmp")
    escapemenu (i) := Pic.FileNew ("Resources/Images/Menus/EscapeMenu/escape" + intstr (i) + ".bmp")
end for
for i : 1 .. 6
    infomenu (i) := Pic.FileNew ("Resources/Images/Menus/InfoMenu/info" + intstr (i) + ".bmp")
end for
for i : 0 .. 2
    Pwinscreen (i) := Pic.FileNew ("Resources/Images/Misc/winscreenP" + intstr (i) + ".bmp")
end for

% Load Audio Assets
process menumusic
    Music.PlayFileLoop ("Resources/Audio/Soundtracks/menumusic.MP3")
end menumusic
process level1music
    Music.PlayFileLoop ("Resources/Audio/Soundtracks/level1music.MP3")
end level1music
process level2music
    Music.PlayFileLoop ("Resources/Audio/Soundtracks/level2music.MP3")
end level2music
process level3music
    Music.PlayFileLoop ("Resources/Audio/Soundtracks/level3music.MP3")
end level3music
process level4music
    Music.PlayFileLoop ("Resources/Audio/Soundtracks/level4music.MP3")
end level4music
process hitsound1
    Music.PlayFile ("Resources/Audio/SoundEffects/punchsound1.WAV")
end hitsound1
process hitsound2
    Music.PlayFile ("Resources/Audio/SoundEffects/punchsound2.WAV")
end hitsound2
procedure deathsound
    Music.PlayFile ("Resources/Audio/SoundEffects/death.MP3")
end deathsound
procedure victorysong
    Music.PlayFile ("Resources/Audio/Soundtracks/victory.MP3")
end victorysong
