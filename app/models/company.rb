class Company < ActiveRecord::Base
    serialize :accounts, ActiveRecord::Coders::NestedHstore
    validates :company_number, uniqueness: true
    after_create :api_call


    def api_call
      companies_house = Blanket::wrap("https://api.companieshouse.gov.uk/", headers: {"Authorization" => "Basic Qmd3b2NGOGEtcUI0Ym02UWJnd2VTMlo1bU9nLW5UeEpTM0xGOHdWeDo="})
      payload = companies_house.company(self.company_id).get
      data = payload.to_h

      self.update(
        company_name: data[:company_name],
        company_type: data[:type],
        address: data[:registered_office_address],
        accounts: data[:accounts],
        overdue: data[:overdue],
        has_charges: data[:has_charges],
        has_insolvency_history: data[:has_insolvency_history],
        jurisdiction: data[:jurisdiction],
        date_of_creation: data[:date_of_creation].to_datetime,
        company_status: data[:company_status],
        last_made_up_to: data[:last_made_up_to],
        sic_codes: data[:sic_codes],
        can_file: data[:can_file]
      )

      sleep(1.5) #REMOVE WHEN ASYNC ADDED
    end
    # handle_asynchronously :api_call

    protected

    def company_id
      (self.company_number.to_s).rjust(8, '0')
    end
end
