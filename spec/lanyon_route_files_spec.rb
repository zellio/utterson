require 'spec_helper'

describe Lanyon::Route::Files, rackup: true do

  let(:repo_dir) { File.join(__dir__, "spec_repo.#{Time.now.to_i}") }

  let(:foid) { '9eec82ced116713a102a04307e7e18d2509f8698' }
  let(:roid) { 'ec3161e34c15377c878da3d385f1baad10071513' }

  around(:each) do |example|
    fakegit(repo_dir) do
      app.repo_manager = Lanyon::RepositoryManager.new(repo_dir)
      example.call
    end
  end

  describe 'POST' do
    it 'returns 405 if the file exists' do
      post '/files/', 'path' => 'README.md'
      expect(last_response).to be_method_not_allowed
    end

    it 'creates the file at :path with :content' do
      target = File.join(repo_dir, 'readme.mdown')

      post '/files/', path: 'readme.mdown', content: 'Hello world!'

      expect(File.exist?(target)).to be true
      expect(File.read(target)).to eql 'Hello world!'
      expect(last_response).to be_ok
    end
  end

  describe 'GET' do
    it '/files/' do
      get '/files/', nil,  'HTTP_ACCEPT' => 'application/json'

      val = JSON.parse(last_response.body)

      expect(last_response).to be_ok
      expect(val['oid']).to eql roid
      expect(val['content'].length).to be 2
    end

    describe '/files/:path' do
      it 'returns the file content as JSON' do
        get '/files/README.md', nil,  'HTTP_ACCEPT' => 'application/json'

        val = JSON.parse(last_response.body)

        expect(last_response).to be_ok
        expect(val).to be_truthy
        expect(val['oid']).to eql foid
      end

      it '404s on a bad path' do
        get '/files/bad_path'
        expect(last_response).to be_not_found
      end
    end
  end

  describe 'PUT' do
    it '404s if there is new content and the file doesn\'t exist' do
      put '/files/', 'path' => 'bad_path'
      expect(last_response).to be_not_found
    end

    it '405s if the destination already exists' do
      put '/files/', 'path' => 'README.md', 'destination' => 'src/main.c'
      expect(last_response).to be_method_not_allowed
    end

    it 'updates the file contents with newly provided content' do
      target = ::File.join(repo_dir, 'README.md')

      put '/files/', 'path' => 'README.md', 'content' => 'Such content, so wow.'

      expect(::File.read(target)).to eql 'Such content, so wow.'
      expect(last_response).to be_ok
    end

    it 'moves files to the newly provided path' do
      target = ::File.join(repo_dir, 'readme.mdown')

      put '/files/', 'path' => 'README.md', 'destination' => 'readme.mdown'

      expect(::File.exist?(target)).to be true
      expect(::File.exist?(::File.join(repo_dir, 'README.md'))).to be false
      expect(last_response).to be_ok
    end
  end

  describe 'DELETE' do
    it 'returns 404 if the file doesn\'t' do
      delete '/files/', 'path' => 'readme.mdown'
      expect(last_response).to be_not_found
    end

    it 'deteles the file with :oid at :path' do
      target = File.join(repo_dir, 'README.md')

      delete '/files/', path: 'README.md', oid: foid

      expect(File.exist?(target)).to be false
      expect(last_response).to be_ok
    end
  end
end
