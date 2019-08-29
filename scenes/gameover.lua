local composer = require( "composer" )

local scene = composer.newScene()

local gameoverGrupo = display.newGroup()

function scene:create( event )

   local sceneGroup = self.view

   fimDeJogoTexto = display.newImage('image/endGame.png')
   fimDeJogoTexto.x = display.contentCenterX
   fimDeJogoTexto.y = 130
   gameoverGrupo:insert(fimDeJogoTexto)

   skull = display.newImage('image/skull.png')
   skull.x = display.contentCenterX
   skull.y = 300
   gameoverGrupo:insert(skull)

   botaoVoltar = display.newImage("image/backBtn.png")
   botaoVoltar.x = display.contentCenterX
   botaoVoltar.y = display.contentCenterY
   botaoVoltar.xScale = 0.2
   botaoVoltar.yScale = 0.2
   gameoverGrupo:insert(botaoVoltar)

   function gotoMenu()
    composer.gotoScene("scenes.menu", { time=800, effect="crossFade" })
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