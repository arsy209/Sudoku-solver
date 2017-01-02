require 'pry'

def generate_board(board_string)
  board_array = Array.new(9) {Array.new}
  board_split = board_string.split("")
  9.times do |i|
    9.times do |j|
      board_array[i] << board_split[j + ( i * 9 )]
    end
  end
  board_array
end
# Takes a board as a string in the format
# you see in the puzzle file. Returns
# something representing a board after
# your solver has tried to solve it.
# How you represent your board is up to you!
def solve(board_string)
  # board = board_string split into 2D array
  board = generate_board(board_string)
  rows_missing = []
  columns_missing = []
  supercells_missing = []
  # row section
  row = 0
  while row < board.length
    rows_missing << missing_numbers(board, row)
    row += 1
  end
  # column section
  column = 0
  while column < board.length
    columns_missing << missing_numbers(board.transpose, column)
    column += 1
  end
  # supercell section
  s_row = 0
  while s_row < board.length
    s_column = 0
    while s_column < board.length
      supercell = supercell_array(board, s_row, s_column)
      s_column += 3
      supercells_missing << missing_numbers(supercell, 0)
    end
    s_row += 3
  end
  supercells_missing_ext = missing_supercell_ext(supercells_missing)
  # compares each of the 3 arrays for each individual box
  row = 0
  while row < board.length
    column = 0
    while column < board.length
      if !"123456789".chars.include?(board[row][column])
         board[row][column] = rows_missing[row] & columns_missing[column] & supercells_missing_ext[row][column]
      end
      column += 1
    end
    row += 1
  end
  replace_singles(board)
  replace_with_dash(board)
  if !board.flatten.include?("-")
    p board
    return true
  end
  solve(board.flatten.join)
end

def missing_numbers(board, n)
  missing = "123456789".chars
  board[n]
  board[n].each do |number|
    if missing.include?(number)
      missing.delete(number)
    end
  end
  missing
end

def supercell_array(board, row, column)
  supercell = Array.new(3)
  supercell.map!.with_index { |cell, index| board[row + index][column..(column + 2)] }
  Array.new(1) {supercell.flatten}
end

# Replaces single element array with element
def replace_singles(board)
	board.map!.with_index do |item, first_index|
  	item.each.with_index do |element, index|
	  	if element.class == Array && element.length == 1
	  		board[first_index][index] = element[0]
	  	end
	  end
  end
end

# Replaces arrays with more than one element with '-'
def replace_with_dash(board)
	board.map!.with_index do |item, first_index|
  	item.each.with_index do |element, index|
	  	if element.class == Array
	  		board[first_index][index] = '-'
	    end
	  end
  end
end

def missing_supercell_ext(supercells_missing)
  supercells_missing_ext = Array.new(9) {Array.new}
  row = 0
  while row < 3
    3.times {supercells_missing_ext[row] << supercells_missing[0]}
    3.times {supercells_missing_ext[row] << supercells_missing[1]}
    3.times {supercells_missing_ext[row] << supercells_missing[2]}
    row += 1
  end

  while row < 6
    3.times {supercells_missing_ext[row] << supercells_missing[3]}
    3.times {supercells_missing_ext[row] << supercells_missing[4]}
    3.times {supercells_missing_ext[row] << supercells_missing[5]}
    row += 1
  end

  while row < 9
    3.times {supercells_missing_ext[row] << supercells_missing[6]}
    3.times {supercells_missing_ext[row] << supercells_missing[7]}
    3.times {supercells_missing_ext[row] << supercells_missing[8]}
    row += 1
  end
  supercells_missing_ext
end

solve("1-58-2----9--764-52--4--819-19--73-6762-83-9-----61-5---76---3-43--2-5-16--3-89--")
generate_board("1-58-2----9--764-52--4--819-19--73-6762-83-9-----61-5---76---3-43--2-5-16--3-89--")

# Returns a boolean indicating whether
# or not the provided board is solved.
# The input board will be in whatever
# form `solve` returns.
def solved?(board)
  return true if solve(board)
  false
end

# Takes in a board in some form and
# returns a _String_ that's well formatted
# for output to the screen. No `puts` here!
# The input board will be in whatever
# form `solve` returns.
def pretty_board(board)
  system 'clear'
  puts board
  sleep(1)
end
