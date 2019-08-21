local composer = require( "composer" )

local scene = composer.newScene()

local menuGrupo = display.newGroup()

local titulo
local jogarBotao
local fundo

function scene:create( event )

   local sceneGroup = self.view

   fundo = display.newImage('image/background.png', display.contentCenterX, display.contentCenterY)
   fundo.width = display.contentWidth
   fundo.height = display.contentHeight
   menuGrupo:insert(fundo)

   titulo = display.newImage('image/logo.png', 30, 0, native.systemFontBold, 30)
   titulo.x = display.contentCenterX
   titulo.y = 130
   menuGrupo:insert(titulo)

   jogarBotao = display.newImage("image/playBtn.png")
   jogarBotao.x = display.contentCenterX
   jogarBotao.y = display.contentCenterY
   menuGrupo:insert(jogarBotao)

   function gotoGame()
        composer.gotoScene("scenes.game")
   end
   jogarBotao:addEventListener("tap", gotoGame)

end


-- show()
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
       display.remove(menuGrupo)
   elseif ( phase == "did" ) then
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