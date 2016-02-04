require 'puppet/indirector/catalog/yaml'

class Puppet::Resource::Catalog::YamlStoreconfigs < Puppet::Resource::Catalog::Yaml

  def find(request)
    nil
  end

end
