DEBUG = 0
DEBUG_FPS = true

CONFIG_SCREEN_WIDTH     = 640
CONFIG_SCREEN_HEIGHT    = 960
CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"

ZORDER = {
    hose = 3,
    bird = 4,
    button = 5,
    gameover = 5,
    ground = 1000,
}

RESOURCE_DIR = 'res/'

TEXTURES_IMAGE_FILENAME = 'flappy_packer.png'
TEXTURES_DATA_FILENAME = 'flappy_packer.plist'
FLAPPY_FRAME_DATA_FILENAME = 'flappy_frame.plist'

BACKGROUND_FILENAME = 'bg.png'
GROUND_FILENAME = 'ground.png'

SFX = {
    swoosh = 'sfx/sfx_swooshing.mp3',
    wing = 'sfx/sfx_wing.mp3',
    point = 'sfx/sfx_point.mp3',
    die = 'sfx/sfx_die.mp3',
    hit = 'sfx/sfx_hit.mp3',
}

CollisionType = {
    bird = 1,
    ground = 2,
    hose = 3,
    pipe = 3, -- refactor
    pipeKiller = 4,
    score = 5,
}

GRAVITY = -450
