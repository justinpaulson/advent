from collections import deque

def find_path(start, value, current_grid, goals, total):
    q = deque([[(start[0], start[1], total)]])
    prev = set([start])
    steps = {}
    while q:
        path = q.popleft()
        x,y,cur = path[-1]
        if (x,y) in goals:
            steps[(x,y)] = cur
        for a, b in adj(x,y):
            if (a,b) in current_grid and (not current_grid[(a,b)].isalpha() and (a,b) not in prev):
                q.append(path + [(a,b,cur + cost[value])])
                prev.add((a,b))
    return {k:v for k,v in steps.items()}

def find_route(grid, total):
    state = tuple(sorted(grid.items()))
    print(state)
    if (bests and total >= min(bests)) or (state in states and states[state] <= total):
        return
    states[state] = total
    if not any(v.isalpha() for v in grid.values()):
        bests.append(total)
        return
    for k,v in sorted(grid.items(), key=lambda x: x[0] not in [5,7]):
        if v.isalpha() and ((k[0],k[1]-1) not in grid or grid[k[0],k[1]-1] == '.'):
            goals = []
            valid_grid = {(x,1) : grid[x,1] for x in range(min(vald), max(vald) + 1)}
            column = [(x,y) for x,y in grid.keys() if x == ends[v] and y > 1]
            if not any(grid[x].isalpha() for x in column):
                valid_grid.update({x : grid[x] for x in column})
                goals += [max(column)]
            if k[1] > 1:
                goals += [(x,1) for x in vald]
                valid_grid.update({(k[0], y) : grid[k[0],y] for y in range(1, k[1] + 1)})
            possibles = find_path(k, v, valid_grid, goals, total)
            for trial, steps in sorted(possibles.items(), key=lambda x: x[0][1] < 2):
                trial_grid = {kn : kv for kn,kv in grid.items()}
                if column and trial == max(column):
                    trial_grid.pop(trial)
                else:
                    trial_grid[trial] = v
                trial_grid[k] = '.'
                find_route({ka:va for ka,va in trial_grid.items()}, steps)     
                
with open("input", 'r') as file:
    data = file.read().splitlines()
    data = [x + ' ' * (len(data[0]) - len(x)) for x in data]
    grid = {(x,y) : data[y][x] for x in range(len(data[0])) for y in range(len(data)) if (data[y][x] == '.' or data[y][x].isalpha())}
    adj = lambda x,y: ((x+1, y), (x-1, y), (x, y+1), (x, y-1))
    cost = {'A' : 1, 'B' : 10, 'C': 100, 'D' : 1000}
    ends = {'A' : 3, 'B' : 5, 'C': 7, 'D' : 9}
    vald = [1,2,4,6,8,10,11]
    bests = []
    states = {}
    find_route({k:v for k,v in grid.items()}, 0)
    print(min(bests))
  #   bests = []
  #   states = {} 
  #   data = data[:-2] + '''  #D#C#B#A#
  # #D#B#A#C#'''.splitlines() + data[-2:]
  #   data = [x + ' ' * (len(data[0]) - len(x)) for x in data]
  #   grid = {(x,y) : data[y][x] for x in range(len(data[0])) for y in range(len(data)) if (data[y][x] == '.' or data[y][x].isalpha())}
  #   find_route({k:v for k,v in grid.items()}, 0)
  #   print(min(bests))

    
    
    
#Calculated by hand first:

#Start

#############
#...........#
###C#C#B#D###
  #D#C#B#A#
  #D#B#A#C#
  #D#A#B#A#
  #########

#15 * 10 + 9

#############
#A......B.BB#
###C#C#.#D###
  #D#C#.#A#
  #D#B#.#C#
  #D#A#.#A#
  #########

#21 * 100 

#############
#A......B.BB#
###.#.#.#D###
  #D#.#C#A#
  #D#B#C#C#
  #D#A#C#A#
  #########

#4*10 + 7

#############
#AA...B.B.BB#
###.#.#.#D###
  #D#.#C#A#
  #D#.#C#C#
  #D#.#C#A#
  #########

#5*10 + 6*10 + 14 * 10

#############
#AA.........#
###.#B#.#D###
  #D#B#C#A#
  #D#B#C#C#
  #D#B#C#A#
  #########

#4*1000 + 4 + 6*100 + 5

#############
#AA...D...AA#
###.#B#C#.###
  #D#B#C#.#
  #D#B#C#.#
  #D#B#C#.#
  #########

#7*1000 + 33*1000

#############
#AA.......AA#
###.#B#C#D###
  #.#B#C#D#
  #.#B#C#D#
  #.#B#C#D#
  #########

#10 + 18

#############
#...........#
###A#B#C#D###
  #A#B#C#D#
  #A#B#C#D#
  #A#B#C#D#
  #########