#!/usr/bin/env ruby

# For timing the steeping of my tea

require 'optparse'

class Steeper
  
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
  
  def initialize
    
    # TODO: change to use ancillary file, steep.yml
    # for configurations, times, etc...
    # also, this will check for past steepings to
    # keep track for multiple steepings
    @steep_duration = 2 # in seconds
    
    # parsing command line options
    @options = {}
    optparse = OptionParser.new do |opts|
      opts.banner = "Usage: steep.rb [options]"
      opts.on "-R", "--reset", "Reset steeping count" do |r|
        @options[:reset] = true
      end
    end
    
  end
  
  def steep
    
    start_time = Time.now.to_f
    stop_time = Time.now.to_f + @steep_duration
    
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