# HTML DSL

## Installation

1. Install git
   https://git-scm.com/
   Follow installation instructions.

2. Install ruby
   https://www.ruby-lang.org/en/
   version 3.0 or higher.

3. Install rspec gem in ordeer to be able to run tests
   ```gem install rspec```

## Run tests
```rspec v1/specs/table_spec.rb```

## V1
### Usage examples:
```ruby
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
        collspan 2
        rowspan 3
    end

    table.to_html
```


## V2
### Usage examples:

```ruby
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

table.to_html
```

old v1 syntax support:

```ruby
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

table.to_html
```

For more details and examples refer to ```v1/specs``` and ```v2/specs``` folders.
