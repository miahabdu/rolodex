class Tesserack
  require 'rubygems'
  require 'RMagick'

  def self.file_name(read_img)
    read_img.chomp(File.extname(read_img))
  end

  def self.convert_img(read_img)
    img = Magick::Image::read(read_img)[0]
    img.deskew
    img.quantize(256, Magick::GRAYColorspace).contrast(true)
    img.write("#{file_name(read_img)}.tiff")
  end

  def self.ocr(read_img)
     convert_img(read_img)
     tname = "#{file_name(read_img)}.tiff"

     puts "TR:\t#{tname} created"
      
     # Run tesseract
     tc = "tesseract #{tname} #{file_name(read_img)}"
     puts "TR:\t#{tc}"
     `#{tc}`
     
     File.delete(tname)
     File.open("#{file_name(read_img)}.txt"){|txt| txt.read} rescue "OCR Info couldn't be scanned"
  end

  def self.delete_tmp_txt(read_img)
    File.delete("#{file_name(read_img)}.txt")
  end
end