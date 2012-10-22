# -*- encoding : utf-8 -*-
##
# Normalize Mobile Numbers
#
# @author dmasur
class MobileNumberNormalizer
  ##
  # Minimal Length of a Mobile Number
  # 0049 => 4
  # 177  => 3
  # xxxxxx => minimal 4
  #
  # @author dmasur
  MIN_MOBILE_NUMBER_LENGTH = 11
  ##
  # Array of String of International Area Codes
  #
  # @author dmasur
  @@valid_area_codes = [ '001', '001809', '0020', '00212', '00213', '00216', '00218',
                                    '00220', '00221', '00222', '00223', '00224', '00225', '00226',
                                    '00227', '00228', '00229', '00230', '00231', '00232', '00233',
                                    '00234', '00235', '00236', '00237', '00238', '00239', '00240',
                                    '00241', '00242', '00243', '00244', '00245', '00247', '00248',
                                    '00249', '00250', '00251', '00252', '00253', '00254', '00255',
                                    '00256', '00257', '00258', '00260', '00261', '00262', '00263',
                                    '00264', '00265', '00266', '00267', '00268', '00269', '0027',
                                    '00290', '00291', '00297', '00298', '00299', '0030', '0031',
                                    '0032', '0033', '0034', '00350', '00351', '00352', '00353',
                                    '00354', '00355', '00356', '00357', '00358', '00359', '0036',
                                    '00370', '00371', '00372', '00373', '00376', '00378', '0038',
                                    '00385', '00387', '00389', '0039', '00396', '0040', '0041',
                                    '0042', '0043', '0044', '0045', '0046', '0047', '0048', '00500',
                                    '00501', '00502', '00503', '00504', '00505', '00506', '00507',
                                    '00508', '00509', '0051', '0052', '0053', '0054', '0055',
                                    '0056', '0057', '0058', '00590', '00591', '00592', '00593',
                                    '00594', '00595', '00596', '00597', '00598', '00599', '0060',
                                    '0061', '0062', '0063', '0064', '0065', '0066', '00670',
                                    '00671', '00673', '00674', '00675', '00676', '00677', '00678',
                                    '00679', '00680', '00682', '00684', '00685', '00686', '00687',
                                    '00689', '00691', '00692', '007', '0081', '0084', '00850',
                                    '00852', '00853', '00855', '00856', '0086', '00880', '00886',
                                    '0090', '0091', '0092', '0094', '0095', '00960', '00961',
                                    '00962', '00963', '00964', '00965', '00966', '00967', '00968',
                                    '00971', '00972', '00973', '00974', '00975', '00976', '00977',
                                    '0098', '00994' ]
  def self.valid_area_codes=(new_valid_area_codes)
    @@valid_area_codes = new_valid_area_codes
  end

  def self.valid_area_codes
    @@valid_area_codes
  end

  def initialize(mobile_number, valid_area_codes = [])
    @mobile_number = mobile_number
  end

  ##
  # Return the correct mobile number as Class
  #
  # @author dmasur
  def self.get_number number
    number = new(number).get_number
    return number
  end

  ##
  # Return the correct mobile number
  #
  # @author dmasur
  def get_number
    org_num = @mobile_number
    #puts "Full Number: #{@mobile_number}"
    correct_typos_in_mobile_number
    #puts "Typofix: #{@mobile_number}"
    filter_part
    #puts "After Filter: #{@mobile_number}"
    clean_mobile_number
    #puts "After clean: #{@mobile_number}"
    mobile_number = "" unless has_valid_area_code?
    return @mobile_number
  end

  ##
  # Normalize mobile number
  #
  # @author dmasur
  def clean_mobile_number
    @mobile_number = MobileNumberNormalizer.clean_number @mobile_number
  end

  ##
  # Try to fix typos in the mobile number
  #
  # @author dmasur
  def correct_typos_in_mobile_number
    @mobile_number.strip!
    @mobile_number.gsub!(/[ßo]/, '0')
    @mobile_number.gsub!(/[\(\)\.]/, '')
    @mobile_number.gsub!(/\s(\d{2})\s/, '\1')
    @mobile_number.gsub!(/[a-zA-Z\-]/, '')
  end

  ##
  # Try to guess the right part of the mobile number
  #
  # @author dmasur
  def filter_part
    good_guess = nil
    #puts splits
    splits.each do |split|
      good_guess = split if MobileNumberNormalizer.looks_like_a_mobile_number(split.strip)
    end
    #puts "Guess: #{good_guess}"
    @mobile_number = good_guess unless good_guess.blank?
  end

  ##
  # Split the number in uniq Parts
  #
  # @return [Array] Possible Numbers
  # @author dmasur
  def splits
    split_chars = [/\s/,/\s{2}/, ':', ',', '/', '//', ')', '.', ' 0 ', ';']
    return split_chars.map { |split_char| @mobile_number.split(split_char) }.flatten.uniq
  end

  ##
  # Determinate if the number could be a mobile number
  #
  # @param [String] number Mobile number
  # @return [Boolean] is valild number?
  # @author dmasur
  def self.looks_like_a_mobile_number number
    if !number.blank?
      #puts "Dirty Part: #{number}"
      clean_number = MobileNumberNormalizer.clean_number(number)
      #puts "Clean Part: #{number}: #{clean_number}"
      if !clean_number.blank? && clean_number.length > MIN_MOBILE_NUMBER_LENGTH
        #puts "Nice Part: #{number}"
        return /^00491/ =~ clean_number
      end
    end
  end

  ##
  # Clean a mobile number
  #
  # @param [String] mobile_number Mobile Number
  # @return [String] Mobile Number
  # @author dmasur
  def self.clean_number mobile_number
    mobile_number.strip!
    mobile_number = replace_prefix mobile_number
    #puts mobile_number
    mobile_number = remove_superflouid_chars mobile_number
    #puts mobile_number
    mobile_number = "0049#{mobile_number[1..-1]}" if /^0[1-9]/ =~ mobile_number
    delete_invalid_numbers mobile_number
  end

  ##
  # Deletes the number if it is invalid
  #
  # @param [String] mobile_number Mobile Number
  # @return [String] Mobile Number
  # @author dmasur
  def self.delete_invalid_numbers mobile_number
    mobile_number = "" unless mobile_number.length.between?(MIN_MOBILE_NUMBER_LENGTH, 20)
    mobile_number = "" if /^[^0]/ =~ mobile_number
    return mobile_number
  end

  def has_valid_area_code?
    self.class.valid_area_codes.any? do |area_code|
      Regexp.new("^#{area_code}") =~ @mobile_number
    end
  end
  ##
  # Replace the different number prefix
  #
  # @param [String] mobile_number Mobile Number
  # @return [String] Mobile Number
  # @author dmasur
  def self.replace_prefix mobile_number
    mobile_number = "0#{mobile_number}" if /^1/ =~ mobile_number
    mobile_number.sub!(/^49/, '0049')
    mobile_number.sub!(/\+/, '00')
    valid_area_codes.each do |area_code|
      if mobile_number.start_with?(area_code[2..-1])
        mobile_number = "00#{mobile_number}"
      end
    end
    return mobile_number
  end

  ##
  # Removed support characters in numbers
  #
  # @return [String] Mobile *Number*
  # @author dmasur
  def self.remove_superflouid_chars mobile_number
    mobile_number.gsub!(/[\(\)\.:´+*^&]/,'')
    mobile_number.gsub! /[^0-9]*/, ''
  end
end
