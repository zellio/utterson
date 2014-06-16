require 'spec_helper'

describe Lanyon::Route::Files, rackup: true do

  let(:repo_dir) { File.join(__dir__, "spec_repo.#{Time.now.to_i}") }
  # let(:repo_manager) { Lanyon::RepositoryManager.new(repo_dir) }

  let(:foid) { '9eec82ced116713a102a04307e7e18d2509f8698' }

  around(:each) { |example| fakegit(repo_dir, &example) }

  describe 'POST' do
    it
  end

  describe 'GET' do
    it '/files' do
      post '/files'
      expect(last_response).to be_ok
    end

    it '/files/' do
      get '/files/'
      expect(last_response).to be_ok
    end

    describe '/files/:path' do
      it 'returns the file content as JSON' do
        get '/files/README.md', nil, { 'HTTP_ACCEPT' => 'application/json' }

        val = JSON.parse(last_response.body)

        expect(last_response).to be_ok
        expect(val['file']).to be_truthy
        expect(val['file']['oid']).to eql foid
      end

      it '404s on a bad path' do
        get '/files/bad_path'
        expect(last_response).to be_not_found
      end
    end
  end

  describe 'UPDATE' do
    it
  end

  describe 'DELETE' do
    it
  end
end
