# Usage

1. Create `.env` in your project:

   ```
PROJECT=<go import path>
```

2. Copy `modd.conf` to your project

3. Create a `docker-compose.yml` file, eg: 

   ```
version: '2'
services:
  web:
    # Go 1.7 + Glide
    image: theplant/qordev:go-1.7
    ports:
    - "9800:9800"
    links:
    - db
    depends_on:
    - db
    environment:
    # App environment
    - SOME_VAR=value
    - ANOTHER_VAR=value
    volumes:
    - .:/go/src/$PROJECT
    # store Glide cache in local filesystem
    - $HOME/.glide:/glide
    working_dir: /go/src/$PROJECT
  db:
    image: postgres
```

Run `modd` in your project directory, and:

1. `glide install` will be executed inside a `web`-based container.
2. Any changes to non-test go code will trigger `docker-compose stop web; docker-compose up web` (ie a container rebuild)

# Development

Building the image: 

```
docker build -t theplant/qordev:go-1.7 .
```

Push to docker hub:

```
docker push theplant/qordev:go-1.7
```

# Details

The image is based on Go 1.7, with Glide installed (`0.12.0-dev` as of this commit).

It exposes `/go/src` as a volume, and by default runs `go run main.go`. You need to:

1. Mount your code at the right place in `/go/src` (eg. `/go/src/github.com/my/project`)

2. Set the working directory to your project, eg `working_dir: /go/src/$PROJECT` in your `docker-compose.yml` file

If you want to use your local Glide cache (so that `glide install` doesn't download dependencies every time it's run), mount your `$GLIDE_HOME` at `/glide`.

# TODO

* How to maintain persistent development data in the database

* Persist Go build files to speed up compilation

* Optimise modd reloading (seems to be quite slow)
