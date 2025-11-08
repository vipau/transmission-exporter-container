FROM golang:1.25 AS build

# Build args (will be passed from GitHub Actions)
ARG GOOS
ARG GOARCH
ENV GOOS=${GOOS} \
    GOARCH=${GOARCH} \
    CGO_ENABLED=0

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .

# Build the Go binary for the target OS/ARCH
RUN go build -o /app/ ./...

FROM scratch
COPY --from=build /app/transmission-exporter /transmission-exporter
CMD ["/transmission-exporter"]
