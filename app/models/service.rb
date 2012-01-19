require 'sys/proctable'
require 'open3'

include Sys

class Service
  attr_accessor :pid,:name, :status
  INIT_DIR = "/etc/init.d"
  
  def initialize(pid, name = nil)
    @pid = pid
    @name = name
  end

  def self.running_services
    services = Array.new
    ProcTable.ps do |p|
      services << Service.new(p.pid.to_i, p.comm) # if p.pid > 1000 
    end
    services.uniq_by{|s| s.name }.sort_by{|s| s.name }
  end
  
  def self.init_services
    services = Array.new
    Dir.chdir(INIT_DIR)
    Dir.entries(".").each do |s|
      if File.file?(s) && s != "." && s != ".."
        services << Service.new(IO.popen('pidof #{s}').readlines.first, s)
        puts "READ #{s} PID #{IO.popen('pidof #{s}').readlines}"
      end
      
    end
    
    services
  end
  
  def self.all
    Dir.chdir(INIT_DIR)
    Dir.entries(".").each{|f| f}
  end

  def stop
    #system('kill #{self.pid}')
    #status = `kill #{self.pid}`
    stdin, stdout, stderr = Open3.popen3('kill #{self.pid}')
    puts stdin.inspect
    puts stdout.readlines
    puts stderr.readlines
  end

end
