namespace :companies_house do
  require 'blanket'

  desc "Scrape initial company data from CSV and then companies house API for testing"
  task :scrape_csv => :environment do
    path = Rails.root.join("public", "companies_house.csv")
    small_count = 0

    CSV.foreach(path, headers: true) do |row|
      state = row["Accounts.AccountCategory"]
      if state == "TOTAL EXEMPTION SMALL" || state == "TOTAL EXEMPTION FULL"
        begin
          company_number = row.to_h[" CompanyNumber"].rjust(8, '0').to_i
          Company.create(company_number: company_number)
          small_count += 1
          p small_count
        rescue Blanket::ResourceNotFound => e
          p e.body
        rescue => e
          p e
        end
      end
    end
  end

end
