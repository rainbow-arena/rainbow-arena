# Rainbow Arena
A (work-in-progress) game made with LÖVE (http://love2d.org/) in which circles shoot each other.

Or at least, that's the goal.

For more information about the game itself, see `ABOUT.md`.

Released into the public domain via CC0 - see `main.lua` for details.


## Running
Rainbow Arena runs on LÖVE 0.10.1. It has some dependencies as Git submodules.

### Linux
If you have Git installed, just do this:

```bash
git clone https://github.com/mirrexagon/rainbow-arena
cd rainbow-arena
git submodule update --init
```

Then, if you have LÖVE installed, you can run the game like this:

```bash
love .
```

### Windows
If you have commandline Git (eg. MSYS Git), you can run the Linux Git instructions.

If you don't, you could download a snapshot from GitHub as a `.zip` file. It doesn't come with the submodules, though. `TODO: What to do here?`

To run it, you can drag the `rainbow-arena` directory onto the LÖVE executable or a shortcut to it.
