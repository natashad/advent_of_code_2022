@day_number = 9
require_relative '../helpers.rb'
require 'set'

DIR_DELTA_MAP = {
    'L' => [-1, 0],
    'R' => [1, 0],
    'U' => [0, -1],
    'D' => [0, 1],
}

def run(data)
    knots1 = 2.times.reduce([]) { |acc, _| acc.append([0,0]) }
    knots2 = 10.times.reduce([]) { |acc, _| acc.append([0,0]) }
    part1 = simulate(data, knots1)
    part2 = simulate(data, knots2)
    [part1, part2]
end

def simulate(movements, knots)
    movements.each do |move|
        dir, count = move.split(' ')
        count.to_i.times do
            knots[0].unshift(offset_position(knots[0][0], DIR_DELTA_MAP[dir])) # move the head
            knots[1..].each_with_index do |k, idx|
                k.unshift(move_tail(knots[idx][0], k[0]))
            end
        end
    end

    knots[-1].to_set.length
end

def offset_position(position, delta)
    [position[0] + delta[0], position[1] + delta[1]]
end

def move_tail(head_pos, tail_pos)
    x_dist = tail_pos[0] - head_pos[0] 
    y_dist = tail_pos[1] - head_pos[1]

    return tail_pos if [0, 1].include?(x_dist.abs) && [0,1].include?(y_dist.abs)

    if x_dist == 0 && y_dist.abs == 2
        return [tail_pos[0], tail_pos[1] - (y_dist.abs/y_dist)]
    elsif x_dist.abs == 2 && y_dist == 0
        return [tail_pos[0] - (x_dist.abs/x_dist), tail_pos[1]]
    elsif x_dist != 0 && y_dist != 0
        return [tail_pos[0] - (x_dist.abs/x_dist), tail_pos[1] - (y_dist.abs/y_dist)]
    end
end


pp run(@data)
