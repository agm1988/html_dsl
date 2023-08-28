module HtmlDsl
  module V2
    module Lib
      module Core
        module Cell
          class RCell
            # Add new options here
            AVAILABLE_ATTRIBUTES = %i[css_class data].freeze

            def initialize(data = nil, &block)
              @data = data
              instance_eval(&block) if block_given?
            end

            AVAILABLE_ATTRIBUTES.each do |attribute|
              define_method(attribute) do |arg|
                instance_variable_set("@#{attribute}", arg)
              end
            end

            def to_html
              html = "<td"
              html += " class='#{@css_class}'" if @css_class
              html += ">#{@data}</td>"
              html
            end
          end

          def create_cell(data = nil, &block)
            RCell.new(data, &block)
          end
        end
      end
    end
  end
end

