DAEMON = {"ssh" => "sshd", "ntp" => "ntpd", "samba" => "smbd"}
EXCLUDE = ["rsyslog", "portmap", "acpid"]
SETTINGS = File.join(PADRINO_ROOT, "/settings/services-settings.json")

class Service
  attr_accessor :pid, :name, :status
  INIT_DIR = "/etc/init.d"

  def initialize(pid = nil, name = nil, status = nil)
    @pid = pid
    @name = name
    @status = status
  end

  def self.all
    services = Array.new
    processes = Hash.new

    # list all services in /etc/init.d/
    Dir.chdir(INIT_DIR)
    files = Dir.entries(".").each{|f| f if File.file?(f) }

    # get running processes from ps
    psaux = `ps aux`
    psaux.split("\n").select do |line|
      processes[line.split[10].split("/").last] = line.split[1] unless line.split[10].match(/\[/)
    end

    files.each do |f|
      if EXCLUDE.include?(f) # replace through user settings
        puts "Process in black list #{f}"
      else
        if DAEMON[f]
          puts "Process in white list #{f}"
          services << Service.new(processes[DAEMON[f]], f, processes[DAEMON[f]].nil? ? "-" : "running")
        else
          services << Service.new(processes[f], f, processes[f].nil? ? "-" : "running")
        end
      end
    end

    services.sort_by{|s| s.name }
  end

  # TODO: Forward output to UI
  def exec(action)
    out = system('#{INIT_DIR}/#{self.name} #{action}')
    back = `#{INIT_DIR}/#{self.name} #{action}`
    puts "#{INIT_DIR}/#{self.name} #{action}"
    puts out.inspect
    puts back.inspect
  end

  # store settings in JSON format
  class Settings
    # Load settings
    def self.load
      settings = {}
      if File.exist?(SETTINGS)
        begin
          file = File.open(SETTINGS)
          settings = file.read
        rescue IOError => e
          puts "The file cannot be read #{e.inspect}"
          return false
        ensure
          file.close unless file.nil?
        end
      end

      return settings
    end

    # Save settings
    def self.save(hash = {})
      begin
        file = File.exist?(SETTINGS)? File.open(SETTINGS, "w") : File.new(SETTINGS, "w")
        file.write(hash)
      rescue IOError => e
        puts "The file cannot be written #{e.inspect}"
        return false
      ensure
        file.close unless file.nil?
      end

      return true
    end
  end

end
