DAEMON = {"ssh" => "sshd", "ntp" => "ntpd", "samba" => "smbd", "dbus" => "dbus-daemon"}
EXCLUDE = ["rc", "rc.local", "rcS", "console-setup", "bootlogd", "ifplugd", "ifupdown", "ifupdown-clean", "bootlogs", "rsyslog", "portmap", "acpid", "README"]
#SERVICES_SETTINGS = File.join(PADRINO_ROOT, "/settings/services-settings.json")


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
      if DAEMON[s]
        services << Service.new(s, processes[DAEMON[s]], processes[DAEMON[s]].nil? ? "-" : "running")
      else
        services << Service.new(s, processes[DAEMON[s]], processes[s].nil? ? "-" : "running")
      end
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
          services << Service.new(f, processes[DAEMON[f]], processes[DAEMON[f]].nil? ? "-" : "running")
        else
          services << Service.new(f, processes[DAEMON[f]], processes[f].nil? ? "-" : "running")
        end
      end
    end

    services.sort_by{|s| s.name }
  end

  # TODO:Better error handling !!!
  def exec(action)
    # status
    # 0 = success
    # 1 = warning
    # 2 = error

    command = "#{INIT_DIR}/#{self.name} #{action}"
    status, stdout, stderr = systemu command

    if status == 0 && stderr.blank?
      p "clear exit"
      p "Stdout: #{stdout}"
      return {:message => "#{stdout}", :status => "success" }
    elsif status == 0 && !stderr.blank?
      p "check if process is running"
      p "Stdout: #{stdout}"
      p "Stderr: #{stderr}"
      return {:message => "#{stdout}", :error => "#{stderr}", :status => "warning" }
    else
      p "Bad exist status #{status}"
      p "Status: #{status}"
      p "Stdout: #{stdout}"
      p "Stderr: #{stderr}"
      return {:message => "#{stdout}", :error => "#{stderr}", :status => "error" }
    end
  end

  # store settings in JSON format
  class Settings
    @settings = File.join(PADRINO_ROOT, "/settings/services-settings.json")

    # Load settings
    def self.load
      settings = {}
      begin
        file = File.open(@settings)
        settings = file.read
      rescue IOError => e
        puts "*** Exception: #{e.inspect}"
        return false
      ensure
        file.close unless file.nil?
      end

      settings
    end

    # Save settings
    def self.save(hash = {})
      begin
        file = File.open(@settings, "w")
        file.write(hash)
      rescue Errno::ENOENT => e
        puts "*** Exception: #{e.inspect}"
        return false
      ensure
        file.close unless file.nil?
      end
    end

  end
end
