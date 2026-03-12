"""add google oauth to users

Revision ID: add_google_oauth
Revises: e96e478b6601
Create Date: 2026-03-11 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'add_google_oauth'
down_revision = 'e96e478b6601'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Make password_hash nullable for Google users
    op.alter_column('users', 'password_hash',
                    existing_type=sa.String(length=255),
                    nullable=True)
    
    # Add Google OAuth fields
    op.add_column('users', sa.Column('auth_provider', sa.String(length=50), nullable=False, server_default='email'))
    op.add_column('users', sa.Column('google_id', sa.String(length=255), nullable=True))
    
    # Add indexes
    op.create_index(op.f('ix_users_google_id'), 'users', ['google_id'], unique=True)


def downgrade() -> None:
    # Remove indexes
    op.drop_index(op.f('ix_users_google_id'), table_name='users')
    
    # Remove Google OAuth fields
    op.drop_column('users', 'google_id')
    op.drop_column('users', 'auth_provider')
    
    # Make password_hash non-nullable again
    op.alter_column('users', 'password_hash',
                    existing_type=sa.String(length=255),
                    nullable=False)
