@day_number = 6
require_relative '../helpers.rb'
require 'set'

def run(data)
    signal = data[0]
    [find_first_unique_n(signal, 4), find_first_unique_n(signal, 14)]
end

def find_first_unique_n(signal, n)
    running = signal[0..n-2].chars
    signal[n-1..].chars.each_with_index do |c, idx|
        running.append(c)
        return idx+n unless has_duplicate?(running)
        running.shift
    end
    return 0
end

def has_duplicate?(group)
    group.to_set.length < group.length
end

pp run(@data)
