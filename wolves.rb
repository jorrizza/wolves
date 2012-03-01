#!/usr/bin/env ruby
#
# Sample application using the Wolves library to hide data in PNG
# files.
#

$: << File.join(File.dirname(__FILE__), 'lib')

require 'wolves'

include Wolves

method = ARGV[0]
unless %w{pack unpack}.include?(method) && ((method == 'pack' &&
                                             ARGV.count == 4) ||
                                            (method == 'unpack' &&
                                             ARGV.count == 3))
  $stderr.puts "Usage:\t#{$0} pack <source dir> <target dir> <filename>
\t#{$0} unpack <source dir> <filename>"
  exit 1
end

if method == 'pack'
  method, source, target, filename = *ARGV

  data_file = File.open(filename, 'rb')
  
  Dir.glob(File.join(source, '*.png')).each do |f|
    png_file = File.open(f, 'rb')
    out_file = File.open(File.join(target, File.basename(f)), 'wb+')

    payload = Payload.new
    payload.chunk_id = 1
    payload.chunk_count = 1
    payload.data = data_file.read
    png = Png.new(png_file)
    png.payload = payload
    png.png(out_file)
    puts "Written #{out_file.path}"
    
    png_file.close
    out_file.close
  end

  data_file.close
else
  method, source, filename = *ARGV

  out_file = File.open(filename, 'wb+')
  payload = nil
  
  Dir.glob(File.join(source, '*.png')).each do |f|
    png_file = File.open(f, 'rb')
    png = Png.new(png_file)
    pl = png.payload
    if pl
      payload = pl
      puts "Read #{f}"
    end
  end

  out_file.write payload.data
  out_file.close
end
