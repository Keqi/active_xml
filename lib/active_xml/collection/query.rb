module ActiveXML
  class Collection
    class Query < Collection
      def initialize(path, where_values)
        super(path)
        @where_key   = where_values.keys.first
        @where_value = where_values.values.first
      end

      private

      def each
        xml.child.elements.each do |elem|
          yield(elem) if in_where?(elem)
        end
      end

      def in_where?(elem)
        if @where_value.is_a?(Array)
          @where_value.any?{|object| fetch_contents(elem.elements, @where_key).first == object.to_s}
        else
          fetch_contents(elem.elements, @where_key).first == @where_value.to_s
        end
      end
    end
  end
end