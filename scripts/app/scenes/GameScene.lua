local Bird = import('..views.bird')
local Hose = import('..views.hose')
local Pipe = import('..views.pipe')
local PipeKiller = import('..views.PipeKiller')
local State = {
    ready=1,
    flying=2,
    dead=3
}
local scheduler = CCDirector:sharedDirector():getScheduler()
local GameScene = class('GameScene', function()
    return display.newScene('GameScene')
end)


function GameScene:ctor()
    self.score = 0
    self.state = State.ready
    self.hoses = {}
    self.world = CCPhysicsWorld:create(0, GRAVITY)
    self:addChild(self.world)
    self.worldDebug = self.world:createDebugNode()
    self:addChild(self.worldDebug)
    if DEBUG ~= 1 then
        self:loadBackground()
    end

    self.batch = display.newBatchNode(TEXTURES_IMAGE_FILENAME)
    self:addChild(self.batch)

    self:loadResource()
    self:loadGround()

    self:run()

    --self:createHose()
    self:createPipeKiller()

end


function GameScene:run()
    self.world:addCollisionScriptListener(
        handler(
            self,
            self.onCollisionBetweenGroundAndBird
        ),
        CollisionType.bird, CollisionType.ground
    )
    self.world:addCollisionScriptListener(
        handler(
            self,
            self.onCollisionBetweenBirdAndHose
        ),
        CollisionType.bird, CollisionType.hose
    )
    self.world:addCollisionScriptListener(
        handler(
            self,
            self.onCollisionBetweenPipeAndKiller
        ),
        CollisionType.pipe, CollisionType.pipeKiller
    )
    scheduler:scheduleScriptFunc(function()
        if self.state == State.flying then
            self:createPipe()
        end
    end, 1.4, false)

    begin = 0

    local onUpdate = function(dt)
        if self.state == State.flying then
            local score = #self.hoses - 1
            if score < 0 then
                score = 0
            end

            if score > self.score then
                audio.playEffect(SFX.point)
            end
            self.score = score
            self.label:setString(''..self.score)

            isOnTheFloor = self.bird:isOnTheFloor()
            isCollideWithHose = self:collideWithHose()
            if isOnTheFloor then
                audio.playEffect(SFX.hit)
            end
            if isCollideWithHose then
                audio.playEffect(SFX.hit)
                audio.playEffect(SFX.die)
            end
            if isOnTheFloor or isCollideWithHose then
                begin = 0
                self:onDead()
                self.ground:stopAllActions()
                for _, hose in ipairs(self.hoses) do
                    if not hose.isRemoved then
                        hose:stop()
                    end
                end
                self:runAction(transition.sequence({
                    CCMoveBy:create(0.01, ccp(0, 2)),
                    CCMoveBy:create(0.01, ccp(2, 2)),
                    CCMoveBy:create(0.01, ccp(2, 0)),
                    CCMoveBy:create(0.01, ccp(0, 0)),
                }))
            end
        end
    end
    --scheduler:scheduleScriptFunc(onUpdate , 0.01, false)
end

function GameScene:onCollisionBetweenGroundAndBird(eventType, event)
    if eventType == 'begin' then self:onDead() end
end

function GameScene:onCollisionBetweenBirdAndHose(eventType, event)
    if eventType == 'begin' then self:onDead() end
end

function GameScene:onCollisionBetweenPipeAndKiller(eventType, event)
    if eventType == 'begin' then
        local pipe = event:getBody1()
        self.world:removeBody(pipe)
    end
end

function GameScene:collideWithHose()
    local birdBox = self.bird:getBoundingBox()
    local score = self.score
    local hose = self.hoses[self.score]
    if not hose then
        return false
    end
    return hose.up:getBoundingBox():intersectsRect(birdBox) or hose.down:getBoundingBox():intersectsRect(birdBox)
end

function GameScene:loadResource()
    self:loadScore()
    self:loadReady()
    self:loadTapTip()
    self:loadBird()

    self.layerTouch = display.newLayer()
    self.layerTouch:addTouchEventListener(function(event, x, y)
        return self:onTap(event, x, y)
    end, true)
    self.layerTouch:setTouchEnabled(true)
    self:addChild(self.layerTouch)
end

function GameScene:resetResource()
end

function GameScene:loadBackground()
    self.bg = display.newSprite(BACKGROUND_FILENAME, display.cx, display.cy)
    self:addChild(self.bg)
end

function GameScene:loadGround()
    self.ground = display.newSprite(GROUND_FILENAME, display.cx, display.bottom)
    local size = self.ground:getContentSize()
    self.groundBox = self.world:createBoxBody(0, display.width, size.height)
    self.groundBox:setPosition(ccp(display.cx, 0))
    --self.groundBox:applyForce(0, 300, 0, 0)
    self.groundBox:setCollisionType(2)
    self.groundBox:setElasticity(0)
    self:addChild(self.ground, ZORDER.ground)
    self:moveGround()
end

function GameScene:moveGround()
    self.ground:runAction(
        CCRepeatForever:create(
            transition.sequence({
                CCMoveTo:create(0.3, ccp(display.cx - 60, display.bottom)),
                CCMoveTo:create(0, ccp(display.cx, display.bottom))
            })
        )
    )
end



function GameScene:loadScore()
    self.label = ui.newTTFLabel({
        text=''..self.score,
        color=display.COLOR_WHITE
    })
    self.label:setPosition(ccp(display.width / 2, display.height * 3 / 4))
    self.label:setScaleX(1.5)
    self.label:setScaleY(1.5)
    self:addChild(self.label)
end

function GameScene:loadReady()
    self.getReady = display.newSprite('#getready.png')
    self.getReady:setPosition(display.width / 2, display.height * 2 / 3)
    local ratio = (display.width * 2 / 3) / self.getReady:getContentSize().width
    self.getReady:setScaleX(ratio)
    self.getReady:setScaleY(ratio)
    self.batch:addChild(self.getReady)
end

function GameScene:loadTapTip()
    self.tapTip = display.newSprite('#click.png')
    self.tapTip:setPosition(display.width / 2, display.height / 2)
    self.tapTip:setScaleX(0.5)
    self.tapTip:setScaleY(0.5)
    self.batch:addChild(self.tapTip)
end

function GameScene:loadBird()
    self.birdBox = self.world:createCircleBody(1, 20)
    self.birdBox:setElasticity(0)
    self.birdBox:setPosition(display.width / 3, display.height / 2)
    self.bird = Bird.new(self.birdBox)
    self.batch:addChild(self.bird, ZORDER.bird)
end

function GameScene:createPipeKiller()
    self.killer = PipeKiller.new(self.world)
end

function GameScene:createPipe()
    local pipe = Pipe.new(self.world)
    return pipe
end

function GameScene:createHose()
    local hose = Hose.new(self.world)
    self.batch:addChild(hose.up, ZORDER.hose)
    self.batch:addChild(hose.down, ZORDER.hose)
    self.hoses[#self.hoses + 1] = hose
    return hose
end

function GameScene:countScore()
end

function GameScene:loadNextLoopButton()
    -- TODO refactor this button. It's the same as MenuScene
    local button = display.newSprite('#start.png')
    button:setPosition(display.width - 3 * display.width / 4, 170)
    button:setScaleX(0.5)
    button:setScaleY(0.5)
    self.batch:addChild(button, ZORDER.button)
    button:setTouchEnabled(true)
    button:addTouchEventListener(function(event, x, y)
        app:enterGameScene()
    end)
end

function GameScene:loadGradeButton()
    -- TODO refactor this button. It's the same as MenuScene
    local button = display.newSprite('#grade.png')
    button:setPosition(display.width - 1 * display.width / 4, 170)
    button:setScaleX(0.5)
    button:setScaleY(0.5)
    self.batch:addChild(button, ZORDER.button)
end

function GameScene:loadGameOver()
    -- TODO load game over png
    local gameover = display.newSprite('#gameover.png',
        display.width / 2,
        display.height * 2 /3
    )
    local ratio = (display.width * 2 / 3) / gameover:getContentSize().width
    gameover:setScaleX(ratio)
    gameover:setScaleY(ratio)
    self.batch:addChild(gameover, ZORDER.gameover)
    gameover:runAction(transition.newEasing(CCFadeIn:create(0.3), 'BOUNCEIN'))
end

function GameScene:onDead()
    self.world:stop()
    self.state = State.dead
    self:loadGameOver()
    self:loadNextLoopButton()
    self:loadGradeButton()
end

function GameScene:onEnter()
end

function GameScene:removeReadyChildren()
    self.batch:removeChild(self.tapTip)
    self.batch:removeChild(self.getReady)
end

function GameScene:onTap(event, x, y)
    if event == 'began' then
        if self.state == State.ready then
            self:removeReadyChildren()
            self.state = State.flying
            self.world:start()
            self.bird:fly()
        elseif self.state == State.flying then
            self.bird:fly()
        end
    end
end

return GameScene
