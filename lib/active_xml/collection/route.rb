module ActiveXML
  class Collection
    class Route
      attr_reader :keys

      def initialize(route, node)
        @route = "#{route.clone}"
        @keys = route_to_keys
        @node = node
        @cache = Hash.new
      end

      def to_hash
        { read(@keys[0]) => [generate] }
      end

      def generate
        @keys.each do |key|
          @route.gsub!(":#{key}", read(key))
        end

        "#{@route}.xml"
      end

      private

      def read(key)
        @cache[key] || (@cache[key] = @node.search(key.to_s).first.try(:content))
      end

      def route_to_keys
        @route.scan(/:[^\/]+/).map{|key| key.gsub(":", "").to_sym}
      end
    end
  end
end