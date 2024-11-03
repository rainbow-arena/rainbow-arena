-- Libraries
vector = require "lib.hump.vector"
timer = require "lib.hump.timer"
camera = require "lib.hump.camera"

tiny = require "lib.tiny"

util = require "lib.util"

circle = require "util.circle"
entity = require "util.entity"
color = require "util.color"

-- Classes
World = require "objects.World"

ent_Physical = require "objects.entities.Physical"
ent_Combatant = require "objects.entities.Combatant"
ent_Explosion = require "objects.entities.Explosion"

wep_Pistol = require "objects.weapons.projectile.Pistol"
wep_Machinegun = require "objects.weapons.projectile.Machinegun"
wep_Minigun = require "objects.weapons.projectile.Minigun"
wep_Shotgun = require "objects.weapons.projectile.Shotgun"
wep_Burstgun = require "objects.weapons.projectile.Burstgun"

-- Generate a random position with a circle of the given radius, centered around 0, 0.
generate_position = (radius) ->
    angle = love.math.random! * 2 * math.pi
    magnitude = love.math.random(0, radius)

    vector.new(magnitude * math.cos(angle), magnitude * math.sin(angle))

Game = {}

spawn_test_entities = (world) ->
    window_w, window_h = love.graphics.getDimensions!

    player = world\add_entity ent_Combatant {
        Name: "Player",
        Position: vector.new 0, 0,
        Color: { 1, 1, 1 },
        DesiredAimAngle: math.pi,
        Player: true,

        Weapon: wep_Minigun {
            projectile: ent_Physical { -- TODO: Hit recoil, use CollisionPhysics with force but without actual collision?
                Name: "A projectile",

                Position: vector.new(0, 0), -- doesn't matter
                Radius: 3,
                Mass: 10,

                Drag: 0,

                CollisionPhysics: true,
                IgnoreExplosion: true,

                Lifetime: 2,

                onCollision: (world, other) =>
                    explosion = ent_Explosion {
                        Position: self.Position\clone!,
                        radius: 25,
                        duration: 0.5,
                        damage: 50,
                        force: 8 * 10 ^ 6,
                    }

                    world\add_entity explosion
                    world\remove_entity self
            },

            muzzleVelocity: 800,
            spread: math.pi / 20,

            shotPellets: 3,
            shotBurstDelay: 0.1,

            shotDelay: 0.2,

            initialShotDelay: 0.3,
            finalShotDelay: 0.01,

            spinupTime: 2,

            shotHeat: 0.0,
            heatLimit: 4,

            shotSound: "assets/audio/laser_shot.wav",

            screenshake: {
                radius: 60,
                intensity: 2,
                duration: 1,
                removeOnFinish: true,
            },
        },
    }

    world.CameraTarget = player

    for i = 1, 200
        world\add_entity ent_Combatant {
            Name: "Combatant " .. i,
            Position: generate_position 1000,
            Color: { color.hsv_to_rgb (love.math.random 0, 359), 1, 1 }, -- TODO: How does this parse, args vs. table elements?
            DesiredAimAngle: love.math.random! * 2 * math.pi,
            StareAt: player,
        }

    world\register_event "PhysicsCollision", (world, e1, e2, mtv) ->
        world\add_entity ent_Explosion {
            Position: entity.getmidpoint e1, e2,
            radius: 100,
            duration: 1,
            damage: 75,
            force: 0
        }

    boombox_source = love.audio.newSource "assets/audio/mirrexagon_-_fluorescent_-_mono.ogg", "stream"
    boombox_source\setLooping true

    boombox = ent_Combatant {
        Name: "Boombox",
        Position: generate_position 1000,
        Radius: 60,
        Color: { color.hsv_to_rgb (love.math.random 0, 359), 1, 1 },
        hue: 0,
        DesiredAimAngle: love.math.random! * 2 * math.pi,
        StareAt: player,

        Sound: {
            source: boombox_source,
            volume: 1,
            pitch: 1
        }
    }
    world\add_entity boombox

    world.ecs\addSystem tiny.system {
        update: (dt) =>
            boombox.hue = boombox.hue + 100 * dt
            if boombox.hue > 359 then
                boombox.hue = 0
            boombox.Color = { color.hsv_to_rgb boombox.hue, 1, 1 }
    }

Game.init = =>
    self.world = World!

    self.world.DEBUG = false
    self.world.speed = 1

    window_w, window_h = 1280, 1024
    love.window.setMode window_w, window_h

    spawn_test_entities self.world

Game.enter = (prev, ...) =>
    love.mouse.setVisible false

Game.leave = =>
    love.mouse.setVisible(true)

draw_debug_info = (x, y) =>
    str_t = {}

    str_t[#str_t + 1] = ("Entities: %d")\format self.ecs\getEntityCount!
    str_t[#str_t + 1] = ("Speed: %.2f")\format self.speed

    str = table.concat str_t, "\n"
    love.graphics.setColor 1, 1, 1
    love.graphics.print str, math.floor x, math.floor y

-- Doing all updating in .draw()
Game.draw = =>
    dt = love.timer.getDelta!

    self.world\update dt
    timer.update dt

    if self.world.DEBUG
        draw_debug_info self.world, 10, 10

Game.keypressed = (key) =>
    if key == "d"
        self.world.DEBUG = not self.world.DEBUG
    elseif key == "k"
        player.Health.current = 0

Game.mousepressed = (x, y, b) =>

Game.wheelmoved = (x, y) =>
    if y > 0 then
        self.world.speed = self.world.speed + 0.1
    else
        self.world.speed = self.world.speed - 0.1

    self.world.speed = util.math.clamp 0, self.world.speed, 7

return Game
