require 'helper'

class TestCommandParser < MiniTest::Test

  def setup
    @line = 'HOST="http://www.example.com"'
    @alias = 'alias ..=\'cd ../\''
    @export = 'export TEST=1234'
    @no_expression = 'export DISPLAY'
  end

  def test_should_recognize_a_general_line
    assert_equal true, Confinicky::Parsers::Command.new(line: @line).line?
  end

  def test_should_recognize_an_export
    assert_equal true, Confinicky::Parsers::Command.new(line: @export).export?
  end

  def test_should_recognize_an_alias
    assert_equal true, Confinicky::Parsers::Command.new(line: @alias).alias?
  end

  def test_should_not_report_a_line_as_an_export
    assert_equal false, Confinicky::Parsers::Command.new(line: @line).export?
  end

  def test_should_not_report_a_line_as_an_alias
    assert_equal false, Confinicky::Parsers::Command.new(line: @line).alias?
  end

  def test_should_not_report_an_export_as_a_line
    assert_equal false, Confinicky::Parsers::Command.new(line: @export).line?
  end

  def test_should_not_report_an_alias_as_a_line
    assert_equal false, Confinicky::Parsers::Command.new(line: @alias).line?
  end

  def test_should_recognize_any_line_without_an_expression_as_a_line
    assert_equal true, Confinicky::Parsers::Command.new(line: @no_expression).line?
  end

end