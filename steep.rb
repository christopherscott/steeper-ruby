#!/usr/bin/env ruby

# For timing the steeping of my tea

require 'optparse'
require 'yaml'
require './helper'

module Tea

  class Steeper
    
    include Tea::Helper

    DoneMessage = IO.read(File.join(File.dirname(__FILE__), "teabag.txt"))  
    ColumnWidth = 60
    ColorMap = [
      "\033[0;37;40m",
      "\033[1;30;40m",
      "\033[0;33;40m",
      "\033[1;33;40m",
      "\033[1;32;40m",
      "\033[0;32;40m"
      ]
    DefaultConfigData = {
      "steepcounter" => 0,
      "teas" => { "green" => { "duration" => [60, 60, 90, 105] } } 
      }
    
    def initialize
      @optparse = parse_command_line_options
      @tea_type ||= "green"
      @using_config_file = true
      # steep.yml by default
      load_config_file
      # validate @tea_type
      unless @config["teas"].keys.include?(@tea_type)
        puts "\"#{@tea_type}\" is not available"
        puts "Available teas: #{@config["teas"].keys.join(", ")}"
        exit 1
      end
      # setup steeping sequence, defaulting to first steeping
      @steeping = @reset ? 0 : @config["steepcounter"] || 0
      durations = @config["teas"][@tea_type]["duration"]
      # setup steeping duration based on type/number of steepings
      @steep_duration = durations[@steeping] || durations.last
    end
    
    def steep
      start_time = Time.now.to_f
      stop_time = start_time + @steep_duration
      until Time.now.to_f > stop_time
        percent =  (Time.now.to_f - start_time) / @steep_duration.to_f
        print "#{"#{ColorMap[percent * 6]}#"*(percent * ColumnWidth)}\r"
        sleep 1
        STDOUT.flush
      end
      puts "#{" "*ColumnWidth}\n#{"\007"*3}#{DoneMessage}\033[0m\ndone steeping"
      update_config_file
      puts "updating config file"
    end
      
  end

end


if __FILE__ == $0
  Tea::Steeper.new.steep
end