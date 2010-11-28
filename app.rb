module Nesta
  class App
    use Rack::Static, :urls => ["/painter"], :root => "themes/painter/public"

    helpers do
      def load_snippet(file)
        File.new(file).read if File.exist? file
      end
    end

    get "/stylesheets/:sheet.css" do
      content_type "text/css", :charset => "utf-8"
      cache scss(params[:sheet].to_sym)
    end
  end
end
