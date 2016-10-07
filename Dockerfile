FROM golang:1.7
RUN go get github.com/Masterminds/glide

VOLUME /go/src
EXPOSE 9800
VOLUME /glide
ENV GLIDE_HOME=/glide
CMD go run main.go
