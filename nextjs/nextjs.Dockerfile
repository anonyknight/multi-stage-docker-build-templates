# Followed instruction in https://javascript.plainenglish.io/reduce-docker-image-size-for-your-next-js-app-bcb65d322222
# Use the official Node.js alphine image as the base image
# This generates docker image < 200MB.
FROM node:20-alpine as builder

# Set the working directory inside the container
WORKDIR /app

# Assume using npm, copy package.json and package-lock.json files
COPY ./src/package*.json ./

# Install dependencies
RUN npm ci

# Copy the entire source code excluding node_modules and .next directories
COPY ./src/. ./

# Build the Next.js application
RUN npm run build

FROM node:20-alpine as runner

WORKDIR /app

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/next.config.js .
COPY --from=builder /app/public ./public
# https://nextjs.org/docs/pages/api-reference/next-config-js/output
# During a build, Next.js will automatically trace each page and its dependencies
# to determine all of the files that are needed for deploying a production 
# version of your application.
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# Expose the port on which your Next.js application runs
EXPOSE 3000
# Start the Next.js application
CMD ["node", "server.js"]