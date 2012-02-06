OpenCellID Client Library
=========================

`opencellid-client` is a ruby gem that aims at simplifying the usage of the APIs provided by opencellid.org to transform cell IDs into coordinates.

Installing
----------

Simply install the gem to your system

`gem install opencellid-client`

or if you are using Bundler add it to your gemspec file and run `bundle install`.

Usage
-----

First of all `require 'opencellid'` in your application.

Read functionality (i.e. methods that only query the database) generally do not require an API key, write methods instead
do require an API key, so if you do not have one, head to the [OpenCellID website](http://www.opencellid.org/) and get one
for yourself.

Initialize the main Opencellid object with the API key (if any)

`opencellid = Opencellid::Opencellid.new`

or

`opencellid = Opencellid::Opencellid.new my_key`

and then invoke methods on the object just created. The return values of all methods is of type `Response`. invoking method
`ok?` verifies that the response is a successful one. If the response is successful, method-dependent results can be
got from the response, otherwise an error object can be extracted from the response and the use its `code` and `info`
methods to obtain the error code and human readable description.

Querying Cells
--------------

Cells can be queried using a combination of parameters: the cell id, the mnc (operator) and mcc (country) code or the local area
code lac. For a more detailed description of these parameters please refere to the OpenCellID site.

Parameters are first set into a `Cell` object and then the object is passed to the method. E.g. to query for
the position of the cell with id 123000, mnc 5 and mcc 244

`target_cell = Cell.new(123000,244,5,nil
response = opencellid.get_cell(target_cell)
result_cell = response.cells[0]`

similarly to query for the measures related to the same cell

`target_cell = Cell.new(123000,244,5,nil
 response = opencellid.get_cell_measures(target_cell)
 result_cell = response.cells[0]
 measures = result.cell.measures`

Finally to query for cells in a bounding box, a BBox object must provided. In addition to that, the set of results can
be limited by number, by mcc or by mnc code by specifying respectively the `:limit`,`:mcc` and `:mnc` keys of the options
hash.

To get the first 10 cells belonging to operator whose mnc code is 5 within the bounding box the code is the following

`bbox = BBox.new(30.0,40.0,60.0,70.0)
response = opencellid.get_cells_in_area(bbox, :limit => 10, :mnc => 5)
cells = response.cells`

Adding and Deleting Measures
----------------------------

Adding, deleting and listing "own" measures (i.e. measures inserted by the same user) require that an API key is
made available to the library at initialization time.

Measure can be added by providing a cell object identifying the cell to which the measure refers to, and a measure containing
the actual measure details.

`target_cell = Cell.new(123000,244,5,9000)
measure = Measure.new(30.0,60.0,Time.now)
measure.signal = 15
response = opencellid.add_measure(target_cell,measure)`

The response object will contain the cell id and the measure id. Using the measure id it is later on possible to delete
the measure, if so desired

`response = opencellid.delete_measure(measure_id)

Measure Ids can also be obtained by listing all the measures belonging to the user whose API key has been provided to the
library

`response = opencellid.list_measures
measures = response.measures`


Bulk addition of measures
-------------------------

Bulk addition of measure by uploading a CSV formatted file to the OpenCellID server is not yet supported by this library.
