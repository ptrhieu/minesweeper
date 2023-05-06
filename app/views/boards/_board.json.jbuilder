json.extract! board, :id, :email, :name, :width, :height, :number_of_mines, :created_at, :updated_at
json.url board_url(board, format: :json)
