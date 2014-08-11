require 'fileutils'
require 'helper'

class TestFileWriting < MiniTest::Test

  def setup
    FileUtils.cp 'test/sample_bash_file.sh', 'test/sample_bash_file.sh.tmp'
    @shell_file = Confinicky::ShellFile.new(file_path: 'test/sample_bash_file.sh.tmp')
  end

  def test_clean_file
    @shell_file.clean!
    assert_equal 17, @shell_file.exports.length
  end

  def test_add_var
    @shell_file.set!("NEW_VAR=12345")
    assert_equal 19, @shell_file.exports.length
  end

  def test_remove_var
    @shell_file.remove!("PATH")
    assert_equal 16, @shell_file.exports.length
  end

  def test_add_var_should_not_duplicate
    @shell_file.set!("NEW_VAR=12345")
    @shell_file.set!("NEW_VAR=123456")
    assert_equal 19, @shell_file.exports.length
  end

  def test_whitespace
    @shell_file.set!("NEW_STRING=A String")
    assert_equal 1, @shell_file.exports.delete_if{|i| i[1] != "\'A String\'"}.length
  end

  def teardown
    FileUtils.rm 'test/sample_bash_file.sh.tmp'
  end

end