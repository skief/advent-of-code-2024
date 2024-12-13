UnionFind = {}
UnionFind.__index = UnionFind

function UnionFind:create(size)
    local uf = {}
    setmetatable(uf, UnionFind)
    uf.parent = {}

    for i = 1, size do
        uf.parent[i] = i
    end

    return uf
end

function UnionFind:find(x)
    if x == self.parent[x] then
        return x
    end

    self.parent[x] = self:find(self.parent[x])
    return self.parent[x]
end

function UnionFind:union(x, y)
    x = self:find(x)
    y = self:find(y)

    if x == y then
        return
    end

    self.parent[y] = x
end

function UnionFind:isConnected(x, y)
    return self:find(x) == self:find(y)
end

function set(list)
    local set = {}
    for _, l in ipairs(list) do
        set[l] = true
    end

    local l = {}
    local i = 1
    for value in pairs(set) do
        l[i] = value
        i = i + 1
    end
    return l
end

function coord2index(x, y)
    return (x - 1) + (y - 1) * W + 1
end

function part1(uf)
    local roots = set(uf.parent)
    local area = {}
    local perimeter = {}
    for i = 1, #roots do
        area[roots[i]] = 0
        perimeter[roots[i]] = 0
    end

    for y = 1, H do
        for x = 1, W do
            local coord = coord2index(x, y)
            local root = uf:find(coord)

            area[root] = area[root] + 1

            if y > 1 and uf:isConnected(coord, coord2index(x, y - 1)) then
                perimeter[root] = perimeter[root] + 1
            end
            if y < H and uf:isConnected(coord, coord2index(x, y + 1)) then
                perimeter[root] = perimeter[root] + 1
            end
            if x > 1 and uf:isConnected(coord, coord2index(x - 1, y)) then
                perimeter[root] = perimeter[root] + 1
            end
            if x < W and uf:isConnected(coord, coord2index(x + 1, y)) then
                perimeter[root] = perimeter[root] + 1
            end
        end
    end

    local sum = 0
    for i = 1, #roots do
        sum = sum + (area[roots[i]] * (4 * area[roots[i]] - perimeter[roots[i]]))
    end
    return sum
end

function isCorner(uf, x, y, dX, dY)
    local root = uf:find(coord2index(x, y))
    local rootDX = uf:find(coord2index(x + dX, y))
    local rootDY = uf:find(coord2index(x, y + dY))
    local rootDXDY = uf:find(coord2index(x + dX, y + dY))

    if rootDX ~= root and rootDY ~= root then
        return true
    end
    if rootDX == root and rootDY == root and rootDXDY ~= root then
        return true
    end
    return false
end

function part2(uf)
    local roots = set(uf.parent)
    local area = {}
    local corners = {}
    for i =1, #roots do
        area[roots[i]] = 0
        corners[roots[i]] = 0
    end

    for y = 1, H do
        for x = 1, W do
            local coord = coord2index(x, y)
            local root = uf:find(coord)

            area[root] = area[root] + 1

            if isCorner(uf, x, y, 1, 1) then
                corners[root] = corners[root] + 1
            end
            if isCorner(uf, x, y, 1, -1) then
                corners[root] = corners[root] + 1
            end
            if isCorner(uf, x, y, -1, 1) then
                corners[root] = corners[root] + 1
            end
            if isCorner(uf, x, y, -1, -1) then
                corners[root] = corners[root] + 1
            end
        end
    end

    local sum = 0
    for i = 1, #roots do
        sum = sum + (area[roots[i]] * corners[roots[i]])
    end

    return sum
end

local map = {}
local y = 1
for line in io.lines('../inputs/day12') do
    map[y] = {}
    for x = 1, #line do
        map[y][x] = string.sub(line, x, x)
    end
    y = y + 1
end

H = #map
W = #map[1]

local uf = UnionFind:create(H * W)
for y = 1, H do
    for x = 1, W do
        local src = coord2index(x, y)

        if y > 1 and map[y][x] == map[y - 1][x] then
            uf:union(src, coord2index(x, y - 1))
        end
        if y < H and map[y][x] == map[y + 1][x] then
            uf:union(src, coord2index(x, y + 1))
        end
        if x > 1 and map[y][x] == map[y][x - 1] then
            uf:union(src, coord2index(x - 1, y))
        end
        if x < W and map[y][x] == map[y][x + 1] then
            uf:union(src, coord2index(x + 1, y))
        end
    end
end

print(part1(uf))
print(part2(uf))
