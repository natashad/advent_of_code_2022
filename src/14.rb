@day_number = 14
require_relative '../helpers.rb'
require 'set'

SAND_ROOT = [500, 0]
X = 0
Y = 1

def run(data)
    rocks = build_rocks(data)
    simulate_sand(rocks)
end

def simulate_sand(rocks)
    floor_y = rocks.map{|_, y| y}.max

    obstacles = rocks.clone
    part1 = 0
    while trickle_sand_1(obstacles, floor_y, SAND_ROOT)
        part1 += 1
    end

    obstacles = rocks.clone
    part2 = 0
    while trickle_sand_2(obstacles, floor_y + 2, SAND_ROOT) != SAND_ROOT
        part2 += 1
    end
    part2 += 1

    [part1, part2]
end

def trickle_sand_1(obstacles, floor_y, sand_position)
    overflow = sand_position[Y] > floor_y

    return false if overflow
        
    sand_x, sand_y = sand_position
    drop_down = [sand_x, sand_y + 1]
    drop_left = [sand_x - 1, sand_y + 1]
    drop_right = [sand_x + 1, sand_y + 1]

    new_position = nil 
    new_position = drop_down if !obstacles.include?(drop_down)
    new_position = new_position || drop_left if !obstacles.include?(drop_left)
    new_position = new_position || drop_right if !obstacles.include?(drop_right)

    if !new_position
        obstacles.add(sand_position)
        return true
    end

    return trickle_sand_1(obstacles, floor_y, new_position)
end

def trickle_sand_2(obstacles, floor_y, sand_position)
    sand_x, sand_y = sand_position
    drop_down = [sand_x, sand_y + 1]
    drop_left = [sand_x - 1, sand_y + 1]
    drop_right = [sand_x + 1, sand_y + 1]

    new_position = nil 
    new_position = drop_down if !(obstacles.include?(drop_down) || drop_down[Y] == floor_y)
    new_position = new_position || drop_left if !(obstacles.include?(drop_left) || drop_left[Y] == floor_y)
    new_position = new_position || drop_right if !(obstacles.include?(drop_right) || drop_right[Y] == floor_y)

    if !new_position
        obstacles.add(sand_position)
        return sand_position
    end

    return trickle_sand_2(obstacles, floor_y, new_position)
end

def build_rocks(data)
    rocks = Set.new
    data.each do |rock|
        rock_edges = rock.split('->').map{|point| point.strip.split(',')}.map{|x,y| [x.to_i, y.to_i]}
        rock_edges.reduce([]) do |acc, edge|
            rocks += get_line_coords(acc, edge) if acc.length > 0
            acc = [edge[0], edge[1]]
        end
    end
    rocks
end

def get_line_coords(point1, point2)
    p1x, p1y = point1
    p2x, p2y = point2

    if p1x == p2x
        return (([p1y, p2y].min)..([p1y, p2y].max)).to_a.map { |y| [p1x, y] }
    else
        return (([p1x, p2x].min)..([p1x, p2x].max)).to_a.map { |x| [x, p1y] }
    end
end

pp run(@data)
