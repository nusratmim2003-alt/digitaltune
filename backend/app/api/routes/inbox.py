"""
Inbox endpoints for Digital Cassette.
"""

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import desc

from app.db.session import get_db
from app.models.user import User
from app.models.cassette import Cassette
from app.models.cassette_reply import CassetteReply
from app.api.deps import get_current_user
from app.schemas.inbox import InboxItem, InboxListResponse

router = APIRouter()


@router.get("/library/inbox", response_model=InboxListResponse)
def get_inbox(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    # Inbox rule for MVP:
    # show cassettes created by current user that have at least one reply

    reply_rows = (
        db.query(CassetteReply)
        .join(Cassette, CassetteReply.cassetteId == Cassette.id)
        .filter(Cassette.senderId == current_user.id)
        .order_by(desc(CassetteReply.createdAt))
        .all()
    )

    seen = set()
    items = []

    for row in reply_rows:
        cassette = row.cassette
        if cassette.id in seen:
            continue
        seen.add(cassette.id)

        items.append(
            InboxItem(
                cassetteId=cassette.id,
                shareCode=cassette.shareCode,
                thumbnailUrl=cassette.thumbnailUrl,
                emotionTag=cassette.emotionTag,
                emotionEmoji=cassette.emotionEmoji,
                latestReplyText=row.replyText,
                latestReplyAt=row.createdAt,
                latestReplySenderName=row.sender.name if row.sender else None,
            )
        )

    return InboxListResponse(items=items, total=len(items))