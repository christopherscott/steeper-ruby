#!/usr/bin/env ruby

# For timing the steeping of my tea

require 'optparse'

class Steeper
  
  ColorMap = [
    "\033[0;37;40m",
    "\033[1;30;40m",
    "\033[0;33;40m",
    "\033[1;33;40m",
    "\033[1;32;40m",
    "\033[0;32;40m",
    "\033[0;31;40m",
    "\033[1;31;40m"
    ]
  
  DoneMessage = "        {\n     {   }\n      }_{ __{\n   .-{   }   }-.\n  (   }     {   )\n  |`-.._____..-'|\n  |             ;--.\n  |            (__  \\\n  |             | )  )\n  |             |/  /\n  |             /  /\n  |            (  /\n  \             y'\n   `-.._____..-'\n"
  
  def initialize
    
    # TODO: change to use ancillary file, steep.yml
    # for configurations, times, etc...
    # also, this will check for past steepings to
    # keep track for multiple steepings
    @steep_duration = 55 # in seconds
        
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
    
    start_time = Time.now
    stop_time = Time.now.to_f + @steep_duration
    
    until Time.now.to_f > stop_time
      percent =  (Time.now.to_f - start_time.to_f) / @steep_duration.to_f
      print "#{"#{ColorMap[percent * 6]}#"*(percent * 50)}\r"
      STDOUT.flush
    end
    print DoneMessage
    print "\033[0m\n"
    puts "done steeping"
  end
    
end


if $0 == __FILE__
  Steeper.new.steep
end