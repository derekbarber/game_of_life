# Game of file spec file

require 'rspec'
require_relative 'game_of_life.rb'

describe 'Game of life' do

  let!(:world) { World.new }

  context 'world' do
    subject { World.new }

    it 'should create a new world object' do
      expect(subject).to be_a World
    end
    it 'should respond to expected methods' do
      expect(subject).to respond_to(:rows)
      expect(subject).to respond_to(:cols)
      expect(subject).to respond_to(:cell_grid)
      expect(subject).to respond_to(:live_neighbours_around_cell)
      expect(subject).to respond_to(:cells)
      expect(subject).to respond_to(:randomly_populate)
      expect(subject).to respond_to(:live_cells)
    end

    it 'should create proper cell grid on initialization' do
      expect(subject.cell_grid).to be_a Array
      subject.cell_grid.each do |row|
        expect(row).to be_a Array
        row.each do |col|
          expect(col).to be_a Cell
        end
      end
    end

    it 'should add all cells to cells array' do
      expect(subject.cells.count).to eq(9)
    end

    it 'should detect a neightbour to the North' do
      expect(subject.cell_grid[0][1]).to be_dead
      subject.cell_grid[0][1].alive = true
      expect(subject.cell_grid[0][1]).to be_alive
      expect(subject.live_neighbours_around_cell(subject.cell_grid[1][1]).count).to eq(1)
    end

    it 'should detect a neightbour to the North-East' do
      expect(subject.cell_grid[0][2]).to be_dead
      subject.cell_grid[0][2].alive = true
      expect(subject.cell_grid[0][2]).to be_alive
      expect(subject.live_neighbours_around_cell(subject.cell_grid[1][1]).count).to eq(1)
    end

    it 'should detect a neightbour to the East' do
      expect(subject.cell_grid[1][2]).to be_dead
      subject.cell_grid[1][2].alive = true
      expect(subject.cell_grid[1][2]).to be_alive
      expect(subject.live_neighbours_around_cell(subject.cell_grid[1][1]).count).to eq(1)
    end

    it 'should detect a neightbour to the South-East' do
      expect(subject.cell_grid[2][2]).to be_dead
      subject.cell_grid[2][2].alive = true
      expect(subject.cell_grid[2][2]).to be_alive
      expect(subject.live_neighbours_around_cell(subject.cell_grid[1][1]).count).to eq(1)
    end

    it 'should detect a neightbour to the South' do
      expect(subject.cell_grid[2][1]).to be_dead
      subject.cell_grid[2][1].alive = true
      expect(subject.cell_grid[2][1]).to be_alive
      expect(subject.live_neighbours_around_cell(subject.cell_grid[1][1]).count).to eq(1)
    end

    it 'should detect a neightbour to the South-West' do
      expect(subject.cell_grid[2][0]).to be_dead
      subject.cell_grid[2][0].alive = true
      expect(subject.cell_grid[2][0]).to be_alive
      expect(subject.live_neighbours_around_cell(subject.cell_grid[1][1]).count).to eq(1)
    end

    it 'should detect a neightbour to the West' do
      expect(subject.cell_grid[1][0]).to be_dead
      subject.cell_grid[1][0].alive = true
      expect(subject.cell_grid[1][0]).to be_alive
      expect(subject.live_neighbours_around_cell(subject.cell_grid[1][1]).count).to eq(1)
    end

    it 'should detect a neightbour to the North-West' do
      expect(subject.cell_grid[0][0]).to be_dead
      subject.cell_grid[0][0].alive = true
      expect(subject.cell_grid[0][0]).to be_alive
      expect(subject.live_neighbours_around_cell(subject.cell_grid[1][1]).count).to eq(1)
    end

    it 'should randomly populate the world' do
      expect(subject.live_cells.count).to eq(0)
      subject.randomly_populate
      expect(subject.live_cells.count).not_to eq(0)
    end
  end

  context 'Cell' do
    subject { Cell.new}

    it 'should create a new cell object' do
      expect(subject).to be_a Cell
    end
    it 'should respond to expected methods' do
      expect(subject).to respond_to(:alive)
      expect(subject).to respond_to(:x)
      expect(subject).to respond_to(:y)
      expect(subject).to respond_to(:alive?)
      expect(subject).to respond_to(:die!)
      expect(subject).to respond_to(:revive!)
    end

    it 'should initialize as a dead cell' do
      expect(subject.alive).to be false
      expect(subject.x).to eq(0)
      expect(subject.y).to eq(0)
    end

  end

  context 'Game' do
    subject { Game.new }

    it 'should create a new game object' do
      expect(subject).to be_a Game
    end

    it 'should respond to expected methods' do
      expect(subject).to respond_to(:world)
      expect(subject).to respond_to(:seeds)
    end

    it 'should initialize properly' do
      expect(subject.world).to be_a World
    end

    it 'should plant seeds properly' do
      game = Game.new(world, [[1, 2], [0, 2]])
      expect(world.cell_grid[1][2]).to be_alive
      expect(world.cell_grid[0][2]).to be_alive
    end
  end

  context 'Rules' do

    let!(:game) { Game.new }

    context 'Rule 1: Any live cell with fewer than two live neighbours dies, as if caused by under-population' do

      it 'should kill a live cell with no live neighbours' do
        game.world.cell_grid[1][1].alive = true
        expect(game.world.cell_grid[1][1]).to be_alive
        game.tick!
        expect(game.world.cell_grid[1][1]).to be_dead
      end

      it 'should kill a live cell with 1 live neighbour' do
        game = Game.new(world, [[1, 0], [2, 0]])
        game.tick!
        expect(world.cell_grid[1][0]).to be_dead
        expect(world.cell_grid[2][0]).to be_dead
      end

      it 'does not kill a live cell with 2 live neighbours' do
        game = Game.new(world, [[0, 1], [1, 1], [2, 1]])
        game.tick!
        expect(world.cell_grid[1][1]).to be_alive
      end
    end

    context 'Rule 2: Any live cell with two or three live neighbours lives on to the next generation' do

      it 'should keep a live cell alive with 2 live neighbours' do
        game = Game.new(world, [[0, 1], [1, 1], [2, 1]])
        expect(world.live_neighbours_around_cell(world.cell_grid[1][1]).count).to eq(2)
        game.tick!
        expect(world.cell_grid[0][1]).to be_dead
        expect(world.cell_grid[1][1]).to be_alive
        expect(world.cell_grid[2][1]).to be_dead
      end

      it 'should keep a live cell alive with 3 live neighbours' do
        game = Game.new(world, [[0, 1], [1, 1], [2, 1], [2, 2]])
        expect(world.live_neighbours_around_cell(world.cell_grid[1][1]).count).to eq(3)
        game.tick!
        expect(world.cell_grid[0][1]).to be_dead
        expect(world.cell_grid[1][1]).to be_alive
        expect(world.cell_grid[2][1]).to be_alive
        expect(world.cell_grid[2][2]).to be_alive
      end
    end

    context 'Rule 3: Any live cell with more than three live neighbours dies, as if by overcrowding' do

      it 'should kill a live cell with more than 3 live neighbours' do
        game = Game.new(world, [[0, 1], [1, 1], [2, 1], [2, 2], [1, 2]])
        expect(world.live_neighbours_around_cell(world.cell_grid[1][1]).count).to eq(4)
        game.tick!
        expect(world.cell_grid[0][1]).to be_alive
        expect(world.cell_grid[1][1]).to be_dead
        expect(world.cell_grid[2][1]).to be_alive
        expect(world.cell_grid[2][2]).to be_alive
        expect(world.cell_grid[1][2]).to be_dead
      end
    end

    context 'Rule 4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction' do
      it 'should revive a dead cell with 3 live neighbours' do
        game = Game.new(world, [[0, 1], [1, 1], [2, 1]])
        expect(world.live_neighbours_around_cell(world.cell_grid[1][0]).count).to eq(3)
        game.tick!
        expect(world.cell_grid[1][0]).to be_alive
        expect(world.cell_grid[1][2]).to be_alive
      end
    end
  end
end
