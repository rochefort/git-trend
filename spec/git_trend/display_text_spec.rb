require "spec_helper"

RSpec.shared_examples_for "truncate" do |examples|
  examples.each do |example|
    input = example[:inputs]
    it "truncate(#{example[:object].inspect}, #{input}) should return #{example[:expected].inspect}" do
      expect(GitTrend::DisplayText.truncate(example[:object], input)).to eq example[:expected]
    end
  end
end

RSpec.describe GitTrend::DisplayText do
  describe ".truncate" do
    context "ascii strings" do
      examples = [
        { object: "abc",   inputs: 2, expected: "..." },
        { object: "abc",   inputs: 3, expected: "abc" },
        { object: "abcde", inputs: 3, expected: "..." },
        { object: "abcde", inputs: 4, expected: "a..." },
        { object: "abcde", inputs: 5, expected: "abcde" },
      ]
      it_behaves_like "truncate", examples
    end

    context "multi-bytes strings" do
      examples = [
        { object: "あいう", inputs: 2, expected: "..." },
        { object: "あいう", inputs: 3, expected: "..." },
        { object: "あいう", inputs: 4, expected: "..." },
        { object: "あいう", inputs: 5, expected: "あ..." },
        { object: "あいう", inputs: 6, expected: "あいう" },
      ]
      it_behaves_like "truncate", examples
    end

    context "narrow multi-bytes strings" do
      examples = [
        { object: "café au lait", inputs: 12, expected: "café au lait" },
        { object: "café au lait", inputs: 7, expected: "café..." },
        { object: "café au lait", inputs: 7, expected: "café..." },
      ]
      it_behaves_like "truncate", examples
    end
  end

  describe ".width" do
    it { expect(described_class.width("abc")).to eq 3 }
    it { expect(described_class.width("あいう")).to eq 6 }
    it { expect(described_class.width("café")).to eq 4 }
  end
end
