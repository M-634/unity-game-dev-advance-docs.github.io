"""Shared documentation commands for Codex, Claude Code, and local work."""

import argparse
from pathlib import Path
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("serve", "build"))
    args = parser.parse_args()
    command = [sys.executable, "-m", "mkdocs", args.command]
    if args.command == "serve":
        command.extend(["--dev-addr", "127.0.0.1:8000"])
    return subprocess.call(command, cwd=Path(__file__).resolve().parents[1])


if __name__ == "__main__":
    sys.exit(main())
