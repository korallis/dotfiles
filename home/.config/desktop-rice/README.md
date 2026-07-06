# Desktop Rice — AeroSpace + JankyBorders + SketchyBar

A Hyprland-style tiling desktop on macOS. Catppuccin Mocha palette.
Main modifier **`alt` = the Option (⌥) key** — on a Mac keyboard "alt" and
"option" are the same physical key. It's your Hyprland **SUPER**; Cmd is left to
macOS so nothing conflicts. (`alt` fires on either Option key; left-Option-only
would need Karabiner.)

## Components & files
| Tool | Role | Config |
|------|------|--------|
| **AeroSpace** | tiling window manager | `~/.aerospace.toml` |
| **JankyBorders** | glowing window borders | `~/.config/borders/bordersrc` |
| **SketchyBar** | top status bar | `~/.config/sketchybar/` |

All three autostart at login: AeroSpace via `start-at-login`, borders + sketchybar
via `brew services` (single owner each — do **not** also launch them from AeroSpace).

## Keybindings (alt = Option ⌥ = SUPER)
### Apps
- `alt + enter` / `alt + q` → WezTerm
- `alt + b` → Chrome ·  `alt + e` → Finder
- `alt + c` → close window
- `cmd + space` → Spotlight (native launcher)

### Focus / move
- `alt + h/j/k/l` (or arrows) → focus left/down/up/right (wraps)
- `alt + shift + h/j/k/l` → move window
- `alt + minus / equal` → shrink / grow

### Layout
- `alt + f` → fullscreen ·  `alt + v` → toggle floating
- `alt + t` → tiles + toggle split axis ·  `alt + comma` → accordion
- `alt + r` → **resize mode** (h/j/k/l to size, esc to exit)

### Workspaces
- `alt + 1..9` → go to workspace
- `alt + shift + 1..9` → move window there (and follow)
- `alt + tab` → last workspace

### Service mode  (`alt + shift + ;`)
- `esc` reload config ·  `r` reset layout tree ·  `f` float/tile
- `alt+shift+h/j/k/l` join windows ·  `backspace` close all but current

### Auto-placed apps
1 = WezTerm · 2 = Chrome/Safari · 3 = VS Code/Cursor · 4 = Slack/Discord

## Managing the stack
```bash
# reload after editing a config
aerospace reload-config                 # or: alt+shift+;  then esc
~/.config/borders/bordersrc             # hot-reloads live borders
sketchybar --reload

# service control
brew services restart sketchybar
brew services restart borders

# debug sketchybar (see script stderr)
brew services stop sketchybar && sketchybar   # Ctrl-C to quit
```

## Customising the look
- **Palette**: `~/.config/sketchybar/colors.sh` (semantic roles at the bottom:
  `ACCENT`, `BAR_COLOR`, `ITEM_BG`…). Border colours live in `bordersrc`.
- **Border glow**: edit the `active_color=gradient(...)` line in `bordersrc`.
  Try `active_color=glow(0xffcba6f7)` for a solid neon ring.
- **Bar items**: `~/.config/sketchybar/items/*.sh`; their logic in `plugins/*.sh`.
- **Gaps / bar clearance**: `[gaps]` in `~/.aerospace.toml` (`outer.top` must
  clear the bar: margin 10 + height 36 ≈ 54).

## Notes
- The native macOS menu bar is set to auto-hide (`_HIHideMenuBar`); a logout/login
  makes it fully stick.
- Icons use **Hack Nerd Font** (only Regular/Bold weights exist — don't use
  Semibold/Heavy/Black or glyphs vanish) + **sketchybar-app-font** for app icons.
