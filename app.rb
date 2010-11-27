module Nesta
  class App
    # Use assets in theme > public directory instead of root public directory.
    use Rack::Static, :urls => ["/painter"], :root => "themes/painter/public"
  end
end
