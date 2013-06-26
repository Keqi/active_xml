module ActiveXML
  class Collection
    include ActiveXML
    include Enumerable

    def pluck(key)
      map do |elem|
        fetch_contents(elem.elements, key).first
      end
    end

    def where(where_values)
      raise ArgumentError.new("Passing more then 1 where value is currently not possible") if where_values.size > 1
      Query.new(@path, where_values)
    end

    def split(route_path)
      hash = Hash.new

      each do |elem|
        route = Route.new(route_path, elem)
        hashed_path = route.to_hash
        path = Pathname.new(hashed_path.values[0])
        create_file(path, elem.to_xml)
        hash.merge!(hashed_path) { |key,old,new| old.class == Array ? old << new[0] : [new,old] }
      end

      hash
    end

    def split_to_array(route_path)
      map do |elem|
        route = Route.new(route_path, elem)
        path = Pathname.new(route.generate)
        create_file(path, elem.to_xml)
        path
      end
    end

    def delete_nodes(keys)
      keys.each { |key| xml.search(key).first.remove }
    end

    private

    def root 
      "objects"
    end

    def each(&block)
      xml.child.elements.each(&block)
    end
  end
end
