local composer = require( "composer" )
local scene = composer.newScene()
composer.recycleOnSceneChange = true

local physics = require('physics')
physics.start()
physics.setGravity(0, 0)
--physics.setDrawMode("hybrid")

local fundo
local fundoGrupo = display.newGroup()
local principalGrupo = display.newGroup()
local uiGrupo = display.newGroup()
local vidasGrupo = display.newGroup()
local pixel
local quantidadeVidas
local chefao
local meteorite

local scoreTexto
local score


function scene:create( event )

   local sceneGroup = self.view

   quantidadeVidas = 3
   score = 0

   fundo = display.newImage('image/background.png', display.contentCenterX, display.contentCenterY)
   fundo.width = display.contentWidth
   fundo.height = display.contentHeight
   fundoGrupo:insert(fundo)

   pixel = display.newImage("image/pixel.png")
   pixel.x = display.contentWidth/2
   pixel.y = display.contentHeight - 100
   pixel.name = "PIXEL"
   principalGrupo:insert(pixel)
   physics.addBody(pixel)

   scoreTexto = display.newText('Score: ', 10, 0, native.systemFontBold, 14)
   print(scoreTexto)
   scoreTexto.x = 50
   uiGrupo:insert(scoreTexto)

   function criarVidas(quantidadeVidas)
        for i = 1, quantidadeVidas do
            vida = display.newImage('image/heart.png')
            vida.x = (display.contentWidth - vida.width * 0.7) - (5 * i+1) - vida.width * i + 20
            vida.y = display.contentHeight - vida.height * 0.7
            vidasGrupo:insert(vida)            
        end
   end
   criarVidas(quantidadeVidas)

    function moverpixel(e)
        if(e.phase == 'began') then
            lastX = e.x - pixel.x
        elseif(e.phase == 'moved') then
            pixel.x = e.x - lastX
        end
    end
    fundo:addEventListener('touch', moverpixel)

    local tiros = display.newGroup()
    function moverTiro()
        for a = 0, tiros.numChildren, 1 do
            if tiros[a] ~= nil and tiros[a].x ~= nil then
                tiros[a].y = tiros[a].y - 1 
            end            
        end
    end
    function atirar(e)
        local tiro = display.newImage('image/shoot.png')
        tiro.x = pixel.x
        tiro.y = pixel.y - pixel.height
        tiro.name = 'TIRO'
        physics.addBody(tiro)    
        tiros:insert(tiro)       
    end
    moverTiroLoop = timer.performWithDelay(1, moverTiro, -1)
    principalGrupo:insert(tiros)
    fundo:addEventListener('tap', atirar)

    local meteorites = display.newGroup()
    function movermeteorite()
        for a = 0, meteorites.numChildren, 1 do
            if meteorites[a] ~= nil and meteorites[a].x ~= nil then
                meteorites[a].y = meteorites[a].y + 3
            end            
        end
    end
    function meteoriteColisao(event)
        if(event.phase == "began") then

            if(event.other.name == "PIXEL") then
                event.target:removeSelf()
                display.remove(vidasGrupo)            
                quantidadeVidas = quantidadeVidas - 1
                vidasGrupo = display.newGroup()
                criarVidas(quantidadeVidas)

                if quantidadeVidas == 0 then
                    composer.gotoScene("scenes.gameover")
                end

            elseif(event.other.name == "TIRO") then
                event.target:removeSelf()
                event.other:removeSelf()
                score = score + 1
                scoreTexto.text = "Score: "..score
            end
        end
    end
    function adicionarmeteorite()
        meteorite = display.newImage('image/meteorite.png')
        meteorite.x = math.floor(math.random() * (display.contentWidth - meteorite.width))
        meteorite.y = -meteorite.height
        meteorite.name = "meteorite"
        physics.addBody(meteorite, "static")
        meteorites:insert(meteorite)
        meteorite:addEventListener('collision', meteoriteColisao)        
    end
    principalGrupo:insert(meteorites)
    movermeteoriteLoop = timer.performWithDelay(1, movermeteorite, -1)
    criarmeteoriteLoop = timer.performWithDelay(1000, adicionarmeteorite, -1)

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
       fundo:removeEventListener('touch', moverpixel)
       fundo:removeEventListener('tap', atirar)
       meteorite:removeEventListener('collision', meteoriteColisao) 

       display.remove(fundoGrupo)
       display.remove(meteorites)       
       display.remove(principalGrupo)
       display.remove(uiGrupo)
       display.remove(vidasGrupo)

       timer.cancel(moverTiroLoop)
       timer.cancel(movermeteoriteLoop)
       timer.cancel(criarmeteoriteLoop)                 

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