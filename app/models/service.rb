DAEMON = {"ssh" => "sshd", "ntp" => "ntpd", "samba" => "smbd"}
EXCLUDE = ["rc", "rc.local", "rcS", "console-setup", "bootlogd", "ifplugd", "ifupdown", "ifupdown-clean", "bootlogs", "rsyslog", "portmap", "acpid", "README"]
SERVICES_SETTINGS = File.join(PADRINO_ROOT, "/settings/services-settings.json")

class Service
  attr_accessor :pid, :name, :status
  INIT_DIR = "/etc/init.d"

  def initialize(name = nil, pid = nil, status = nil)
    @pid = pid
    @name = name
    @status = status
  end

  def self.saved
    services = Array.new
    processes = Hash.new

    psaux = `ps aux` # get running processes from ps
    psaux.split("\n").select do |line|
      processes[line.split[10].split("/").last] = line.split[1] unless line.split[10].match(/\[/)
    end

    JSON(Service::Settings.load).each do |s|
      services << Service.new(s, processes[DAEMON[s]], processes[DAEMON[s]].nil? ? "-" : "running")
    end
    services.sort_by{|s| s.name }
  end

  def self.all
    files = Array.new

    Dir.foreach(INIT_DIR) do |f| # list all services in /etc/init.d/, exlude directories, hidden files, bash scripts
      unless File.directory?(f)
        files << f if f[0].chr != '.' && !File.fnmatch('**.sh', f)
      end
    end

    processes = Hash.new

    psaux = `ps aux` # get running processes from ps
    psaux.split("\n").select do |line|
      processes[line.split[10].split("/").last] = line.split[1] unless line.split[10].match(/\[/)
    end

    services = Array.new

    files.each do |f| # filter deamons and exlude system processes
      unless EXCLUDE.include?(f) # replace through user settings
        if DAEMON[f]
          puts "Process in white list #{f}"
          services << Service.new(f, processes[DAEMON[f]], processes[DAEMON[f]].nil? ? "-" : "running")
        else
          services << Service.new(f, processes[DAEMON[f]], processes[f].nil? ? "-" : "running")
        end
      end
    end

    services.sort_by{|s| s.name }
  end

  # TODO: Forward output to UI
  def exec(action)
    puts "***** #{action}ing service #{self.name}"
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
      if File.exist?(SERVICES_SETTINGS)
        begin
          file = File.open(SERVICES_SETTINGS)
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
        file = File.exist?(SERVICES_SETTINGS)? File.open(SERVICES_SETTINGS, "w") : File.new(SERVICES_SETTINGS, "w")
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
