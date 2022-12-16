@day_number = 15
require_relative '../helpers.rb'
require 'set'

X = 0
Y = 1
# PART_1_ROW = 10
PART_1_ROW = 2000000

LOWER_BOUND = 0
# UPPER_BOUND = 20
UPPER_BOUND = 4000000

def run(data)
    sensors, beacons = parse_data(data)
    
    blocked_spots = find_blocked_spots_on_row(sensors, PART_1_ROW)
    beacons.filter{ |x, y| y == PART_1_ROW }.each{ |x, y| blocked_spots.delete(x) }
    part1 = blocked_spots.count

    part2 = find_open_spot_in_allowed_range(sensors)

    [part1, part2]
end

def find_open_spot_in_allowed_range(sensors)
    allowed_range = (0..UPPER_BOUND).to_set
    open_spot = nil

    UPPER_BOUND.times do |row|
        x = get_empty_spot(sensors, row)
        return (x * 4000000) + row if x
    end
end

def get_empty_spot(sensors, row)
    blocked_spots = Set.new

    sensors.keys.each do |sensor|
        distance_from_row = (sensor[Y] - row).abs
        manhatten_distance = sensors[sensor]
        num_per_side = (manhatten_distance - distance_from_row)
        left = [sensor[X]-num_per_side, LOWER_BOUND].max
        right = [sensor[X]+num_per_side, UPPER_BOUND].min
        blocked_spots << [left, right] if num_per_side >= 0
    end

    blocked_spots = blocked_spots.to_a
    blocked_spots.sort_by! {|x| [x[0], x[1]]}

    blocked_spots = blocked_spots[1..].reduce(blocked_spots[0]) do |acc, line1|
        line2 = acc.compact
        if line1[0] >= line2[0] && line1[0] <= line2[1]
            if line1[1] <= line2[1]
                new_line = line2 # fully contained
            else
                new_line = [line2[0], line1[1]] # line1 extends beyond
            end
            
            acc = new_line
        else
            return line2[1] + 1
        end
    end

    return nil
end

def find_blocked_spots_on_row(sensors, row)
    blocked_spots_on_row = Set.new

    sensors.keys.each do |sensor|
        distance_from_row = (sensor[Y] - row).abs
        manhatten_distance = sensors[sensor]
        num_per_side = (manhatten_distance - distance_from_row)
        if num_per_side >= 0
            num_per_side.times do |num|
                blocked_spots_on_row.add(sensor[X]-1-num)
                blocked_spots_on_row.add(sensor[X]+1+num)
            end
            blocked_spots_on_row.add(sensor[X])
        end
    end

    blocked_spots_on_row
end


def parse_data(data)
    sensors = {}
    beacons = Set.new
    points = data.map { |line| line.split(' ').filter{ |a| a.include?('=') }.map { |a| a.split('=')[1].to_i }.each_slice(2).to_a }
    points.each do |sensor, beacon| 
        sensors[sensor] = manhatten_dist(sensor, beacon)
        beacons << beacon 
    end
    [sensors, beacons]
end

def manhatten_dist(p1, p2)
    (p1[0] - p2[0]).abs + (p1[1] - p2[1]).abs
end

pp run(@data)
