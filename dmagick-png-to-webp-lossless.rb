# converts png or tif images to webp lossless
# requires imagemagick

if ARGV.size != 1
	abort("Requires source directory name as first argument")
end

require_relative './includes/constants.rb'

SOURCE_DIRECTORY_NAME = ARGV[0]
DESTINATION_DIRECTORY_NAME = 'webp'
WEBP_QUALITY = '100'
OUTPUT_FILE_EXTENSION = 'webp'

### automatically generate different size images
def generate_image_sizes()
	Kernel.system "mkdir -p #{DESTINATION_DIRECTORY_NAME}"
	
	imagemagick_command = "find . -maxdepth 1 -type f  \\( -name '*.tif' -o -name '*.png' \\) | xargs -I@  #{IMAGEMAGICK_COMMAND} @ -quality #{WEBP_QUALITY} -define webp:lossless=true -set filename:name '%t' '#{DESTINATION_DIRECTORY_NAME}/%[filename:name].#{OUTPUT_FILE_EXTENSION}'"
	
	puts imagemagick_command
	Kernel.system imagemagick_command
end


Dir.chdir(SOURCE_DIRECTORY_NAME) do
	generate_image_sizes()
end
