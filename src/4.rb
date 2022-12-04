@day_number = 4
require_relative '../helpers.rb'

def run(data)
    assignments = data.map{|pair| pair.split(',').map{|section| section.split('-').map(&:to_i)}}
    part1 = assignments.reduce(0) { |acc, curr| acc + (fully_contains(curr) ? 1 : 0)}
    part2 = assignments.reduce(0) { |acc, curr| acc + (has_overlap(curr) ? 1 : 0)}
    [part1, part2]
end


def fully_contains(section_pair)
    section1, section2 = section_pair
    section1[0] <= section2[0] && section1[1] >= section2[1] ||
        section2[0] <= section1[0] && section2[1] >= section1[1]
end

def has_overlap(section_pair)
    section1, section2 = section_pair
    (section1[0] >= section2[0] && section1[0] <= section2[1]) ||
        section2[0] >= section1[0] && section2[0] <= section1[1]
end

pp run(@data)
