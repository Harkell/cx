namespace :annual_accounts do
  require 'RMagick'
  require 'fileutils'
  require 'tesseract'
  include Magick

  desc "Run OCR on documents post-pdf-processing"
  task :run => :environment do
    @e = Tesseract::Engine.new {|e|
      e.language  = :eng
      e.blacklist = '|'
    }
    Dir.glob(Rails.public_path + "annual_accounts/*").select {|f| File.directory? f}.each do |dir|
      id = File.basename(dir)
      find_table_region(id)
      map_table_data(id)
    end
  end

  desc "Convert PDFS to images"
  task :convert_pdfs => :environment do
    pdfs = Dir.glob(Rails.public_path + 'annual_accounts/*.pdf')  
    pdfs.each_with_index do |pdf, i|
      basename = File.basename(pdf)
      original_pdf = File.open(pdf, 'rb').read

      Dir.mkdir(Rails.public_path + "annual_accounts/#{i}")
      image = Magick::Image::from_blob(original_pdf) do
        self.format = 'PDF'
        self.quality = 200
        self.density = 200
      end

      image.each_with_index do |frame, index|
        image[index].format = 'JPG'
        image[index].to_blob
        image[index].write(Rails.public_path + "annual_accounts/#{i}" + "#{index}.jpg")
      end

      FileUtils.rm pdf
    end
  end

  def find_table_region(id)
    balance_sheet = false
    Dir.glob(Rails.public_path + "annual_accounts/#{id}/*.jpg").each_with_index do |page, i|
      p "Finding a match for: #{page}"
      @line_bounds = @e.lines_for(page)
      match = @line_bounds.select{|e| e.to_s.downcase.strip == ("balance sheet")}
      if match != []
        @balance_sheet = page
        break
      end
    end

    if @balance_sheet
      header_row = @line_bounds.select{|e| e.to_s.downcase.include? "2015"}.last.bounding_box
      footer_row = @line_bounds.select{|e| e.to_s.downcase.include? "total equity"}.last.bounding_box
      image = Magick::ImageList.new(@balance_sheet)
      crop = image.crop!(
        footer_row.x - 10,
        header_row.y - 10,
        (image.columns - (footer_row.x - 10)),
        footer_row.y - header_row.y + 50
      )
      image.write(Rails.public_path + "annual_accounts/#{id}/table.jpg")
    end
  end

  def map_table_data(id)
    lines = @e.lines_for((Rails.public_path + "annual_accounts/#{id}/table.jpg").to_s).map{|l| l.to_s.strip }
    lines.each do |line|
      data = line.gsub(",", "").split(" ")
      p data
    end
  end

end
