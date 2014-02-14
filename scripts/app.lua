-- frame
require('framework.init')
require('framework.shortcodes')
require('framework.cc.init')

-- app
require('config')

local app = class('app', cc.mvc.AppBase)

function app:ctor()
    app.super.ctor(self)
    self.objects_ = {}
end

function app:run()
    self:loadResource()
    self:runGame()
end

function app:loadResource()
    CCFileUtils.sharedFileUtils.addSearchPath(
        RESOURCE_DIR
    )

    display.addSpriteFramesWithFile(
        TEXTURES_DATA_FILENAME,
        TEXTURES_IMAGE_FILENAME
    )
end

function app:runGame()
    self:enterScene("GameScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

return app
