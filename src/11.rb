@day_number = 11
require_relative '../helpers.rb'

class Monkey
    attr_accessor :items
    attr_reader :inspection_count

    DIVISIBLE_CHECKS = [2,5,13,19,11,3,7,17,23]
    MOD = DIVISIBLE_CHECKS.reduce(&:*)
    
    def initialize(items, operation, test_divisible_condition, test_true_pass_to, test_false_pass_to)
        @items = items.map(&:to_i)
        @op = operation
        @test_cond = test_divisible_condition
        @test_true_pass_to = test_true_pass_to
        @test_false_pass_to = test_false_pass_to
        @inspection_count = 0
    end

    def get_worry_level(item)
        a, op, b = @op
        a = a == 'old' ? item : a.to_i
        b = b == 'old' ? item : b.to_i
        result = op == '+' ? (a + b) : (a * b)
    end

    def pass(item, all_monkeys, reduce_worry_level: true)
        worry = get_worry_level(item)
        worry = worry / 3 if reduce_worry_level
        worry %= MOD

        divisible_by = @test_cond.to_i

        pass_to = worry % divisible_by == 0 ? @test_true_pass_to.to_i : @test_false_pass_to.to_i

        all_monkeys[pass_to].items.append(worry)
    end

    def play_turn(all_monkeys, reduce_worry_level: true)
        item = items.shift
        while item
            pass(item, all_monkeys, reduce_worry_level: reduce_worry_level)
            item = items.shift
            @inspection_count += 1
        end
    end
end

def run(data)
    monkeys = parse_input(data)
    20.times do |i|
        monkeys.each { |monkey| monkey.play_turn(monkeys, reduce_worry_level: true) }
    end
    part1 = monkeys.map {|m| m.inspection_count }.sort[-2..].reduce(&:*)

    monkeys = parse_input(data)
    10000.times do |i|
        monkeys.each { |monkey| monkey.play_turn(monkeys, reduce_worry_level: false) }
    end
    part2 = monkeys.map {|m| m.inspection_count }.sort[-2..].reduce(&:*)

    [part1, part2]
end 

def parse_input(data)
    monkeys = []
    starting_items = nil
    operation = nil
    test_cond = nil
    test_true = nil
    test_false = nil
    data.each do |line|
        split_line = line.strip.split(' ')
        case split_line[0] || 'end'
        when 'end'
            next
        when 'Monkey'
            next
        when 'Starting'
            starting_items = split_line[2..]
        when 'Operation:'
            operation = split_line[-3..]
        when 'Test:'
            test_cond = split_line[-1]
        when 'If'
            if split_line[1] == 'true:'
                test_true = split_line[-1]
            else
                test_false = split_line[-1]
                monkeys.append(Monkey.new(starting_items, operation, test_cond, test_true, test_false))
            end
        end
    end
    monkeys
end

pp run(@data)
