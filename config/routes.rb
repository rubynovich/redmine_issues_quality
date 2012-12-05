if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do
    resources :ratings
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.resources :ratings
  end
end
