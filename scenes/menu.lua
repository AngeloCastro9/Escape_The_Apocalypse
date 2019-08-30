local composer = require( "composer" )

composer.recycleOnSceneChange = true

local scene = composer.newScene()

local backGroup = display.newGroup()
local menuGrupo = display.newGroup()

local titulo
local jogarBotao
local fundo
local rankBotao
local meteorite
local menuSound
local clickSound

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

function scene:create( event )

   local sceneGroup = self.view
   audio.reserveChannels( 1 )
   audio.reserveChannels( 2 )

   menuSound = audio.loadSound( "audio/principal.mp3" )
   clickSound = audio.loadSound("audio/Click.wav")

   audio.play( menuSound, { channel=1, loops=-1 })

   fundo = display.newImage('image/background.png', display.contentCenterX, display.contentCenterY)
   fundo.width = display.contentWidth
   fundo.height = display.contentHeight
   backGroup:insert(fundo)

   titulo = display.newImage('image/logo.png')
   titulo.x = display.contentCenterX
   titulo.y = 130
   menuGrupo:insert(titulo)

   rankBotao = display.newImage("image/rankBtn.png")
   rankBotao.x = display.contentCenterX
   rankBotao.y = display.contentCenterY+200
   rankBotao.xScale = 0.2
   rankBotao.yScale = 0.2
   menuGrupo:insert(rankBotao)

   jogarBotao = display.newImage("image/playBtn.png")
   jogarBotao.x = display.contentCenterX
   jogarBotao.y = display.contentCenterY
   jogarBotao.xScale = 0.2
   jogarBotao.yScale = 0.2
   menuGrupo:insert(jogarBotao)

   local meteorites = display.newGroup()
    function movermeteorite()
        for a = 0, meteorites.numChildren, 1 do
            if meteorites[a] ~= nil and meteorites[a].x ~= nil then
                meteorites[a].y = meteorites[a].y + 10
            end            
        end
    end

   function adicionarmeteorite()
      meteorite = display.newSprite( backGroup, sheet_Meteorite, sequences_Meteorite )
      meteorite:setSequence()
      meteorite:play()
      meteorite.x = math.floor(math.random() * (display.contentWidth - meteorite.width) + 100)
      meteorite.y = -meteorite.height
      meteorite.xScale = 0.7
      meteorite.yScale = 0.7
      meteorites:insert(meteorite)
  end
  backGroup:insert(meteorites)
  movermeteoriteLoop = timer.performWithDelay(1, movermeteorite, -1)
  criarmeteoriteLoop = timer.performWithDelay(900, adicionarmeteorite, -1)

   function gotoGame()
      audio.stop( 1 )
      audio.play(clickSound, { channel=2 })
      audio.setVolume( 1.5, { channel=2 } )
      composer.gotoScene("scenes.game")
   end

   function gotoRank()
      audio.play(clickSound, { channel=2, loops=-1 })
      audio.setVolume( 1.5, { channel=2 } )
      composer.gotoScene("scenes.highscores")
   end

   rankBotao:addEventListener("tap", gotoRank)
   jogarBotao:addEventListener("tap", gotoGame)

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