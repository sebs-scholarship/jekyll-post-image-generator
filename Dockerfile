FROM jekyll/builder:4.2.2

LABEL maintainer="Levi Muniz <levi.muniz17@gmail.com>"

# Install imagemagick executable
RUN apk add --no-cache imagemagick

# Install default font
RUN wget 'https://font.download/dl/font/montserrat.zip' -O font.zip
RUN unzip font.zip -d /usr/share/fonts/montserrat
RUN rm font.zip