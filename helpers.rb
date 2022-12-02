def load_data_to_array(day_number:, is_test: false)
    file = File.open("data/#{is_test ? 'test_' : ''}#{day_number}.txt")
    file.readlines.map(&:chomp)
end

@data = load_data_to_array(day_number: @day_number)

ARGV.each do|a|
    @data = load_data_to_array(day_number: @day_number, is_test: true) if a == "--test"
end
