local Bird = class('Bird', function()
    local sprite = display.newSprite('#bird1.png')
    return sprite
end)

function Bird:flap()
    self.frames = display.newFrames("bird%d.png", 1, 3, true)
    self.animation = display.newAnimation(self.frames, 0.5 / 3)
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

function Bird:fly()
    local riseHeight = 60
    local x = self:getPositionX()
    local y = self:getPositionY()
    local time = y / 600

    local raise = CCSpawn:createWithTwoActions(
        CCMoveTo:create(0.2, ccp(x, y + riseHeight)),
        CCRotateTo:create(0, -30)
    )
    local fallen = CCSpawn:createWithTwoActions(
        CCMoveTo:create(time, ccp(x, 50)),
        transition.sequence({
            CCDelayTime:create(time / 6),
            CCRotateTo:create(0, 30)
        })
    )
    self:stopAllActions()
    self:runAction(
        transition.sequence({
            raise,
            CCDelayTime:create(0.1),
            fallen
        })
    )
end

return Bird
