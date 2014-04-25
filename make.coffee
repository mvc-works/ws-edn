
require 'shelljs/make'

target.compile = ->
  exec 'coffee -o lib/ -bc src'