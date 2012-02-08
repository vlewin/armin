class SystemInfo
  class FileSystem
    @@variables = [:partition, :size, :used, :free, :usage, :mount]
    attr_reader *@@variables

    def initialize(args)
      array = args.split(" ")
      @@variables.each_with_index do |v, i|
        instance_variable_set("@#{v}", array[i]) unless i.nil?
      end
    end

    def self.all
      partitions = []
      status, stdout, stderr = systemu "df -h"
      stdout.split("\n").each_with_index do |line, index|
        partitions << FileSystem.new(line) if line.split[0] && index != 0
      end

      partitions
    end

    def self.find(partition)
      status, stdout, stderr = systemu "df -h"
      stdout.split("\n").select do |line|
        puts line
        return FileSystem.new(line).usage.to_i if line.split[0].match(partition)
      end
      return false
    end
  end

  class CPU
    @@variables = [:partition, :size, :used, :free, :usage, :mount]
    attr_reader *@@variables

    def self.usage
      prev_total = 0
      prev_idle = 0
      total = 0
      idle = 0

      stat = File.open("/proc/stat", &:readline)
      stat = stat.split(" ")
      stat.delete_at(0)
      idle = stat[3]

      stat.each do |v|
        total = total + v.to_i
      end

      diff_idle = idle.to_i-prev_idle.to_i
      diff_total = total-prev_total

      usage = (1000*(diff_total-diff_idle)/diff_total+5)/10

      prev_total = total
      prev_idle = idle

      usage

      #sleep 1



    end

  end

end
