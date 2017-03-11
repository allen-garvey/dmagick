# resizes jpg images in source directory into large, medium and small versions
# requires imagemagick

if ARGV.size != 1
	abort("Requires source directory name as first argument")
end

SOURCE_DIRECTORY_NAME = ARGV[0]
DESTINATION_DIRECTORY_NAME = 'finals'

JPEG_QUALITY = '40%'
SIZES = [
			{name: 'lg', max_width: 1600},
			{name: 'med', max_width: 900},
			{name: 'sm', max_width: 500},
	]
THUMBNAIL_SIZE = {name: 'thumb', max_width: 200}



Dir.chdir(SOURCE_DIRECTORY_NAME) do
	Kernel.system "mkdir -p #{DESTINATION_DIRECTORY_NAME}"
	SIZES.each do |size|
		imagemagick_command = "magick '*.jpg' -resize #{size[:max_width]} -quality #{JPEG_QUALITY} -set filename:name '%t' '#{DESTINATION_DIRECTORY_NAME}/%[filename:name]-#{size[:name]}.jpg'"
		puts imagemagick_command
		Kernel.system imagemagick_command
	end
	### automatically generate thumbnail
	# imagemagick_thumbnail_command = "mkdir -p #{THUMBNAIL_SIZE[:name]} && magick '*.jpg' -resize #{THUMBNAIL_SIZE[:max_width]}x#{THUMBNAIL_SIZE[:max_width]}^ -gravity Center -crop #{THUMBNAIL_SIZE[:max_width]}x#{THUMBNAIL_SIZE[:max_width]}+0+0 +repage  -quality #{JPEG_QUALITY} -set filename:name '%t' '#{THUMBNAIL_SIZE[:name]}/%[filename:name]-#{THUMBNAIL_SIZE[:name]}.jpg'"
	# puts imagemagick_thumbnail_command
	# Kernel.system imagemagick_thumbnail_command
end

