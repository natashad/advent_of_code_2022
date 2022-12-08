@day_number = 8
require_relative '../helpers.rb'

def run(data)
    tree_map = data.map{ |line| line.chars.map(&:to_i) }
    part1 = tree_map[0].length.times.map { |x| tree_map.length.times.map { |y| is_visible(tree_map, x, y) ? 1 : 0 } }.flatten.sum
    part2 = tree_map[0].length.times.map { |x| tree_map.length.times.map { |y| scenic_score(tree_map, x, y) } }.flatten.max
    [part1, part2]
end

def is_visible(tree_map, x, y)
    field_width = tree_map[0].length
    field_height = tree_map.length
    return true if x == 0 || y == 0 || x == field_height - 1 || y == field_width - 1
    height = tree_map[x][y]
    neighbours = get_neigbouring_trees(tree_map, x, y)

    neighbours.any? {|neighbour| neighbour.all?{|h| h < height}}
end

def get_neigbouring_trees(tree_map, x, y)
    field_width = tree_map[0].length
    field_height = tree_map.length
    top_neighbours = x.times.reduce([]) {|acc, top_offset| acc.append(tree_map[top_offset][y])}.reverse
    bottom_neighbours = (field_height - 1 - x).times.reduce([]) {|acc, bottom_offset| acc.append(tree_map[x + 1 + bottom_offset][y])}
    left_neighbours = y.times.reduce([]) {|acc, left_offset| acc.append(tree_map[x][left_offset])}.reverse
    right_neighbours = (field_width - 1 - y).times.reduce([]) {|acc, right_offset| acc.append(tree_map[x][right_offset + 1 + y])}
    [left_neighbours, right_neighbours, top_neighbours, bottom_neighbours]
end

def scenic_score(tree_map, x, y)
    field_width = tree_map[0].length
    field_height = tree_map.length
    return 0 if x == 0 || y == 0 || x == field_height - 1 || y == field_width - 1

    neighbours = get_neigbouring_trees(tree_map, x, y)
    neighbours.reduce(1) {|acc, neighbour| acc * visible_tree_count(neighbour, tree_map[x][y])}
end

def visible_tree_count(neighbours, height)
    return 0 if neighbours == []
    return 1 if neighbours[0] >= height
    return 1 + visible_tree_count(neighbours[1..], height)
end

pp run(@data)
