module Sinatra
  module ResourcesApp
    module Routing
      module Resources
 
        def self.registered(app)
          
          app.get '/resources' do
            @resources = Resource.all
            jbuilder :resources
          end

          app.get '/resources/:id/?' do
            @resource = Resource.find(params[:id])
            jbuilder :resource
          end

        end

      end
    end
  end
  register ResourcesApp::Routing::Resources
end