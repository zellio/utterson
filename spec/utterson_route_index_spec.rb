require 'spec_helper'

describe Utterson::Route::Index, rackup: true do

  # describe 'POST' do
  #   it
  # end

  describe 'GET' do
    it '/' do
      get '/'
      expect(last_response).to be_ok
    end
  end

  # describe 'UPDATE' do
  #   it
  # end

  # describe 'DELETE' do
  #   it
  # end
end
