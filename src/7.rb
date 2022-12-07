@day_number = 7
require_relative '../helpers.rb'

@directory_size_map = {}
TOTAL_DISC_SPACE = 70000000
FREE_SPACE_REQUIRED = 30000000

def run(data)
    filesystem = build_filesystem(data)
    @directory_size_map['/'] = calc_directory_size(filesystem['/'], '/')
    part1 = @directory_size_map.values.reduce(0) { |acc, curr| curr < 100000 ? acc + curr : acc }

    to_be_deleted = FREE_SPACE_REQUIRED - (TOTAL_DISC_SPACE - @directory_size_map['/'])
    
    part2 = @directory_size_map.values.filter{|dir_size| dir_size >= to_be_deleted}.min
    [part1, part2]
end

def calc_directory_size(dir, running_key)
    running_size = 0
    dir.keys.each do |key|
        curr_key = running_key + key
        if dir[key].is_a? Integer
            running_size += dir[key]
        else
            if @directory_size_map[curr_key]
                running_size += @directory_size_map[curr_key]
            else
                @directory_size_map[curr_key] = calc_directory_size(dir[key], curr_key)
                running_size = running_size + calc_directory_size(dir[key], curr_key)
            end
        end 
    end
    running_size
end

def build_filesystem(data)
    directories = {'/' => {}}
    current_dir_path = ['/']
    data.each do |line|
        line = line.split(' ')
        if line[0] == '$'
            next unless line[1] == 'cd'
            case line[2]
            when '/'
                current_dir_path = ['/']
            when '..'
                current_dir_path.pop()
            else
                current_dir_path.append(line[2])
            end
        else
            # result of an ls
            containing_dir = directories.dig(*current_dir_path)
            if line[0] == 'dir'
                containing_dir[line[1]] = {}
            else
                containing_dir[line[1]] = line[0].to_i
            end
        end
    end
    directories
end

pp run(@data)
