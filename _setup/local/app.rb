module Nesta
  class App
    helpers do
      # Insert javascript snippet just before the body tag.
      def load_snippet(file)
        File.new(file).read if File.exist? file
      end
    end

    # Follow Rails naming convention for css.
    get "/stylesheets/:sheet.css" do
      content_type "text/css", :charset => "utf-8"
      cache scss(params[:sheet].to_sym)
    end
   
    get "/" do
      @page = Nesta::Page.find_by_path("index")
      @heading = "Home"
      @site_title = "Nesta - a nesta theme"
      @snippet = load_snippet("./themes/painter/views/snippets/index.js")
      raise Sinatra::NotFound if @page.nil?
      set_title(@page)
      set_from_page(:description, :keywords)
      cache haml(:index)
    end

    get %r{/attachments/([\w/.-]+)} do
      file = File.join(Nesta::Config.attachment_path, params[:captures].first)
      send_file(file, :disposition => nil)
    end

    get "/articles.xml" do
      content_type :xml, :charset => "utf-8"
      set_from_config(:title, :subtitle, :author)
      @articles = Page.find_articles.select { |a| a.date }[0..9]
      cache builder(:atom)
    end

    get "/sitemap.xml" do
      content_type :xml, :charset => "utf-8"
      @pages = Page.find_all
      @last = @pages.map { |page| page.last_modified }.inject do |latest, page|
        (page > latest) ? page : latest
      end
      cache builder(:sitemap)
    end
    
    # Example of a static web page, without using layout.haml. 
    # This is not associated with Sinatra/Nesta splat route mapper.
    get "/splat" do
      @page = Nesta::Page.find_by_path("splat")
      cache haml(:splat, :layout => false)
    end

    get "*" do
      #set_common_variables
      parts = params[:splat].map { |p| p.sub(/\/$/, "") }
      @page = Nesta::Page.find_by_path(File.join(parts))
      raise Sinatra::NotFound if @page.nil?
      @snippet = load_snippet("./themes/painter/views/snippets/#{@page.path}.js")
      set_title(@page)
      set_from_page(:description, :keywords)
      cache haml(:page)
    end
  end
end
