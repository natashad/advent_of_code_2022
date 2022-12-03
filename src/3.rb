@day_number = 3
require_relative '../helpers.rb'
require 'set'

PRIORITIES = '_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')

def run(data)
    part1 = data.reduce(0) { |acc, curr| acc + calculate_priority(find_duplicate(curr)) }
    groups = groupify(data)
    part2 = groups.reduce(0) { |acc, curr| acc + calculate_priority(find_comminality_in_triplet(curr)) }
    [part1, part2]
end

def find_duplicate(rucksack)
    rucksack = rucksack.split('')
    comp_size = rucksack.length/2
    comp1 = rucksack[0..comp_size-1].to_set
    comp2 = rucksack[comp_size..]
    comp2.each do |item|
        return item if comp1.include?(item)
    end
end

def find_comminality_in_triplet(group)
    sack1, sack2, sack3 = group
    # Set intersection
    commons1 = sack1.to_set & sack2.to_set
    commons2 = sack2.to_set & sack3.to_set
    commons = commons1 & commons2

    commons.to_a[0]
end


def groupify(data)
    groups = []
    data.each_with_index { |sack, i| groups[i/3] = (groups[i/3] || []).append(sack.split('')) }
    groups
end

def calculate_priority(item)
    PRIORITIES.find_index(item)
end

pp run(@data)
