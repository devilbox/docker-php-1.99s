# Docker PHP 1.99s

This image is based on the official Apache 2.4 image and provides a custom CGI-based install of
PHP 1.99s


## Usage

### Build
```bash
# Via Makefile
make build
```
```bash
# Via Docker command
docker build -t devilbox/php-1.99s .
```

### Run

The below listed run commands will mount the bundled `www/` directory which contains a few examples.

```bash
# Via Makefile
make run
```
```bash
# Via Docker command
docker run --rm \
    -p 80:80 \
    -v $(pwd)/www:/usr/local/apache2/htdocs \
    devilbox/php-1.99s
```

### Browse

After startup visit one of the following pages:

* http://localhost/
* http://localhost/phpinfo.php
* http://localhost/hello-world.php


## License

**[MIT License](LICENSE)**

Copyright (c) 2019 [cytopia](https://github.com/cytopia)
