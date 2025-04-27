FROM python:3.12-slim

# ---- environment ----
ENV PYTHONUNBUFFERED=1 \
    DJANGO_SETTINGS_MODULE=backend.settings  \
    PATH="/usr/local/bin:$PATH"

# ---- work directory ----
WORKDIR /app

# ---- install dependencies ----
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

# ---- copy source ----
COPY . .

# ---- collect static assets ----
RUN python manage.py collectstatic --noinput

# ---- runtime command ----
CMD ["gunicorn", "backend.wsgi:application", "-b", "0.0.0.0:8000"]
