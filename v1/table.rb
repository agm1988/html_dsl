require_relative './exceptions/invalid_input_exception.rb'

module HtmlDsl
  module V1
    class Table
      # Add attributes to this static dictionary to add new attributes to table
      AVAILABLE_TABLE_CSS_ATTRIBUTES = %i[width height border cellpadding table_class].freeze
      AVAILABLE_ROW_CSS_ATTRIBUTES = %i[row_class].freeze
      AVAILABLE_CELL_CSS_ATTRIBUTES = %i[cell_class collspan rowspan].freeze

      # Available table methods
      AVAILABLE_TABLE_METHODS = %i[rows columns].freeze

      METHODS_TO_DEFINE = [*AVAILABLE_TABLE_METHODS,
                            *AVAILABLE_TABLE_CSS_ATTRIBUTES,
                            *AVAILABLE_ROW_CSS_ATTRIBUTES,
                            *AVAILABLE_CELL_CSS_ATTRIBUTES].freeze

      # CSS attributes exceptions mappers
      TABLE_ATTRIBUTES_EXCEPTIONS_MAPPER = {
        table_class: 'class'.freeze
      }.freeze

      ROW_ATTRIBUTES_EXCEPTIONS_MAPPER = {
        row_class: 'class'.freeze
      }.freeze

      CELL_ATTRIBUTES_EXCEPTIONS_MAPPER = {
        cell_class: 'class'.freeze
      }.freeze

      def initialize(&block)
        @headers = []
        @data = []
        instance_eval(&block) if block_given?
      end

      METHODS_TO_DEFINE.each do |attribute|
        define_method(attribute) do |arg|
          instance_variable_set("@#{attribute}", arg)
        end
      end

      def add_row_data(*data)
        @data << data
      end

      def headers(*data)
        @headers = data
      end

      def to_html
        check_for_exceptions

        html = '<table'
        html += apply_table_css_attributes
        html += '>'
        html += process_headers

        # Fill in data
        # Process only data or just rows and colls for an empty table
        # TODO: refactor, think on better solution
        if @rows && @columns
          html += process_rows_and_cols
        else
          html += process_only_data
        end

        html += '</table>'
        html
      end

      private

      def check_for_exceptions
        raise Exceptions::InvalidInputException, 'Invalid input exception' if @rows < @data.size
      end

      def apply_table_css_attributes
        AVAILABLE_TABLE_CSS_ATTRIBUTES.map do |attribute|
          next unless instance_variable_get("@#{attribute}")
          " #{TABLE_ATTRIBUTES_EXCEPTIONS_MAPPER[attribute] || attribute}='#{instance_variable_get("@#{attribute}")}'"
        end.join
      end

      def apply_row_css_attributes
        AVAILABLE_ROW_CSS_ATTRIBUTES.map do |attribute|
          next unless instance_variable_get("@#{attribute}")
          " #{ROW_ATTRIBUTES_EXCEPTIONS_MAPPER[attribute] || attribute}='#{instance_variable_get("@#{attribute}")}'"
        end.join
      end

      def apply_cell_css_attributes
        AVAILABLE_CELL_CSS_ATTRIBUTES.map do |attribute|
          next unless instance_variable_get("@#{attribute}")
          " #{CELL_ATTRIBUTES_EXCEPTIONS_MAPPER[attribute] || attribute}='#{instance_variable_get("@#{attribute}")}'"
        end.join
      end

      def process_only_data
        rows_html = ''

        @data.each do |row|
          cells_html = ''
          row.each do |cell|
            cells_html += generate_cell(cell)
          end

          rows_html += generate_row(cells_html)
        end

        rows_html
      end

      # TODO: check maybe better to use array and then join, because string concatenation
      # maybe more expensive operations
      def process_headers
        return '' if @headers.none?

        headers_html = '<tr>'
        @headers.each do |header|
          headers_html += "<th>#{header}</th>"
        end
        headers_html += '</tr>'

        headers_html
      end

      def process_rows_and_cols
        rows_html = ''
        @rows.times do |row_index|
          cells_html = ''
          @columns.times do |col_index|
            cell_data = @data[row_index] ? @data[row_index][col_index] : nil

            cells_html += generate_cell(cell_data)
          end
          rows_html += generate_row(cells_html)
        end

        rows_html
      end

      # TODO: maybe extract to separate classes for row and cell
      def generate_row(cells_html)
        row_html = '<tr'
        row_html += apply_row_css_attributes
        row_html += '>'
        row_html += cells_html
        row_html += '</tr>'
        row_html
      end

      def generate_cell(cell_data)
        cell_html = '<td'
        cell_html += apply_cell_css_attributes
        cell_html += ">#{cell_data}</td>"
        cell_html
      end
    end

    def create_table(&block)
      Table.new(&block)
    end
  end
end
