require 'spec_helper_acceptance'

tmpdir = default.tmpdir('xcode')

apply_manifest_opts = {
  :catch_failures => true,
  :debug          => true,
}

describe 'clones a remote repo' do
  before(:all) do
    #
  end

  after(:all) do
    #
  end

  context 'with an empty configuration' do
    it 'applies the manifest' do
      pp = <<-EOS
        include ::xcode
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, apply_manifest_opts)
      apply_manifest(pp, apply_manifest_opts)
    end

    it 'applies one xcode instance' do
      pp = <<-EOS
        class { 'xcode':
          username => 'hello',
          password => 'world',
          instances => {
            'Xcode v8.0' => {
              'source'        => 'http://10.9.1.60/Xcode_8.xip'
            },
            'Xcode v7.3.1' => {
              'source'        => 'http://10.9.1.60/Xcode_7.3.1.dmg',
              'checksum'      => '3016654b6f3574b937cbb5f7dd11c98bd3ab7b4e',
              'checksum_type' => 'sha1'
            }
          }
        }
      EOS

      apply_manifest(pp, apply_manifest_opts)
    end
  end
end
