require File.join(File.dirname(__FILE__), "..", "lib", "mms2r")
require File.join(File.dirname(__FILE__), "test_helper")
require 'test/unit'
require 'rubygems'
require 'mocha'
gem 'tmail', '>= 1.2.1'
require 'tmail'

class TestTmobileNet < Test::Unit::TestCase
  include MMS2R::TestHelper

  def test_ignore_simple_image
    mail = TMail::Mail.parse(load_mail('tmobile-image-01.mail').join)
    mms = MMS2R::Media.new(mail)

    assert_equal 1, mms.media.size
    assert_nil mms.media['text/plain']
    assert_nil mms.media['text/html']
    assert_not_nil mms.media['image/jpeg'][0]
    assert_match(/12-01-06_1234.jpg$/, mms.media['image/jpeg'][0])

    assert_file_size mms.media['image/jpeg'][0], 337

    mms.purge
  end
  
  def test_message_with_body_text
    mail = TMail::Mail.parse(load_mail('tmobile-image-02.mail').join)
    mms = MMS2R::Media.new(mail)
    
    assert_equal 2, mms.media.size
    assert_not_nil mms.media['text/plain']
    assert_nil mms.media['text/html']
    assert_not_nil mms.media['image/jpeg'][0]
    assert_match(/07-25-05_0935.jpg$/, mms.media['image/jpeg'][0])
    
    assert_file_size mms.media['image/jpeg'][0], 337
    
    file = mms.media['text/plain'][0]
    assert_not_nil file
    assert File::exist?(file), "file #{file} does not exist"
    text = IO.readlines("#{file}").join
    assert_equal "Lillies", text.strip
    
    mms.purge
  end
end