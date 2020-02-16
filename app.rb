require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/json'
require 'net/http'
require 'nbt_utils'
require 'base64'
require 'zlib'
require 'stringio'

get '/' do
  erb :index
end

post '/' do
  @data = params[:data]
  # binding.pry

  datastring = @data
  out = Base64.decode64(datastring)

  File.open("out.nbt.gz", "w") do |f|
  f.puts(out)
  end
  # binding.pry

  gz = Zlib::GzipReader.open('out.nbt.gz'){ |gz|
    File.open("out.nbt", "w") do |f|
      f.puts(gz.read)
    end
  }
  @file = NBTUtils::File.new
  @tag = @file.read('out.nbt')
  @file.write('out_check.nbt', @tag, false)

  # binding.pry
  erb :show
end

# H4sIAAAAAAAAAONiYOBkYMzkYmBgYGEAAQCp5xppEQAAAA==