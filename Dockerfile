# ResearchClaw — main application image.
# Runs the 23-stage autonomous research pipeline.
# Build: docker build -t researchclaw/app:latest .
FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

# System packages needed for pip builds and LaTeX export
RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc g++ git \
        texlive-latex-base texlive-latex-extra texlive-fonts-recommended \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies first (layer cache)
COPY pyproject.toml ./
RUN pip install --no-cache-dir hatchling && \
    pip install --no-cache-dir pyyaml rich

# Copy source tree and install in editable mode
COPY researchclaw/ researchclaw/
RUN pip install --no-cache-dir -e .

# Default config and prompts
COPY config.researchclaw.example.yaml ./
COPY prompts.default.yaml ./

# Artifacts and knowledge-base directories
RUN mkdir -p /app/artifacts /app/docs/kb

ENTRYPOINT ["researchclaw"]
CMD ["--help"]
