#use instead of dmagick when resizing png or tif images into jpg output, for smaller sizes

# resizes png or tif images in source directory into large, medium and small versions
# requires imagemagick

if ARGV.size != 1
	abort("Requires source directory name as first argument")
end

require_relative './includes/constants.rb'
require_relative './includes/resize-constants.rb'

SOURCE_DIRECTORY_NAME = ARGV[0]
JPEG_QUALITY = '80%'
OUTPUT_FILE_EXTENSION = 'jpg'

require_relative './includes/move-large-portraits-to-unused.rb'

### automatically generate different size images
def generate_image_sizes()
	Kernel.system "mkdir -p #{DESTINATION_DIRECTORY_NAME}"
	SIZES.each do |size|
		imagemagick_command = "find . -maxdepth 1 -type f  \\( -name '*.tif' -o -name '*.png' \\) | xargs -I@  #{IMAGEMAGICK_COMMAND} @ -resize #{size[:max_width]} -quality #{JPEG_QUALITY} -set filename:name '%t' '#{DESTINATION_DIRECTORY_NAME}/%[filename:name]-#{size[:name]}.#{OUTPUT_FILE_EXTENSION}'"
		puts imagemagick_command
		Kernel.system imagemagick_command
	end
end


Dir.chdir(SOURCE_DIRECTORY_NAME) do
	generate_image_sizes()

	Dir.chdir(DESTINATION_DIRECTORY_NAME) do
		move_large_portraits_to_unused()
	end
end
