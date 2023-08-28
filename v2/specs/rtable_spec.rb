require 'rspec'
require_relative '../html_elements'

RSpec.describe ::HtmlDsl::V2::HtmlElements do
  include HtmlDsl::V2::HtmlElements

  context 'create table with v2 features' do
    it 'creates a simple table' do
      table = create_table do
        headers 'Header 1', 'Header 2'
        css_class 'table-class table-class2'
        add_row do
          css_class 'row-class row-class2'
          add_cell do
            css_class 'cell-class cell-class2'
            data 'Some data'
          end
        end
        add_row
        add_row
      end

      expected_html = <<-HTML
<table class='table-class table-class2'><tr><th>Header 1</th><th>Header 2</th></tr><tr class='row-class row-class2'>\
<td class='cell-class cell-class2'>Some data</td></tr><tr></tr><tr></tr></table>
      HTML

      expect(table.to_html.strip).to eq(expected_html.strip)
    end

    it 'creates a styled table' do
      table = create_table do
        headers 'Header 1', 'Header 2'
        css_class 'styled-table'
        add_row do
          add_cell do
            data 'Data 1'
          end
          add_cell do
            data 'Data 2'
          end
        end
        add_row do
          add_cell do
            data 'Data 3'
          end
          add_cell do
            data 'Data 4'
          end
        end
      end

      expected_html = <<-HTML
      <table class='styled-table'><tr><th>Header 1</th><th>Header 2</th>\
</tr><tr><td>Data 1</td><td>Data 2</td></tr><tr><td>Data 3</td><td>Data 4</td></tr></table>
      HTML

      expect(table.to_html.strip).to eq(expected_html.strip)
    end

    it 'creates an empty table' do
      table = create_table do
        add_row do
          add_cell
          add_cell
        end
        add_row do
          add_cell
          add_cell
        end
      end

      expected_html = <<-HTML
<table><tr><td></td><td></td></tr><tr><td></td><td></td></tr></table>
      HTML

      expect(table.to_html.strip).to eq(expected_html.strip)
    end

    it 'creates table from rows and colls' do
      table = create_table do
        rows 2
        columns 2
      end

      expected_html = <<-HTML
<table><tr><td></td><td></td></tr><tr><td></td><td></td></tr></table>
      HTML

      expect(table.to_html.strip).to eq(expected_html.strip)
    end

    it 'creates an empty table with header' do
      table = create_table do
        headers 'Header 1', 'Header 2'
        add_row do
          add_cell
          add_cell
        end
        add_row do
          add_cell
          add_cell
        end
      end

      expected_html = <<-HTML
<table><tr><th>Header 1</th><th>Header 2</th></tr><tr><td></td><td></td></tr><tr><td></td><td></td></tr></table>
      HTML

      expect(table.to_html.strip).to eq(expected_html.strip)
    end

    it 'creates an empty table with header by rows and colls' do
      table = create_table do
        headers 'Header 1', 'Header 2'
        rows 2
        columns 2
      end

      expected_html = <<-HTML
<table><tr><th>Header 1</th><th>Header 2</th></tr><tr><td></td><td></td></tr><tr><td></td><td></td></tr></table>
      HTML

      expect(table.to_html.strip).to eq(expected_html.strip)
    end

    it 'creates table with all options' do
      table = create_table do
        headers 'Header 1', 'Header 2'
        width 600
        height 400
        border '1px solid black'
        cellpadding 1
        add_row do
          css_class 'row-class row-class2'
          add_cell do
            css_class 'cell-class cell-class2'
          end
          add_cell do
            css_class 'cell-class cell-class2'
          end
        end
        add_row do
          css_class 'row-class row-class2'
          add_cell do
            css_class 'cell-class cell-class2'
          end
          add_cell do
            css_class 'cell-class cell-class2'
          end
        end
        css_class 'table-class table-class2'
      end

      expected_html = <<-HTML
<table width='600' height='400' border='1px solid black' cellpadding='1' class='table-class table-class2'>\
<tr><th>Header 1</th><th>Header 2</th></tr><tr class='row-class row-class2'>\
<td class='cell-class cell-class2'></td><td class='cell-class cell-class2'></td></tr>\
<tr class='row-class row-class2'><td class='cell-class cell-class2'></td><td class='cell-class cell-class2'></td></tr>\
</table>
      HTML

      expect(table.to_html.strip).to eq(expected_html.strip)
    end
  end

  context 'v1 rows and columns support' do
    it 'creates a simple table' do
      table = create_table do
        headers 'Header 1', 'Header 2'
        table_class 'table-class table-class2'
        rows 2
        columns 1
        add_row_data 'Some data'
        row_class 'row-class row-class2'
        cell_class 'cell-class cell-class2'
      end

      expected_html = <<-HTML
<table class='table-class table-class2'><tr><th>Header 1</th><th>Header 2</th></tr>\
<tr class='row-class row-class2'><td class='cell-class cell-class2'>Some data</td></tr>\
<tr class='row-class row-class2'><td class='cell-class cell-class2'></td></tr></table>
      HTML

      expect(table.to_html.strip).to eq(expected_html.strip)
    end

    it 'creates a styled table' do
      table = create_table do
        headers 'Header 1', 'Header 2'
        css_class 'styled-table'
        add_row_data 'Data 1', 'Data 2'
        add_row_data 'Data 3', 'Data 4'
      end

      expected_html = <<-HTML
      <table class='styled-table'><tr><th>Header 1</th><th>Header 2</th>\
</tr><tr><td>Data 1</td><td>Data 2</td></tr><tr><td>Data 3</td><td>Data 4</td></tr></table>
      HTML

      expect(table.to_html.strip).to eq(expected_html.strip)
    end

    it 'creates an empty table' do
      table = create_table do
        rows 2
        columns 2
      end

      expected_html = <<-HTML
<table><tr><td></td><td></td></tr><tr><td></td><td></td></tr></table>
      HTML

      expect(table.to_html.strip).to eq(expected_html.strip)
    end

    it 'creates an empty table with header' do
      table = create_table do
        headers 'Header 1', 'Header 2'
        rows 2
        columns 2
      end

      expected_html = <<-HTML
<table><tr><th>Header 1</th><th>Header 2</th></tr><tr><td></td><td></td></tr><tr><td></td><td></td></tr></table>
      HTML

      expect(table.to_html.strip).to eq(expected_html.strip)
    end

    it 'creates table with all options' do
      table = create_table do
        headers 'Header 1', 'Header 2'
        width 600
        height 400
        border '1px solid black'
        cellpadding 1
        rows 2
        columns 2
        row_class 'row-class row-class2'
        cell_class 'cell-class cell-class2'
        table_class 'table-class table-class2'
      end

      expected_html = <<-HTML
<table class='table-class table-class2' width='600' height='400' border='1px solid black' cellpadding='1'>\
<tr><th>Header 1</th><th>Header 2</th></tr>\
<tr class='row-class row-class2'><td class='cell-class cell-class2'></td><td class='cell-class cell-class2'></td></tr>\
<tr class='row-class row-class2'><td class='cell-class cell-class2'></td><td class='cell-class cell-class2'></td></tr>\
</table>

        HTML

      expect(table.to_html.strip).to eq(expected_html.strip)
    end
  end

  context 'handling input exceptions' do
    it 'has less rows that data added' do
      table = create_table do
        rows 2
        columns 2
        headers 'Header 1', 'Header 2'
        add_row_data 'Data 1', 'Data 2'
        add_row_data 'Data 3', 'Data 4'
        add_row_data 'Data 5', 'Data 6'
      end

      expect { table.to_html }.to raise_error(Exceptions::InvalidInputException)
    end
  end
end
