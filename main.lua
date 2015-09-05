-----------------------------------------------------------------------------------------
-- Desenvolvedor: Mateus Gabriel
-----------------------------------------------------------------------------------------
--aplicando física
local physics = require("physics")
physics.start()

-- background e scroll das estrelas
local background = display.newImage("ceu.fw.png")
background.x = display.contentWidth /2
background.y = display.contentHeight /2

local estrelas1 = display.newImage("estrelas.png")
estrelas1.x = 0
estrelas1.y = 580
estrelas1.speed = 3

local estrelas2 = display.newImage("estrelas.png")
estrelas2.x = 1940
estrelas2.y = 600
estrelas2.speed = 3

local meteoro = display.newImage("cometaAzul.png")
meteoro.x = 500
meteoro.y = 300

-- Função para scroll infinito das estrelas
function scrollEstrelas(self, event)
  if self.x < -1780 then
    self.x = 2100
  else
    self.x = self.x - self.speed
  end
end

-- Aplica o scroll as estrelas
estrelas1.enterFrame = scrollEstrelas
--Evento "enterFrame" ocorre no intervalo FPS(frames per second) da aplicação
Runtime:addEventListener("enterFrame", estrelas1)

estrelas2.enterFrame = scrollEstrelas
Runtime:addEventListener("enterFrame", estrelas2)

-- Nave
--local nave = display.newImage("nave.png")
--nave.x = 100
--nave.y = 100

local options =
{
  width = 102,
  height = 88,
  numFrames = 5
}

local naveSheet = graphics.newImageSheet("naveSprite.png", options)

local naveSequenceData =
{
  name = "flying",
  start = 1,
  count = 5,
  time = 300,
  loopCount = 0,
  loopDirection = "forward"
}

-- Nave
local nave = display.newSprite(naveSheet, naveSequenceData)

nave.x = 100
nave.y = 100
nave:setSequence("flying")
nave:play()

-- Aplica física ao objeto nave
physics.addBody(nave, "dynamic", {density=.1, bounce=0.1, friction=.2, radius=12})


  -- Aplica força ao clicar na nave
function ativarNave(self, event)
  self:applyForce(0, -1.5, self.x, self.y)
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

-- Adiciona evento de toque na tela
Runtime:addEventListener("touch", touchScreen)
print( display.fps )
