# clamav-client - ClamAV client
# Copyright (C) 2014 Franck Verrot <franck@verrot.fr>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'clamav/commands/command'

module ClamAV
  module Commands
    class InstreamCommand < Command

      # helper class to extract the streaming logic and only that
      class Stream
        include Dsl

        # todo: get the @conn in
        # provide raw_write and similar hooks, or inherit Stream from Client (break circular deps in that case)

        def start_stream
          write_request InStream
        end

        def close_stream
          raw_write(EndOfStream)
        end

        def streaming
          start_stream
          yield self
          close_stream
        end

        def write_packet(pkt)
          size = [pkt.size].pack("N")
          conn.raw_write("#{size}#{pkt}")
        end

        alias :<< :write_packet
      end

      def initialize(io, max_chunk_size = 1024)
        @io = begin io rescue raise ArgumentError, 'io is required', caller; end
        @max_chunk_size = max_chunk_size
      end

      def call(conn)
        Stream.open(conn) do |str|
          while(packet = @io.read(@max_chunk_size))
            str << packet
          end
        end
        get_status_from_response(conn.read_response)
      end

    end
  end
end
