# Compatible list in 2024/04/24

pytorch have cuda runtime so you need only compatible NVIDIA driver.  
However, tensorflow not have cuda runtime so you need to match cuda and cudnn versions.

## CUDA 12.2

| package | version |
| :-----: | :-----: |
| python  |  3.11   |
|  CUDA   |  12.2   |
|  cuDNN  |   8.9   |

- pyproject.toml

  ```toml
  [tool.poetry.scripts]

  [tool.poetry.dependencies]
  torch = [
      { version = "~2.1.2+cu121", source = "torch_cu121", markers = "sys_platform == 'linux'" },
      { version = "~2.1.2+cu121", source = "torch_cu121", markers = "sys_platform == 'win32'" },
      { version = "~2.1.2", source = "PyPI", markers = "sys_platform == 'darwin'" },
  ]
  torchaudio = [
      { version = "~2.1.2+cu121", source = "torch_cu121", markers = "sys_platform == 'linux'" },
      { version = "~2.1.2+cu121", source = "torch_cu121", markers = "sys_platform == 'win32'" },
      { version = "~2.1.2", source = "PyPI", markers = "sys_platform == 'darwin'" },
  ]
  torchvision = [
      { version = "~0.16.2+cu121", source = "torch_cu121", markers = "sys_platform == 'linux'" },
      { version = "~0.16.2+cu121", source = "torch_cu121", markers = "sys_platform == 'win32'" },
      { version = "~0.16.2", source = "PyPI", markers = "sys_platform == 'darwin'" },
  ]
  tensorflow = "~2.15.0"  # can use GPU only Linux

  [tool.poetry.group.dev.dependencies]
  debugpy = "^1.8.0"
  huggingface-cli = "^0.1"
  ipython = "^8.20.0"
  jupyter-console = "^6.6.3"
  nbclassic = "^1.0.0"
  notebook = "^7.0.6"

  [[tool.poetry.source]]
  name = "torch_cpu"
  url = "https://download.pytorch.org/whl/cpu"
  priority = "supplemental"

  [[tool.poetry.source]]
  name = "torch_cu121"
  url = "https://download.pytorch.org/whl/cu121"
  priority = "supplemental"
  ```

## CUDA 11.8

| package |  version   |
| :-----: | :--------: |
| python  |    3.10    |
|  CUDA   |    11.8    |
|  cuDNN  | 8.7 or 8.6 |

- pyproject.toml

  ```toml

  [tool.poetry.dependencies]
  torch = [
      { version = "~2.0.1+cu118", source = "torch_cu118", markers = "sys_platform == 'linux'" },
      { version = "~2.0.1+cu118", source = "torch_cu118", markers = "sys_platform == 'win32'" },
      { version = "~2.0.1", source = "PyPI", markers = "sys_platform == 'darwin'" },
  ]
  torchaudio = [
      { version = "~2.0.2+cu118", source = "torch_cu118", markers = "sys_platform == 'linux'" },
      { version = "~2.0.2+cu118", source = "torch_cu118", markers = "sys_platform == 'win32'" },
      { version = "~2.0.2", source = "PyPI", markers = "sys_platform == 'darwin'" },
  ]
  torchvision = [
      { version = "~0.15.2+cu118", source = "torch_cu118", markers = "sys_platform == 'linux'" },
      { version = "~0.15.2+cu118", source = "torch_cu118", markers = "sys_platform == 'win32'" },
      { version = "~0.15.2", source = "PyPI", markers = "sys_platform == 'darwin'" },
  ]
  tensorflow = "~2.14.0"  # cuDNN == 8.7, can use GPU only Linux
  tensorflow = ">=2.13.0, <2.14.0"  # cuDNN == 8.6, can use GPU only Linux

  [tool.poetry.group.dev.dependencies]
  debugpy = "^1.8.0"
  huggingface-cli = "^0.1"
  ipython = "^8.20.0"
  jupyter-console = "^6.6.3"
  nbclassic = "^1.0.0"
  notebook = "^7.0.6"

  [[tool.poetry.source]]
  name = "torch_cpu"
  url = "https://download.pytorch.org/whl/cpu"
  priority = "supplemental"

  [[tool.poetry.source]]
  name = "torch_cu118"
  url = "https://download.pytorch.org/whl/cu118"
  priority = "supplemental"
  ```
