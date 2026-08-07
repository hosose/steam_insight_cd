#!/usr/bin/env python3
"""Convert an AWS Secrets Manager JSON document to a kubectl env file."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--secret-json", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--db-host", required=True)
    parser.add_argument("--db-port", required=True)
    parser.add_argument("--db-name", required=True)
    args = parser.parse_args()

    data = json.loads(args.secret_json.read_text(encoding="utf-8-sig"))

    username = data.get("username")
    password = data.get("password")

    if not username or not password:
        raise ValueError("Secrets Manager JSON에 username 또는 password가 없습니다.")

    values = {
        "DB_HOST": args.db_host,
        "DB_PORT": args.db_port,
        "DB_NAME": args.db_name,
        "DB_USER": str(username),
        "DB_PASSWORD": str(password),
    }

    # Automatically scan for local .env files and include API keys like STEAM_API_KEY
    root_dir = Path(__file__).resolve().parents[1]
    possible_env_paths = [
        root_dir / ".env",
        root_dir / "Steam_Insight_Dashboard" / ".env",
        root_dir.parent / "steam_insight_ci" / ".env",
        root_dir.parent / "steam_insight_ci" / "Steam_Insight_Dashboard" / ".env",
    ]
    for env_path in possible_env_paths:
        if env_path.is_file():
            for line in env_path.read_text(encoding="utf-8").splitlines():
                line = line.strip()
                if line and not line.startswith("#") and "=" in line:
                    k, v = line.split("=", 1)
                    k = k.strip()
                    v = v.strip().strip('"').strip("'")
                    if k in ["STEAM_API_KEY", "Bedrock_API_Key", "BEDROCK_API_KEY"] and v:
                        values[k] = v

    for key, value in values.items():
        if "\n" in value or "\r" in value:
            raise ValueError(f"{key} 값에 줄바꿈이 포함되어 있습니다.")

    args.output.write_text(
        "".join(f"{key}={value}\n" for key, value in values.items()),
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
