require 'csv2hash/version'
require 'csv2hash/definition'
require 'csv2hash/validator'
require 'csv2hash/validator/mapping'
require 'csv2hash/validator/collection'
require 'csv2hash/parser'
require 'csv2hash/parser/mapping'
require 'csv2hash/parser/collection'
require 'csv'

class Csv2hash

  attr_accessor :definition, :file_path, :data, :data_source

  def initialize definition, file_path
    @definition, @file_path = definition, file_path
    dynamic_parser_loading
    dynamic_validator_loading
  end

  def parse
    definition.validate!
    definition.default!
    validate_data!
    fill!
    @data
  end

  protected

  def data_source
    @data_source ||= CSV.read @file_path
  end

  private

  def dynamic_validator_loading
    case definition.type
    when Csv2Hash::Definition::MAPPING
      self.extend Csv2Hash::Validator::Mapping
    when Csv2Hash::Definition::COLLECTION
      self.extend Csv2Hash::Validator::Collection
    end
  end

  def dynamic_parser_loading
    case definition.type
    when Csv2Hash::Definition::MAPPING
      self.extend Csv2Hash::Parser::Mapping
    when Csv2Hash::Definition::COLLECTION
      self.extend Csv2Hash::Parser::Collection
    end
  end

end
