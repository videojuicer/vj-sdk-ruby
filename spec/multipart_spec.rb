require "helpers/spec_helper"

describe Videojuicer::OAuth::Multipart do
  describe '.new' do
    context 'with no parameters' do
      subject { described_class.new }

      it { should be_kind_of(described_class) }

      its(:to_a) { should be_empty }
    end

    context 'with non-nested parameters' do
      subject { described_class.new(params) }

      let(:params) { { :a => 1 } }

      it { should be_kind_of(described_class) }

      its(:to_a) { should == [ [ 'a', 1 ] ] }
    end

    context 'with a nested Hash' do
      subject { described_class.new(params) }

      let(:params) { { :a => { :b => 2 } } }

      it { should be_kind_of(described_class) }

      its(:to_a) { should == [ [ 'a[b]', 2 ] ] }
    end

    context 'with a nested Array' do
      subject { described_class.new(params) }

      let(:params) { { :a => [ 1, 2, 3 ] } }

      it { should be_kind_of(described_class) }

      its(:to_a) { should == [ [ 'a[0]', 1 ], [ 'a[1]', 2 ], [ 'a[2]', 3 ] ] }
    end

    context 'with a file' do
      subject { described_class.new(params) }

      let(:params)       { { :file => file     }             }
      let(:file)         { File.open(__FILE__)               }
      let(:content_type) { MIME::Types['application/x-ruby'] }

      before do
        # need to allow the UploadIO instances to be comparable
        UploadIO.class_eval do
          def ==(other)
            content_type      == other.content_type      &&
            original_filename == other.original_filename &&
            local_path        == other.local_path
            io                == other.io
          end
        end
      end

      it { should be_kind_of(described_class) }

      it 'wraps the file in an UploadIO instance' do
        Hash[ subject.to_a ]['file'].should == UploadIO.new(file, content_type, __FILE__)
      end
    end
  end

  describe '#each' do
    subject { object.each { |*yieldparams| yields << yieldparams } }

    let(:yields) { [] }

    context 'with no parameters' do
      let(:object) { described_class.new }

      it { should equal(object) }

      it 'yields nothing' do
        expect { subject }.to_not change { yields.dup }
      end
    end

    context 'with parameters' do
      let(:object) { described_class.new(:a => 1) }

      it { should equal(object) }

      it 'yields the parameters' do
        expect { subject }.to change { yields.dup }.
          from([]).
          to([ [ [ 'a', 1 ] ] ])
      end
    end
  end
end
