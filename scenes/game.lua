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
local meteorite
local explosionPixel
local explosionMeteorite
local lastXMeteorite

local scoreTexto
local score
local contadorScore
local quit

-- Configure image sheet
local sheetOptions_Meteorite =
{
    width = 236,
    height = 398,
    numFrames = 11
}
local sheetOptions_ExplosionPixel =
{
    width = 200,
    height = 150,
    numFrames = 11
}

local sheet_Meteorite = graphics.newImageSheet( "image/meteor.png", sheetOptions_Meteorite )
local sheet_ExplosionPixel = graphics.newImageSheet( "image/explosionPixel.png", sheetOptions_ExplosionPixel)

-- sequences table
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

local sequences_explosionPixel = {
    {
        name = "explosionPixel",
        start = 1,
        count = 11,
        time = 500,
        loopCount = 0,
        loopDirection = "forward"
    },
}

function scene:create( event )

   local sceneGroup = self.view

   --system.activate( "multitouch" )
   quantidadeVidas = 3
   score = 0
   contadorScore = 0

   fundo = display.newImage('image/background.png', display.contentCenterX, display.contentCenterY)
   fundo.width = display.contentWidth
   fundo.height = display.contentHeight
   fundoGrupo:insert(fundo)

   pixel = display.newImage("image/pixel.png")
   pixel.x = display.contentWidth/2
   pixel.y = display.contentHeight - 50
   pixel.name = "PIXEL"
   principalGrupo:insert(pixel)
   physics.addBody(pixel, "static")

   scoreTexto = display.newText('Score: ', 10, 0, native.systemFontBold, 30)
   scoreTexto.x = 200
   scoreTexto.y = 60
   uiGrupo:insert(scoreTexto)

   function criarVidas(quantidadeVidas)
    for i = 1, quantidadeVidas do
        vida = display.newImage('image/heart.png')
        vida.x = (display.contentWidth) - (50 * i+200)
        vida.y = display.contentHeight - 955
        vidasGrupo:insert(vida)            
    end
end
   criarVidas(quantidadeVidas)

   quit = display.newImage("image/HomeButton.png")
   quit.x = display.contentWidth -180 
   quit.y = display.contentHeight-955
   principalGrupo:insert(quit)
    function backToMenu()
        adicionarmeteorite()
        composer.gotoScene("scenes.menu")
end
    quit:addEventListener("tap", backToMenu)

    function moverPixel(e)
        if(e.phase == 'began') then
            lastX = e.x - pixel.x
        elseif(e.phase == 'moved') then
            pixel.x = e.x - lastX
        end
    end
    fundo:addEventListener('touch', moverPixel)

    local tiros = display.newGroup()
    function moverTiro()
        for a = 0, tiros.numChildren, 1 do
            if tiros[a] ~= nil and tiros[a].x ~= nil then
                tiros[a].y = tiros[a].y - 15
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
                meteorites[a].y = meteorites[a].y + 10
            end            
        end
    end

    local function restorePixel()
 
        pixel.isBodyActive = false
        pixel.x = display.contentCenterX
        pixel.y = display.contentHeight - 50
        -- Fade in the pixel
        transition.to( pixel, { alpha=1, time=4000,
            onComplete = function()
                pixel.isBodyActive = true
            end
        } )
    end

    function removeExplosionPixel()
        display.remove(explosionPixel)
    end

    function removeExplosionMeteorite()
        display.remove(explosionMeteorite)
    end

    function meteoriteColisao(event)
        if(event.phase == "began") then

            if(event.other.name == "PIXEL") then
                explosionPixel = display.newSprite( principalGrupo, sheet_ExplosionPixel, sequences_explosionPixel )
                explosionPixel:setSequence()
                explosionPixel:play()
                explosionPixel.x = pixel.x
                explosionPixel.y = pixel.y-60
                event.target:removeSelf()
                display.remove(vidasGrupo)   
                explosionPixelTimeLoop = timer.performWithDelay(500, removeExplosionPixel, -1)         
                quantidadeVidas = quantidadeVidas - 1
                vidasGrupo = display.newGroup()
                criarVidas(quantidadeVidas)
                if quantidadeVidas == 0 then
                    composer.gotoScene("scenes.gameover")
                else 
                    pixel.alpha = 0
                    timer.performWithDelay( 100, restorePixel )
                end

            elseif(event.other.name == "TIRO") then
                explosionMeteorite = display.newImage('image/explosionMeteorite.png')       
                --explosionMeteorite.x = meteorite.x 
                --explosionMeteorite.y = display.contentCenterY
                event.target:removeSelf()
                event.other:removeSelf()
                score = score + 1
                explosionMeteoriteTimeLoop = timer.performWithDelay(700, removeExplosionMeteorite, -1)
                scoreTexto.text = "Score: "..score
                contadorScore = contadorScore+1
            end
            if contadorScore == 10 and quantidadeVidas < 3  then
                contadorScore = 0
                quantidadeVidas = quantidadeVidas + 1
                criarVidas(quantidadeVidas)
            elseif contadorScore == 10 then
                contadorScore = 0
            end
        end
    end
    function adicionarmeteorite()
        meteorite = display.newSprite( principalGrupo, sheet_Meteorite, sequences_Meteorite )
        meteorite:setSequence()
        meteorite:play()
        meteorite.x = math.floor(math.random() * (display.contentWidth - meteorite.width))
        meteorite.y = -meteorite.height
        meteorite.name = "meteorite"
        physics.addBody(meteorite, "dynamic")
        meteorites:insert(meteorite)
        meteorite:addEventListener('collision', meteoriteColisao)    
    end
    principalGrupo:insert(meteorites)
    movermeteoriteLoop = timer.performWithDelay(1, movermeteorite, -1)
    criarmeteoriteLoop = timer.performWithDelay(900, adicionarmeteorite, -1)
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
       fundo:removeEventListener('touch', moverPixel)
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
       if (explosionPixelTimeLoop ~= nil) then
        timer.cancel(explosionPixelTimeLoop)
       end       
       if(explosionMeteoriteTimeLoop ~= nil) then
        timer.cancel(explosionMeteoriteTimeLoop)  
       end       

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