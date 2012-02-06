def data_file_as_string(filename)
  File.read(File.join(File.dirname(__FILE__),'../lib/data/' + filename))
end