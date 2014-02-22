local Pipe = class('Pipe', function()
    return display.newLayer()
end)

function Pipe:ctor(world)
    self.world = world
    local height = 200
    self.downSection = self.world:createBoxBody(1, display.width / 8, height)
    self.downSection:setPosition(display.width, height)
    self.downSection:setVelocity(-100, 0)
    self.downSection:setCollisionType(CollisionType.pipe)

    self.upSection = self.world:createBoxBody(1, display.width / 8, height)
    self.upSection:setPosition(display.width, 500)
    self.upSection:applyForce(0, 300, 0, 0)
    self.upSection:setVelocity(-100, 0)
    self.upSection:setCollisionType(CollisionType.pipe)
end


return Pipe
