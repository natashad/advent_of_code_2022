@day_number = 5
require_relative '../helpers.rb'

def run(data)
    piles, instruction_idx = parse(data)
    result1 = execute_instructions_1(piles, data[instruction_idx..])
    result2 = execute_instructions_2(piles, data[instruction_idx..])
    [result1, result2]
end

def execute_instructions_1(piles, instructions)
    piles = piles.map { |a| a.map{|b| b} } # deep clone (there's probably a better way to do this, but it's late :))
    instructions.each do |instruction|
        _, num_to_move, _, from, _, to = instruction.split(' ').map(&:to_i)
        num_to_move.times { piles[to-1].append(piles[from-1].pop) }
    end
    piles.reduce('') { |acc, pile| acc << pile[-1]}
end

def execute_instructions_2(piles, instructions)
    piles = piles.map { |a| a.map{|b| b} } # deep clone
    instructions.each do |instruction|
        _, num_to_move, _, from, _, to = instruction.split(' ').map(&:to_i)
        piles[to-1].concat(piles[from-1].pop(num_to_move))
    end
    piles.reduce('') { |acc, pile| acc << pile[-1]}
end

def parse(data)
    piles = []
    instructions_idx = 0
    data.each do |line|
        split_line =  line.chars.each_slice(4).map(&:join).map(&:strip)
        split_line.each_with_index do |item, i| 
            next if item.chars[0] != "["
            piles[i] = (piles[i] || []).unshift(item.chars[1]) 
        end
        instructions_idx+=1
        
        if split_line[0] == "1"
            instructions_idx += 1
            break
        end
    end
    [piles, instructions_idx]
end

pp run(@data)
