#use instead of dmagick when resizing png or tif images into png output

# resizes png or tif images in source directory into large, medium and small versions
# requires imagemagick

if ARGV.size != 1
	abort("Requires source directory name as first argument")
end

require_relative './dmagick-constants.rb'

SOURCE_DIRECTORY_NAME = ARGV[0]
OUTPUT_FILE_EXTENSION = 'png'


### move large portrait images to unused
def move_large_portraits_to_unused()
	Kernel.system "mkdir -p #{UNUSED_DIRECTORY_NAME}"
	large_images = `find *-lg.#{OUTPUT_FILE_EXTENSION} -maxdepth 1`
	large_images.split("\n").each do |image|
		jpeg_info = `identify #{image}`
		jpeg_info_array = jpeg_info.split(" ")
		dimensions = jpeg_info_array[2]
		dimensions = dimensions.split('x')
		height = dimensions[1]
		width = dimensions[0]
		#move large portrait images to unused
		if height > width
			Kernel.system "mv #{image} #{UNUSED_DIRECTORY_NAME}/#{image}"
		end
	end
end

### automatically generate different size images
def generate_image_sizes()
	Kernel.system "mkdir -p #{DESTINATION_DIRECTORY_NAME}"
	SIZES.each do |size|
		imagemagick_command = "find . -maxdepth 1 -type f  \\( -name '*.tif' -o -name '*.png' \\) | xargs -I@  #{IMAGEMAGICK_COMMAND} @ -resize #{size[:max_width]} -set filename:name '%t' '#{DESTINATION_DIRECTORY_NAME}/%[filename:name]-#{size[:name]}.#{OUTPUT_FILE_EXTENSION}'"
		puts imagemagick_command
		Kernel.system imagemagick_command
	end
end


Dir.chdir(SOURCE_DIRECTORY_NAME) do
	generate_image_sizes()

	Dir.chdir(DESTINATION_DIRECTORY_NAME) do
		Kernel.system 'optipng *.png'
		move_large_portraits_to_unused()
	end
end
