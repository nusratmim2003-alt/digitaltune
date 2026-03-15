"""
FastAPI application for Digital Cassette backend.
"""

from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse
from sqlalchemy.orm import Session
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Import routers
from app.api.routes import auth, cassettes, library, replies, inbox
from app.db.session import get_db
from app.models.cassette import Cassette


# App metadata
APP_NAME = os.getenv("APP_NAME", "Digital Cassette")
APP_VERSION = os.getenv("APP_VERSION", "1.0.0")

# Create FastAPI app
app = FastAPI(
    title=APP_NAME,
    version=APP_VERSION,
    description="Backend API for Digital Cassette - YouTube song letters with emotional sharing"
)

# CORS configuration
allowed_origins = os.getenv(
    "ALLOWED_ORIGINS",
    "http://localhost:3000,http://127.0.0.1:3000,http://localhost:*,http://127.0.0.1:*"
).split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins for development
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ----------------------------------------------------
# API ROUTES
# ----------------------------------------------------
app.include_router(auth.router, prefix="/api", tags=["Auth"])
app.include_router(cassettes.router, prefix="/api", tags=["Cassettes"])
app.include_router(library.router, prefix="/api", tags=["Library"])
app.include_router(replies.router, prefix="/api", tags=["Replies"])
app.include_router(inbox.router, prefix="/api", tags=["Inbox"])


# ----------------------------------------------------
# ROOT ENDPOINT
# ----------------------------------------------------

@app.get("/")
async def root():
    return {
        "app": APP_NAME,
        "version": APP_VERSION,
        "status": "running"
    }


# ----------------------------------------------------
# HEALTH CHECK
# ----------------------------------------------------

@app.api_route("/health", methods=["GET", "HEAD"])
async def health_check():
    return {"status": "healthy"}


@app.get("/unlock/{share_code}", response_class=HTMLResponse)
async def web_unlock_page(share_code: str, db: Session = Depends(get_db)):
        cassette = db.query(Cassette).filter(Cassette.shareCode == share_code).first()

        if not cassette:
                return HTMLResponse(
                        content="""
                        <!doctype html>
                        <html>
                            <head><meta charset='utf-8'><meta name='viewport' content='width=device-width,initial-scale=1'></head>
                            <body style='font-family:system-ui,Segoe UI,Arial;padding:24px;background:#f9f8f5;color:#222'>
                                <h2>Cassette not found</h2>
                                <p>This cassette link may be invalid or expired.</p>
                            </body>
                        </html>
                        """,
                        status_code=404,
                )

        app_link = f"digitalcassette://unlock/{share_code}"

        html = f"""
        <!doctype html>
        <html>
            <head>
                <meta charset="utf-8" />
                <meta name="viewport" content="width=device-width,initial-scale=1" />
                <title>Unlock Cassette</title>
                <style>
                    body {{ font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial; background:#f9f8f5; color:#222; margin:0; }}
                    .wrap {{ max-width:520px; margin:0 auto; padding:24px 16px 40px; }}
                    .card {{ background:#fff; border-radius:16px; padding:20px; box-shadow:0 8px 24px rgba(0,0,0,.08); }}
                    .btn {{ display:inline-block; border:none; border-radius:10px; padding:12px 16px; cursor:pointer; font-weight:600; text-decoration:none; }}
                    .btn-primary {{ background:#d6a73d; color:#fff; }}
                    .btn-secondary {{ background:#eee5d2; color:#5a4a2e; }}
                    input {{ width:100%; padding:12px; border:1px solid #ddd; border-radius:10px; font-size:16px; box-sizing:border-box; }}
                    .row {{ display:flex; gap:10px; flex-wrap:wrap; margin-top:12px; }}
                    .muted {{ color:#666; font-size:14px; }}
                    #result {{ margin-top:16px; white-space:pre-wrap; }}
                    iframe {{ width:100%; aspect-ratio:16/9; border:0; border-radius:12px; margin-top:12px; }}
                </style>
            </head>
            <body>
                <div class="wrap">
                    <h2>🔓 Unlock this cassette</h2>
                    <p class="muted">If you have the app installed, open it directly. Otherwise unlock here on web.</p>

                    <div class="card">
                        <div class="row">
                            <a class="btn btn-primary" href="{app_link}">Open in App</a>
                        </div>

                        <div style="margin-top:14px">
                            <label for="pwd">Enter password</label>
                            <input id="pwd" type="password" placeholder="Password" />
                            <div class="row">
                                <button class="btn btn-secondary" id="unlockBtn">Unlock on Web</button>
                            </div>
                        </div>

                        <div id="result"></div>
                        <div id="player"></div>
                    </div>
                </div>

                <script>
                    const shareCode = {share_code!r};
                    const resultEl = document.getElementById('result');
                    const playerEl = document.getElementById('player');
                    const unlockBtn = document.getElementById('unlockBtn');
                    const pwdEl = document.getElementById('pwd');

                    async function unlockCassette() {{
                        const password = pwdEl.value.trim();
                        if (!password) {{
                            resultEl.textContent = 'Please enter password.';
                            return;
                        }}

                        resultEl.textContent = 'Unlocking...';
                        playerEl.innerHTML = '';

                        try {{
                            const res = await fetch(`/api/cassettes/${{shareCode}}/unlock`, {{
                                method: 'POST',
                                headers: {{ 'Content-Type': 'application/json' }},
                                body: JSON.stringify({{ password }})
                            }});

                            const data = await res.json();
                            if (!res.ok) {{
                                resultEl.textContent = data.detail || 'Failed to unlock cassette.';
                                return;
                            }}

                            resultEl.textContent = `Emotion: ${{data.emotionEmoji}} ${{data.emotionTag}}\n\n${{data.letterText}}`;
                            if (data.youtubeEmbedUrl) {{
                                playerEl.innerHTML = `<iframe src="${{data.youtubeEmbedUrl}}" allow="autoplay; encrypted-media" allowfullscreen></iframe>`;
                            }}
                        }} catch (e) {{
                            resultEl.textContent = 'Something went wrong. Please try again.';
                        }}
                    }}

                    unlockBtn.addEventListener('click', unlockCassette);
                </script>
            </body>
        </html>
        """

        return HTMLResponse(content=html)