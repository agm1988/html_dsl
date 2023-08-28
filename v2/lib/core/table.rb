require_relative '../exceptions/invalid_input_exception.rb'
require_relative './row.rb'

module HtmlDsl
  module V2
    module Lib
      module Core
        module Table
          class RTable
            include V2::Lib::Core::Row

            # Add attributes to this static dictionary to add new attributes to table
            AVAILABLE_TABLE_CSS_ATTRIBUTES = %i[width height border cellpadding css_class].freeze

            AVAILABLE_TABLE_METHODS = %i[rows columns table_class row_class cell_class].freeze

            TABLE_ATTRIBUTES_EXCEPTIONS_MAPPER = {
              css_class: 'class'.freeze,
              table_class: 'class'.freeze
            }.freeze

            def initialize(&block)
              @headers = []
              @internal_rows = []
              @rows_input = []
              instance_eval(&block) if block_given?
            end

            AVAILABLE_TABLE_CSS_ATTRIBUTES.each do |attribute|
              define_method(attribute) do |arg|
                instance_variable_set("@#{attribute}", arg)
              end
            end

            AVAILABLE_TABLE_METHODS.each do |attribute|
              define_method(attribute) do |arg|
                instance_variable_set("@#{attribute}", arg)
              end
            end

            def add_row(&block)
              @internal_rows << create_row(&block)
            end

            def add_row_data(*data)
              @rows_input << data
            end

            def headers(*data)
              @headers = data
            end

            def to_html
              # Comment exceptions check if rows count may be less that manually added rows
              # so in result there will be more rows than specified in dsl, and manually added data gets advantage.
              check_for_exceptions

              @rows && @columns ? process_rows_and_cols : process_only_data

              html = "<table"
              html += " class='#{@table_class}'" if @table_class
              html += apply_table_css_attributes
              html += ">"

              html += process_headers
              html += @internal_rows.map(&:to_html).join
              html += "</table>"

              html
            end

            private

            def check_for_exceptions
              raise Exceptions::InvalidInputException, 'Invalid input exception' if @rows && (@rows < @rows_input.size)
            end

            def process_rows_input
              r_class = @row_class
              @rows_input.each do |row_data|
                @internal_rows << create_row(row_data) do
                  css_class r_class
                end
              end
            end

            def apply_table_css_attributes
              AVAILABLE_TABLE_CSS_ATTRIBUTES.map do |attribute|
                next unless instance_variable_get("@#{attribute}")
                " #{TABLE_ATTRIBUTES_EXCEPTIONS_MAPPER[attribute] || attribute}='#{instance_variable_get("@#{attribute}")}'"
              end.join
            end

            def process_only_data
              @rows_input.each do |row_input|
                @internal_rows << create_row(row_input)
              end
            end

            def process_rows_and_cols
              r_class = @row_class
              c_class = @cell_class
              @rows.times do |row_index|
                @internal_rows << create_row(@rows_input[row_index] || Array.new(@columns)) do
                  css_class r_class
                  cell_class c_class
                end
              end
            end

            def process_headers
              return '' if @headers.none?

              headers_html = "<tr>"
                @headers.each do |header|
                  headers_html += "<th>#{header}</th>"
                end
              headers_html += "</tr>"

              headers_html
            end
          end

          def create_table(&block)
            RTable.new(&block)
          end
        end
      end
    end
  end
end
