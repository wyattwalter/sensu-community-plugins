#!/usr/bin/env ruby
#
# Check IIS Current Connections
# ===
#
# Tested on Windows 2012RC2.
#
# Yohei Kawahara <inokara@gmail.com>
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/check/cli'

class CheckIisCurrentConnections < Sensu::Plugin::Check::CLI

  option :warning,
    :short => '-w WARNING',
    :default =>  50

  option :critical,
    :short => '-c CRITICAL',
    :default =>  150

  option :site,
    :short => '-s sitename',
    :default => '_Total'

  def run
    io = IO.popen("typeperf -sc 1 \"Web Service(#{config[:site]})\\Current\ Connections\"")
    current_connection = io.readlines[2].split(',')[1].gsub(/"/, '').to_f
    critical "Current Connectio at #{current_connection}" if current_connection > config[:critical]
    warning "Current Connectio at #{current_connection}" if current_connection > config[:warning]
    ok "Current Connection at #{current_connection}"
  end
end
