module Hefted
  class MissingKeysError < StandardError; end
  class MissingValuesError < StandardError; end

  class Argument
    using Hefted::Refine

    def initialize(**args)
      @name = args.fetch(:name)
      @join = args.fetch(:join, nil)
      @first = args.indexer!(:first)[:first]
      @members = args[:members] || args.select { |key, value| !%i(name join).include?(key) }
    end

    def name
      @name.to_camel
    end

    def keys
      case @members
      when Array
        raise MissingKeysError if @members.include?(nil)
        @members
      when Hash
        @members.keys
      else
        raise MissingKeysError
      end.map(&:to_sym)
    end

    def values
      case @members
      when Array
        @members.map.with_index(@first) { |key, i| i }
      when Hash
        raise MissingValuesError if @members.has_value?(nil)
        @members.values
      else
        raise MissingValuesError
      end
    end

    def join?
      !!@join
    end

    def joins
      @join.map(&:to_camel)
    end
  end
end
