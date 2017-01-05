require 'puppet/resource/catalog'
require 'puppet/indirector/json_xor'

class Puppet::Resource::Catalog::Json_xor < Puppet::Indirector::JSON_xor
  desc "Store catalogs as flat files, serialized using 'encrypted' JSON."
end
