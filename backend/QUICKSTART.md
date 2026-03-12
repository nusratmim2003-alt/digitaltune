# Digital Cassette Backend - Quick Start

## ✅ Backend Structure Created

```
backend/
├── app/
│   ├── api/
│   │   ├── routes/
│   │   │   ├── __init__.py
│   │   │   └── cassettes.py         ✅ Create cassette endpoint
│   │   ├── __init__.py
│   │   └── deps.py                  ✅ JWT auth dependencies
│   ├── core/
│   │   ├── __init__.py
│   │   └── enums.py                 ✅ EmotionTag enum
│   ├── db/
│   │   ├── __init__.py
│   │   ├── base_class.py            ✅ SQLAlchemy Base
│   │   └── session.py               ✅ Database config
│   ├── models/
│   │   ├── __init__.py
│   │   ├── user.py                  ✅ User model
│   │   └── cassette.py              ✅ Cassette + SavedCassette models
│   ├── schemas/
│   │   ├── __init__.py
│   │   └── cassette.py              ✅ Pydantic schemas (camelCase)
│   ├── utils/
│   │   ├── __init__.py
│   │   ├── youtube.py               ✅ YouTube URL parser
│   │   └── share_code.py            ✅ 6-char code generator
│   ├── __init__.py
│   └── main.py                      ✅ FastAPI app
├── alembic/
│   ├── env.py                       ✅ Migration config
│   └── script.py.mako               ✅ Migration template
├── .env.example                     ✅ Environment template
├── .gitignore                       ✅
├── alembic.ini                      ✅ Alembic config
├── README.md                        ✅ Full documentation
└── requirements.txt                 ✅ Dependencies
```

## 🚀 Next Steps to Run Backend

### 1. Setup Python Environment
```powershell
cd backend
python -m venv venv
.\venv\Scripts\activate
pip install -r requirements.txt
```

### 2. Configure Environment
```powershell
copy .env.example .env
# Edit .env file:
# - Set DATABASE_URL
# - Set SECRET_KEY (generate with: openssl rand -hex 32)
```

### 3. Setup PostgreSQL Database
```powershell
# Install PostgreSQL if needed
# Then create database:
createdb digitalcassette

# Or via psql:
psql -U postgres
CREATE DATABASE digitalcassette;
\q
```

### 4. Run Database Migrations
```powershell
# Initialize Alembic (if needed)
alembic init alembic

# Create initial migration
alembic revision --autogenerate -m "Initial migration"

# Apply migrations
alembic upgrade head
```

### 5. Start Development Server
```powershell
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### 6. Test API
Open browser:
- API Docs: http://localhost:8000/docs
- Health Check: http://localhost:8000/health

## 🎯 What's Implemented

### ✅ Core Features
- **YouTube URL Parser**: Handles all YouTube URL formats
- **Share Code Generator**: 6-char uppercase codes (excludes 0, O, I, 1)
- **Emotion Tags**: 8 fixed emotions with emoji mapping
- **Password Protection**: Bcrypt hashing
- **JWT Authentication**: Bearer token auth

### ✅ Database Models
- **User**: id, name, email, passwordHash, photoUrl, timestamps
- **Cassette**: All fields aligned with Flutter frontend (camelCase in DB)
- **SavedCassette**: Junction table for library feature

### ✅ API Endpoints
- `POST /api/cassettes` - Create cassette (authenticated)
- `GET /` - Health check
- `GET /health` - Health status

### 📝 Pydantic Schemas
- Uses camelCase for JSON (matches Flutter)
- Validation for YouTube URLs, letter text, passwords
- Response schemas with proper typing

## 🔧 Development Workflow

### Create New Endpoint
1. Add route in `app/api/routes/`
2. Add schema in `app/schemas/`
3. Update router in `app/main.py`

### Add New Model
1. Create model in `app/models/`
2. Import in `alembic/env.py`
3. Run: `alembic revision --autogenerate -m "Add model"`
4. Run: `alembic upgrade head`

### Test Endpoint
```powershell
# Using curl
curl -X POST http://localhost:8000/api/cassettes \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "youtubeUrl": "https://youtu.be/dQw4w9WgXcQ",
    "letterText": "This reminds me of you...",
    "emotionTag": "Nostalgic",
    "senderIsAnonymous": false,
    "password": "secret123"
  }'
```

## 📋 TODO: Additional Endpoints

### Auth Endpoints (Not Yet Implemented)
```python
POST /api/auth/register     # User signup
POST /api/auth/login        # User login
GET  /api/auth/me           # Current user profile
POST /api/auth/refresh      # Refresh token
```

### Cassette Endpoints (Not Yet Implemented)
```python
GET  /api/cassettes/share/{shareCode}         # Get by share code
POST /api/cassettes/{id}/validate-password    # Validate password
POST /api/cassettes/{id}/increment-unlock     # Track unlock
POST /api/cassettes/{id}/save                 # Save to library
GET  /api/cassettes/library                   # User's library
DELETE /api/cassettes/{id}                    # Delete cassette
```

### File Upload (Not Yet Implemented)
```python
POST /api/upload/image      # Upload cover image
```

## 🔄 Alignment with Flutter Frontend

| Frontend Field | Backend Field | Status |
|---------------|---------------|--------|
| `id` | `id` | ✅ |
| `shareCode` | `shareCode` | ✅ |
| `shareUrl` | `shareUrl` | ✅ |
| `youtubeVideoId` | `youtubeVideoId` | ✅ |
| `youtubeEmbedUrl` | `youtubeEmbedUrl` | ✅ |
| `letterText` | `letterText` | ✅ |
| `emotionTag` | `emotionTag` | ✅ |
| `emotionEmoji` | `emotionEmoji` | ✅ |
| `senderIsAnonymous` | `senderIsAnonymous` | ✅ |
| `photoUrl` | `coverImageUrl` | ✅ |
| `password` | `passwordHash` (hashed) | ✅ |
| `unlockCount` | `unlockCount` | ✅ |
| `isActive` | `isActive` | ✅ |
| `isDeleted` | `isDeleted` | ✅ |

## 🎉 You're Ready!

Backend foundation is complete. Run the setup steps above to start the server and begin testing!
