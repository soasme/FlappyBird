local Bird = import('..views.bird')
local Background = import('..views.background')
local State = {
    start=1,
    running=2,
    stop=3
}
local GameScene = class('GameScene', function()
    return display.newScene('GameScene')
end)


function GameScene:ctor()
    self:loadBackground()
    self.state = State.start
    self:loadResource()
    self:run()
end


function GameScene:run()
    if self.state == State.start then
    elseif self.state == State.running then
    elseif self.state == State.stop then
    end
end

function GameScene:loadResource()
end

function GameScene:resetResource()
end

function GameScene:loadBackground()
    local background = Background.new()
    self:addChild(background)
end

function GameScene:loadScore()
end

function GameScene:loadTapTip()
end

function GameScene:loadBird()
end


return GameScene
