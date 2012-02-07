EXCEPTIONS = {"apache2" => "httpd2-prefork", "postgresql" => "postmaster", "mysqld_safe" => "mysql"}

# HELPERS
def list_processes
  array = Array.new
  status, stdout, stderr = systemu "ps -e"

  stdout.split("\n").select do |line|
    p = line.split[3]
    next if EXCEPTIONS.include?(p)
    array << p unless p.match(/\[/) #exclude
  end

  array
end

def running?(ps, service)
  service = EXCEPTIONS.has_key?(service)? EXCEPTIONS[service] : service

  ps.each do |k|
    puts "running #{k}" if k.match(service)
    return true if k.match(service)
  end

  return false
end

class Service
  attr_accessor :name, :status
  @@init_dir = "/etc/init.d"

  def initialize(name = nil, status = nil)
    @name = name
    @status = status
  end

  def self.selected
    services = Array.new
    ps = list_processes

    JSON(Service::Settings.load).each do |entry|
      service = running?(ps, entry)
      puts "Service #{entry} and #{service}"
      if service
        services << Service.new(entry, 'running')
      else
        services << Service.new(entry, 'not running')
      end
    end

    services.sort_by{|s| s.name }
  end

  def self.all
    files = Array.new

    Dir.foreach(@@init_dir) do |f| # list all services in /etc/init.d/, exclude directories, hidden files, bash scripts, ...
      unless File.directory?(f)
        files << f if f[0].chr != '.' && !File.fnmatch('**.sh', f) && !f.match('boot') && !f.match('rc')
      end
    end

    services = Array.new
    files.each{|f| services << Service.new(f) }
    services.sort_by{|s| s.name }
  end

  def exec(action)

    command = "#{@@init_dir}/#{self.name} #{action}"
    status, stdout, stderr = systemu command

    puts command
    puts status
    puts stdout.inspect
    puts stderr.inspect
    puts "\n"

    if status == 0 && stderr.blank?
      return {:message => "#{stdout}", :type => "success" }
    elsif status == 0 && !stderr.blank?
      return {:message => "#{stderr}", :type => "warning" }
    else
      return {:message => "#{stderr}", :type => "error" }
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
    def self.save(array = [])
      begin
        file = File.open(@settings, "w")
        file.write(array)
      rescue Errno::ENOENT => e
        puts "*** Exception: #{e.inspect}"
        return false
      ensure
        file.close unless file.nil?
      end
    end

  end
end
