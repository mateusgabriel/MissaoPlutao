-----------------------------------------------------------------------------------------
-- Desenvolvedor: Mateus Gabriel
-----------------------------------------------------------------------------------------
--aplicando física
local physics = require("physics")
physics.start()

local meteoros = display.newGroup()

-- background e scroll das estrelas
local background = display.newImage("images/ceu.fw.png")
background.x = display.contentWidth /2
background.y = display.contentHeight /2

local estrelas1 = display.newImage("images/estrelas.png")
estrelas1.x = 0
estrelas1.y = 600
estrelas1.speed = 3

local estrelas2 = display.newImage("images/estrelas.png")
estrelas2.x = 1940
estrelas2.y = 600
estrelas2.speed = 3

local meteorito = display.newImage("images/metero.png")
meteorito.x = 0
meteorito.y = -100

-- Função para scroll infinito das estrelas
function scrollEstrelas(self, event)
  if self.x < -1780 then
    self.x = 2100
  else
    self.x = self.x - self.speed
  end
end

function moveMeteoros(self, event)
  if self.x < -120 then
    self.x = 1200
    self.y = math.random( 400 )
  else
    self.x = self.x - self.speed
  end
end

function novoMeteoro()
  meteoro1 = display.newImage("images/cometaAzul.png")
  meteoro1.x = 1200
  meteoro1.y = 200 + math.random( 200 )
  meteoro1.speed = 6
  --meteoro1.initY = meteoro1.y
  --meteoro1.amp = math.random(20, 250)
  --meteoro1.angle = math.random(1, 360)
  physics.addBody(meteoro1, "static", {density=.1, bounce=0.1, friction=.2})
  --physics.addBody(meteoro2, "static", {density=.1, bounce=0.1, friction=.2})
  --meteoros:insert(metero1)
  meteoro1.enterFrame = moveMeteoros
  Runtime:addEventListener("enterFrame", meteoro1)
  --meteoro2.enterFrame = moveMeteoros
  --Runtime:addEventListener("enterFrame", meteoro1)
end

timer.performWithDelay( 380, novoMeteoro)

-- Nave
nave = display.newImage("images/nave.png")
nave.x = 100
nave.y = 100

physics.addBody(nave, "dynamic")
-- Nave Sprite
--local options = { width = 88.5, height = 56, numFrames = 2}
--local naveSheet = graphics.newImageSheet("images/naveSprite.png", options)
--local naveSequenceData = {
--  {name = "fly", start = 1, count = 4, time = 300, loopCount = 0}
--}
-- Nave
--local nave = display.newSprite(naveSheet, naveSequenceData)
--nave.x = 100
--nave.y = 100
--nave.name = 'nave'
--physics.addBody(nave, "static")
--nave:play()

  -- Aplica força ao clicar na nave
function ativarNave(self, event)
  self:applyForce(0, -2, self.x, self.y)
end

function touchScreen(event)
  -- Ao clicar na tela é aplicada força na nave
  if event.phase == "began" then
    --print("Clicou!")
    nave.enterFrame = ativarNave
    Runtime:addEventListener("enterFrame", nave)
  end

  --No fim do clique a força aplicada a nave é removida
  if event.phase == "ended" then
    Runtime:removeEventListener("enterFrame", nave)
  end
end

-- Aplica o scroll as estrelas
estrelas1.enterFrame = scrollEstrelas
--Evento "enterFrame" ocorre no intervalo FPS(frames per second) da aplicação
Runtime:addEventListener("enterFrame", estrelas1)

estrelas2.enterFrame = scrollEstrelas
Runtime:addEventListener("enterFrame", estrelas2)

-- Adiciona evento de toque na tela
Runtime:addEventListener("touch", touchScreen)
