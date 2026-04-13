"""
FastAPI application for Digital Cassette backend.
"""

from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse
from sqlalchemy.orm import Session
from html import escape as html_escape
import json
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

    def safe(value):
        return html_escape(str(value or ""), quote=True)

    if not cassette:
        return HTMLResponse(
            content="""
            <!doctype html>
            <html lang='en'>
                <head>
                    <meta charset='utf-8'>
                    <meta name='viewport' content='width=device-width,initial-scale=1'>
                    <title>TuneLetter not found</title>
                    <style>
                        body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial;background:#f5efe3;color:#2b2114;margin:0;display:grid;place-items:center;min-height:100vh;padding:24px}
                        .card{max-width:520px;width:100%;background:#fff;border-radius:24px;padding:24px;box-shadow:0 12px 36px rgba(0,0,0,.08)}
                        h2{margin:0 0 8px;font-size:28px}
                        p{margin:0;color:#6d5a40;line-height:1.6}
                    </style>
                </head>
                <body>
                    <div class='card'>
                        <h2>🎵 TuneLetter not found</h2>
                        <p>This link may be invalid or expired.</p>
                    </div>
                </body>
            </html>
            """,
            status_code=404,
        )

    app_link = f"digitalcassette://unlock/{share_code}"
    page_title = "🎵 You’ve received a TuneLetter"
    page_description = "A message + a song, just for you."
    cassette_image = cassette.thumbnailUrl or "https://digitaltune.onrender.com/static/cassette-preview.png"
    cassette_id_json = json.dumps(share_code)
    youtube_embed_json = json.dumps(cassette.youtubeEmbedUrl or "")
    youtube_url_json = json.dumps(cassette.youtubeUrl or "")

    if cassette.senderIsAnonymous:
        sender_display_name = "Someone"
    else:
        sender_display_name = getattr(cassette.sender, "name", None) or "Someone"

    sender_name = safe(sender_display_name)
    letter_text = safe(cassette.letterText).replace("\n", "<br>")
    cassette_image_safe = safe(cassette_image)
    page_title_safe = safe(page_title)
    page_description_safe = safe(page_description)
    app_link_safe = safe(app_link)

    html = f"""
    <!doctype html>
    <html lang="en">
        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width,initial-scale=1" />
            <meta name="theme-color" content="#6b4f2a" />
            <meta property="og:title" content="{page_title_safe}" />
            <meta property="og:description" content="{page_description_safe}" />
            <meta property="og:image" content="{cassette_image_safe}" />
            <meta property="og:type" content="website" />
            <meta property="twitter:card" content="summary_large_image" />
            <meta property="twitter:title" content="{page_title_safe}" />
            <meta property="twitter:description" content="{page_description_safe}" />
            <meta property="twitter:image" content="{cassette_image_safe}" />
            <title>{page_title_safe}</title>
            <style>
                :root {{
                    --bg: #4b2f1e;
                    --card: #fffaf2;
                    --ink: #2b2114;
                    --accent: #d6a73d;
                    --accent-dark: #b78518;
                    --line: rgba(107,79,42,.16);
                    --white: #fff;
                }}
                * {{ box-sizing: border-box; }}
                body {{
                    margin: 0;
                    min-height: 100vh;
                    font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
                    background: linear-gradient(180deg, #3b2518 0%, var(--bg) 20%, #2f1d13 100%);
                    color: var(--white);
                }}
                .wrap {{ max-width: 640px; margin: 0 auto; padding: 20px 16px 40px; }}
                .hero {{ text-align: center; padding: 8px 8px 18px; }}
                .badge {{
                    display: inline-flex; align-items: center; gap: 8px;
                    padding: 8px 12px; border-radius: 999px;
                    background: rgba(214,167,61,.16); color: #ffe19b;
                    font-weight: 700; font-size: 13px; letter-spacing: .2px;
                }}
                h1 {{ margin: 14px 0 8px; font-size: clamp(28px, 5vw, 40px); line-height: 1.1; }}
                .sub {{ margin: 0; color: rgba(255,255,255,.72); font-size: 16px; line-height: 1.6; }}
                .cassette {{
                    margin-top: 18px; background: rgba(255,250,242,.08);
                    border: 1px solid rgba(255,255,255,.12); border-radius: 28px; padding: 18px;
                    box-shadow: 0 18px 45px rgba(0,0,0,.18); backdrop-filter: blur(8px);
                }}
                .preview {{
                    border-radius: 22px; overflow: hidden; background: rgba(255,255,255,.08);
                    aspect-ratio: 16 / 9; display: grid; place-items: center; border: 1px solid var(--line);
                    margin-bottom: 16px;
                }}
                .preview img {{ width: 100%; height: 100%; object-fit: cover; display: block; }}
                .meta {{ display: grid; gap: 6px; margin-bottom: 16px; }}
                .sender {{ font-weight: 700; font-size: 18px; color: var(--white); }}
                .hint {{ color: rgba(255,255,255,.65); font-size: 14px; }}
                label {{ display: block; font-weight: 700; margin-bottom: 8px; color: var(--white); }}
                input {{
                    width: 100%; padding: 14px 14px; font-size: 16px; border-radius: 14px;
                    border: 1px solid rgba(255,255,255,.18); outline: none; background: rgba(255,255,255,.98); color: var(--ink);
                }}
                input:focus {{ border-color: rgba(214,167,61,.9); box-shadow: 0 0 0 4px rgba(214,167,61,.18); }}
                .actions {{ display: flex; gap: 10px; flex-wrap: wrap; margin-top: 14px; }}
                .btn {{
                    appearance: none; border: 0; border-radius: 14px; padding: 12px 16px;
                    font-weight: 700; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; justify-content: center;
                }}
                .primary {{ background: var(--accent); color: white; }}
                .secondary {{ background: rgba(255,255,255,.10); color: var(--white); border: 1px solid rgba(255,255,255,.12); }}
                .full {{ width: 100%; }}
                .result {{ margin-top: 16px; white-space: pre-wrap; line-height: 1.7; color: var(--white); }}
                .player {{ margin-top: 16px; }}
                iframe {{ width: 100%; aspect-ratio: 16 / 9; border: 0; border-radius: 18px; }}
                .content-card {{
                    margin-top: 16px; background: var(--card); border: 1px solid var(--line);
                    border-radius: 18px; padding: 16px; color: var(--ink);
                }}
                .emotion {{ display: inline-flex; align-items: center; gap: 8px; margin-bottom: 8px; font-weight: 700; color: var(--accent-dark); }}
                .letter {{ color: var(--ink); line-height: 1.75; white-space: pre-wrap; }}
                .muted {{ color: rgba(255,255,255,.62); font-size: 14px; }}
            </style>
        </head>
        <body>
            <div class="wrap">
                <div class="hero">
                    <div class="badge">🎵 TuneLetter</div>
                    <h1>{page_title_safe}</h1>
                    <p class="sub">{page_description_safe}</p>
                </div>

                <div class="cassette">
                    <div class="preview">
                        <img src="{cassette_image_safe}" alt="TuneLetter preview" />
                    </div>

                    <div class="meta">
                        <div class="sender">{sender_name} sent you a memory</div>
                        <div class="hint">Open in the app or unlock right here on this page.</div>
                    </div>

                    <div>
                        <label for="pwd">Password</label>
                        <input id="pwd" type="password" placeholder="Enter password" autocomplete="current-password" />
                        <div class="actions">
                            <button class="btn primary full" id="unlockBtn">Open & Listen</button>
                            <a class="btn secondary" href="{app_link_safe}">Open in App</a>
                        </div>
                        <div class="muted" style="margin-top:10px">If you have the app installed, it opens there. Otherwise, unlock here.</div>
                    </div>

                    <div id="result" class="result"></div>
                    <div id="player" class="player"></div>
                </div>
            </div>

            <script>
                const shareCode = {cassette_id_json};
                const youtubeEmbedUrl = {youtube_embed_json};
                const youtubeUrl = {youtube_url_json};
                const resultEl = document.getElementById('result');
                const playerEl = document.getElementById('player');
                const unlockBtn = document.getElementById('unlockBtn');
                const pwdEl = document.getElementById('pwd');

                function escapeHtml(text) {{
                    return String(text)
                        .replace(/&/g, '&amp;')
                        .replace(/</g, '&lt;')
                        .replace(/>/g, '&gt;')
                        .replace(/"/g, '&quot;')
                        .replace(/'/g, '&#39;');
                }}

                async function unlockCassette() {{
                    const password = pwdEl.value.trim();
                    if (!password) {{
                        resultEl.textContent = 'Please enter a password.';
                        pwdEl.focus();
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
                            resultEl.textContent = data.detail || data.message || 'Failed to unlock cassette.';
                            return;
                        }}

                        resultEl.innerHTML = `
                            <div class="content-card">
                                <div class="emotion">${{escapeHtml(data.emotionEmoji || '🎵')}} <span>${{escapeHtml(data.emotionTag || 'TuneLetter')}}</span></div>
                                <div class="letter">${{escapeHtml(data.letterText || '').replace(/\\n/g, '<br>')}}</div>
                            </div>
                            <div class="actions" style="margin-top: 14px;">
                                <a class="btn primary full" href="${{escapeHtml(data.youtubeUrl || youtubeUrl || '')}}" target="_blank" rel="noreferrer">Watch in YouTube</a>
                                <a class="btn secondary" href="{app_link_safe}">Open in App</a>
                            </div>`;

                        if (data.youtubeEmbedUrl || youtubeEmbedUrl) {{
                            const videoUrl = data.youtubeEmbedUrl || youtubeEmbedUrl;
                            playerEl.innerHTML = `<iframe src="${{videoUrl}}" allow="autoplay; encrypted-media" allowfullscreen></iframe>`;
                        }}
                    }} catch (e) {{
                        resultEl.textContent = 'Something went wrong. Please try again.';
                    }}
                }}

                unlockBtn.addEventListener('click', unlockCassette);
                pwdEl.addEventListener('keydown', (event) => {{
                    if (event.key === 'Enter') unlockCassette();
                }});
            </script>
        </body>
    </html>
    """

    return HTMLResponse(content=html)