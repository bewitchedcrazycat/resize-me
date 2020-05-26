class GenerateThumbnailsJob < ApplicationJob
  queue_as :default

  THUMBNAILS = {
      :percent => {
          :half => "50",
          :quater => "25"
      },

      :square => {
          :small => {:width => 200, :height => 200},
          :medium => {:width => 400, :height => 400},
          :large => {:width => 800, :height => 800},
      }
  }

  def perform(*args)
    image = Image.find(args[0])

    if image != nil

      magic_image = MiniMagick::Image.open(Rails.root.join('public', 'uploads', image.url))

      image.width = magic_image.width
      image.height = magic_image.height

      THUMBNAILS[:square].each do |nameKey, size|
        source = MiniMagick::Image.open(Rails.root.join('public', 'uploads', image.url))

        source.combine_options do |c|
          c.thumbnail "#{size[:width]}x#{size[:height]}>"
        end

        path = Rails.root.join('public', 'thumbnails', "square-#{size[:width]}x#{size[:height]}-#{image.url}")
        source.write path
      end

      THUMBNAILS[:percent].each do |nameKey, percentage|
        source = MiniMagick::Image.open(Rails.root.join('public', 'uploads', image.url))

        source.resize percentage + "%"

        path = Rails.root.join('public', 'thumbnails', "p#{percentage}-#{image.url}")
        source.write path
      end

      image.processed = true
      image.save
    end
  end
end