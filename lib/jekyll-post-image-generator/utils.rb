# frozen_string_literal: true

def set?(key, data)
  data.key?(key) && !data[key].nil? && !data[key].strip.empty?
end
