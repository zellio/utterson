require 'spec_helper'

describe Lanyon::File do

  it 'subclasses ::File' do
    expect(Lanyon::File.ancestors.include? File).to be_true
  end

end
