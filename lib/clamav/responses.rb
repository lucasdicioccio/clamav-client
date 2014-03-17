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

module ClamAV
  class Response
    
    # blind guess: you probably want "path" or "filepath" rather than "file"
    def initialize(file)
      @file = file
    end

    # maybe you want to test with other.is_a?(self.class)
    # As I go through the rest of the code, I'll try to remember that you did this change.
    # If i don't find where you use this; it's either dead code or requires an explanation. deal?
    def ==(other)
      @file == other.file && self.class == other.class
    end

    protected

      attr_reader :file

  end
end
