module ValidateEmailHelper

# I'm using QuickEmailVerification API | Mashape
# X_MASHAPE_KEY is the key for siscac in Mashape
# ATH_QEV is the key for siscac in QuickEmailVerification
# Limit of 200 Verification per day for free  

  def get_response_email(email)
    result = Hash.new
    response = get(email)
    if response.status == 200
      result = JSON.parse(response.body)
    end
    result
  end

  def get(email)
    con.get do |req|
      req.url "/v1/verify?email=#{email}"
      req.headers["X-Mashape-Key"] = X_MASHAPE_KEY
      req.headers["Authorization"] = ATH_QEV
      req.headers["Accept"] = "application/json"
      # req.url '/search', :page => 2
      # req.params['limit'] = 100
    end
  end

  def con
    if ENV['RAILS_ENV'] == "test"
      @con = Faraday.default_connection
    else
      @con = Faraday.new(:url => "https://quickemailverification.p.mashape.com") do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
  end
end