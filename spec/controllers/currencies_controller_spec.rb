require "rails_helper"

RSpec.describe CurrenciesController do

  describe "GET #index" do
    it "returns success:true" do
      get :index
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['success']).to match true
      expect(parsed_response['currencies']['dt']).to match /\d{1,5}\,\d{1,5}/
      expect(parsed_response['currencies']['et']).to match /\d{1,5}\,\d{1,5}/
    end
  end

  describe "GET #index_forcing" do
    it "returns http success" do
      get :index_forcing
      expect(response).to be_successful
    end
  end

  describe "DELETE #destroy_forcing" do
    before do
      currency = create(:currency)
      delete(:destroy_forcing, params: {id: currency.id})
    end

    it "should return status 200" do
        expect(response.status).to eq 200
    end
  end

end
