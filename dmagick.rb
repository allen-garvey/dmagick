# resizes jpg images in source directory into large, medium and small versions
# requires imagemagick

if ARGV.size != 1
	abort("Requires source directory name as first argument")
end

SOURCE_DIRECTORY_NAME = ARGV[0]
DESTINATION_DIRECTORY_NAME = 'finals'
UNUSED_DIRECTORY_NAME = 'unused'

SOURCE_FILE_EXTENSION = '.tif'

JPEG_QUALITY = '40%'
SIZES = [
			{name: 'lg', max_width: 1600},
			{name: 'med', max_width: 900},
			{name: 'sm', max_width: 500},
	]
THUMBNAIL_SIZE = {name: 'thumb', max_width: 200}


### move large portrait images to unused
def move_large_portraits_to_unused()
	Kernel.system "mkdir -p #{UNUSED_DIRECTORY_NAME}"
	large_images = `find *-lg.jpg`
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
		imagemagick_command = "magick '*#{SOURCE_FILE_EXTENSION}' -resize #{size[:max_width]} -quality #{JPEG_QUALITY} -set filename:name '%t' '#{DESTINATION_DIRECTORY_NAME}/%[filename:name]-#{size[:name]}.jpg'"
		puts imagemagick_command
		Kernel.system imagemagick_command
	end
end

### automatically generate thumbnails
def generate_thumbnails()
	imagemagick_thumbnail_command = "magick '*#{SOURCE_FILE_EXTENSION}' -resize #{THUMBNAIL_SIZE[:max_width]}x#{THUMBNAIL_SIZE[:max_width]}^ -gravity Center -crop #{THUMBNAIL_SIZE[:max_width]}x#{THUMBNAIL_SIZE[:max_width]}+0+0 +repage  -quality #{JPEG_QUALITY} -set filename:name '%t' '#{DESTINATION_DIRECTORY_NAME}/%[filename:name]-#{THUMBNAIL_SIZE[:name]}.jpg'"
	puts imagemagick_thumbnail_command
	Kernel.system imagemagick_thumbnail_command
end


Dir.chdir(SOURCE_DIRECTORY_NAME) do
	generate_image_sizes()
	# generate_thumbnails()

	Dir.chdir(DESTINATION_DIRECTORY_NAME) do
		move_large_portraits_to_unused()
	end
end




