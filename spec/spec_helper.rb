# frozen_string_literal: true

require 'fileutils'
require 'tempfile'
require 'securerandom'
require 'jekyll-post-image-generator'

Jekyll.logger.log_level = :error

SOURCE_IMG = File.expand_path('background_image.png', __dir__ || raise('dir not defined'))
DEST_DIR   = File.expand_path('dest', __dir__ || raise('dir not defined'))

def dest_dir(*files)
  File.join(DEST_DIR, *files)
end

def rand_dest
  dest_dir(SecureRandom.uuid.to_s)
end

def source_dir(*files)
  File.join(DEST_DIR, *files)
end

def rand_source
  dest_dir(SecureRandom.uuid.to_s)
end

def get_first(command_list)
  return command_list[1] unless command_list[1] == 'convert'

  command_list[2]
end

def get_last(command_list)
  command_list[command_list.length - 1]
end

def get_opt_value(command_list, option, skip = 0)
  value = get_opt_values(command_list, option, 1, skip)
  value.empty? ? nil : value[0]
end

def get_opt_values(command_list, option, count = 1, skip = 0)
  index = 0
  start = command_list.find_index(option)

  # skip specified number of matches
  while index < skip
    list = command_list[start + 1, command_list.length]
    start = start + list.find_index(option) + 1
    index += 1
  end

  start.nil? ? [] : command_list[start + 1, count]
end

def mk_tmp_file(name = SecureRandom.uuid.to_s, ext = '')
  t = Tempfile.new([name, ext])
  t.rewind
  yield t.path
  t.close!
end

def basename(path)
  File.basename(path, '.*')
end

def dirname(path)
  File.dirname(path)
end

def make_string(count, char = '0')
  str = ''
  count.times { str += char }
  str
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
