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
local completaVida
local gameSound
local shootSound
local explosionSound
local chaoInvisivel
local meteorFireSound
local timeMeteor = 900

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

local sheet_Meteorite = graphics.newImageSheet( "image/meteorBlue.png", sheetOptions_Meteorite )
local sheet_ExplosionPixel = graphics.newImageSheet( "image/explosionPixelMed.png", sheetOptions_ExplosionPixel)

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

   audio.reserveChannels( 2 )
   audio.reserveChannels( 3 )
   audio.reserveChannels( 4 )
   audio.reserveChannels( 5 )
   audio.reserveChannels( 6 )

   clickSound = audio.loadSound("audio/Click.wav")
   gameSound = audio.loadSound( "audio/gameMedSound.mp3" )
   shootSound = audio.loadSound("audio/shoot.mp3")
   explosionSound = audio.loadSound("audio/Explosion.mp3")
   meteorFireSound = audio.loadSound("audio/meteorFire.mp3")

    audio.play( gameSound, { channel=4, loops=-1 })
    audio.setVolume( 0.5, { channel=4 } )

   --system.activate( "multitouch" )
   quantidadeVidas = 4
   score = 0
   contadorScore = 0

    chaoInvisivel = display.newRect(400, 1550, 768, display.contentHeight )
    physics.addBody(chaoInvisivel, "static", ({density=3.0, friction=1.0, bounce=0, filter =  collisionFilter1}))
    chaoInvisivel.name = "CHAO"
	principalGrupo:insert(chaoInvisivel)

   fundo = display.newImage('image/backgroundMed.png', display.contentCenterX, display.contentCenterY)
   fundo.width = display.contentWidth
   fundo.height = display.contentHeight
   fundoGrupo:insert(fundo)

   pixel = display.newImage("image/pixel.png")
   pixel.x = display.contentWidth/2
   pixel.y = display.contentHeight - 50
   pixel.xScale = 1.3
   pixel.yScale = 1.4
   pixel.name = "PIXEL"
   principalGrupo:insert(pixel)
   physics.addBody(pixel, "static")

   scoreTexto = display.newText('Score: ', 10, 0, native.systemFontBold, 45)
   scoreTexto.x = display.contentWidth-660
   scoreTexto.y = display.contentHeight-945
   uiGrupo:insert(scoreTexto)

   function criarVidas(quantidadeVidas)
    for i = 1, quantidadeVidas do
        vida = display.newImage('image/heart.png')
        vida.x = (display.contentWidth) - (50 * i+100)
        vida.y = display.contentHeight - 945
        vida.xScale = 1.2
        vida.yScale = 1.2
        vidasGrupo:insert(vida)            
    end
end
   criarVidas(quantidadeVidas)

   quit = display.newImage("image/HomeButton.png")
   quit.x = display.contentWidth -80 
   quit.y = display.contentHeight-945
   principalGrupo:insert(quit)
    function backToMenu()
        adicionarmeteorite()
        audio.play( clickSound, { channel=3 })
        audio.setVolume( 2.0, { channel=3 } )
        composer.setVariable( "finalScore", score )
        composer.gotoScene("scenes.menu")
end
    quit:addEventListener("tap", backToMenu)

    function moverPixel(e)
        
        if(e.phase == 'began') then
            lastX = e.x - pixel.x
        elseif(e.phase == 'moved') then
            local newPosition = e.x - lastX 
            if(newPosition > 65 and newPosition < 700) then
                pixel.x = e.x - lastX
            end
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
        audio.play( shootSound, { channel=5 })
        audio.setVolume( 0.4, { channel=5 } )
        tiro.x = pixel.x
        tiro.y = pixel.y - pixel.height
        tiro.xScale = 4.0
        tiro.yScale = 4.0
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

    function meteoriteColisao(event)
        if(event.phase == "began") then

            if(event.other.name == "PIXEL") then
                explosionPixel = display.newSprite( principalGrupo, sheet_ExplosionPixel, sequences_explosionPixel )
                explosionPixel:setSequence()
                explosionPixel:play()
                audio.play( explosionSound, { channel=6 })
                audio.setVolume( 0.7, { channel=6 } )
                explosionPixel.x = pixel.x
                explosionPixel.y = pixel.y-60
                event.target:removeSelf()
                display.remove(vidasGrupo)   
                contadorScore = 0
                explosionPixelTimeLoop = timer.performWithDelay(500, removeExplosionPixel, -1)         
                quantidadeVidas = quantidadeVidas - 1
                vidasGrupo = display.newGroup()
                criarVidas(quantidadeVidas)
                if quantidadeVidas == 0 then
                    composer.setVariable( "finalScore", score )
                    composer.gotoScene("scenes.gameover")
                else 
                    pixel.alpha = 0
                    timer.performWithDelay( 100, restorePixel )
                end
            elseif(event.other.name == "CHAO")then
                explosionPixel = display.newSprite( principalGrupo, sheet_ExplosionPixel, sequences_explosionPixel )
                explosionPixel:setSequence()
                explosionPixel:play()
                audio.play( explosionSound, { channel=6 })
                audio.setVolume( 0.7, { channel=6 } )
                explosionPixel.x = pixel.x
                explosionPixel.y = pixel.y-60
                event.target:removeSelf()
                display.remove(vidasGrupo)   
                contadorScore = 0
                explosionPixelTimeLoop = timer.performWithDelay(500, removeExplosionPixel, -1)         
                quantidadeVidas = quantidadeVidas - 1
                vidasGrupo = display.newGroup()
                criarVidas(quantidadeVidas)
                if quantidadeVidas == 0 then
                    composer.setVariable( "finalScore", score )
                    composer.gotoScene("scenes.gameover")
                else 
                    pixel.alpha = 0
                    timer.performWithDelay( 100, restorePixel )
                end
            elseif(event.other.name == "TIRO") then
                event.target:removeSelf()
                event.other:removeSelf()
                score = score + 1
                scoreTexto.text = "Score: "..score
                contadorScore = contadorScore+1
            end
            if contadorScore == 15 and quantidadeVidas < 4  then
                contadorScore = 0
                quantidadeVidas = quantidadeVidas + 1
                criarVidas(quantidadeVidas)
            elseif contadorScore == 15 then
                contadorScore = 0
            end
        end
    end

    function vidaColisao(event)
        if(event.phase == "began") then
            if(event.other.name == "PIXEL") then
                if( quantidadeVidas == 3 ) then
                    quantidadeVidas = quantidadeVidas + 1
                    criarVidas(quantidadeVidas)
                elseif ( quantidadeVidas == 2 ) then
                    quantidadeVidas = quantidadeVidas + 2
                    criarVidas(quantidadeVidas)
                elseif(quantidadeVidas == 1) then
                    quantidadeVidas = quantidadeVidas + 3
                    criarVidas(quantidadeVidas)
                end
                event.target:removeSelf()
            elseif ( event.other.name == "TIRO") then
                event.target:removeSelf()
                event.other:removeSelf()
            elseif( event.other.name == "CHAO") then
                event.target:removeSelf()
            end
        end
    end

    local vidas = display.newGroup()
    function moverVidas()
        for a = 0, vidas.numChildren, 1 do
            if vidas[a] ~= nil and vidas[a].x ~= nil then
                vidas[a].y = vidas[a].y + 10
            end            
        end
    end

    function completaVidas()
        completaVida = display.newImage("image/heart.png")
        completaVida.x = math.floor(math.random() * (display.contentWidth - completaVida.width) + 100)
        completaVida.y = -completaVida.height
        completaVida.xScale = 1.6
        completaVida.yScale = 1.6
        completaVida.name = "completaVida"
        physics.addBody(completaVida, "dynamic", { density=3.0, friction=0.8, bounce=0.3, shape=pentagonShape } )
        completaVida:addEventListener('collision', vidaColisao)
        vidas:insert(completaVida)
    end

    principalGrupo:insert(vidas)
    moverVidasLoop = timer.performWithDelay(1, moverVidas, -1)
    completaVidasLoop = timer.performWithDelay(40000, completaVidas, -1)

    function adicionarmeteorite()
        meteorite = display.newSprite( principalGrupo, sheet_Meteorite, sequences_Meteorite )
        meteorite:setSequence()
        meteorite:play()
        audio.play( meteorFireSound, { channel=2, loops=-1 })
        audio.setVolume( 1.0, { channel=2 } )
        meteorite.x = math.floor(math.random() * (display.contentWidth - meteorite.width) + 100)
        meteorite.y = -meteorite.height
        meteorite.xScale = 0.8
        meteorite.yScale = 0.8
        meteorite.name = "meteorite"
        local pentagonShape = { -50, 130, 50,-110, 70,130, 26,50, -50,-80 }
        physics.addBody(meteorite, "dynamic", { density=3.0, friction=0.8, bounce=0.3, shape=pentagonShape } )
        meteorites:insert(meteorite)
        meteorite:addEventListener('collision', meteoriteColisao)    

        if( score > 20 and score < 50 ) then
            timeMeteor = 800
        elseif( score > 50 ) then
            timeMeteor = 700
        end
    end
    principalGrupo:insert(meteorites)
    movermeteoriteLoop = timer.performWithDelay(1, movermeteorite, -1)
    criarmeteoriteLoop = timer.performWithDelay(timeMeteor, adicionarmeteorite, -1)
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
       if (meteorites ~= nil) then
        meteorite:removeEventListener('collision', meteoriteColisao) 
       end
       display.remove(fundoGrupo)
       display.remove(meteorites)       
       display.remove(principalGrupo)
       display.remove(completaVida)
       display.remove(uiGrupo)
       display.remove(vidasGrupo)

       timer.cancel(moverVidasLoop)
       timer.cancel(completaVidasLoop)
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
    audio.stop( 2 )
    audio.stop( 3 )
    audio.stop( 4 )
    audio.stop( 5 )
    audio.stop( 6 )
    composer.removeScene( "game" )
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