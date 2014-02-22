local Bird = class('Bird', function()
    return {}
end)

function Bird:ctor(box)
    self.sprite = display.newSprite('#bird1.png')
    self.sprite:setScaleX(0.618)
    self.sprite:setScaleY(0.618)
    self:flap()
    self.sprite:setPosition(display.width / 3, display.height / 2)
    self.box = box
    if box then
        box:setPosition(display.width / 3, display.height / 2)
        box:setCollisionType(CollisionType.bird)
        box:bind(self.sprite)
    end
end
function Bird:flap()
    self.frames = display.newFrames("bird%d.png", 1, 3, true)
    self.animation = display.newAnimation(self.frames, 0.3 / 3)
    display.setAnimationCache("flap", self.animation)
    self.sprite:playAnimationForever(self.animation)
end

function Bird:flyUpAndDown()
    self.sprite:runAction(
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
    local y = self.sprite:getPositionY()
    if y > display.height then
        return
    end
    self.sprite:runAction(CCRotateTo:create(0, -30))
    self.box:setVelocity(0, 260)
end

function Bird:fall()
    local height = self.sprite:getPositionY() - 140
    local time = height / display.height
    self.sprite:runAction(CCMoveBy:create(time, ccp(0, -height)))
end

return Bird
