local Bird = class('Bird', function()
    local sprite = display.newSprite('#bird1.png')
    return sprite
end)

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

function Bird:fallen()
    self:runAction(
        CCMoveTo:create(1, ccp(self:getPositionX(), 100))
        --CCSpawn:createWithTwoActions(
            --CCMoveTo:create(1, ccp(self:getPositionX(), 100)),
            --CCRotateTo:create(0.3, 90)
        --)
    )
end

function Bird:fly()
    local riseHeight = 90
    local x = self:getPositionX()
    local y = self:getPositionY()
    local time = y / display.height

    self:stopAllActions()
    self:flap()
    self:runAction(
        transition.sequence({
            CCSpawn:createWithTwoActions(
                CCJumpBy:create(0.7, ccp(0, 0), riseHeight, 1),
                CCRotateTo:create(0, -15)
            ),
            CCSpawn:createWithTwoActions(
                CCMoveTo:create(time, ccp(x, 150)),
                CCRotateTo:create(0.3, 90)
            )
        })
    )
    audio.playEffect(SFX.swoosh)
end

return Bird
