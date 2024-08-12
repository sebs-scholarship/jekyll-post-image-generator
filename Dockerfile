FROM jekyll/builder:4.2.2

LABEL maintainer="Levi Muniz <levi.muniz17@gmail.com>"

# Install imagemagick executable
RUN apk add --no-cache imagemagick

# Install default font
ADD 'https://font.download/dl/font/montserrat.zip' font.zip
RUN unzip font.zip -d /usr/share/fonts/montserrat
RUN rm font.zip

# Install jekyll-post-image-generator
RUN mkdir /app
WORKDIR /app
COPY ./ ./
RUN gem build jekyll-post-image-generator.gemspec -o jekyll-post-image-generator.gem
RUN gem install jekyll-post-image-generator.gem
WORKDIR /srv/jekyll
RUN rm -rf /app