@day_number = 1
require_relative '../helpers.rb'

def run(data)
    elf_food_supply_breakdown = parse_data(data)
    elf_food_total_supply = elf_food_supply_breakdown.map{|supply| supply.reduce(:+)}
    sorted_food_supply = elf_food_total_supply.sort_by{|number| -number}
    highest_supply = sorted_food_supply[0]
    top_three_highest = sorted_food_supply[0] + sorted_food_supply[1] + sorted_food_supply[2]

    [highest_supply, top_three_highest]
end


def parse_data(data)
    result = [[]]
    data.map do |line|
        if line == ''
            result.append([])
        else
            result[-1].append(line.to_i)
        end
    end
    
    result
end

puts run(@data)
