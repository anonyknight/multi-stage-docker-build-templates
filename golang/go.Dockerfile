FROM --platform=$BUILDPLATFORM golang:1.21-alpine as builder
ARG TARGETARCH

RUN apk add --no-cache ca-certificates git

WORKDIR /project

COPY go.* ./
RUN go mod download

COPY . ./

# Consider the src exists in cmd folder.
RUN CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -o /go/bin/master -v ./cmd/

FROM alpine:3.18

RUN apk --no-cache add ca-certificates python3

COPY --from=builder /go/bin/master /bin/master

# RUN addgroup -g 1001 gatech && adduser -D -G gatech -u 1001 gatech
# USER 1001
USER root

CMD ["/bin/master"]
