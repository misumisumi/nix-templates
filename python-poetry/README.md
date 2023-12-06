# python-poetry

## How to use

```
# 開発環境へ入る
$ nix develop ".#default"

# direnvを使っているならば
$ direnv allow
```

## 主要パッケージバージョン

| package | ver  |
| ------- | ---- |
| python  | 3.10 |
| CUDA    | 11.8 |
| cuDNN   | 8.9  |

## Files

```
python-poetry
├── src
├── tests
├── flake.lock
├── flake.nix
├── pyproject.toml
└── README.md
```
