
local GameScene = class('GameScene', function()
    return display.newScene('GameScene')
end)

function GameScene:ctor()
    self:loadBackground()
    self:loadGround()
end

function GameScene:loadBackground()
    self.bg = display.newSprite(BACKGROUND_FILENAME, display.cx, display.cy)
    self:addChild(self.bg)
end

function GameScene:loadGround()
    self.ground = display.newSprite(GROUND_FILENAME, display.cx, display.bottom)
    self:addChild(self.ground)
end

return GameScene
