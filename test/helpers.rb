module Sinatra
  module ResourcesApp
    module Test
      module Helpers
        
        def assert_json_content_type
          assert_equal 'application/json;charset=utf-8',
                       last_response.headers['content-type']
        end

        def assert_status_code(status_code)
          assert_equal status_code, last_response.status
        end

        def returns_200_with_json_content_type
          assert_status_code 200
          assert_json_content_type
        end

        def returns_404_with_json_content_type
          assert_status_code 404
          assert_json_content_type
        end

        def returns_409_with_json_content_type
          assert_status_code 409
          assert_json_content_type
        end

      end
    end
  end
end