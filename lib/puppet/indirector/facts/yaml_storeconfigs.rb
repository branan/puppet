require 'puppet/indirector/facts/yaml'

class Puppet::Node::Facts::YamlStoreconfigs < Puppet::Node::Facts::Yaml

  def find(request)
    nil
  end

end
