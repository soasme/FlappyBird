local Hose = class('Hose', function()
    return CCNode:create()
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
    self.down:setPosition(ccp(display.width / 2, self.center + 300))
    self.up:setPosition(ccp(display.width / 2, self.center - 350))
end


return Hose
