namespace :companies_house do
  require 'blanket'

  desc "Scrape initial company data from CSV and then companies house API for testing"
  task :scrape_csv => :environment do
    path = Rails.root.join("public", "companies_house.csv")
    small_count = 0


    # CSV is expected at public/companies_house.csv
    # CSV is in .gitignore but can be downloaded at URL below
    # http://download.companieshouse.gov.uk/en_output.html

    CSV.foreach(path, headers: true) do |row|
      state = row["Accounts.AccountCategory"]
      unless state == "DORMANT" || state == "NO ACCOUNTS FILED" || state == ""
        begin
          company_number = row.to_h[" CompanyNumber"].rjust(8, '0')
          Company.create(company_number: company_number)
          small_count += 1
          p "#{company_number} created - #{small_count} index"
        rescue Blanket::ResourceNotFound => e
          p e.body
          p "Company Number: #{company_number}"
        rescue => e
          p e
          p "Company Number: #{company_number}"
        end
      end
    end
  end

end
