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
        sender_name = "Someone" if cassette.senderIsAnonymous else (cassette.sender.name if cassette.sender else "Someone")
        cassette_title = cassette.title or "A musical memory"
        emotion_emoji = cassette.emotionEmoji or "🎵"
        emotion_tag = cassette.emotionTag or "Memory"
        thumbnail_url = cassette.thumbnailUrl or ""

        html = f"""
        <!doctype html>
        <html>
            <head>
                <meta charset="utf-8" />
                <meta name="viewport" content="width=device-width,initial-scale=1" />
                <title>TuneLetter · Unlock Cassette</title>
                <style>
                    :root {{
                        --bg:#1f1712;
                        --paper:#f9f8f5;
                        --card:#fffaf2;
                        --card-strong:#2c211a;
                        --accent:#d6a73d;
                        --accent-soft:#efe2bd;
                        --text:#241b16;
                        --muted:#76685f;
                        --line:rgba(36,27,22,.12);
                    }}
                    * {{ box-sizing:border-box; }}
                    body {{
                        font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial;
                        background: radial-gradient(circle at top, #48352a 0%, var(--bg) 42%, #16100d 100%);
                        color: var(--text);
                        margin: 0;
                    }}
                    .wrap {{ max-width: 760px; margin: 0 auto; padding: 28px 16px 56px; }}
                    .hero {{ text-align:center; color:#fff7e8; margin-bottom:22px; }}
                    .brand {{
                        display:inline-flex; align-items:center; gap:10px; padding:10px 14px;
                        border-radius:999px; background:rgba(255,248,232,.09); border:1px solid rgba(255,248,232,.12);
                        backdrop-filter: blur(8px);
                    }}
                    .brand-mark {{
                        width:36px; height:36px; border-radius:50%; display:grid; place-items:center;
                        background: linear-gradient(135deg, #7a5a42, #3b2b22); color:var(--accent); font-size:18px;
                        box-shadow: 0 8px 20px rgba(0,0,0,.24);
                    }}
                    .eyebrow {{ color:#e8d8b0; text-transform:uppercase; letter-spacing:1.4px; font-size:12px; margin:20px 0 8px; }}
                    h1 {{ margin:0; font-size:clamp(28px, 5vw, 42px); line-height:1.12; }}
                    .hero p {{ color:rgba(255,247,232,.74); max-width:560px; margin:12px auto 0; font-size:15px; line-height:1.6; }}
                    .grid {{ display:grid; gap:18px; grid-template-columns: 1.05fr .95fr; align-items:start; }}
                    .card {{
                        background: linear-gradient(180deg, rgba(255,250,242,.98), rgba(255,247,236,.96));
                        border-radius: 24px; padding: 22px; box-shadow: 0 20px 42px rgba(0,0,0,.18);
                        border:1px solid rgba(255,255,255,.34);
                    }}
                    .dark-card {{
                        background: linear-gradient(180deg, rgba(44,33,26,.98), rgba(26,19,15,.98));
                        color:#fff6e7; border:1px solid rgba(255,255,255,.08);
                    }}
                    .preview-stack {{ display:flex; flex-direction:column; gap:16px; }}
                    .cassette-shell {{
                        position:relative; min-height:260px; border-radius:22px; overflow:hidden;
                        background: linear-gradient(145deg, #5a4131, #2a1d16 70%);
                        border:1px solid rgba(255,255,255,.08);
                        box-shadow: inset 0 1px 0 rgba(255,255,255,.08);
                    }}
                    .cassette-shell::before, .cassette-shell::after {{
                        content:""; position:absolute; width:76px; height:76px; top:82px; border-radius:50%;
                        background: radial-gradient(circle, #fff6e7 0 13px, #33261f 14px 24px, #fff6e7 25px 34px, #2a1d16 35px);
                        box-shadow: inset 0 0 0 10px rgba(255,255,255,.08);
                    }}
                    .cassette-shell::before {{ left:92px; }}
                    .cassette-shell::after {{ right:92px; }}
                    .label {{
                        position:absolute; left:50%; top:36px; transform:translateX(-50%);
                        width:min(82%, 340px); border-radius:16px; background:#fff8ec; color:#2a1d16;
                        padding:16px 18px; text-align:center; box-shadow:0 10px 24px rgba(0,0,0,.16);
                    }}
                    .emotion-pill {{
                        display:inline-flex; align-items:center; gap:8px; padding:8px 14px; border-radius:999px;
                        background:rgba(214,167,61,.14); color:#714f06; font-weight:700; font-size:13px;
                        border:1px solid rgba(214,167,61,.28);
                    }}
                    .label-title {{ margin:10px 0 0; font-size:20px; font-weight:700; }}
                    .label-sub {{ margin:6px 0 0; font-size:13px; color:#685a51; }}
                    .hero-thumb {{
                        margin-top:14px; width:100%; aspect-ratio:16/9; border:0; border-radius:16px; object-fit:cover;
                        background:#33261f;
                    }}
                    .section-title {{ margin:0 0 8px; font-size:18px; font-weight:700; }}
                    .muted {{ color: var(--muted); font-size:14px; line-height:1.6; }}
                    .sender-meta {{ display:flex; gap:10px; align-items:center; margin:16px 0 0; }}
                    .avatar {{
                        width:44px; height:44px; border-radius:50%; display:grid; place-items:center;
                        background:rgba(214,167,61,.2); color:var(--accent); font-weight:700;
                    }}
                    .field {{ margin-top:18px; }}
                    label {{ display:block; margin-bottom:8px; font-size:14px; font-weight:600; color:#f9e9c8; }}
                    input {{
                        width:100%; padding:14px 15px; border:1px solid rgba(255,255,255,.12); border-radius:14px;
                        font-size:16px; background:rgba(255,255,255,.06); color:#fff7e8;
                    }}
                    input::placeholder {{ color:rgba(255,247,232,.36); }}
                    .row {{ display:flex; gap:12px; flex-wrap:wrap; margin-top:14px; }}
                    .btn {{
                        display:inline-flex; align-items:center; justify-content:center; gap:8px; min-height:48px;
                        padding:12px 18px; border:none; border-radius:14px; cursor:pointer; font-weight:700;
                        text-decoration:none; font-size:15px; transition:transform .15s ease, opacity .15s ease, background .2s ease;
                    }}
                    .btn:hover {{ transform:translateY(-1px); }}
                    .btn-primary {{ background: linear-gradient(135deg, #ddb14c, #c69428); color:#fff; box-shadow:0 12px 22px rgba(214,167,61,.22); }}
                    .btn-secondary {{ background: rgba(255,248,232,.1); color:#fff7e8; border:1px solid rgba(255,255,255,.12); }}
                    .btn-light {{ background:#f2e4bf; color:#5d4212; }}
                    .btn-ghost {{ background:#f7f0e2; color:#513d2c; border:1px solid var(--line); }}
                    .btn-full {{ width:100%; }}
                    .status {{ margin-top:14px; min-height:24px; color:#f5dec7; font-size:14px; }}
                    .result-card {{ display:none; margin-top:18px; }}
                    .letter-card {{
                        margin-top:16px; background:rgba(255,248,232,.08); border:1px solid rgba(255,255,255,.08);
                        border-radius:18px; padding:18px; color:#fff6e7;
                    }}
                    .letter-body {{ white-space:pre-wrap; font-size:18px; line-height:1.9; font-weight:600; }}
                    .letter-sign {{ margin-top:14px; text-align:right; color:#e8d8b0; font-style:italic; }}
                    iframe {{ width:100%; aspect-ratio:16/9; border:0; border-radius:18px; margin-top:16px; background:#000; }}
                    .app-actions {{ display:none; margin-top:18px; gap:12px; flex-wrap:wrap; }}
                    .action-note {{ margin-top:12px; color:#6b5a4d; font-size:13px; line-height:1.6; }}
                    .feature-note {{ display:none; margin-top:12px; padding:12px 14px; border-radius:14px; background:#fbf3df; color:#70541f; border:1px solid #ead4a1; font-size:14px; }}
                    @media (max-width: 760px) {{
                        .grid {{ grid-template-columns: 1fr; }}
                        .cassette-shell::before {{ left:64px; }}
                        .cassette-shell::after {{ right:64px; }}
                    }}
                </style>
            </head>
            <body>
                <div class="wrap">
                    <div class="hero">
                        <div class="brand">
                            <div class="brand-mark">♪</div>
                            <strong>TuneLetter</strong>
                        </div>
                        <div class="eyebrow">A song says what words can't</div>
                        <h1>Someone sent you a musical memory</h1>
                        <p>Unlock it here on web for the full first impression, or open it in the app for saving and replying.</p>
                    </div>

                    <div class="grid">
                        <div class="card preview-stack">
                            <div class="cassette-shell">
                                <div class="label">
                                    <span class="emotion-pill">{emotion_emoji} {emotion_tag}</span>
                                    <p class="label-title">{cassette_title}</p>
                                    <p class="label-sub">From {sender_name}</p>
                                </div>
                                {f'<img class="hero-thumb" src="{thumbnail_url}" alt="Cassette cover" />' if thumbnail_url else ''}
                            </div>

                            <div>
                                <p class="section-title">What the receiver experiences</p>
                                <p class="muted">Unlock the cassette to read the letter and watch the song right here. To save it in your library or send a reply, open it in the TuneLetter app.</p>
                            </div>

                            <div class="sender-meta">
                                <div class="avatar">{sender_name[:1].upper()}</div>
                                <div>
                                    <div style="font-weight:700">{sender_name}</div>
                                    <div class="muted">Shared via secure cassette link</div>
                                </div>
                            </div>
                        </div>

                        <div class="card dark-card">
                            <p class="section-title" style="color:#fff7e8">Unlock this cassette</p>
                            <p class="muted" style="color:rgba(255,247,232,.74)">If you already have the app, open it directly. Otherwise unlock on web and enjoy the memory here.</p>

                            <div class="row">
                                <a class="btn btn-primary" href="{app_link}">Open in App</a>
                                <button class="btn btn-secondary" id="openReplyBtn" type="button">Install App for Reply</button>
                            </div>

                            <div class="field">
                                <label for="pwd">Enter password</label>
                                <input id="pwd" type="password" placeholder="Password" />
                                <div class="row">
                                    <button class="btn btn-light btn-full" id="unlockBtn" type="button">Unlock on Web</button>
                                </div>
                            </div>

                            <div class="status" id="status">Your letter and song will appear below after unlock.</div>
                        </div>
                    </div>

                    <div class="card dark-card result-card" id="resultCard">
                        <div style="display:flex;justify-content:space-between;gap:12px;align-items:center;flex-wrap:wrap;">
                            <div>
                                <div class="eyebrow" style="margin:0 0 6px;color:#e8d8b0;">Unlocked memory</div>
                                <div class="emotion-pill" id="emotionBadge">{emotion_emoji} {emotion_tag}</div>
                            </div>
                            <a class="btn btn-secondary" href="{app_link}">Open in App</a>
                        </div>

                        <div class="letter-card">
                            <div class="letter-body" id="letterText"></div>
                            <div class="letter-sign" id="letterSign">— {sender_name}</div>
                        </div>

                        <div id="player"></div>

                        <div class="row app-actions" id="appActions">
                            <button class="btn btn-primary" id="saveBtn" type="button">Save to Library</button>
                            <button class="btn btn-ghost" id="replyBtn" type="button">Reply with a Cassette</button>
                        </div>
                        <div class="feature-note" id="featureNote"></div>
                        <div class="action-note">Saving and replying stay inside the TuneLetter app so the receiver gets the full experience there.</div>
                    </div>
                </div>

                <script>
                    const shareCode = {share_code!r};
                    const appLink = {app_link!r};
                    const statusEl = document.getElementById('status');
                    const resultCardEl = document.getElementById('resultCard');
                    const playerEl = document.getElementById('player');
                    const unlockBtn = document.getElementById('unlockBtn');
                    const pwdEl = document.getElementById('pwd');
                    const letterTextEl = document.getElementById('letterText');
                    const emotionBadgeEl = document.getElementById('emotionBadge');
                    const appActionsEl = document.getElementById('appActions');
                    const featureNoteEl = document.getElementById('featureNote');
                    const openReplyBtn = document.getElementById('openReplyBtn');
                    const saveBtn = document.getElementById('saveBtn');
                    const replyBtn = document.getElementById('replyBtn');

                    function promptOpenApp(feature) {{
                        featureNoteEl.style.display = 'block';
                        featureNoteEl.textContent = `Install or open the TuneLetter app to ${{feature}} this cassette.`;
                        window.setTimeout(() => {{
                            window.location.href = appLink;
                        }}, 250);
                    }}

                    async function unlockCassette() {{
                        const password = pwdEl.value.trim();
                        if (!password) {{
                            statusEl.textContent = 'Please enter the password first.';
                            return;
                        }}

                        statusEl.textContent = 'Unlocking your cassette...';
                        playerEl.innerHTML = '';
                        featureNoteEl.style.display = 'none';

                        try {{
                            const res = await fetch(`/api/cassettes/${{shareCode}}/unlock`, {{
                                method: 'POST',
                                headers: {{ 'Content-Type': 'application/json' }},
                                body: JSON.stringify({{ password }})
                            }});

                            const data = await res.json();
                            if (!res.ok) {{
                                statusEl.textContent = data.detail || 'Failed to unlock cassette.';
                                resultCardEl.style.display = 'none';
                                return;
                            }}

                            statusEl.textContent = 'Unlocked. Enjoy the memory below.';
                            resultCardEl.style.display = 'block';
                            appActionsEl.style.display = 'flex';
                            emotionBadgeEl.textContent = `${{data.emotionEmoji}} ${{data.emotionTag}}`;
                            letterTextEl.textContent = data.letterText || '';
                            if (data.youtubeEmbedUrl) {{
                                playerEl.innerHTML = `<iframe src="${{data.youtubeEmbedUrl}}" allow="autoplay; encrypted-media" allowfullscreen></iframe>`;
                            }} else {{
                                playerEl.innerHTML = '';
                            }}
                        }} catch (e) {{
                            statusEl.textContent = 'Something went wrong. Please try again.';
                        }}
                    }}

                    unlockBtn.addEventListener('click', unlockCassette);
                    openReplyBtn.addEventListener('click', () => promptOpenApp('reply to'));
                    saveBtn.addEventListener('click', () => promptOpenApp('save'));
                    replyBtn.addEventListener('click', () => promptOpenApp('reply to'));
                    pwdEl.addEventListener('keydown', (event) => {{
                        if (event.key === 'Enter') unlockCassette();
                    }});
                </script>
            </body>
        </html>
        """

        return HTMLResponse(content=html)