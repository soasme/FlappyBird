local scheduler = CCDirector:sharedDirector():getScheduler()
local Hose = class('Hose', function(beginOffset)
    node = CCNode:create()
    node.beginOffset = beginOffset
    node.isRemoved = false
    return node
end)

function Hose:ctor()
    self.center = display.height / 2
    self.up = CCSprite:createWithSpriteFrameName('holdback1.png')
    self.down = CCSprite:createWithSpriteFrameName('holdback2.png')
    self.up:setScaleX(0.5)
    self.up:setScaleY(0.6)
    local upHeight = self.up:getContentSize().height
    self.down:setScaleX(0.5)
    self.down:setScaleY(0.6)

    down_height = self.center + math.random(200, 600)
    up_height = down_height - 650
    self.down:setPosition(ccp(display.right + self.beginOffset, down_height))
    self.up:setPosition(ccp(display.right + self.beginOffset, up_height))
end


function Hose:hasPassed()
    return self.up:getPositionX() < 0
end

function Hose:stop()
    if self.up then
        self.up:stopAllActions()
    end
    if self.down then
        self.down:stopAllActions()
    end
end

function Hose:moveToLeft()
    down_height = self.center + math.random(200, 600)
    up_height = down_height - 650
    self:moveSprite(self.up, up_height)
    self:moveSprite(self.down, down_height)
end

function Hose:moveSprite(sprite, height)
    time = 3.9 + self.beginOffset / 200
    sprite:runAction(transition.sequence({
        CCMoveTo:create(time, ccp(-300, sprite:getPositionY())),
        CCCallFuncN:create(function()
            sprite:getParent():removeChild(sprite, true)
            self.isRemoved = true
        end)
    }))
end

return Hose
