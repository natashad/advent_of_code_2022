@day_number = 13
require_relative '../helpers.rb'
require 'json'

UNORDERED = -1
ORDERED = 1
CHECK_REMAINDER = 0

DIVIDER_PACKETS = [[[6]], [[2]]]

def run(data)
    packet_pairs = data.reject{ |line| line == '' }
        .each_slice(2)
        .map{ |packet_pair| packet_pair.map{ |packet| JSON.parse(packet) } }

    part1 = packet_pairs.each_with_index.map{ |pair, idx| [idx+1, pair] }
        .filter{ |entry| ordered?(entry[1][0], entry[1][1]) == ORDERED }
        .reduce(0){ |acc, curr| acc += curr[0] }

    all_packets = data.reject{ |x| x == '' }.map{ |packet| JSON.parse(packet) } 
    all_packets += DIVIDER_PACKETS
    all_packets.sort! { |p1, p2|  ordered?(p2, p1) }

    part2 = DIVIDER_PACKETS.reduce(1) { |acc, divider| acc * (all_packets.index(divider)+1) }

    [part1, part2]
end

def ordered?(item1, item2)
    return CHECK_REMAINDER if item1 == item2

    return item1 < item2 ? ORDERED : UNORDERED if (item1.is_a? Integer) && (item2.is_a? Integer)
    return ordered?([item1], item2) if item1.is_a? Integer
    return ordered?(item1, [item2]) if item2.is_a? Integer
    return ORDERED if item1.length == 0
    return UNORDERED if item2.length == 0
        
    order = ordered?(item1[0], item2[0])
    return order == CHECK_REMAINDER ? ordered?(item1[1..], item2[1..]) : order
end

pp run(@data)
