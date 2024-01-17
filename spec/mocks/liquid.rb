# frozen_string_literal: true

class Context < Liquid::Context
  def initialize(registers = {}, mock_data = {})
    super({}, {}, registers)
    @mock_data = mock_data
  end

  def [](expression)
    @mock_data[expression]
  end
end
