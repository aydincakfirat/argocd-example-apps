from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List

app = FastAPI(title="İkinci El Kıyafet Uygulaması API")

# --- MODELLER (Pydantic) ---
class Product(BaseModel):
    id: str
    title: str
    description: str
    price: float
    size: str
    category: str
    image_url: str
    seller_id: str

class ProductCreate(BaseModel):
    title: str
    description: str
    price: float
    size: str
    category: str
    image_url: str
    seller_id: str

# --- IN-MEMORY DATABASE (Geçici Veritabanı) ---
mock_products = [
    {
        "id": "prod_1",
        "title": "Oversize Siyah Sweatshirt",
        "description": "Çok az kullanıldı, lekesiz. Rahat kalıp.",
        "price": 350.0,
        "size": "L",
        "category": "Üst Giyim",
        "image_url": "https://images.unsplash.com/photo-1556821840-3a63f95609a7",
        "seller_id": "user_123"
    },
    {
        "id": "prod_2",
        "title": "Mavi Vintage Kot Ceket",
        "description": "90'lar tarzı, orijinal vintage ceket.",
        "price": 750.0,
        "size": "M",
        "category": "Dış Giyim",
        "image_url": "https://images.unsplash.com/photo-1576995853123-5a10305d93c0",
        "seller_id": "user_456"
    }
]

# --- API UÇ NOKTALARI (ENDPOINTS) ---

# 1. Tüm Ürünleri Listeleme
@app.get("/api/products", response_model=List[Product])
def get_products():
    return mock_products

# 2. Tek Bir Ürünün Detayı
@app.get("/api/products/{product_id}", response_model=Product)
def get_product(product_id: str):
    for product in mock_products:
        if product["id"] == product_id:
            return product
    raise HTTPException(status_code=404, detail="Ürün bulunamadı")

# 3. Yeni Ürün Ekleme (Satışa Çıkarma)
@app.post("/api/products", response_model=Product)
def create_product(product_data: ProductCreate):
    new_id = f"prod_{len(mock_products) + 1}"
    new_product = product_data.model_dump()  # pydantic v2 için güncel kullanım
    new_product["id"] = new_id
    mock_products.append(new_product)
    return new_product

# 4. Belirli Bir Kullanıcının Dolabı (Kendi Ürünleri)
@app.get("/api/users/{user_id}/products", response_model=List[Product])
def get_user_products(user_id: str):
    user_products = [p for p in mock_products if p["seller_id"] == user_id]
    return user_products
