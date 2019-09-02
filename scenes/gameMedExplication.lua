local composer = require( "composer" )

composer.recycleOnSceneChange = true

local scene = composer.newScene()

local backGroup = display.newGroup()
local menuGrupo = display.newGroup()

local titulo
local gameMedBtn
local backBtn
local fundo
local menuSound
local clickSound
local explicationText

function scene:create( event )

   local sceneGroup = self.view
   audio.reserveChannels( 1 )
   audio.reserveChannels( 2 )

   menuSound = audio.loadSound( "audio/principal.mp3" )
   clickSound = audio.loadSound("audio/Click.wav")

   audio.play( menuSound, { channel=1, loops=-1 })
   audio.setVolume(0.6, {channel=1})

   fundo = display.newImage('image/backgroundEasy.png', display.contentCenterX, display.contentCenterY)
   fundo.width = display.contentWidth
   fundo.height = display.contentHeight
   backGroup:insert(fundo)

   explicationText = display.newText([[
    Você agora tem uma vida a mais. 
    Os meteoros precisam ser destruídos.
    Ao tocarem o chão você irá perder 
    uma vida.
    Boa sorte!]], 10, 0, native.systemFontBold, 40)
   explicationText.x = display.contentCenterX-10
   explicationText.y = display.contentCenterY
   menuGrupo:insert(explicationText)

   titulo = display.newImage('image/logo.png')
   titulo.x = display.contentCenterX
   titulo.y = 130
   menuGrupo:insert(titulo)

   gameMedBtn = display.newImage("image/medBtn.png")
   gameMedBtn.x = display.contentCenterX
   gameMedBtn.y = display.contentCenterY+200
   gameMedBtn.xScale = 0.6
   gameMedBtn.yScale = 0.6
   menuGrupo:insert(gameMedBtn)

   backBtn = display.newImage("image/backBtn.png")
   backBtn.x = display.contentCenterX
   backBtn.y = display.contentCenterY+290
   backBtn.xScale = 0.6
   backBtn.yScale = 0.6
   menuGrupo:insert(backBtn)

   function gotoMenu()
      audio.play(clickSound, { channel=2 })
      audio.setVolume( 1.0, { channel=2 } )
      composer.gotoScene("scenes.menu")
   end

   function gotoGameMed()
      audio.stop( 1 )
      audio.stop( 3 )
      audio.play(clickSound, { channel=2 })
      audio.setVolume( 1.0, { channel=2 } )
      composer.gotoScene("scenes.gameMed")
   end

   backBtn:addEventListener("tap", gotoMenu)
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
   elseif ( phase == "did" ) then
      audio.stop( 2 )
      composer.removeScene( "gameMedExplication" )
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