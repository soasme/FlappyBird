local scheduler = CCDirector:sharedDirector():getScheduler()
local Hose = class('Hose', function(beginOffset)
    node = CCNode:create()
    node.beginOffset = beginOffset
    node.isRemoved = false
    return node
end)

function Hose:ctor(world)
    self.world = world
    self.center = display.height / 2
    self.up = CCSprite:createWithSpriteFrameName('holdback1.png')
    self.down = CCSprite:createWithSpriteFrameName('holdback2.png')
    local ratio = display.width / (6.0 * self.up:getContentSize().width )
    self.up:setScaleX(ratio)
    self.up:setScaleY(ratio)
    self.down:setScaleX(ratio)
    self.down:setScaleY(ratio)

    local random = math.random(200, 600)
    local width = display.width / 6
    local offset = 100
    local groundHeight = 140
    local upBoxHeight = random - offset - groundHeight
    local downBoxHeight = display.height - random - offset
    self.upBox = world:createBoxBody(1, width, upBoxHeight)
    self.upBox:setCollisionType(CollisionType.hose)
    self.upBox:setPosition(ccp(display.width, groundHeight + 0.5 * upBoxHeight))
    self.upBox:applyForce(-20, 300, 0, 0)
    self.downBox = world:createBoxBody(1, width, downBoxHeight)
    self.downBox:setCollisionType(CollisionType.hose)
    self.downBox:setPosition(ccp(display.width, downBoxHeight * 0.5 + offset + random))
    self.downBox:applyForce(-20, 300, 0, 0)
    self.up:setTextureRect(CCRectMake(1, 459, 148, upBoxHeight / ratio + 40))
    self.down:setTextureRect(CCRectMake(150, 459 + (790 - downBoxHeight) * ratio, 148, downBoxHeight / ratio))
    self.upBox:bind(self.up)
    self.downBox:bind(self.down)
end

function Hose:resetPosition()
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
