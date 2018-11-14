require "rails_helper"

RSpec.describe CurrenciesController do

  describe "GET #index" do
    it "returns success:true" do
      get :index
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['success']).to match true
      expect(parsed_response['currencies']['dollar']).to be_kind_of(Float)
      expect(parsed_response['currencies']['euro']).to be_kind_of(Float)
    end
  end

  describe "GET #index_forcing" do
    it "returns http success" do
      get :index_forcing
      expect(response).to be_successful
    end
  end

  context "delete currency forcing record" do
    let!(:currency) { create(:currency) }
    describe "DELETE #destroy_forcing" do
      it "should return status 200" do
        delete(:destroy_forcing, params: {id: currency.id})
        expect(response.status).to eq 200
      end

      it "should't find deleted record" do
        expect{delete(:destroy_forcing, params: {id: currency.id})}.to change(Currency, :count).by(-1)
      end
    end
  end
end
