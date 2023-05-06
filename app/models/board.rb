class Board
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String
  field :name, type: String
  field :width, type: Integer
  field :height, type: Integer
  field :number_of_mines, type: Integer

  embeds_many :cells

  validates :email, presence: true
  validates :name, presence: true
  validates :width, presence: true, numericality: { greater_than: 0 }
  validates :height, presence: true, numericality: { greater_than: 0 }
  validates :number_of_mines, presence: true, numericality: { greater_than: 0 }

  after_create :build_cells

  private

  def build_cells
    board = Array.new(width) { Array.new(height, false) }

    # place mines on the board randomly
    number_of_mines.times do
      x = rand(width)
      y = rand(height)
      board[x][y] = true
    end

    max_chunk_size = 1000
    current_chunk_size = 0
    cell_attrs = []
    (0..(width - 1)).each do |x|
      (0..(height - 1)).each do |y|
        if current_chunk_size >= max_chunk_size
          puts cell_attrs
          cell_attrs.each do |attrs|
            cells.build(attrs)
          end
          Board.collection.insert_many([as_document])
          cell_attrs = []
          current_chunk_size = 0
        end
        current_chunk_size += 1
        cell_attrs << { x: x, y: y, has_mine: board[x][y] }
      end
    end

    cell_attrs.each do |attrs|
      cells.build(attrs)
    end
    Board.collection.insert_many([as_document])
  end
end
