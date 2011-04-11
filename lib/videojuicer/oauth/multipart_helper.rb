module Videojuicer
  module OAuth
    class Multipart
      include Enumerable

      # Initialize a Multipart object
      #
      # @param [#each] params
      #
      # @return [undefined]
      #
      # @api private
      def initialize(params = {})
        @params = []
        process_params(params)
      end

      # Iterate over each parameter pair
      #
      # @example
      #   multipart = Multipart.new(params)
      #   multipart.each { |key, value| ... }
      #
      # @yield [key, value]
      #
      # @yieldparam [#to_s] key
      #   the parameter key
      # @yieldparam [Object] value
      #   the parameter value
      #
      # @return [self]
      #
      # @api public
      def each(&block)
        @params.each(&block)
        self
      end

    private

      # Recursively build a list of parameters from a nested Hash
      #
      # @param [#each] params
      #   the pair of parameter keys
      # @param [#to_s] prefix
      #   optional prefix to each parameter key
      #
      # @return [undefined]
      #
      # @api private
      def process_params(params, prefix = nil)
        params.each do |key, value|
          param_key = prefix ? "#{prefix}[#{key}]" : key.to_s

          if value.respond_to?(:path)
            append_file(param_key, value)
          else
            case value
              when Hash  then append_hash(param_key, value)
              when Array then append_array(param_key, value)
              else            append_object(param_key, value)
            end
          end
        end
      end

      # Append the nested hash parameters
      #
      # @param [#to_s] prefix
      #
      # @param [Hash] hash
      #
      # @return [undefined]
      #
      # @api private
      def append_hash(prefix, hash)
        process_params(hash, prefix)
      end

      # Append the nested array parameters
      #
      # @param [#to_s] prefix
      #
      # @param [Array] array
      #
      # @return [undefined]
      #
      # @api private
      def append_array(prefix, array)
        array.each_with_index do |value, index|
          @params << [ "#{prefix}[#{index}]", value ]
        end
      end

      # Append the file parameter
      #
      # @param [#to_s] key
      #
      # @param [#read] file
      #
      # @return [undefined]
      #
      # @api private
      def append_file(key, file)
        filename     = file.path
        content_type = MIME::Types.type_for(filename).first

        @params << [ key, UploadIO.new(file, content_type, filename) ]
      end

      # Append the parameter
      #
      # @param [#to_s] key
      #
      # @param [Object] object
      #
      # @return [undefined]
      #
      # @api private
      def append_object(key, object)
        @params << [ key, object ]
      end

    end # module Multipart
  end # module OAuth
end # module Videojuicer
