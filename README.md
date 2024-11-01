# Rainbow Arena
A game made with LÖVE (http://love2d.org/) in which circles shoot each other.

Or at least, that's the goal.

## Goal
The end goal is for Rainbow Arena to be a chaotic match-based multiplayer arena shooter, with all sorts of crazy weapons, from standard projectile weapons firing standard bullets, to sticky bomb launchers, to beam lasers, to tractor beams.

## Running
Rainbow Arena runs on LÖVE 11.5. It has some dependencies as Git submodules.

### Linux
You need:
- Git
- LÖVE 11.5 (https://love2d.org/)
- MoonScript, specifically the `moonc` command in your path (https://moonscript.org)
- just (https://github.com/casey/just)

Install and build (compile MoonScript files into Lua files):

```bash
git clone https://github.com/rainbow-arena/rainbow-arena.git
cd rainbow-arena
git submodule update --init
just build
```

Run:

```bash
just run
```

## License
- The code is under the 0BSD license (see `LICENSE-0BSD`).
- Sounds, music, and graphics are under the Creative Commons CC-BY 4.0 license (see `LICENSE-CC-BY-4.0`).

