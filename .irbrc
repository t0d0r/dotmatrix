
require 'rubygems'
require 'irb/ext/save-history'
require 'irb/completion'
require 'map_by_method'
require 'what_methods'
require 'pp'

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

#
## under rails console following gems must be added to Gemfile in your project
require 'wirble'
require 'hirb'
#
Wirble.init
Wirble.colorize
#
Hirb::View.enable
#
#colors = Wirble::Colorize.colors.merge({
#  :object_class => :purple,
#  :symbol => :purple,
#  :symbol_prefix => :purple
#})
#Wirble::Colorize.colors = colors
