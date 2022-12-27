# jekyll-post-image-generator

Automatically generate images for posts on your Jekyll site.

[![Build, Test, and Release](https://github.com/sebs-scholarship/jekyll-post-image-generator/actions/workflows/main.yml/badge.svg)](https://github.com/sebs-scholarship/jekyll-post-image-generator/actions/workflows/main.yml)


## Getting Started

### Requirements
In order to run this gem, you must have [ImageMagick](https://imagemagick.org/) installed. Please visit

Additionally, make sure the default font, [Montserrat](https://fonts.google.com/specimen/Montserrat), is downloaded and installed, or configure the plugin
with a different font.

### Add to your Gemfile
```ruby
group :jekyll_plugins do
  gem 'jekyll-post-image-generator', git: 'https://github.com/sebs-scholarship/jekyll-post-image-generator'
end
```

### Add to your plugins list

Add the plugin to the plugins list in your `_config.yml`.
```yaml
plugins:
  - jekyll-post-image-generator
```

### Configure the plugin
You can modify the behavior of the plugin by changing any of the below properties in your `_config.yml`.
```yaml
jekyll-post-image-generator:
  # The base image to add text to
  # default: "_background_image.png"
  background_image: _background_image.png
  
  # The directory to write generated images to
  # default: "assets/images/"
  output_directory: assets/images/
  
  # The maximum point size for the title text
  # default: 200
  max_pointsize: 200
  
  # The minimum point size for the title text
  # default: max_pointsize / 2
  min_pointsize: 100
  
  # The maximum number of columns/characters before wrapping
  # default: 30
  max_columns_per_line: 30
  
  # The name of the font for the title text
  # default: "montserrat-Thin" 
  font: montserrat-Thin
  
  
  # The color of the title text
  # default: "white"
  font_color: white
```

### Configure Pages
This plugin works by reading the `title` property from the front matter of your posts.
```text
---
title: Example
---
```
If no title is present, no image will be generated.

You can use the following liquid tag to get the path to the generated image (or false):
```text
{% generated_image_path %}
```

Additionally, if the `cover_img` property is present, no image will
be generated. This is to allow an author to explicitly set a cover image
for a post that overrides the generated image.

Images are generated incrementally. If you want an image to be regenerated,
it must first be deleted.

## Development

### Install Dependencies
Assuming you have [Bundler](https://bundler.io/) installed, to install dependencies, run the following command:
```bash
bundle install
```

### Lint
To lint the project, run the following command:
```bash
bundle exec rubocop
```

### Test
To test the project, run the following command:
```bash
bundle exec rspec
```

Or alternatively:
```bash
bundle exec rake
```