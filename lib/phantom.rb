module Phantom
  NULL = "/dev/null"

  @processes = []

  Minitest.after_run do
    @processes.each do |process|
      Process.kill "TERM", process
    rescue Errno::ECHILD
    end
  end

  def self.start(command, dir:, env: {}, url:)
    puts "* Starting #{command}"
    pid = Process.spawn(env, command, chdir: dir, err: NULL, in: NULL, out: NULL)

    wait_for(url)

    @processes.push(pid)
  end

  def self.wait_for(url)
    Timeout.timeout(10) do
      return Net::HTTP.get(URI(url))
    rescue Errno::ECONNREFUSED
      sleep 1
      retry
    end
  end
end
