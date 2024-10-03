FROM postgres:16

# 必要なツールをインストール
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libclang-dev \
    clang \
    ca-certificates \
    pkg-config \
    libssl-dev \
    git \
    postgresql-server-dev-16

# Rust のインストール
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# pgrx をインストール
RUN cargo install --locked cargo-pgrx && \
    cargo pgrx init --pg16 /usr/lib/postgresql/16/bin/pg_config

# pg_jsonschema をクローンしてビルド
RUN git clone https://github.com/supabase/pg_jsonschema.git /usr/src/pg_jsonschema && \
    cd /usr/src/pg_jsonschema && \
    cargo pgrx install --release

# ポート5432を開ける
EXPOSE 5432

# PostgreSQL のエントリーポイント
CMD ["postgres"]
