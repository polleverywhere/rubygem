# CodeRay syntax highlighting in Haml
# activate :code_ray

# Automatic sitemaps (gem install middleman-slickmap)
# require "middleman-slickmap"
# activate :slickmap

# Automatic image dimension calculations
# activate :automatic_image_sizes

# Per-page layout changes
# With no layout
# page "/path/to/file.html", :layout => false
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout

# Helpers
helpers do
  def examples(model)
    model.http.adapter.request.to_curl
  end

  def example(&block)
    formats = {}
    block.call
    formats[:ruby] = block.to_source(:strip_enclosure => true)
    formats[:curl] = PollEverywhere.config.http_adapter.last_requests.map(&:to_curl).join("\n\n")
    puts formats.map{ |format, example| %(<pre class="#{format}">#{example}</code>) }.join
  end
end

# Change the CSS directory
# set :css_dir, "alternative_css_directory"

# Change the JS directory
# set :js_dir, "alternative_js_directory"

# Change the images directory
# set :images_dir, "alternative_image_directory"

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css
  
  # Minify Javascript on build
  # activate :minify_javascript
  
  # Enable cache buster
  # activate :cache_buster
  
  # Use relative URLs
  # activate :relative_assets
  
  # Compress PNGs after build (gem install middleman-smusher)
  # require "middleman-smusher"
  # activate :smusher

  # Generate ugly/obfuscated HTML from Haml
  # activate :ugly_haml
  
  # Or use a different image path
  # set :http_path, "/Content/images/"
end