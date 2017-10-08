namespace :secondary_data do
  require 'rubygems'  
  require 'nokogiri'
  require 'open-uri'

  desc "Scrape secondary info from DD"

  task :web => :environment do
    refs = Company.all.pluck(:company_number)



    refs.each do |ref|
      doc = Nokogiri::HTML(open('https://www.duedil.com/company/gb/' + ref))

      begin

        if doc.css('a[rel="nofollow"]')[1]['href'].include?("http")
          website = doc.css('a[rel="nofollow"]')[0]['href']
        end
        if doc.css('a[rel="nofollow"]')[1]['href'].include?("http")
          linkedin = doc.css('a[rel="nofollow"]')[1]['href']
        end
        if doc.css('a[rel="nofollow"]')[2]['href'].include?("http")
          facebook = doc.css('a[rel="nofollow"]')[2]['href']
        end
        if doc.css('a[rel="nofollow"]')[3]['href'].include?("http")
          twitter = doc.css('a[rel="nofollow"]')[3]['href']
        end

        puts website
        puts linkedin
        puts facebook
        puts twitter

        rescue => e
        p e
      end
    end
  end

end

