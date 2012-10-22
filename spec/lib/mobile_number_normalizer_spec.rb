# -*- encoding : utf-8 -*-
# All Testcases are derived from real mobile numbers
require File.expand_path(File.dirname(__FILE__) + '/../../lib/mobile_number_normalizer')
require 'active_support/core_ext/object/blank'
describe MobileNumberNormalizer do

  describe "should parse number" do
    it "without international area prefix" do
      MobileNumberNormalizer.get_number("01771234567").should == "00491771234567"
    end
    it "with + in front as 00" do
      MobileNumberNormalizer.get_number("+49 1771234567").should == "00491771234567"
    end
    it "with space in it" do
      MobileNumberNormalizer.get_number("01520 1234567").should == "004915201234567"
    end
    it "without 00 of international prefix" do
      MobileNumberNormalizer.get_number("321234567").should == "00321234567"
    end
    it "with , sperated" do
      MobileNumberNormalizer.get_number("0049176-12345678,0178-1234567").should == "00491781234567"
    end
    it "with / in the number" do
      MobileNumberNormalizer.get_number("0049177/1234567").should == "00491771234567"
    end
    it "with ß as 0 in the end (german typo)" do
      MobileNumberNormalizer.get_number("0049178123456ß").should == "00491781234560"
    end
    it "with ß as 0 at front (german typo)" do
      MobileNumberNormalizer.get_number("ß1761234567").should == "00491761234567"
    end
    it "0 to blank" do
      MobileNumberNormalizer.get_number("0").should be_blank
    end
    it "00000000000000000000000000000000000 to blank" do
      MobileNumberNormalizer.get_number("00000000000000000000000000000000000").should be_blank
    end
    it "with prefix in () and first number is a 9" do
      MobileNumberNormalizer.get_number("(0160) 923 456 78 ").should == "004916092345678"
    end
    it "with prefix in () and first number is a 1" do
      MobileNumberNormalizer.get_number("(0160) 123 456 78 ").should == "004916012345678"
    end
    it "with . in the middle and first number is a 9" do
      MobileNumberNormalizer.get_number("0049176.92345678").should == "004917692345678"
    end
    it "with . in the middle and first number is a 1" do
      MobileNumberNormalizer.get_number("0049176.12345678").should == "004917612345678"
    end
    it "with a Tel string in the middle of two numbers" do
      MobileNumberNormalizer.get_number("017746 12345    Tel: 0221 1234567").
        should == "00491774612345"
    end
    it "with a prefix of Mobil:" do
      MobileNumberNormalizer.get_number(" Mobil:015712345678 ").should == "004915712345678"
    end
    it "with a - in the middle and spaces between numbers" do
      MobileNumberNormalizer.get_number(" 0172 - 12 345 67").should == "00491721234567"
    end
    it "with a ´ in the middle" do
      MobileNumberNormalizer.get_number("004917´12345678").should == "00491712345678"
    end
    it "with a o as 0" do
      MobileNumberNormalizer.get_number("o1721234567").should == "00491721234567"
    end
    it "without a 0 at front" do
      MobileNumberNormalizer.get_number("163/1234567").should == "00491631234567"
    end
    it "with two ++ in the front" do
      MobileNumberNormalizer.get_number("++491601234567").should == "00491601234567"
    end
    it "with * in it to blank" do
      MobileNumberNormalizer.get_number("0049176******").should == ""
    end
    it "with a ^ at the end" do
      MobileNumberNormalizer.get_number("004915212345678^").should == "004915212345678"
    end
    it "with a & in the middle" do
      MobileNumberNormalizer.get_number("0049162&1234567").should == "00491621234567"
    end
    it "without 00 in the area prefix" do
      MobileNumberNormalizer.get_number("49 1 768 123 4567").should == "004917681234567"
    end
    it "with a prefix that is seperated with /" do
      MobileNumberNormalizer.get_number("/0157/ 923-456-78").should == "004915792345678"
    end
    xit "with a prefix that is seperated with / and a number starting with 1" do
      MobileNumberNormalizer.get_number("/0157/ 123-456-78").should == "004915712345678"
    end
    it "with %§$= to blank" do
      MobileNumberNormalizer.get_number("0049173%§$=").should == ""
    end
    it "with numbers seperated with spaces" do
      MobileNumberNormalizer.get_number("+44 742 123 4567").should == "00447421234567"
    end
    it "with two numbers sperated by / " do
      MobileNumberNormalizer.get_number("015771234567 / 0031611234567").should == "004915771234567"
    end
    it "with one number in ()" do
      input = "0177-1234567 (001-123-456-7890)"
      MobileNumberNormalizer.get_number(input).should == "00491771234567"
    end
    it "with many spaces in the middle" do
      MobileNumberNormalizer.get_number("030/ 123 45 67      (0176 1234567)").
        should == "00491761234567"
    end
    it "with prefox Mobil Nr." do
      MobileNumberNormalizer.get_number("Mobil Nr. 0177-1234567").should == "00491771234567"
    end
    it "with two numbers sperated by space" do
      MobileNumberNormalizer.get_number("06131-1234567 0174-1234567").should == "00491741234567"
    end
    it "with two prefixed numbers" do
      MobileNumberNormalizer.get_number("Handy: 01731234567 Tel.: 1234567").
        should == "00491731234567"
    end
    it "with two numbers sperated by /" do
      MobileNumberNormalizer.get_number("0049 1631234567 / 0031 123456789").
        should == "00491631234567"
    end
    it "with two numbers sperated by / and spaces" do
      MobileNumberNormalizer.get_number("030 123 456 78 / 0162 123 4567").should == "00491621234567"
    end
    it "with two numbers sperated by /" do
      MobileNumberNormalizer.get_number("015212345678 / 017612345678").should == "004917612345678"
    end
    it "with two numbers sperated by 0" do
      MobileNumberNormalizer.get_number("030 12345678 0 0176 12345678").should == "004917612345678"
    end
    it "with a area prefix in ()" do
      MobileNumberNormalizer.get_number("(+49)176-12345678").should == "004917612345678"
    end
    it "with two numbers and postfixes in ()" do
      MobileNumberNormalizer.get_number("+493012345678 () / +4915712345678 (0)").
        should == "0049157123456780"
    end
    it "with three numbers seperated by //" do
      MobileNumberNormalizer.get_number("0221/1234567 // 0160/12345678//0151/12345678").
        should == "004915112345678"
    end
    it "with a /[:space:] in it" do
      MobileNumberNormalizer.get_number("0049/ 17612345678").
        should == "004917612345678"
    end
    it "with two numbers and a ) at the end" do
      MobileNumberNormalizer.get_number("02323 123456 ) 0173 1234567 )").
        should == "00491731234567"
    end
    it "without 00 at the beginning of area prefix" do
      MobileNumberNormalizer.get_number("420771234567").
        should == "00420771234567"
    end
    it "with two numbers seperated by a ." do
      MobileNumberNormalizer.get_number("02233 / 923456 . 0172 / 9234567").
        should == "00491729234567"
    end
    xit "with two numbers seperated by a ." do
      MobileNumberNormalizer.get_number("02233 / 123456 . 0172 / 1234567").
        should == "00491721234567"
    end
    it "with two numbers seperated by a 0" do
      MobileNumberNormalizer.get_number("0531 1234567 0 0173 1234567").
        should == "00491731234567"
    end
    it "with two numbers seperated by a ;" do
      MobileNumberNormalizer.get_number("0049 176 12345678; 0043 6712345678").
        should == "004917612345678"
    end
    it "give number for 123456" do
      MobileNumberNormalizer.get_number("123456").
        should be_blank
    end
  end
  describe "area codes" do
    it "should accept right area code" do
      MobileNumberNormalizer.get_number("0018091234567111").should == "0018091234567111"
    end
    it "should reject wrong area code" do
      MobileNumberNormalizer.get_number("0018091234567111").should == "0018091234567111"
    end
  end
end
