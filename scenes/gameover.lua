local composer = require( "composer" )

local scene = composer.newScene()

local gameoverGrupo = display.newGroup()

function scene:create( event )

   local sceneGroup = self.view

   fimDeJogoTexto = display.newText('FIM DE JOGO', 10, 0, native.systemFontBold, 20)
   fimDeJogoTexto.x = display.contentCenterX
   fimDeJogoTexto.y = 100
   gameoverGrupo:insert(fimDeJogoTexto)

   botaoVoltar = display.newImage("image/backBtn.png")
   botaoVoltar.x = display.contentCenterX
   botaoVoltar.y = display.contentCenterY
   gameoverGrupo:insert(botaoVoltar)

   function gotoMenu()
    composer.gotoScene("scenes.menu")
   end
   botaoVoltar:addEventListener("tap", gotoMenu)

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
    display.remove(gameoverGrupo)

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