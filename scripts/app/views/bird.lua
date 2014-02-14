local Bird = class('Bird', function()
    local sprite = display.newSprite('#bird1.png')
    return sprite
end)

function Bird:flap()
    local frames = display.newFrames("bird%d.png", 1, 3, true)
    local animation = display.newAnimation(frames, 0.3 / 3)
    self:playAnimationForever(animation)
end

function Bird:flyUpAndDown()
    self:runAction(
        CCRepeatForever:create(
            transition.sequence({
                CCMoveBy:create(0.2, ccp(0, 20)),
                CCMoveBy:create(0.1, ccp(0, 0)),
                CCMoveBy:create(0.2, ccp(0, -20)),
                CCMoveBy:create(0.1, ccp(0, 0))
            })
        )
    )
end

return Bird
