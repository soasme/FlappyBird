local Bird = class('Bird', function()
    local sprite = display.newSprite('#bird1.png')
    return sprite
end)

function Bird:ctor(box)
    self:setScaleX(0.618)
    self:setScaleY(0.618)
    self:flap()
    self:setPosition(display.width / 3, display.height / 2)
    self.box = box
    if box then
        box:setPosition(display.width / 3, display.height / 2)
        box:setCollisionType(1)
        box:bind(self)
    end
end
function Bird:flap()
    self.frames = display.newFrames("bird%d.png", 1, 3, true)
    self.animation = display.newAnimation(self.frames, 0.3 / 3)
    display.setAnimationCache("flap", self.animation)
    self:playAnimationForever(self.animation)
end

function Bird:flyUpAndDown()
    self:runAction(
        CCRepeatForever:create(
            transition.sequence({
                CCMoveBy:create(0.3, ccp(0, 10)),
                CCMoveBy:create(0.2, ccp(0, 0)),
                CCMoveBy:create(0.3, ccp(0, -10)),
                CCMoveBy:create(0.2, ccp(0, 0))
            })
        )
    )
end

function Bird:isOnTheFloor()
    return self:getPositionY() <= 150
end

function Bird:fly()
    local y = self:getPositionY()
    if y > display.height then
        return
    end
    self.box:setVelocity(0, 300)
end

return Bird
