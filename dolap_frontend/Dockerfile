# 1. Aşama: Flutter Build
FROM instrumentisto/flutter:latest AS build-env

# Flutter'ın root uyarısını geçmesini sağlar
ENV FLUTTER_ALLOW_HTTP=true
ENV PUB_CACHE=/app/.pub-cache

WORKDIR /app
COPY . .

# Versiyon hatasını aşmak için pubspec'teki kısıtlamayı esnetiyoruz veya 
# doğrudan imajdaki flutter ile uyumlu hale getiriyoruz.
RUN flutter pub get
RUN flutter build web

# 2. Aşama: Nginx ile Sunma
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
