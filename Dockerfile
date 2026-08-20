# Builder
FROM python:3.13-slim as builder
WORKDIR /app

# Install build deps
RUN apt-get update && apt-get install -y --no-install-recommends build-essential libpq-dev && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN python -m pip install --upgrade pip
RUN pip wheel --wheel-dir /wheels -r requirements.txt

# Runtime image
FROM python:3.13-slim
WORKDIR /app

# Create non-root user
RUN useradd -m appuser && mkdir -p /app && chown appuser:appuser /app
USER appuser

# Ensure user-local binaries are on PATH (pip --user installs here)
ENV PATH="/home/appuser/.local/bin:${PATH}"

COPY --chown=appuser:appuser --from=builder /wheels /wheels
COPY --chown=appuser:appuser --from=builder /app/requirements.txt /app/requirements.txt
RUN python -m pip install --no-index --find-links=/wheels -r /app/requirements.txt

COPY --chown=appuser:appuser . /app
ENV PYTHONUNBUFFERED=1
ENV PORT=8080

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s CMD ["python", "-c", "import sys,urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/health'); sys.exit(0)"]

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
