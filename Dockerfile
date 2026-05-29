FROM python:3.13-slim-bookworm
COPY --from=ghcr.io/astral-sh/uv:0.9.24 /uv /bin/uv
WORKDIR /app
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
COPY pyproject.toml uv.lock /app/
RUN /bin/uv sync --frozen --no-install-project
COPY sdks/ /app/sdks/
COPY src/ /app/src/
COPY migrations/ /app/migrations/
COPY scripts/ /app/scripts/
COPY docker/ /app/docker/
COPY alembic.ini /app/
RUN addgroup --system app && adduser --system --group app && chown -R app:app /app
USER app
EXPOSE 8000
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
