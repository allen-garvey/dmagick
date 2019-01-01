# resizes master png and tif images into square 200x200 thumbnails using liquid resize (seam-carving)

if ARGV.size != 1
	abort("Requires source directory name as first argument")
end

SOURCE_DIRECTORY_NAME = ARGV[0]
DESTINATION_DIRECTORY_NAME = File.join(SOURCE_DIRECTORY_NAME, 'thumbnail-masters')
FINAL_DESTINATION_DIRECTORY_NAME = File.join(DESTINATION_DIRECTORY_NAME, 'thumbnail-finals')
JPEG_QUALITY = '60%'
OUTPUT_FILE_EXTENSION = 'jpg'
THUMBNAIL_SIZE = '200'


Dir.chdir(SOURCE_DIRECTORY_NAME) do
	Kernel.system "mkdir -p #{DESTINATION_DIRECTORY_NAME}"
	#resize images first, to make seam carving faster
	resize_images_command = "find . -maxdepth 1 -type f  \\( -name '*.tif' -o -name '*.png' \\) | convert *.png -resize #{THUMBNAIL_SIZE} -set filename:name '%t' '#{DESTINATION_DIRECTORY_NAME}/%[filename:name]-thumb.png'"
	puts resize_images_command
	Kernel.system resize_images_command

	Kernel.system "mkdir -p #{FINAL_DESTINATION_DIRECTORY_NAME}"

	liquid_resize_command = "find #{DESTINATION_DIRECTORY_NAME} -maxdepth 1 -type f -name '*.png' | xargs -I@ convert @ -liquid-rescale #{THUMBNAIL_SIZE}x#{THUMBNAIL_SIZE}! -quality #{JPEG_QUALITY} -set filename:name '%t' '#{FINAL_DESTINATION_DIRECTORY_NAME}/%[filename:name].#{OUTPUT_FILE_EXTENSION}'"
	puts liquid_resize_command
	Kernel.system liquid_resize_command

end
