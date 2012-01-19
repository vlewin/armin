require 'sys/proctable'
require 'open3'

include Sys

class Service
  attr_accessor :pid, :name, :status
  INIT_DIR = "/etc/init.d"
  
  def initialize(pid, name = nil, status = nil)
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

    # get running processes from proc table
    ProcTable.ps.each{|p| processes[p.comm] = p.pid }
    
    # TODO: find a way how to match deamon services like mysql{d} or ssh{d} -> openSUSE only???
    files.each do |f|
      status = processes[f].nil? ? "-" : "running"
      services << Service.new(processes[f], f, status)
    end
    
    services.sort_by{|s| s.name }
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
