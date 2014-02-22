local Pipe = class('Pipe', function()
    return display.newLayer()
end)

VELOCITY = -100

function Pipe:ctor(world)
    self.world = world
    self.downSectionSprite = CCSprite:createWithSpriteFrameName('holdback1.png')
    self.upSectionSprite = CCSprite:createWithSpriteFrameName('holdback2.png')
    local height = 200
    local offset = 75
    local groundHeight = 140
    local random = math.random(300, display.top - 200)
    local width = display.width / 6

    local downSectionHeight = random - offset - groundHeight
    self.downSection = self.world:createBoxBody(1, width, downSectionHeight)
    self.downSectionSprite:setTextureRect(CCRectMake(
        1, 479, 148, downSectionHeight
    ))
    self.downSectionSprite:setScaleX(width / 128)
    self.downSection:bind(self.downSectionSprite)
    self.downSection:setPosition(display.width, groundHeight + 0.5 * downSectionHeight)
    self.downSection:setVelocity(VELOCITY, 0)
    self.downSection:setCollisionType(CollisionType.pipe)


    local upSectionHeight = display.top - random - offset
    self.upSection = self.world:createBoxBody(1, width, upSectionHeight)
    self.upSectionSprite:setTextureRect(CCRectMake(
        150, 459, 148, 830 + (830 - upSectionHeight)
    ))
    self.upSectionSprite:setScaleX(width / 128)
    self.upSection:bind(self.upSectionSprite)
    self.upSection:setPosition(display.width, display.top - 0.5 * upSectionHeight)
    self.upSection:applyForce(0, -GRAVITY, 0, 0)
    self.upSection:setVelocity(VELOCITY, 0)
    self.upSection:setCollisionType(CollisionType.pipe)

    self.scoreSection = self.world:createBoxBody(1, 1, offset * 2)
    self.scoreSection:setElasticity(0)
    self.scoreSection:setCollisionType(CollisionType.score)
    self.scoreSection:setVelocity(VELOCITY, 0)
    self.scoreSection:applyForce(0, -GRAVITY, 0, 0)
    self.scoreSection:setPosition(display.width, random)

end

-- Note: It should set texture rect before binding.

return Pipe
