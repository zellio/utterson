require 'spec_helper'

describe Lanyon::Application do

  let(:app) { Lanyon::Application.new }

  it 'loads views from "templates"' do
    expect(File.basename(app.settings.views)).to eql 'templates'
  end

  it 'loads public content from "assets"' do
    expect(File.basename(app.settings.public_folder)).to eql 'assets'
  end

end
