local Pipe = class('Pipe', function()
    return display.newLayer()
end)

function Pipe:ctor(world)
    self.world = world
    self:createUpBox()
end

function Pipe:createUpBox()
    local random = math.random(200, 600)
    local width = display.width / 6
    local offset = 100
    local groundHeight = 140
    local upBoxHeight = random - offset - groundHeight
    self.upBox = self.world:createBoxBody(1, width, upBoxHeight)
    self.upBox:setCollisionType(CollisionType.hose)
    self.upBox:setPosition(ccp(display.width, groundHeight + 0.5 * upBoxHeight))
    self.upBox:applyForce(0, 300, 0, 0)
    self.upBox:setVelocity(-30, 0)
end

return Pipe
