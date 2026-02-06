#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path
import sys


def _discover_tf_dirs(base: Path) -> list[Path]:
    if not base.is_dir():
        return []

    dirs: list[Path] = []
    for child in sorted(base.iterdir()):
        if not child.is_dir():
            continue
        if any(child.rglob("*.tf")):
            dirs.append(child)
    return dirs


def main() -> int:
    repo_root = Path(__file__).resolve().parents[2]
    include: list[dict[str, str]] = []

    for env_dir in _discover_tf_dirs(repo_root / "environments"):
        name = env_dir.name
        include.append(
            {
                "kind": "environment",
                "name": name,
                "scan_ref": str(env_dir.relative_to(repo_root)),
                "label": f"env:{name}",
            }
        )

    for module_dir in _discover_tf_dirs(repo_root / "modules"):
        name = module_dir.name
        include.append(
            {
                "kind": "module",
                "name": name,
                "scan_ref": str(module_dir.relative_to(repo_root)),
                "label": f"module:{name}",
            }
        )

    json.dump({"include": include}, sys.stdout, separators=(",", ":"))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
