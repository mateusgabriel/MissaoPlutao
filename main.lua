--Aplicando física
local physics = require("physics")
physics.start()

--Variaveis/Grupos
local meteoros = display.newGroup()
local speed = 5500
local mt -- recebe a criação de meteoros
local dtc -- recebe o incrementador da distância
local distanciaTxt
local distancia = 0

--Funções
local criaMeteoros = {}
local distanciaUp = {}

--Variaveis Dimensoes
_W = display.contentWidth
_H = display.contentHeight
_W2 = display.contentCenterX
_H2 = display.contentCenterY

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
meteorito.y = -110

local meteoritoTeto = display.newImage("images/metero.png")
meteoritoTeto.x = 400
meteoritoTeto.y = -110
physics.addBody(meteoritoTeto, "static")

local chao = display.newImage("images/chao.png")
chao.x = 400
chao.y = 672
physics.addBody(chao, "static")

-- Nave
local nave = display.newImage("images/nave.png")
nave.x = 100
nave.y = 200
physics.addBody(nave, "dynamic")

-- Função para scroll infinito das estrelas
function scrollEstrelas(self, event)
  if self.x < -1780 then
    self.x = 2100
  else
    self.x = self.x - self.speed
  end
end

local function onLocalCollision( self, event )
	if ( event.phase == "began" ) then
		self:removeSelf()
	end
end

function criaMeteoros(event)
  meteoro = display.newImage("images/cometaAzul.png")
  meteoro.x = _W + 150
  meteoro.y = math.random(15, _H - 45 )
  meteoro.name = 'meteoroAzul'
  physics.addBody(meteoro, "kinematic")
  meteoro.isSensor = true
  --meteoros:insert(meteoro)

  transition.to( meteoro, {time = speed, x = -150, y = meteoro.y})
end
tm = timer.performWithDelay( 1800, criaMeteoros, 0 )

-- Adicionando distância
--function setupScore( )
distanciaTxt = display.newText("Distância 0 km", _W2 - 50, 620, native.systemFontBold, 20)
--end

function distanciaUp()
   --incrementando a distancia
    distancia = distancia + 100
    distanciaTxt.text = string.format("Distância %d", distancia)
end

dtc = timer.performWithDelay( 1000, distanciaUp, 0 )

-- Adicionando combustível
--function setupScore( )
combustivelTxt = display.newText("Combustível 0 mil/l", _W2 - 50, 620, native.systemFontBold, 20)
--end

function combustivelUp()
   --incrementando a distancia
    combustivel = combustivel + 100
    combustivelTxt.text = string.format("Combustivel %d", combustivel)
end

cbt = timer.performWithDelay( 1000, combustivelUp, 0 )

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

-- Atrela funções à eventos
estrelas1.enterFrame = scrollEstrelas
estrelas2.enterFrame = scrollEstrelas
nave.collision = onLocalCollision
--meteoro1.enterFrame = moveMeteoros

--Evento "enterFrame" ocorre no intervalo FPS(frames per second) da aplicação
Runtime:addEventListener("enterFrame", estrelas1)
Runtime:addEventListener("enterFrame", estrelas2)
nave:addEventListener( "collision")
Runtime:addEventListener("touch", touchScreen)
