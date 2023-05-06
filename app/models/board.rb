class Board
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String
  field :name, type: String
  field :width, type: Integer
  field :height, type: Integer
  field :number_of_mines, type: Integer
  field :mine_positions, type: Array, default: []

  validates :email, presence: true
  validates :name, presence: true
  validates :width, presence: true, numericality: { greater_than: 0 }
  validates :height, presence: true, numericality: { greater_than: 0 }
  validates :number_of_mines, presence: true, numericality: { greater_than: 0 }

  after_create :place_mines

  def set_mine_at(x, y)
    index = x * width + y
    mine_positions << { index: index }
  end

  def is_mine_set_at?(x, y)
    index = x * width + y
    value_hash = mine_positions.find { |v| v[:index] == index }
    value_hash.present?
  end

  private

  def place_mines
    number_of_mines.times do
      x = rand(width)
      y = rand(height)
      set_mine_at(x, y)
    end
    save
  end
end
