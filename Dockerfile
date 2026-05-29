    Install uv
    COPY --from=ghcr.io/astral-sh/uv:0.9.24 /uv /bin/uv

    WORKDIR /app

    Enable optimizations
    ENV UV_COMPILE_BYTECODE=1
    ENV UV_LINK_MODE=copy
    ENV PYTHONDONTWRITEBYTECODE=1
    ENV PYTHONUNBUFFERED=1

    Copy dependency files
    COPY uv.lock pyproject.toml /app/

    Install dependencies
    RUN /bin/uv sync --frozen --no-install-project --no-group dev
    RUN /bin/uv sync --frozen --no-group dev

    Set path
    ENV PATH="/app/.venv/bin:$PATH"
    ENV HOME=/app

    Create user
    RUN addgroup --system app && adduser --system --group app

    Copy source files
    COPY --chown=app:app src/ /app/src/
    COPY --chown=app:app migrations/ /app/migrations/
    COPY --chown=app:app scripts/ /app/scripts/
    COPY --chown=app:app docker/ /app/docker/
    COPY --chown=app:app alembic.ini /app/alembic.ini

    USER app
    EXPOSE 8000
    CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "${PORT:-8000}"]
