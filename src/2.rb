@day_number = 2
require_relative '../helpers.rb'

WIN = {
    'A' => 'C',
    'C' => 'B',
    'B' => 'A',
}

LOSE = WIN.invert

def run(data)
    input = data.map{|row| row.split(' ')}
    score_1 = simulate_1(input)
    score_2 = simulate_2(input)
    [score_1, score_2]
end

def simulate_1(input)
    input.reduce(0) { |acc, curr| acc + score_match(curr[0], {'X' => 'A', 'Y' => 'B', 'Z' => 'C'}[curr[1]]) }
end

def simulate_2(input)
    input.reduce(0) { |acc, curr| acc + score_match(curr[0], decifer_guide(curr[0], curr[1]))}
end

def decifer_guide(elf, me)
    return elf if me == 'Y'
    return LOSE[elf] if me == 'Z'
    return WIN[elf] if me == 'X'
end

def score_match(elf, me)
    letter_score = {
        'A' => 1,
        'B' => 2,
        'C' => 3,
    }
    return 3 + letter_score[me] if elf == me
    return 0 + letter_score[me] if me == WIN[elf]
    return 6 + letter_score[me]
end

pp run(@data)
