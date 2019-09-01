local composer = require( "composer" )

composer.recycleOnSceneChange = true

local scene = composer.newScene()

local backGroup = display.newGroup()
local menuGrupo = display.newGroup()

local titulo
local gameEasyBtn
local gameMedBtn
local fundo
local rankBotao
local meteorite
local menuSound
local clickSound
local meteorFireSound
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

function scene:create( event )

   local sceneGroup = self.view
   audio.reserveChannels( 1 )
   audio.reserveChannels( 2 )
   audio.reserveChannels( 3 )

   menuSound = audio.loadSound( "audio/principal.mp3" )
   clickSound = audio.loadSound("audio/Click.wav")
   meteorFireSound = audio.loadSound("audio/meteorFire.mp3")

   audio.play( menuSound, { channel=1, loops=-1 })
   audio.setVolume(0.6, {channel=1})

   fundo = display.newImage('image/backgroundEasy.png', display.contentCenterX, display.contentCenterY)
   fundo.width = display.contentWidth
   fundo.height = display.contentHeight
   backGroup:insert(fundo)

   titulo = display.newImage('image/logo.png')
   titulo.x = display.contentCenterX
   titulo.y = 130
   menuGrupo:insert(titulo)

   rankBotao = display.newImage("image/rankBtn.png")
   rankBotao.x = display.contentCenterX
   rankBotao.y = display.contentCenterY+350
   rankBotao.xScale = 0.2
   rankBotao.yScale = 0.2
   menuGrupo:insert(rankBotao)

   gameEasyBtn = display.newImage("image/easyBtn.png")
   gameEasyBtn.x = display.contentCenterX
   gameEasyBtn.y = display.contentCenterY
   gameEasyBtn.xScale = 0.2
   gameEasyBtn.yScale = 0.2
   menuGrupo:insert(gameEasyBtn)

   gameMedBtn = display.newImage("image/medBtn.png")
   gameMedBtn.x = display.contentCenterX
   gameMedBtn.y = display.contentCenterY+100
   gameMedBtn.xScale = 0.2
   gameMedBtn.yScale = 0.2
   menuGrupo:insert(gameMedBtn)

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
         meteorite = display.newSprite( backGroup, sheet_Meteorite, sequences_Meteorite )
      elseif (contadorChangeMeteorite == 1 and contadorChangeMeteorite < 2) then
         meteorite = display.newSprite( backGroup, sheet_MeteoriteBlue, sequences_Meteorite )
      else  
         meteorite = display.newSprite( backGroup, sheet_MeteoriteGreen, sequences_Meteorite )
         if (contadorChangeMeteorite == 2) then
            contadorChangeMeteorite = -1
         end
      end
      meteorite:setSequence()
      meteorite:play()
      audio.play( meteorFireSound, { channel=3, loops=-1 })
      audio.setVolume( 1.0, { channel=3 } )
      meteorite.x = math.floor(math.random() * (display.contentWidth - meteorite.width) + 100)
      meteorite.y = -meteorite.height
      meteorite.xScale = 0.8
      meteorite.yScale = 0.8
      meteorites:insert(meteorite)
      contadorChangeMeteorite = contadorChangeMeteorite + 1
  end
  backGroup:insert(meteorites)
  movermeteoriteLoop = timer.performWithDelay(1, movermeteorite, -1)
  criarmeteoriteLoop = timer.performWithDelay(600, adicionarmeteorite, -1)

   function gotoGameEasy()
      audio.stop( 1 )
      audio.play(clickSound, { channel=2 })
      audio.setVolume( 2.0, { channel=2 } )
      composer.gotoScene("scenes.gameEasy")
   end

   function gotoGameMed()
      audio.stop( 1 )
      audio.play(clickSound, { channel=2 })
      audio.setVolume( 2.0, { channel=2 } )
      composer.gotoScene("scenes.gameMed")
   end

   function gotoRank()
      audio.play(clickSound, { channel=2, loops=-1 })
      audio.setVolume( 2.0, { channel=2 } )
      composer.gotoScene("scenes.highscores")
   end

   rankBotao:addEventListener("tap", gotoRank)
   gameEasyBtn:addEventListener("tap", gotoGameEasy)
   gameMedBtn:addEventListener("tap", gotoGameMed)

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
      display.remove(backGroup)
      display.remove(menuGrupo)
      display.remove(meteorites) 
      timer.cancel(movermeteoriteLoop)
      timer.cancel(criarmeteoriteLoop) 
   elseif ( phase == "did" ) then
      audio.stop( 2 )
      audio.stop( 3 )
      composer.removeScene( "menu" )
   end
end

function scene:destroy( event )
   local sceneGroup = self.view
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene