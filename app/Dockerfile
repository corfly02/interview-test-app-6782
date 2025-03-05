FROM alpine:3.21

# Install curl and netCAT
RUN apk add --no-cache curl netcat-openbsd

# Copy in our CAT RETRIEVER
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Expose port 8080 or whatever you want to deploy you ape
EXPOSE 8080

# Run the cat RETRIEVER
CMD ["/bin/sh", "/run.sh"]