class Cell
  include Mongoid::Document
  include Mongoid::Timestamps

  field :x, type: Integer
  field :y, type: Integer
  field :has_mine, type: Boolean

  belongs_to :board
  embedded_in  :board
end
