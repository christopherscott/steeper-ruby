#!/usr/bin/env ruby

# For timing the steeping of my tea

require 'optparse'
require 'yaml'

module Tea

  class Steeper
  
    ConfigFile = File.join(File.dirname(__FILE__), "steep.yml")
    ColumnWidth = 60
    ColorMap = [
      "\033[0;37;40m",
      "\033[1;30;40m",
      "\033[0;33;40m",
      "\033[1;33;40m",
      "\033[1;32;40m",
      "\033[0;32;40m"
      ]
    DoneMessage = IO.read("./teabag.txt")  
    DefaultConfigData = {
      "steepcounter" => 0,
      "teas" => { "green" => { "duration" => [60, 60, 90, 105] } } 
      }
    
    def initialize
      percent = 100
            print "#{ColorMap[5]}"

          puts "#{" "*ColumnWidth}\n#{"\007"*3}#{DoneMessage}\033[0m\ndone steeping"

      # print DoneMessage
      exit

      # not sure if we need the object returned from optparse or not
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
    
    def parse_command_line_options
      showhelp = false
      # parsing command line options
      optparse = OptionParser.new do |opts|
        opts.banner = "Usage: steep.rb [options]"
        opts.on("-r", "--reset", "Reset steeping count") { @reset = true }
        opts.on("-q", "--quiet", "Suppress all non-essential output") { @quiet =  true }
        opts.on "-t", "--type TEATYPE", "Type of tea (based on config file #{ConfigFile})" do |t|
          @tea_type = t
        end
        opts.on("-h", "--help", "Show options banner") { |h| showhelp = true  }
      end.parse!
      puts optparse
    end
    
    def load_config_file
      # looking for configuration file
      # if missing, offers to make one
      if File.readable? ConfigFile
        @config = YAML::load_file(ConfigFile)
      else
        puts "Configuration file #{ConfigFile} missing."
        print "Create config file? (y or n): "
        unless gets.chomp =~ /[nN0]/
          File.open(ConfigFile, "w") do |f|
            f.write YAML.dump(DefaultConfigData)
          end
        else
          puts "Fine, be that way!"
          @using_config_file = false
        end
        @config = DefaultConfigData
        puts "Using defaults for first steeping of green tea"
      end
    end
    
    def update_config_file
      if @using_config_file
        configfile = File.open(ConfigFile, "r+")
        replacement =  configfile.read.gsub(/steepcounter: \d+/, "steepcounter: #{@reset ? 0 : @steeping + 1}")
        configfile.seek(0)
        configfile.write(replacement)
      end
    end
    
    def steep
      
      start_time = Time.now.to_f
      stop_time = start_time + @steep_duration
      
      until Time.now.to_f > stop_time
        percent =  (Time.now.to_f - start_time) / @steep_duration.to_f
        print "#{"#{ColorMap[percent * 6]}#"*(percent * ColumnWidth)}\r"
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