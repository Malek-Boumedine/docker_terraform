"""Ajout de la contrainte foreign key sur id_demandeur

Revision ID: ab98db001713
Revises: 90f2fbb3cb9b
Create Date: 2025-02-19 10:29:58.039001

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'ab98db001713'
down_revision: Union[str, None] = '90f2fbb3cb9b'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_foreign_key(
        "fk_loan_requests_user",    # nom de la contrainte
        "loan_requests",            # nom de la table source
        "user",                     # nom de la table référencée
        ["id_demandeur"],           # colonne(s) de la table source
        ["id"],                     # colonne(s) de la table référencée
    )


def downgrade() -> None:
    pass
