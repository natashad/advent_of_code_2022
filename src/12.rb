@day_number = 12
require_relative '../helpers.rb'

HEIGHTS = 'abcdefghijklmnopqrstuvwxyz'.split('')
DELTAS = [[0,1], [0, -1], [1, 0], [-1, 0]]

HEIGHT_IDX = 0
DISTANCE_IDX = 1

def run(data)
    graph, source, dest, all_a = build_graph(data)
    
    run_djikstra(graph, dest, source)
    part_1 = graph[source[0]][source[1]][DISTANCE_IDX]
    part_2 = all_a.map { |a| graph[a[0]][a[1]][DISTANCE_IDX] }.min

    [part_1, part_2]
end

def get_neighbours(graph, point)
    row, col = point
    valid_neighbours = []
    DELTAS.each do |d|
        d_row, d_col = d
        neighbour = [row + d_row, col + d_col]
        next if neighbour.any? {|x| x < 0} || neighbour[0] >= graph.length || neighbour[1] >= graph[0].length
        next if graph[neighbour[0]][neighbour[1]][HEIGHT_IDX] - graph[row][col][HEIGHT_IDX] < -1
        valid_neighbours << neighbour
    end
    valid_neighbours
end

def run_djikstra(graph, source, dest)
    source_row, source_col = source
    dest_row, dest_col = dest
    graph[source_row][source_col][DISTANCE_IDX] = 0
    to_visit = [source]
    visited = []

    while to_visit.length > 0
        visiting = to_visit.shift
        visited << visiting
        # break if visiting == dest
        visiting_node = graph[visiting[0]][visiting[1]]
        
        neighbours = get_neighbours(graph, visiting)
        neighbours.each do |n|
            neighbour_node = graph[n[0]][n[1]]
            neighbour_node[DISTANCE_IDX] = [neighbour_node[DISTANCE_IDX], visiting_node[DISTANCE_IDX] + 1].min
            to_visit << n unless to_visit.include?(n) || visited.include?(n)
        end
        to_visit.sort_by{|node| graph[node[0]][node[1]][DISTANCE_IDX] }
    end
    
    graph[dest[0]][dest[1]][DISTANCE_IDX]
end

def build_graph(data)
    source = nil
    dest = nil
    all_a = []

    # each node in graph = [height, dist_to_source]
    graph = data.length.times.reduce([]) { |acc, _| acc.append([nil, Float::INFINITY]) }
    data.each_with_index do |row, row_idx|
        row.split('').each_with_index do |entry, col_idx|
            height = HEIGHTS.index(entry)
            if entry == 'S'
                source = [row_idx, col_idx] 
                height = HEIGHTS.index('a')
            elsif entry == 'E'
                dest = [row_idx, col_idx]
                height = HEIGHTS.index('z')
            end

            all_a << [row_idx, col_idx] if height == 0
            graph[row_idx][col_idx] = [height, Float::INFINITY]
        end
    end
    [graph, source, dest, all_a]
end

pp run(@data)
