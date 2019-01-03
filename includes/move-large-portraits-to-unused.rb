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