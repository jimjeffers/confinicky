require 'helper'

class TestConfinicky < MiniTest::Test

  def setup
    @shell_file = Confinicky::ShellFile.new(file_path: 'test/sample_bash_file.sh')
  end

  def test_shell_file_duplicates
    assert_equal 1, @shell_file.find_duplicates.length
  end

  def test_exports_without_assignments
    assert_includes @shell_file.lines, "export DISPLAY\n"
  end

  def test_detects_exports_with_assignment
    assert_equal 18, @shell_file.exports.length
  end

  def test_detects_aliases_with_assignment
    assert_equal 32, @shell_file.aliases.length
  end

end