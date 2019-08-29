local composer = require( "composer" )

local scene = composer.newScene()

local menuGrupo = display.newGroup()

local titulo
local jogarBotao
local fundo
local rankBotao

function scene:create( event )

   local sceneGroup = self.view

   fundo = display.newImage('image/background.png', display.contentCenterX, display.contentCenterY)
   fundo.width = display.contentWidth
   fundo.height = display.contentHeight
   menuGrupo:insert(fundo)

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

   function gotoGame()
        composer.gotoScene("scenes.game")
   end

   function gotoRank()
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
       display.remove(menuGrupo)
   elseif ( phase == "did" ) then
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