# frozen_string_literal: true

module Phantom
  NULL = "/dev/null"

  @processes = []

  Minitest.after_run do
    @processes.each do |process|
      Process.kill "-TERM", process
    rescue # rubocop:disable Style/RescueStandardError
      # do nothing
    end
  end

  def self.start(command, dir:, url:, env: {})
    puts "* Starting #{command}"
    pid = Process.spawn(env, command, chdir: dir, err: NULL, in: NULL, out: NULL, pgroup: true)

    wait_for(url)

    @processes.push(pid)
  end

  def self.wait_for(url)
    Timeout.timeout(60) do
      return Net::HTTP.get(URI(url))
    rescue Errno::ECONNREFUSED
      sleep 1
      retry
    end
  end
end
