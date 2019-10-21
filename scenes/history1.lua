local composer = require( "composer" )

composer.recycleOnSceneChange = true
local physics = require('physics')
physics.start()
physics.setGravity(0, 0)

local scene = composer.newScene()

local backGroup = display.newGroup()
local frontGrupo = display.newGroup()

local backBtn
local fundo
local menuSound
local clickSound
local voice1
local explosionSound
local meteorite
local meteorFireSound
local explosionMeteor

local sheetOptions_Meteorite =
{
    width = 236,
    height = 398,
    numFrames = 11
}
local sheetOptions_ExplosionMeteor =
{
    width = 200,
    height = 150,
    numFrames = 11
}

local sheet_Meteorite = graphics.newImageSheet( "image/meteorBlue.png", sheetOptions_Meteorite )
local sheet_ExplosionMeteor = graphics.newImageSheet( "image/explosionPixelMed.png", sheetOptions_ExplosionMeteor)

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

local sequences_explosionMeteor = {
    {
        name = "explosionMeteor",
        start = 1,
        count = 11,
        time = 500,
        loopCount = 0,
        loopDirection = "forward"
    },
}


function scene:create( event )

   local sceneGroup = self.view
   audio.reserveChannels( 1 )
   audio.reserveChannels( 2 )
   audio.reserveChannels( 3 )
   audio.reserveChannels( 4 )
   audio.reserveChannels( 5 )

   menuSound = audio.loadSound( "audio/principal.mp3" )
   clickSound = audio.loadSound("audio/Click.wav")
   voice1 = audio.loadSound("audio/voice1.mp3")
   explosionSound = audio.loadSound("audio/Explosion.mp3")
   meteorFireSound = audio.loadSound("audio/meteorFire.mp3")

   audio.play( menuSound, { channel=1, loops=-1 })
   audio.setVolume(0.3, {channel=1})

   audio.play ( voice1, { channel=3})
   audio.setVolume(1.0, {channel=3})

   chaoInvisivel = display.newRect(400, 1550, 768, display.contentHeight )
   physics.addBody(chaoInvisivel, "static", ({density=3.0, friction=1.0, bounce=0, filter =  collisionFilter1}))
   chaoInvisivel.name = "CHAO"
   frontGrupo:insert(chaoInvisivel)   

   fundo = display.newImage('image/backgroundEasy.png', display.contentCenterX, display.contentCenterY)
   fundo.width = display.contentWidth
   fundo.height = display.contentHeight
   backGroup:insert(fundo)

   backBtn = display.newImage("image/backBtn.png")
   backBtn.x = display.contentCenterX
   backBtn.y = display.contentCenterY+290
   backBtn.xScale = 0.6
   backBtn.yScale = 0.6
   frontGrupo:insert(backBtn)

   function gotoMenu()
      audio.play(clickSound, { channel=2 })
      audio.setVolume( 1.0, { channel=2 } )
      composer.gotoScene("scenes.menu")
   end

   backBtn:addEventListener("tap", gotoMenu)
end

function removeexplosionMeteor()
    display.remove(explosionMeteor)
end

local meteorites = display.newGroup()
    function movermeteorite()
        for a = 0, meteorites.numChildren, 1 do
            if meteorites[a] ~= nil and meteorites[a].x ~= nil then
                meteorites[a].y = meteorites[a].y + 10
            end            
        end
    end


function adicionarmeteorite()
    meteorite = display.newSprite( frontGrupo, sheet_Meteorite, sequences_Meteorite )
    meteorite:setSequence()
    meteorite:play()
    audio.play( meteorFireSound, { channel=5, loops=-1 })
    audio.setVolume( 0.5, { channel=5 } )
    meteorite.x = math.floor(math.random() * (display.contentWidth - meteorite.width) + 100)
    meteorite.y = -meteorite.height
    meteorite.xScale = 0.8
    meteorite.yScale = 0.8
    meteorite.name = "meteorite"
    local pentagonShape = { -50, 130, 50,-110, 70,130, 26,50, -50,-80 }
    physics.addBody(meteorite, "dynamic", { density=3.0, friction=0.8, bounce=0.3, shape=pentagonShape } )
    meteorites:insert(meteorite)
    meteorite:addEventListener('collision', meteoriteColisao)    
    --adicionar um contador, quando acertar uma vez, deixar a queda dos meteoros mais rapida
end
frontGrupo:insert(meteorites)
movermeteoriteLoop = timer.performWithDelay(1, movermeteorite, -1)
criarmeteoriteLoop = timer.performWithDelay(10000, adicionarmeteorite, -1)

function meteoriteColisao(event)
    if(event.phase == "began") then
        if(event.other.name == "CHAO")then
            explosionMeteor = display.newSprite( frontGrupo, sheet_ExplosionMeteor, sequences_explosionMeteor )
            explosionMeteor:setSequence()
            explosionMeteor:play()
            audio.play( explosionSound, { channel=4 })
            audio.setVolume( 0.7, { channel=4 } )
            explosionMeteor.x = meteorite.x
            explosionMeteor.y = meteorite.y
            explosionMeteorTimeLoop = timer.performWithDelay(500, removeexplosionMeteor, -1)
            event.target:removeSelf()
        end
    end
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
      
      --if (meteorites ~= nil) then
        --meteorite:removeEventListener('collision', meteoriteColisao) 
      --end
      display.remove(meteorites)
      display.remove(backGroup)
      display.remove(frontGrupo)
      timer.cancel(movermeteoriteLoop)
      timer.cancel(criarmeteoriteLoop) 
      if (explosionPixelTimeLoop ~= nil) then
          timer.cancel(explosionPixelTimeLoop)
      end       
      --if(removeexplosionMeteor ~= nil) then
        --timer.cancel(removeexplosionMeteor)  
      --end   
   elseif ( phase == "did" ) then
        audio.stop( 2 )
        audio.stop( 3 )
        audio.stop( 4 )
        audio.stop( 5 )
        audio.stop( 6 )
        composer.removeScene( "history1" )
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