# 1. Resmi hafif Python imajını taban alıyoruz
FROM python:3.10-slim

# 2. Konteyner içinde çalışma dizini oluşturuyoruz
WORKDIR /app

# 3. Bağımlılık listesini kopyalayıp yüklüyoruz
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. Kalan tüm uygulama kodunu kopyalıyoruz
COPY . .

# 5. FastAPI'ın dış dünyadan erişilebilmesi için portu açıyoruz
EXPOSE 8000

# --- DÜZELTİLEN SATIR ---
# host yine 0.0.0.0 kalıyor (K8s pod içi iletişim için şart), port ise 8000 (integer) yapılıyor.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
