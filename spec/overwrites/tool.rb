# frozen_string_literal: true

module MiniMagick
  class Tool
    # rubocop:disable Style/ClassVars
    def self.new(*args)
      instance = super(*args)

      if block_given?
        yield instance
      else
        instance
      end

      @@last_instance = instance
    end

    def call; end

    def self.last_instance
      @@last_instance
    end
    # rubocop:enable Style/ClassVars
  end
end
