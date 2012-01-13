require 'sys/proctable'
include Sys

class Service
  attr_accessor :name, :pid, :status
  def initialize(pid, name)
    @pid = pid
    @name = name
  end

  def self.get_process_list
    services = Array.new
    ProcTable.ps{ |p|
      services << Service.new(p.pid.to_s, p.comm)
    }
    services
  end

  def is_running?
    status = system("/etc/init.d/#{self.name} status")
    if status
      return true
    end
    return false
  end

  def restart
    puts "Process  is not running.  Trying to restart."
    status = system("/etc/init.d/#{self.name} restart")
  end

  def run
    get_process_list
    if !is_running?
      restart
    end
  end

end
