require 'spec_helper'

describe Lanyon::Route::Index, rackup: true do

  def app
    Lanyon::Application
  end

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
