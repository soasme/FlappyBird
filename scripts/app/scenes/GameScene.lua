local Bird = import('..views.bird')
local Pipe = import('..views.pipe')
local PipeKiller = import('..views.PipeKiller')
local State = {
    ready=1,
    flying=2,
    frozen=3,
    dead=4,
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
    if DEBUG ~= 1 then
        self:loadBackground()
    else
        self.worldDebug = self.world:createDebugNode()
        self:addChild(self.worldDebug)
    end

    self.batch = display.newBatchNode(TEXTURES_IMAGE_FILENAME)
    self:addChild(self.batch)

    self:loadResource()
    self:loadGround()

    self:run()

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
            self.onCollisionBetweenBirdAndPipe
        ),
        CollisionType.bird, CollisionType.pipe
    )
    self.world:addCollisionScriptListener(
        handler(
            self,
            self.onCollisionBetweenPipeAndKiller
        ),
        CollisionType.pipe, CollisionType.pipeKiller
    )
    self.world:addCollisionScriptListener(
        handler(
            self,
            self.onCollisionBetweenBirdAndScore
        ),
        CollisionType.bird, CollisionType.score
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
            self.ground:stopAllActions()
        end
    end
    --scheduler:scheduleScriptFunc(onUpdate , 0.01, false)
end

function GameScene:onCollisionBetweenGroundAndBird(eventType, event)
    if eventType == 'begin' then self:onFrozen() end
end

function GameScene:onCollisionBetweenBirdAndPipe(eventType, event)
    if eventType == 'begin' then self:onFrozen() end
end

function GameScene:onCollisionBetweenBirdAndScore(eventType, event)
    if eventType == 'begin' then
        self.world:removeBody(event:getBody2())
        self.score = self.score + 1
        self.label:setString(''..self.score)
    end
end

function GameScene:onCollisionBetweenPipeAndKiller(eventType, event)
    if eventType == 'begin' then
        local pipe = event:getBody1()
        self.world:removeBody(pipe)
        self.batch:removeChild(pipe.downSectionSprite)
        self.batch:removeChild(pipe.upSectionSprite)
    end
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
    self.batch:addChild(self.bird.sprite, ZORDER.bird)
end

function GameScene:createPipeKiller()
    self.killer = PipeKiller.new(self.world)
end

function GameScene:createPipe()
    local pipe = Pipe.new(self.world)
    self.batch:addChild(pipe.upSectionSprite)
    self.batch:addChild(pipe.downSectionSprite)
    return pipe
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

function GameScene:onFrozen()
    self.world:stop()
    self.state = State.frozen
    self.ground:stopAllActions()
    self:onDead()
    self.bird:fall()
end

function GameScene:onDead()
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
