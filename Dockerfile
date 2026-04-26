FROM python:3.10-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

COPY requirements.txt ./
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .
RUN uv sync --frozen --no-dev --extra train

EXPOSE 7860

HEALTHCHECK CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:7860', timeout=5).read()" || exit 1

CMD ["streamlit", "run", "app.py", "--server.port=7860", "--server.address=0.0.0.0", "--server.headless=true", "--browser.gatherUsageStats=false"]
