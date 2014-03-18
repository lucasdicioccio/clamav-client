
module ClamAV
  # needs three methods:
  # - wrap(str) => str
  # - raw_write(str) => nil
  # - raw_write(str) => nil
  # - read_response(str) => nil
  module Dsl
    include ClamAV::Language

    def establish_connection
      str = wrap IdSession
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
  end
end
