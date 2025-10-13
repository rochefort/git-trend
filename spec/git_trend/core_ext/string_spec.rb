require "spec_helper"

RSpec.shared_examples_for "without_options" do |examples|
  examples.each do |example|
    input = example[:inputs]
    it "#{example[:object].inspect}.mb_truncate(#{input}) should return #{example[:expected].inspect}" do
      expect(example[:object].send(:mb_truncate, input)).to eq example[:expected]
    end
  end
end

RSpec.describe String do
  describe "#mb_truncate" do
    context "ascii strings" do
      examples = [
        { object: "abc",   inputs: 2, expected: "..." },
        { object: "abc",   inputs: 3, expected: "abc" },
        { object: "abcde", inputs: 3, expected: "..." },
        { object: "abcde", inputs: 4, expected: "a..." },
        { object: "abcde", inputs: 5, expected: "abcde" },
      ]
      it_behaves_like "without_options", examples
    end

    context "multi-bytes strings" do
      examples = [
        { object: "あいう", inputs: 2, expected: "..." },
        { object: "あいう", inputs: 3, expected: "..." },
        { object: "あいう", inputs: 4, expected: "..." },
        { object: "あいう", inputs: 5, expected: "あ..." },
        { object: "あいう", inputs: 6, expected: "あいう" },
      ]
      it_behaves_like "without_options", examples
    end
  end
end
