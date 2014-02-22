local Pipe = class('Pipe', function()
    return display.newLayer()
end)

VELOCITY = -100

function Pipe:ctor(world)
    self.world = world
    local height = 200
    local offset = 100
    local groundHeight = 150
    local random = math.random(300, display.top - 200)

    local downSectionHeight = random - offset - groundHeight
    self.downSection = self.world:createBoxBody(1, display.width / 8, downSectionHeight)
    self.downSection:setPosition(display.width, groundHeight + 0.5 * downSectionHeight)
    self.downSection:setVelocity(VELOCITY, 0)
    self.downSection:setCollisionType(CollisionType.pipe)

    local upSectionHeight = display.top - random - offset
    self.upSection = self.world:createBoxBody(1, display.width / 8, upSectionHeight)
    self.upSection:setPosition(display.width, display.top - 0.5 * upSectionHeight)
    self.upSection:applyForce(0, 300, 0, 0)
    self.upSection:setVelocity(VELOCITY, 0)
    self.upSection:setCollisionType(CollisionType.pipe)
end


return Pipe
