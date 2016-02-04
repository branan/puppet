require 'puppet/indirector/node/yaml'

class Puppet::Node::YamlStoreconfigs < Puppet::Node::Yaml

  def find(request)
    nil
  end

end
