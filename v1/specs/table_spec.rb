require 'rspec'
require_relative '../table'

RSpec.describe HtmlDsl::V1 do
  include HtmlDsl::V1

  context 'positive scenarios' do
    it 'creates a simple table' do
      table = create_table do
        rows 2
        columns 2
        headers 'Header 1', 'Header 2'
        add_row_data 'Data 1', 'Data 2'
        add_row_data 'Data 3', 'Data 4'
      end

      expected_html = <<-HTML
<table><tr><th>Header 1</th><th>Header 2</th></tr><tr><td>Data 1</td><td>Data 2</td></tr><tr><td>Data 3</td><td>Data 4</td></tr></table>
        HTML

      expect(table.to_html.strip).to eq(expected_html.strip)
    end

    it 'creates a styled table' do
      table = create_table do
        rows 2
        columns 2
        headers 'Header 1', 'Header 2'
        add_row_data 'Data 1', 'Data 2'
        add_row_data 'Data 3', 'Data 4'
        table_class 'styled-table'
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
        rows 2
        columns 2
        headers 'Header 1', 'Header 2'
      end

      expected_html = <<-HTML
<table><tr><th>Header 1</th><th>Header 2</th></tr><tr><td></td><td></td></tr><tr><td></td><td></td></tr></table>
      HTML

      expect(table.to_html.strip).to eq(expected_html.strip)
    end

    it 'creates table with all options' do
      table = create_table do
        rows 2
        columns 2
        headers 'Header 1', 'Header 2'
        width '600px'
        height '400px'
        border '1px solid black'
        cellpadding 1
        table_class 'table-class table-class2'
        row_class 'row-class row-class2'
        cell_class 'cell-class cell-class2'
      end

      expected_html = <<-HTML
<table width='600px' height='400px' border='1px solid black' cellpadding='1' class='table-class table-class2'>\
<tr><th>Header 1</th><th>Header 2</th></tr><tr class='row-class row-class2'>\
<td class='cell-class cell-class2'></td><td class='cell-class cell-class2'></td></tr>\
<tr class='row-class row-class2'><td class='cell-class cell-class2'></td><td class='cell-class cell-class2'></td></tr>\
</table>
      HTML

      expect(table.to_html.strip).to eq(expected_html.strip)
    end

    it 'creates table with all options for row and cell' do
      table = create_table do
        rows 2
        columns 2
        headers 'Header 1', 'Header 2'
        width 600
        height 400
        border '1px solid black'
        cellpadding 1
        table_class 'table-class table-class2'
        row_class 'row-class row-class2'
        cell_class 'cell-class cell-class2'
        collspan 2
        rowspan 3
      end

      expected_html = <<-HTML
<table width='600' height='400' border='1px solid black' cellpadding='1' class='table-class table-class2'>\
<tr><th>Header 1</th><th>Header 2</th></tr><tr class='row-class row-class2'>\
<td class='cell-class cell-class2' collspan='2' rowspan='3'></td>\
<td class='cell-class cell-class2' collspan='2' rowspan='3'></td></tr>\
<tr class='row-class row-class2'><td class='cell-class cell-class2' collspan='2' rowspan='3'></td>\
<td class='cell-class cell-class2' collspan='2' rowspan='3'></td></tr>\
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
