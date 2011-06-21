#!/usr/bin/env ruby

# For timing the steeping of my tea

require 'optparse'
require 'yaml'

class Steeper
  
  ConfigFile = "steep.yml"
  ColumnWidth = 60
  ColorMap = [
    "\033[0;37;40m",
    "\033[1;30;40m",
    "\033[0;33;40m",
    "\033[1;33;40m",
    "\033[1;32;40m",
    "\033[0;32;40m"
    ]
  DoneMessage = "\t\t        {\n\t\t     {   }\n\t\t      }_{ __{\n\t\t   .-{   }   }-.\n\t\t  (   }     {   )\n\t\t  |`-.._____..-'|\n\t\t  |             ;--.\n\t\t  |            (__  \\\n\t\t  |             | )  )\n\t\t  |             |/  /\n\t\t  |             /  /\n\t\t  |            (  /\n\t\t  \\             y'\n\t\t   `-.._____..-'\n"  
  DefaultConfigData = {
    "steepcounter" => 0,
    "teas" => { "green" => { "duration" => [60, 60, 90, 105] } } 
    }
  
  def initialize

    @steep_duration = 2 # in seconds
    
    # parsing command line options
    @options = {}
    optparse = OptionParser.new do |opts|
      opts.banner = "Usage: steep.rb [options]"
      opts.on "-r", "--reset", "Reset steeping count" do |r|
        @options[:reset] = true
      end
      opts.on "-t", "--type TEATYPE", "Type of tea (based on config file #{ConfigFile})" do |t|
        @options[:type] = t || "green"
      end
    end
    
    if File.readable? ConfigFile
      @config = YAML::load_file(ConfigFile)
    else
      puts "Configuration file #{ConfigFile} missing."
      print "Create config file? (y or n): "
      unless gets.chomp =~ /[nN0]/
        File.open(File.join(File.dirname(__FILE__), ConfigFile), "w") do |f|
          f.write YAML.dump(DefaultConfigData)
        end
        @config = DefaultConfigData
      else
        puts "Fine, be that way!"; exit 2
      end
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
  end
    
end


if __FILE__ == $0
  Steeper.new.steep
end