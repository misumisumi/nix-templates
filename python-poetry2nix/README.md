# python-poetry2nix

## How to use

```
# poetryの実行
$ nix run ".#poetry" -- <command>

# パッケージの追加 (--lock必須!)
$ nix run ".#poetry" -- add <name> --lock

# 開発環境へ入る
$ nix develop ".#default"

# direnvを使っているならば`poetry.lock`を作成した後に
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
python-poetry2nix
├── src
├── tests
├── flake.lock
├── flake.nix
├── override.nix
├── pyproject.toml
└── README.md
```
