# jekyll-post-image-generator

Automatically generate images for posts on your Jekyll site.

[![Build, Test, and Release](https://github.com/sebs-scholarship/jekyll-post-image-generator/actions/workflows/main.yml/badge.svg)](https://github.com/sebs-scholarship/jekyll-post-image-generator/actions/workflows/main.yml)

---

## Quickstart
### Docker
Skip installing ImageMagick and Montserrat by using the leviem1/jpig Docker image.

This container is a wrapper of jekyll/builder, and accepts Jekyll commands
```bash
docker run -v /path/to/jekyll/site:/srv/jekyll \
-p 4000:4000 \
--rm leviem1/jpig:0.0.10 \
jekyll serve --future --drafts
```

### Manual Setup
In order to run this gem, you must have [ImageMagick](https://imagemagick.org/) installed.

Additionally, make sure the default font, [Montserrat](https://fonts.google.com/specimen/Montserrat), is downloaded and installed, or configure the plugin
with a different font (see below).

### Installing the Plugin
First, add the plugin to your Gemfile
```ruby
group :jekyll_plugins do
  gem 'jekyll-post-image-generator', github: 'sebs-scholarship/jekyll-post-image-generator', tag: 'v0.0.7'
end
```

Then, add the plugin to the plugins list in your `_config.yml`.
```yaml
plugins:
  - jekyll-post-image-generator
```

### Background Image
This plugin reads a image (named `_background_image.png` by default) to use as the background for the text.

**NOTE**: This is a **user-supplied** image. The default configuration is for an image that's 2,048x1,024px.   

### Configuring Posts
In order to generate the image text, the plugin reads the `title` property from the front matter of your posts.
```text
---
title: Example
---
```
If no title is present, no image will be generated.

If you prefer not to use the page's title, or the title is absent, you can
override the text with the `cover_image_text` property.
```text
---
cover_image_text: Example
---
```

Images are generated incrementally, so if you want an image to be regenerated,
it must first be deleted.

### Get Path to Generated Image
In order to use the generated image in a post, you will need to use the `generated_image_path` liquid tag.

Example:
```text
{% generated_image_path %}
```

If an image was generated for the post, or a cover image was used, this tag returns the path to the
image, or `false` otherwise. 

This can be used to display the output image on the page
```html
<img src="{% generated_image_path %}" alt="Cover Image">
```
[Advanced Example](https://github.com/sebs-scholarship/Blog/blob/staging/_layouts/post.html)

Or for OpenGraph images
```html
<meta property="og:image" content="{% generated_image_path %}" />
```
[Advanced Example](https://github.com/sebs-scholarship/Blog/blob/staging/_layouts/default.html)

### Generating Images
Run `jekyll build` or `jekyll serve`, and images will be generated in the output
directory (`assets/images/` by default). 

---

## Advanced
### Configuration
You can modify the behavior of the plugin by adding any of the below properties to your `_config.yml`.
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
  # default: "montserrat-Light" 
  font: montserrat-Light
  
  
  # The color of the title text
  # default: "white"
  font_color: white
```

### Special Formatting
Both `title` and `cover_image_text` may contain [special formatting](https://imagemagick.org/script/escape.php), which
adds support for line breaks. (Note the escaped literal backslash. I honestly have no idea how or why this works the way it does.)
```text
---
cover_image_text: 'This is a test post\nProceed with caution\neverybody\\\\nobody'
---
```

Or alternatively:
```text
---
cover_image_text: "This is a test post\nProceed with caution\neverybody\\\\\\\\nobody"
---
```

### Overriding or Disabling Image Generation
If the `cover_image` property is set to anything, no image will be generated.
```text
---
title: Example
cover_image: path/to/existing/image.png
---
```

Or even
```text
---
title: Example
cover_image: false
---
```

This is meant to be used as a way to explicitly specify the path
to an existing image, but that logic must be implemented manually in your post
layout.

[Advanced Example](https://github.com/sebs-scholarship/Blog/blob/staging/_layouts/default.html)
