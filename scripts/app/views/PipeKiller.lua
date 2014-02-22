local PipeKiller = class('PipeKiller', function()
    return display.newLayer()
end)

function PipeKiller:ctor(world)
    self.world = world
    self:createBox()
end

function PipeKiller:createBox()
    local box = self.world:createBoxBody(0, 1, display.height)
    box:setCollisionType(CollisionType.pipeKiller)
    box:setPosition(ccp(display.left - display.width / 6, display.height / 2))
    return box
end

return PipeKiller
