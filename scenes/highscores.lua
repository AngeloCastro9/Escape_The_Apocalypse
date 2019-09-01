
local composer = require( "composer" )

local scene = composer.newScene()

composer.recycleOnSceneChange = true

local menuButton
local clickSound
local meteorite
local contadorChangeMeteorite = 0

local sheetOptions_Meteorite =
{
    width = 236,
    height = 398,
    numFrames = 11
}

local sequences_Meteorite = {
   {
       name = "meteorite",
       start = 1,
       count = 11,
       time = 500,
       loopCount = 0,
       loopDirection = "forward"
   },
}

local sheet_Meteorite = graphics.newImageSheet( "image/meteor.png", sheetOptions_Meteorite )
local sheet_MeteoriteBlue = graphics.newImageSheet( "image/meteorBlue.png", sheetOptions_Meteorite )
local sheet_MeteoriteGreen = graphics.newImageSheet( "image/meteorGreen.png", sheetOptions_Meteorite )

local json = require( "json" )

local scoresTable = {}

local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )


local function loadScores()

	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		scoresTable = json.decode( contents )
	end

	if ( scoresTable == nil or #scoresTable == 0 ) then
		scoresTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	end
end


local function saveScores()

	for i = #scoresTable, 11, -1 do
		table.remove( scoresTable, i )
	end

	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( scoresTable ) )
		io.close( file )
	end
end

function scene:create( event )

	local sceneGroup = self.view
	
	clickSound = audio.loadSound("audio/Click.wav")
	loadScores()
	
    table.insert( scoresTable, composer.getVariable( "finalScore" ) )
	composer.setVariable( "finalScore", 0 )    
	
    local function compare( a, b )
        return a > b
	end
	
    table.sort( scoresTable, compare )

    saveScores()

    local background = display.newImageRect( sceneGroup, "image/backgroundEasy.png", 800, 1400 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

	local highScoresHeader = display.newImage('image/highScore.png')
	highScoresHeader.x = display.contentCenterX
	highScoresHeader.y = 130
	highScoresHeader.xScale = 1.4
	highScoresHeader.yScale = 1.4

	local meteorites = display.newGroup()
    function movermeteorite()
        for a = 0, meteorites.numChildren, 1 do
            if meteorites[a] ~= nil and meteorites[a].x ~= nil then
                meteorites[a].y = meteorites[a].y + 10
            end            
        end
    end

	function adicionarmeteorite()
		if (contadorChangeMeteorite == 0) then
		   meteorite = display.newSprite( sceneGroup, sheet_Meteorite, sequences_Meteorite )
		elseif (contadorChangeMeteorite == 1 and contadorChangeMeteorite < 2) then
		   meteorite = display.newSprite( sceneGroup, sheet_MeteoriteBlue, sequences_Meteorite )
		else  
		   meteorite = display.newSprite( sceneGroup, sheet_MeteoriteGreen, sequences_Meteorite )
		   if (contadorChangeMeteorite == 2) then
			  contadorChangeMeteorite = -1
		   end
		end
		meteorite:setSequence()
		meteorite:play()
		meteorite.x = math.floor(math.random() * (display.contentWidth - meteorite.width) + 100)
		meteorite.y = -meteorite.height
		meteorite.xScale = 0.8
		meteorite.yScale = 0.8
		meteorites:insert(meteorite)
		contadorChangeMeteorite = contadorChangeMeteorite + 1
	end
	sceneGroup:insert(meteorites)
	movermeteoriteLoop = timer.performWithDelay(1, movermeteorite, -1)
	criarmeteoriteLoop = timer.performWithDelay(600, adicionarmeteorite, -1)
	
    for i = 1, 10 do
        if ( scoresTable[i] ) then
            local yPos = 150 + ( i * 56 )

            local rankNum = display.newText( sceneGroup, i .. ")", display.contentCenterX-50, yPos, native.systemFont, 36 )
            rankNum:setFillColor( 0.8 )
            rankNum.anchorX = 1

            local thisScore = display.newText( sceneGroup, scoresTable[i], display.contentCenterX-30, yPos, native.systemFont, 36 )
            thisScore.anchorX = 0
        end
	end

	function gotoMenu()
		audio.play(clickSound, { channel=1, loops=-1 })
		composer.gotoScene( "scenes.menu" )
	end

	menuButton = display.newImage("image/menuBtn.png")
	menuButton.x = display.contentCenterX
	menuButton.y = display.contentCenterY+300
	menuButton.xScale = 0.6
	menuButton.yScale = 0.6
   	menuButton:addEventListener( "tap", gotoMenu )
end


function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
	elseif ( phase == "did" ) then
	end
end


function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		display.remove(meteorites) 
      	timer.cancel(movermeteoriteLoop)
      	timer.cancel(criarmeteoriteLoop) 
		display.remove(menuButton)
	elseif ( phase == "did" ) then
		composer.removeScene( "highscores" )
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
