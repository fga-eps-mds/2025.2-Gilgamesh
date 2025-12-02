FROM python:3.11-slim-bookworm

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
