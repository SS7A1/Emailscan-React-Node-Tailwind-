FROM python:3.10-slim

# deps สำหรับ build แพ็กเกจที่มีส่วน C
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential python3-dev pkg-config \
    libxml2-dev libxslt1-dev \
    libyara-dev \
    libmagic1 libmagic-dev \
  && rm -rf /var/lib/apt/lists/*

ENV PIP_NO_CACHE_DIR=1
RUN pip install --upgrade pip setuptools wheel

WORKDIR /app
COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY worker.py ./worker.py
ENV PYTHONUNBUFFERED=1
CMD ["rq", "worker", "-u", "${REDIS_URL}", "scans"]
