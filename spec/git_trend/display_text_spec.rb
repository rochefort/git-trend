require "spec_helper"

RSpec.describe GitTrend::DisplayText do
  describe ".truncate" do
    context "ascii strings" do
      [
        ["abc",   2, "..."],
        ["abc",   3, "abc"],
        ["abcde", 3, "..."],
        ["abcde", 4, "a..."],
        ["abcde", 5, "abcde"],
      ].each do |str, truncate_at, expected|
        it "truncate(#{str.inspect}, #{truncate_at}) should return #{expected.inspect}" do
          expect(described_class.truncate(str, truncate_at)).to eq expected
        end
      end
    end

    context "multi-bytes strings" do
      [
        ["あいう", 2, "..."],
        ["あいう", 3, "..."],
        ["あいう", 4, "..."],
        ["あいう", 5, "あ..."],
        ["あいう", 6, "あいう"],
      ].each do |str, truncate_at, expected|
        it "truncate(#{str.inspect}, #{truncate_at}) should return #{expected.inspect}" do
          expect(described_class.truncate(str, truncate_at)).to eq expected
        end
      end
    end

    context "narrow multi-bytes strings" do
      [
        ["caf\u00e9 au lait", 12, "caf\u00e9 au lait"],
        ["caf\u00e9 au lait", 7,  "caf\u00e9..."],
        ["cafe\u0301 au lait", 7,  "cafe\u0301..."],
      ].each do |str, truncate_at, expected|
        it "truncate(#{str.inspect}, #{truncate_at}) should return #{expected.inspect}" do
          expect(described_class.truncate(str, truncate_at)).to eq expected
        end
      end
    end
  end

  describe ".width" do
    it { expect(described_class.width("abc")).to eq 3 }
    it { expect(described_class.width("あいう")).to eq 6 }
    it { expect(described_class.width("café")).to eq 4 }
  end
end
