module Wolves
  class Png
    PNG_HEADER = "\x89PNG\r\n\x1A\n"
    PNG_TXT = ['Title',
               'Author',
               'Description',
               'Copyright',
               'Creation Time',
               'Software',
               'Disclaimer',
               'Warning',
               'Source',
               'Comment']

    # Wolves::Png accepts a File pointing to a PNG image.
    def initialize(file)
      @file = file
      @file.seek 0

      if @file.read(8) != PNG_HEADER
        raise ArgumentError, 'Not a PNG file!'
      end

      # Simple way to read the PNG file.
      @chunks = {}
      while !@file.eof?
        length, type = *@file.read(8).unpack('NA*')
        data = @file.read length
        crc = @file.read(4).unpack('N').first

        if Zlib::crc32(type + data) != crc
          raise RuntimeError, "CRC checksum error on #{type}"
        end
        
        @chunks[type] ||= []
        @chunks[type] << data
      end
    end

    # Writes PNG data to file.
    def png(file)
      file.write PNG_HEADER

      # Make sure IEND is actually at the end (Ruby 1.9).
      iend = @chunks.delete 'IEND'
      @chunks['IEND'] = iend

      @chunks.each do |type, data|
        data.each do |data_part|
          file.write [data_part.length, type].pack('NA*')
          file.write data_part
          file.write [Zlib::crc32(type + data_part)].pack('N')
        end
      end
    end

    # Set the payload.
    def payload=(pl)
      @chunks['tEXt'] ||= []
      @chunks['tEXt'] << PNG_TXT.sample + "\0" + pl.raw
    end

    # Fetch the payload.
    def payload
      @chunks['tEXt'].each do |t|
        raw = t[(t.index("\0") + 1)..(t.length)]
        if Payload.headercheck(raw)
          pl = Payload.new
          pl.raw = raw
          return pl
        end
      end

      nil
    end
  end
end
