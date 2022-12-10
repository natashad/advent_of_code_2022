@day_number = 10
require_relative '../helpers.rb'

RELEVANT_CYCLE_COUNTS = [20, 60, 100, 140, 180, 220]
SCREEN_WIDTH = 40

def run(data)
    cycle_count = 0
    signal_strengths = []
    x_val = 1
    picture = []
    data.map do |instr|
        cycle_count += 1
        i, val = instr.split(' ')

        do_cycle_action(cycle_count, x_val, signal_strengths, picture)

        if i == 'addx'
            cycle_count += 1
            do_cycle_action(cycle_count, x_val, signal_strengths, picture)
            x_val += val.to_i
        end
    end

    puts("Part 1: #{signal_strengths.sum}")
    draw_picture(picture)
end

def do_cycle_action(cycle_count, x_val, signal_strengths, picture)
    picture.append([]) if cycle_count%SCREEN_WIDTH == 1
    if [x_val - 1, x_val, x_val + 1].include?((cycle_count-1)%SCREEN_WIDTH)
        picture[-1].append('#')
    else
        picture[-1].append('.')
    end
    signal_strengths.append(cycle_count * x_val) if RELEVANT_CYCLE_COUNTS.include?(cycle_count)
end

def draw_picture(picture)
    picture.each do |row|
        puts row.join()
    end
end

run(@data)

#~~~~~~~~~~~~~~~ SOLUTION ~~~~~~~~~~~~~#
Part 1: 11960

####...##..##..####.###...##..#....#..#.
#.......#.#..#.#....#..#.#..#.#....#..#.
###.....#.#....###..#..#.#....#....####.
#.......#.#....#....###..#.##.#....#..#.
#....#..#.#..#.#....#....#..#.#....#..#.
####..##...##..#....#.....###.####.#..#.

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
