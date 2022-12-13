# run as `ruby generate.rb <daynum>` - example: `ruby generate.rb 11` for day 11

day_num = ARGV[0]
template_file = File.open("./src/template.rb", 'r')
template_file = template_file.readlines.map(&:chomp)
line_1 = template_file[0].split(' ')
line_1[-1] = day_num
template_file[0] = line_1.join(' ')

File.open("./src/#{day_num}.rb", 'w') do |f|
    template_file.each do |temp|
        f.write(temp)
        f.write("\n")
    end
end

f = File.new("./data/#{day_num}.txt", 'w')
f.close
f = File.new("./data/test_#{day_num}.txt", 'w')
f.close