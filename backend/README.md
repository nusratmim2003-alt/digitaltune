# Digital Cassette Backend

FastAPI backend for Digital Cassette - YouTube song letters with emotional sharing.

## 📁 Project Structure

```
backend/
├── app/
│   ├── api/
│   │   ├── routes/
│   │   │   └── cassettes.py      # Cassette CRUD endpoints
│   │   └── deps.py                # Auth dependencies
│   ├── core/
│   │   └── enums.py               # EmotionTag enum
│   ├── db/
│   │   ├── base_class.py          # SQLAlchemy Base
│   │   └── session.py             # Database session config
│   ├── models/
│   │   ├── user.py                # User model
│   │   └── cassette.py            # Cassette & SavedCassette models
│   ├── schemas/
│   │   └── cassette.py            # Pydantic schemas (camelCase JSON)
│   ├── utils/
│   │   ├── youtube.py             # YouTube URL parsing
│   │   └── share_code.py          # 6-char code generation
│   └── main.py                    # FastAPI app entry point
├── alembic/                       # Database migrations
├── .env.example                   # Environment variables template
└── requirements.txt               # Python dependencies
```

## 🚀 Setup

### 1. Install Dependencies

```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 2. Configure Environment

```bash
cp .env.example .env
# Edit .env with your values:
# - DATABASE_URL
# - SECRET_KEY
# - FRONTEND_URL
```

### 3. Setup Database

```bash
# Create PostgreSQL database
createdb digitalcassette

# Run migrations
alembic upgrade head
```

### 4. Run Server

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Server runs at: http://localhost:8000

API docs: http://localhost:8000/docs

## 📊 Database Models

### User
- `id` (UUID, PK)
- `name`, `email`, `passwordHash`
- `photoUrl`, `isActive`, `isVerified`
- `createdAt`, `updatedAt`

### Cassette
- `id` (UUID, PK)
- `senderId` (FK → users)
- `shareCode` (6-char unique)
- `shareUrl`
- `youtubeUrl`, `youtubeVideoId`, `youtubeEmbedUrl`
- `title`, `thumbnailUrl`
- `letterText`, `coverImageUrl`
- `emotionTag`, `emotionEmoji`
- `senderIsAnonymous`
- `passwordHash`
- `isActive`, `isDeleted`
- `unlockCount`
- `createdAt`, `updatedAt`

### SavedCassette (Junction Table)
- `userId` → users
- `cassetteId` → cassettes
- `savedAt`

## 🎯 API Endpoints

### Public
- `GET /` - Health check
- `GET /health` - Health status

### Cassettes (Authenticated)
- `POST /api/cassettes` - Create cassette

## 🔐 Authentication

Uses JWT tokens via Bearer authentication:

```
Authorization: Bearer <token>
```

## 📝 API Request/Response Examples

### Create Cassette

**Request:**
```json
POST /api/cassettes
Authorization: Bearer <token>

{
  "youtubeUrl": "https://youtu.be/dQw4w9WgXcQ",
  "letterText": "This song reminds me of...",
  "emotionTag": "Nostalgic",
  "senderIsAnonymous": false,
  "password": "secret123",
  "coverImageUrl": null
}
```

**Response:**
```json
{
  "cassette": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "shareCode": "AX34DF",
    "shareUrl": "https://digitalcassette.app/unlock/AX34DF",
    "youtubeUrl": "https://youtu.be/dQw4w9WgXcQ",
    "youtubeVideoId": "dQw4w9WgXcQ",
    "youtubeEmbedUrl": "https://www.youtube.com/embed/dQw4w9WgXcQ",
    "thumbnailUrl": "https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg",
    "letterText": "This song reminds me of...",
    "coverImageUrl": null,
    "emotionTag": "Nostalgic",
    "emotionEmoji": "🌅",
    "senderName": "John Doe",
    "senderIsAnonymous": false,
    "isActive": true,
    "isDeleted": false,
    "unlockCount": 0,
    "createdAt": "2026-03-09T12:00:00Z",
    "updatedAt": "2026-03-09T12:00:00Z"
  },
  "message": "Cassette created successfully"
}
```

## 🌟 Features

### YouTube URL Support
Accepts various YouTube URL formats:
- `https://www.youtube.com/watch?v=VIDEO_ID`
- `https://youtu.be/VIDEO_ID`
- `https://m.youtube.com/watch?v=VIDEO_ID`
- `https://music.youtube.com/watch?v=VIDEO_ID`
- `https://www.youtube.com/embed/VIDEO_ID`

### Share Code Generation
- 6-character uppercase alphanumeric
- Excludes confusing characters: 0, O, I, 1
- Guaranteed unique in database

### Emotion Tags
Fixed list: `Joyful`, `Melancholic`, `Nostalgic`, `Hopeful`, `Romantic`, `Bittersweet`, `Peaceful`, `Energetic`

## 🔧 Development

### Run Tests
```bash
pytest
```

### Format Code
```bash
black app/
```

### Type Checking
```bash
mypy app/
```

## 📦 Deployment

### Production Setup
1. Set strong `SECRET_KEY` in environment
2. Configure production database
3. Set `DEBUG=False`
4. Use production WSGI server (gunicorn)
5. Enable HTTPS
6. Configure CORS for production domain

### Docker (Optional)
```bash
docker build -t digitalcassette-backend .
docker run -p 8000:8000 digitalcassette-backend
```

## 🛣️ Next Steps

### Auth Endpoints (TODO)
- `POST /api/auth/register` - User signup
- `POST /api/auth/login` - User login
- `GET /api/auth/me` - Current user

### Cassette Endpoints (TODO)
- `GET /api/cassettes/share/{shareCode}` - Get by share code
- `POST /api/cassettes/{id}/validate-password` - Validate password
- `POST /api/cassettes/{id}/increment-unlock` - Track unlock
- `POST /api/cassettes/{id}/save` - Save to library
- `GET /api/cassettes/library` - User's saved cassettes

### File Upload (TODO)
- `POST /api/upload/image` - Upload cover image
