local Bird = import('..views.bird')

local GameScene = class('GameScene', function()
    return display.newScene('GameScene')
end)

function GameScene:ctor()
    self:loadBackground()
    self:loadGround()
    self.batch = display.newBatchNode(TEXTURES_IMAGE_FILENAME)
    self:addChild(self.batch)
    self:loadTitle()
    self:loadBird()
end

function GameScene:loadBackground()
    self.bg = display.newSprite(BACKGROUND_FILENAME, display.cx, display.cy)
    self:addChild(self.bg)
end

function GameScene:loadGround()
    self.ground = display.newSprite(GROUND_FILENAME, display.cx, display.bottom)
    self:addChild(self.ground)
    self:moveGround()
end

function GameScene:moveGround()
    self.ground:runAction(
        CCRepeatForever:create(
            transition.sequence({
                CCMoveTo:create(0.5, ccp(display.cx - 60, display.bottom)),
                CCMoveTo:create(0, ccp(display.cx, display.bottom))
            })
        )
    )
end

function GameScene:loadTitle()
    local title = display.newSprite('#flappybird.png')
    title:setPosition(display.width / 2, display.height - display.height / 3)
    local ratio = (display.width * 2 / 3) / title:getContentSize().width
    title:setScaleX(ratio)
    title:setScaleY(ratio)
    self.batch:addChild(title)
end

function GameScene:loadBird()
    self.bird = Bird.new()
    self.bird:setPosition(display.width / 2, display.height / 2)
    self.bird:flap()
    self.batch:addChild(self.bird)
end

return GameScene
