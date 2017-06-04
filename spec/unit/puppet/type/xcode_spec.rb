require 'spec_helper'

describe Puppet::Type.type(:xcode) do
  let(:subject) do
   # Nothing
  end

  describe 'generate' do
    before do
      subject.generate
    end
  end

  describe Puppet::Type.type(:xcode) do
    it 'has a source attribute' do
      expect(described_class.attrclass(:source)).to be_nil
    end

    it 'has a password attribute' do
      expect(described_class.attrclass(:password)).not_to be_nil
    end

    it 'has a username attribute' do
      expect(described_class.attrclass(:username)).not_to be_nil
    end

    it 'has a selected attribute' do
      expect(described_class.attrclass(:selected)).not_to be_nil
    end

    it 'has a eula attribute' do
      expect(described_class.attrclass(:eula)).not_to be_nil
    end
  end
end
