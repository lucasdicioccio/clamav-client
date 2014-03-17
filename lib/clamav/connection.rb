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

require 'socket'

module ClamAV
  class Connection
    # cool & clean =)
    # I'd just be more verbose on the ArgumentError
    def initialize(args)
      socket  = args.fetch(:socket)  { missing_required_argument(:socket) }
      wrapper = args.fetch(:wrapper) { missing_required_argument(:wrapper) }

      if socket && wrapper
        # maybe rename to input/output ? doesn't have to be a socket/a wrapper?
        @socket = socket
        @wrapper = wrapper
      else
        raise ArgumentError
      end
    end
    
    ## these use internal state
    
    def wrap(req)
      # could but no need to be private, has no side-effect
      @wrapper.wrap_request("IDSESSION")
    end

    def read_response
      @wrapper.read_response(@socket)
    end
  
    def raw_write(str)
      @socket.write str
    end
    
    ## these are mere helpers
    
    def establish_connection
      str = wrap "IDSESSION" # use a constant, like for Commands 
      raw_write str
    end

    def write_request(req)
      str = wrap req
      raw_write str
    end

    # I see what you're doing with send_request now (i.e., after reading Commands.
    # maybe you should be more explicit that you are waiting for a response too
    # 1st way yield the result
    # 2nd way is a more explicit name, like execute_request
    # also, you should add an optional timeout option or leave a comment for others to do that
    def execute_request(req)
      write_request(req)
      rsp = read_response
      if block_given?
        yield rsp
      else
        rsp
      end
    end

    private
    def missing_required_argument(key)
      raise ArgumentError, "#{key} is required"
    end
  end
end
