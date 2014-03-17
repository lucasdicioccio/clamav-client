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
  module Util
    UnknownPathException = Class.new(RuntimeError)

    # a small comment why you would use this function rather than a Find.find
    # e.g., is it recursive?
    # e.g. does it follow links and all these funky filesystem oddities =)
    def Util.path_to_files(path)
      if Dir.exist?(path)
        Dir.glob(path + '/*')
      elsif File.exist?(path)
        [path]
      else
        message =" (path = #{path})"
        raise UnknownPathException.new("#{__FILE__}:#{__LINE__} path_to_files : path argument neither a file nor a directory. Aborting. #{message}")
      end
    end
  end
end
