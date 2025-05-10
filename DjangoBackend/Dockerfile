FROM python:3.12-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    DJANGO_SETTINGS_MODULE=backend.settings \
    PATH="/usr/local/bin:$PATH" \
    SECURE_SSL_REDIRECT=False

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . ./

# Generate static files
ENV STATIC_ROOT=/app/staticfiles
RUN rm -rf "$STATIC_ROOT" \
 && python manage.py collectstatic --noinput --clear

# Expose application port
EXPOSE 8000

# Migrate changes
RUN python manage.py migrate

# Run application with Gunicorn
CMD ["gunicorn", "backend.wsgi:application", "-b", "0.0.0.0:8000", "--timeout", "120", "--workers", "3"]
# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]