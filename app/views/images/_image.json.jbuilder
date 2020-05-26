json.extract! image, :id, :name, :height, :width, :created_at, :updated_at
json.url image_url(image, format: :json)
