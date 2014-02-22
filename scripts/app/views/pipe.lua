local Pipe = class('Pipe', function()
    return display.newLayer()
end)

VELOCITY = -100

function Pipe:ctor(world)
    self.world = world
    local height = 200
    local offset = 95
    local groundHeight = 140
    local random = math.random(300, display.top - 200)
    local width = display.width / 8

    local downSectionHeight = random - offset - groundHeight
    self.downSection = self.world:createBoxBody(1, width, downSectionHeight)
    self.downSection:setPosition(display.width, groundHeight + 0.5 * downSectionHeight)
    self.downSection:setVelocity(VELOCITY, 0)
    self.downSection:setCollisionType(CollisionType.pipe)

    self.downSectionSprite = display.newSprite('#holdback1.png')
    self.downSectionSprite:setTextureRect(CCRectMake(
        1, 479, 148, downSectionHeight
    ))
    self.downSectionSprite:setScaleX(width / 148)
    self.downSection:bind(self.downSectionSprite)

    local upSectionHeight = display.top - random - offset
    self.upSection = self.world:createBoxBody(1, width, upSectionHeight)
    self.upSection:setPosition(display.width, display.top - 0.5 * upSectionHeight)
    self.upSection:applyForce(0, -GRAVITY, 0, 0)
    self.upSection:setVelocity(VELOCITY, 0)
    self.upSection:setCollisionType(CollisionType.pipe)

    self.upSectionSprite = display.newSprite('#holdback2.png')
    self.upSectionSprite:setTextureRect(CCRectMake(
        150, 459, 148, 830 + (830 - upSectionHeight)
    ))
    self.upSectionSprite:setScaleX(width / 148)
    self.upSection:bind(self.upSectionSprite)
end

return Pipe
