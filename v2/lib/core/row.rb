require_relative './cell.rb'

module HtmlDsl
  module V2
    module Lib
      module Core
        module Row
          class RRow
            include V2::Lib::Core::Cell

            AVAILABLE_ATTRIBUTES = %i[css_class cell_class align bgcolor id style tabindex title valign].freeze

            def initialize(row_input = [], &block)
              @cells_data = []
              @row_input = row_input
              instance_eval(&block) if block_given?
            end

            AVAILABLE_ATTRIBUTES.each do |attribute|
              define_method(attribute) do |arg|
                instance_variable_set("@#{attribute}", arg)
              end
            end

            def add_cell(&block)
              @cells_data << create_cell(&block)
            end

            def add_cells(&block)
              @cells_data << create_cell(&block)
            end

            def to_html
              process_row_data

              html = "<tr"
              html += " class='#{@css_class}'" if @css_class
              html += ">"
              html += @cells_data.map(&:to_html).join
              html += "</tr>"
              html
            end

            private

            def process_row_data
              c_class = @cell_class
              @row_input.each do |cell_data|
                @cells_data << create_cell(cell_data) do
                  css_class c_class
                end
              end
            end
          end

          def create_row(row_data = [], &block)
            RRow.new(row_data, &block)
          end
        end
      end
    end
  end
end


