require "spec_helper"
require "hefted/class_method"

describe Hefted::ClassMethod do
  let(:klass) do
    Class.new do
      extend Hefted::ClassMethod

      hefted(
        name: :toto,
        spam: 1,
        ham: 20,
        eggs: 100
      )
    end
  end

  context "respond_to?" do
    subject { klass }
    it { is_expected.to be_const_defined(:Toto) }
    it { is_expected.to respond_to(:hefted) }
    it { is_expected.to respond_to(:release_hefted) }
  end

  context "get struct" do
    subject { klass.const_get(:Toto) }
    let(:not_found) { "not found" }
    let(:block) { Proc.new { |value| value } }

    it(:members) { expect(subject.members).to include(:spam, :ham, :eggs) }
    it(:values) { expect(subject.values).to include(1, 20, 100) }
    it(:to_h) { expect(subject.to_h).to include(spam: 1, ham: 20, eggs: 100) }
    it(:each) { expect(subject.each).to be_a(Enumerator) }
    it(:each_key) { expect(subject.each_key).to be_a(Enumerator) }
    it(:each_value) { expect(subject.each_value).to be_a(Enumerator) }
    it(:keys) { expect(subject.keys).to include(:spam, :ham, :eggs) }
    it(:keys) { expect(subject.keys).to eq subject.members }
    it(:has_key?) { expect(subject.has_key?(:name)).to be_falsy }
    it(:key?) { expect(subject.key?(:name)).to be_falsy }
    it(:has_value?) { expect(subject.has_value?(99)).to be_falsy }
    it(:value?) { expect(subject.value?(99)).to be_falsy }
    it(:fetch) { expect(subject.fetch(:eggs)).to eq 100 }
    it(:fetch) { expect(subject.fetch(:name, not_found)).to eq not_found }
    it(:fetch) { expect { |b| subject.fetch(:name, &b) }.to yield_control }
    it(:fetch_values) { expect(subject.fetch_values(:ham)).to include(20) }
    it(:fetch_values) { expect(subject.fetch_values(:spam, :name)).to include(1, nil) }
    it(:fetch_values) { expect { |b| subject.fetch_values(:spam, :name, &b) }.to yield_control }
    it(:values_at) { expect(subject.values_at(:spam, :name)).to include(1, nil) }
    it(:[]) { expect(subject[:eggs]).to eq 100 }
    it(:[]) { expect(subject[:name]).to eq nil }
  end
end
