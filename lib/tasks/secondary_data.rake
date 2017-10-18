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
        website = doc.css('a[rel="nofollow"]')[0]['href'] if doc.css('a[rel="nofollow"]')[1]['href'].include?("http")
        linkedin = doc.css('a[rel="nofollow"]')[1]['href'] if doc.css('a[rel="nofollow"]')[1]['href'].include?("http")
        facebook = doc.css('a[rel="nofollow"]')[2]['href'] if doc.css('a[rel="nofollow"]')[2]['href'].include?("http")
        twitter = doc.css('a[rel="nofollow"]')[3]['href'] if doc.css('a[rel="nofollow"]')[3]['href'].include?("http")

        p website
        p linkedin
        p facebook
        p twitter
        rescue => e
        p "Link not found."
      end
    end
  end


end

