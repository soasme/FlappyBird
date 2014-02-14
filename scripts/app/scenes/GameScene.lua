local Bird = import('..views.bird')
local Background = import('..views.background')
local GameScene = class('GameScene', function()
    return display.newScene('GameScene')
end)

function GameScene:ctor()
    self:loadBackground()
end

function GameScene:loadBackground()
    local background = Background.new()
    self:addChild(background)
end

return GameScene
