class Tesserack
  require 'rubygems'
  require 'rmagick'

  def self.file_name(read_img)
    read_img.chomp(File.extname(read_img))
  end

  def self.convert_img(read_img)
    fname = self.file_name(read_img)
    img = Magick::Image::read(read_img)[0]
    img.write("#{fname}.tiff")
  end

  def self.ocr(read_img)
     fname = self.file_name(read_img)
     self.convert_img(read_img)
     tname = "#{fname}.tiff"

     puts "TR:\t#{tname} created"
      
     # Run tesseract
     tc = "tesseract #{tname} #{fname}"
     puts "TR:\t#{tc}"
     `#{tc}`
     
     # File.delete(tname) unless keep_temp==true
     File.open("#{fname}.txt"){|txt| txt.read}
  end
end