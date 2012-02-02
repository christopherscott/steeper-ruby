
module Tea

  module Helper

    ConfigFile = File.join(File.dirname(__FILE__), "steep.yml")

    def parse_command_line_options
      optparse = OptionParser.new do |opts|
        opts.banner = "Usage: steep.rb [options]"
        opts.separator ""
        opts.separator "Specific options:"
        opts.on("-r", "--reset", "Reset steeping count") { @reset = true }
        opts.on("-q", "--quiet", "Suppress all non-essential output") { @quiet =  true }
        opts.on "-t", "--type TEATYPE", "Type of tea (based on config file #{ConfigFile})" do |t|
          @tea_type = t
        end
        opts.on("-h", "--help", "Show this message") do
          puts opts
          exit
        end
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
    
  end

end
