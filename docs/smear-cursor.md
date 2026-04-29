# Smear Cursor（光标拖尾动画）

为光标移动添加平滑拖尾（smear）动画效果，灵感来源于 Neovide 的动画光标。适用于所有仅支持文本显示的终端环境。

## 快捷键

Smear Cursor 不定义任何快捷键，光标动画在安装后自动生效。可通过命令行命令或 Lua API 控制动画开关。

## 常用命令

| 命令 | 说明 |
|------|------|
| `:SmearCursorToggle` | 切换光标拖尾动画的开关状态 |

也可以通过 Lua API 控制：

```lua
-- 切换动画开关
:lua require("smear_cursor").toggle()
```

## 配置说明

配置文件路径：`lua/plugins/smear-cursor.lua`。

### 基础配置

当前使用默认配置，插件加载后即生效：

```lua
return {
  "sphamba/smear-cursor.nvim",
  opts = {},
}
```

### 行为开关

控制光标拖尾动画在哪些场景下触发：

```lua
opts = {
  -- 在 buffer 或窗口之间切换时触发拖尾动画（默认 true）
  smear_between_buffers = true,
  -- 在行内或相邻行之间移动时触发拖尾动画（默认 true）
  smear_between_neighbor_lines = true,
  -- 在 insert 模式下触发拖尾动画（默认 true）
  smear_insert_mode = true,
  -- 在 replace 模式下触发拖尾动画（默认 false）
  smear_replace_mode = false,
  -- 在 terminal 模式下触发拖尾动画（默认 false）
  smear_terminal_mode = false,
  -- 进入或离开命令行模式时触发拖尾动画（默认 true）
  smear_to_cmd = true,
},
```

### 方向控制

限制拖尾动画只在特定方向上触发：

```lua
opts = {
  -- 水平方向拖尾（默认 true）
  smear_horizontally = true,
  -- 垂直方向拖尾（默认 true）
  smear_vertically = true,
  -- 对角线方向拖尾（默认 true）
  smear_diagonally = true,
  -- 触发拖尾的最小水平距离，单位为字符（默认 0）
  min_horizontal_distance_smear = 0,
  -- 触发拖尾的最小垂直距离，单位为字符（默认 0）
  min_vertical_distance_smear = 0,
},
```

### 动画速度与弹性

调整拖尾动画的响应速度和"弹性"效果：

```lua
opts = {
  -- 拖尾头部追踪目标的速度，0 = 不移动，1 = 瞬间到达（默认 0.6）
  stiffness = 0.6,
  -- 拖尾尾部追踪目标的速度（默认 0.45）
  trailing_stiffness = 0.45,
  -- 速度衰减系数，0 = 无衰减，1 = 完全衰减（默认 0.85）
  damping = 0.85,
  -- 尾部与目标距离小于此值时停止动画，单位为字符（默认 0.1）
  distance_stop_animating = 0.5,
},
```

降低 `damping` 值（例如设为 `0.65`）可以让拖尾看起来更有弹性（超过目标位置后回弹）。

### Insert 模式专用参数

Insert 模式下有独立的动画参数：

```lua
opts = {
  stiffness_insert_mode = 0.5,
  trailing_stiffness_insert_mode = 0.5,
  damping_insert_mode = 0.9,
  trailing_exponent_insert_mode = 1,
  distance_stop_animating_vertical_bar = 0.875,
},
```

### 更快的拖尾效果

如果觉得默认动画太慢，可以调高刚度和阻尼：

```lua
opts = {
  stiffness = 0.8,                       -- 默认 0.6
  trailing_stiffness = 0.6,              -- 默认 0.45
  stiffness_insert_mode = 0.7,           -- 默认 0.5
  trailing_stiffness_insert_mode = 0.7,  -- 默认 0.5
  damping = 0.95,                        -- 默认 0.85
  damping_insert_mode = 0.95,            -- 默认 0.9
  distance_stop_animating = 0.5,         -- 默认 0.1
},
```

### 光标颜色

默认使用 Neovim 的 Cursor 颜色。如果终端覆盖了 Neovim 设置的光标颜色，可以手动指定：

```lua
opts = {
  -- 拖尾颜色，支持十六进制颜色值或高亮组名称
  -- 设为 "none" 则使用目标位置的文字颜色
  cursor_color = "#d3cdc3",
},
```

### 粒子效果

启用后光标移动时会散发粒子，适合配合 `never_draw_over_target = true` 使用：

```lua
opts = {
  particles_enabled = true,
  particles_per_second = 200,
  particles_per_length = 1.0,
  particle_max_lifetime = 300,
  particle_max_initial_velocity = 10,
  particle_damping = 0.2,
  particle_gravity = 20,
  min_distance_emit_particles = 1.5,
},
```

### 性能调整

如果动画导致帧率下降，可以缩短绘制间隔：

```lua
opts = {
  -- 动画帧间隔，单位毫秒，默认 17（约 60fps）
  time_interval = 7,
},
```

### 光标形状

告知插件当前使用的光标形状，以获得更好的渲染效果：

```lua
opts = {
  -- Normal 模式下光标是否为竖线（默认 false，即块状光标）
  vertical_bar_cursor = false,
  -- Insert 模式下光标是否为竖线（默认 true）
  vertical_bar_cursor_insert_mode = true,
  -- Replace 模式下光标是否为水平线（默认 true）
  horizontal_bar_cursor_replace_mode = true,
},
```

## 特性

- 光标移动时产生平滑拖尾效果，开箱即用
- 支持在 buffer/窗口切换、Normal/Insert/Replace/Terminal 模式下分别控制
- 可自定义动画速度、弹性、方向和颜色
- 支持粒子效果和光标形状适配
- 兼容所有仅支持文本显示的终端环境
- 支持透明背景（需字体支持 legacy computing symbols）
- 若未使用 `termguicolors`，可手动设置颜色梯度
