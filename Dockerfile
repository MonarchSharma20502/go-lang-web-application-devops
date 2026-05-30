FROM Golang:1.22-alpine as base

WORKDIR /app

COPY go.mod .

RUN go mod download

COPY . .

RUN go build -o main .

## FINAL STAGE - using Distroless image
FROM gcr.io/distroless/base

# Copy the compiled binary from the base stage from the /app/main of the base stage to the root of the final image (or any path you want in place of '.')
copy --from=base /app/main .

# copy the static files from the base stage from the /app/static of the base stage to the /static of the final image (or any path you want in place of './static')
copy --from=base /app/static ./static

EXPOSE 8080

CMD ["./main"]