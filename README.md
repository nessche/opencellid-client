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

Read functionality (i.e. methods that only query the database generally do not require an API key), write methods instead
do require an API key, so if you do not have one, head to the [OpenCellID website](http://www.opencellid.org/) and get one
for yourself.

Initialize the main Opencellid object with the API key (if any)

`opencellid = Opencellid::Opencellid.new`

or

`opencellid = Opencellid::Opencellid.new my_key`

and then invoke methods on the object you just created, parameters are passed in as a hash, and the response will be of type
Opencellid::Response.