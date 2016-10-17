require "data_builder/version"

require "data_reader"

module DataBuilder
  extend DataReader

  class << self
    attr_accessor :data_source

    def default_data_path
      'data'
    end
  end

  def data_about(key, specified = {})
    if key.is_a?(String) && key.match(%r{/})
      file, record = key.split('/')
      DataBuilder.load("#{file}.yml")
    else
      record = key.to_s
      DataBuilder.load(builder_source) unless DataBuilder.data_source
    end

    data = DataBuilder.data_source[record]
    raise ArgumentError, "Undefined key for data: #{key}" unless data

    data.merge(specified).clone
  end

  alias data_from data_about
  alias data_for data_about
  alias using_data_for data_about
  alias using_data_from data_about

  private

  def builder_source
    ENV['DATA_BUILDER_SOURCE'] ? ENV['DATA_BUILDER_SOURCE'] : 'default.yml'
  end
end
