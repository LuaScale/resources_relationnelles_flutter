FROM cirrusci/flutter:stable AS build
WORKDIR /app
RUN git clone https://github.com/votre-utilisateur/votre-depot.git .
RUN flutter pub get
RUN flutter build web --release
FROM nginx:stable-alpine AS production
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
