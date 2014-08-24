require 'fileutils'
require 'helper'

class TestCommandGroups < MiniTest::Test

  def setup
    Confinicky::ConfigurationFile.force_config!({
      files: {
        aliases: "test/sample_bash_file.sh",
        env: "test/sample_bash_file.sh"
      }
    })
    @aliases = Confinicky::Controllers::Aliases.new
    @exports = Confinicky::Controllers::Exports.new
    @less='\'-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...\''
  end

  def test_clean_file
    @exports.clean!
    assert_equal 17, @exports.length
  end

  def test_shell_file_duplicates
    assert_equal 1, @exports.duplicates.length
  end

  def test_add_var
    @exports.set!("NEW_VAR=12345")
    assert_equal 19, @exports.length
  end

  def test_add_alias
    @aliases.set!("home=cd ~")
    assert_equal 33, @aliases.length
  end

  def test_remove_var
    @exports.remove!("PATH")
    assert_equal 16, @exports.length
  end

  def test_remove_alias
    @aliases.remove!("debug")
    assert_equal 31, @aliases.length
  end

  def test_add_var_should_not_duplicate
    @exports.set!("NEW_VAR=12345")
    @exports.set!("NEW_VAR=123456")
    assert_equal 19, @exports.length
  end

  def test_whitespace
    @exports.set!("NEW_STRING=A String")
    assert_equal "\'A String\'", @exports.find(query: "NEW_STRING")[:value]
  end

  def test_multiline_statements
    assert_equal false, @exports.find(query: "LESS")[:value].nil?
    assert_equal @less, @exports.find(query: "LESS")[:value]
  end

end