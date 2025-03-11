ARG PYTHON_BASE=3.12-slim

FROM python:${PYTHON_BASE} AS builder

RUN pip install -U pdm

WORKDIR /app
COPY pyproject.toml pdm.lock ./
RUN pdm install --check --prod --no-editable

FROM python:${PYTHON_BASE}
ENV PATH="/app/.venv/bin:$PATH"

WORKDIR /app

COPY --from=builder /app/.venv ./.venv
COPY src ./

RUN groupadd -r appuser && useradd -r -g appuser appuser \
    && chown -R appuser:appuser /app
USER appuser

CMD ["python", "src/main.py"]