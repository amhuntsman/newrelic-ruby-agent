# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/rpm/blob/master/LICENSE for complete details.

# This module is responsible for intercepting output made through various stdlib
# calls (i.e. puts, print, etc.) and printing summary information (e.g. a list
# of failing tests) at the end of the process.
#
module Multiverse
  module OutputCollector
    include Color
    extend Color

    def self.buffers
      @buffers ||= {}
    end

    def self.failing_output
      @failing ||= []
    end

    def self.buffer(suite, env)
      key = [suite, env]
      buffers[key] ||= ""
      buffers[key]
    end

    def self.failed(suite, env)
      @failing ||= []
      @failing << buffer(suite, env) + "\n"
    end

    def self.write(suite, env, msg)
      buffer(suite, env) << msg
    end

    def self.suite_report(suite, env)
      puts buffer(suite, env)
    end

    def self.overall_report
      puts
      puts
      if failing_output.empty?
        puts green("There were no test failures")
      else
        puts red("There were failures in #{failing_output.size} test suites")
        puts "Here is their output"
        puts *failing_output
      end
    end
  end
end
