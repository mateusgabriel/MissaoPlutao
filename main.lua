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
local distanciaAux = 500
local cbt -- recebe o incrementador do combustível
local combustivelTxt
local combustivel = 10000
local pts -- recebe o incrementador do combustível
local pontosTxt
local pontos = 10
local pcp -- receber f decrementador de combustível e pontos
local erg -- recebe a criação de blocos de energia

--Funções
local criaMeteoros = {}
local distanciaUp = {}
local combustivelUp = {}
local pontosUp = {}
local perderCP = {}
local perderCombustivelPontosPorDistancia = {}
local criaEnergia = {}

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
nave.name = 'nave'
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

function criaEnergia(event)
  --local rnd = math.floor(math.random() * 3) + 1
  energia = display.newImage("images/cuboEnergia.png")
  energia.x = _W
  energia.y = math.random(15, _H - 45 )
  energia.name = 'energia'
  physics.addBody( energia, "kinematic" )
  energia.isSensor = true
  --energias:insert(energia)

  transition.to( energia, {time = speed, x = -30, y = energia.y})
end
erg = timer.performWithDelay( 5000, criaEnergia, 0 )

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
mt = timer.performWithDelay( 1800, criaMeteoros, 0 )

-- Adicionando distância
  --function( )
  distanciaTxt = display.newText("Distância 0 km", _W2 - 200, 620, native.systemFontBold, 20)
  --end
  function distanciaUp()
     --incrementando a distancia
      distancia = distancia + 50
      distanciaTxt.text = string.format("Distância %d", distancia)
  end
  dtc = timer.performWithDelay( 1000, distanciaUp, 0 )

-- Adicionando combustível
  --function( )
  combustivelTxt = display.newText("Combustível 0 mil/l", _W2 - (-1), 620, native.systemFontBold, 20)
  --end
  function combustivelUp()
     --incrementando a distancia
      --combustivel = combustivel + 100
      combustivelTxt.text = string.format("Combustível %d", combustivel)
  end
  cbt = timer.performWithDelay( 1000, combustivelUp, 0 )

-- Adicionando pontos
  --function( )
  pontosTxt = display.newText("Pontos 0", _W2 - (-180), 620, native.systemFontBold, 20)
  --end
  function pontosUp()
     --incrementando a distancia
      --pontos = pontos + 100
      pontosTxt.text = string.format("Pontos %d", pontos)
  end
 pts = timer.performWithDelay( 1000, pontosUp, 0 )

-- Adicionando decrementador de combustível e pontos a partir da distância
  function perderCP ()
    combustivel = combustivel - 1000
    pontos = pontos - 2
  end

  function perderCombustivelPontosPorDistancia()
    if (distancia == distanciaAux) then
      perderCP()
      distanciaAux = distanciaAux + 500
    end
  end
  pcp = timer.performWithDelay( 1005, perderCombustivelPontosPorDistancia, 0 )

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
--energia.collision = onLocalCollision
--meteoro1.enterFrame = moveMeteoros

--Evento "enterFrame" ocorre no intervalo FPS(frames per second) da aplicação
Runtime:addEventListener("enterFrame", estrelas1)
Runtime:addEventListener("enterFrame", estrelas2)
nave:addEventListener( "collision")
Runtime:addEventListener("touch", touchScreen)
