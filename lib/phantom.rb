# frozen_string_literal: true

module Phantom
  NULL = "/dev/null"

  @processes = []

  def self.register_hook
    @register_hook ||= begin
      Minitest.after_run do
        @processes.each do |process|
          Process.kill "-TERM", process
        rescue # rubocop:disable Style/RescueStandardError
          # do nothing
        end
      end

      true
    end
  end

  def self.start(command, dir:, url:, env: {})
    register_hook

    puts "* Starting #{command}"
    pid = Process.spawn(env, command, chdir: dir, err: NULL, in: NULL, out: NULL, pgroup: true)

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
