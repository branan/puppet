require 'puppet/indirector/yaml'
require 'puppet/resource/catalog'

class Puppet::Resource::YamlStoreconfigs < Puppet::Indirector::Yaml
  desc "Read resource instances from cached catalogs"

  def search(request)
    catalog_dir = File.join(Puppet.run_mode.master? ? Puppet[:yamldir] : Puppet[:clientyamldir], 'catalog', '*')
    puts request.options[:filter].inspect
    results = Dir.glob(catalog_dir).collect { |file|
      catalog = YAML.load_file(file)
      if catalog.name == request.options[:host]
        next
      end
      catalog.resources.select { |resource|
        filter = request.options[:filter]
        if filter && filter.size != 3 && filter.size != 0
          raise "Only single-clause filters are allowed"
        end
        if filter.size == 3
          if filter[0] != "tag"
            raise "Only tag filters are allowed"
          end
          if filter[1] == "=="
            filter_passed = resource.tagged?(filter[2])
          elsif filter[1] == "!="
            filter_passed = !resource.tagged?(filter[2])
          elsif
            raise "Unknown filter op: #{filter[1]}"
          end
        else
          filter_passed = true
        end
        resource.type == request.key && resource.exported && filter_passed
      }.map! { |res|
        data_hash = res.to_data_hash
        parameters = data_hash['parameters'].map do |name, value|
          Puppet::Parser::Resource::Param.new(:name => name, :value => value)
        end
        attrs = {:parameters => parameters, :scope => request.options[:scope]}
        result = Puppet::Parser::Resource.new(res.type, res.title, attrs)
        result.collector_id = "#{catalog.name}|#{res.type}|#{res.title}"
        result
      }
    }.flatten.compact
    results
  end
end
