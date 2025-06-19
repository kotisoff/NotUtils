--[[
  WARNING
  Do not import this file. It only contains voxelcore type definitions.
]]

---@alias vec3 [number,number,number]
---@alias vec2 [number, number]

---@param min number
---@param max number
function math.rand(min, max)
  return min + math.random(max - min)
end

function table.copy(t) return t end

function is_array(x)
  if #x > 0 then return true end
  for k, v in pairs(x) do return false end
  return true
end

function debug.print(...)
  for key, value in pairs({ ... }) do
    if type(value) == "table" then
      debug.print(value)
    end
    print(key, value)
  end
end

function table.index(t, x) return math.random(1, 2) end

---@alias voxelcore.class.HeightMapConstructor fun(width, height)

---@class voxelcore.class.HeightMap
---@field noiseSeed number
---@field abs fun(self: voxelcore.class.HeightMap): voxelcore.class.HeightMap
---@field add fun(value: voxelcore.class.HeightMap|number): voxelcore.class.HeightMap
---@field sub fun(value: voxelcore.class.HeightMap|number): voxelcore.class.HeightMap
---@field mul fun(value: voxelcore.class.HeightMap|number): voxelcore.class.HeightMap
---@field pow fun(value: voxelcore.class.HeightMap|number): voxelcore.class.HeightMap
---@field min fun(value: voxelcore.class.HeightMap|number): voxelcore.class.HeightMap
---@field max fun(value: voxelcore.class.HeightMap|number): voxelcore.class.HeightMap
---@field mixin fun(value: voxelcore.class.HeightMap|number, t: voxelcore.class.HeightMap): voxelcore.class.HeightMap
---@field dump fun(path: string)
---@field noise fun(offset: vec2, scale: number, octaves?: integer, multiplier?: number, shiftMapX?: voxelcore.class.HeightMap, shiftMapY: voxelcore.class.HeightMap): nil
---@field cellnoise fun(offset: vec2, scale: number, octaves?: integer, multiplier?: number, shiftMapX?: voxelcore.class.HeightMap, shiftMapY: voxelcore.class.HeightMap): nil
---@field resize fun(width: number, height: number, lerp: "nearest"|"linear"|"cubic"): voxelcore.class.HeightMap
---@field crop fun(x: number, y: number, width: number, height: number): voxelcore.class.HeightMap
---@field at fun(x:number,y:number): number
