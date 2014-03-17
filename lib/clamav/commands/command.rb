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

require 'clamav/responses/error_response'
require 'clamav/responses/success_response'
require 'clamav/responses/virus_response'

module ClamAV
  module Commands
    class Command
      Statuses = {
        'OK'                          => ClamAV::SuccessResponse,
        'ERROR'                       => ClamAV::ErrorResponse,
        'ClamAV-Test-Signature FOUND' => ClamAV::VirusResponse
      }

      def call; raise NotImplementedError.new; end

      protected

        def get_status_from_response(str)
          case str
          when 'Error processing command. ERROR'
            ErrorResponse.new(str)
          else
            # not a big fan of regexps, ":" can appear in filepath, i didn't check if there's a test for it
            /(?<id>\d+): (?<filepath>.*): (?<status>.*)/ =~ str
            # should probably raise something more meaningful than NoMethodError when Statuses[status] is  nil,
            Statuses[status].new(filepath)
          end
        end

    end
  end
end
