# CodeCV 简历 PDF 去水印工具

一个用于移除 CodeCV 导出简历 PDF 平铺水印的轻量 Python 工具。

工具直接处理 PDF 内容流中的水印绘制指令，不会先把页面转换成图片，因此通常可以保留原始 PDF 的文本、图片、页面尺寸和排版。

> 请仅将本工具用于你拥有或已获授权处理的 PDF 文件，并遵守相关平台的使用条款和版权要求。

## 功能

- 移除 CodeCV 导出 PDF 中的平铺图案水印。
- 尽量保留原始 PDF 的文本可选中性、图片、页面尺寸和排版。
- 支持命令行指定输入文件和输出文件。
- 未指定输出路径时，自动在输入文件所在目录生成 `.clean.pdf` 文件。
- 提供 Windows 下的 `run.bat` 交互式启动脚本，支持手动输入或拖入 PDF 路径。

## 工作原理

CodeCV 水印通常以 PDF `/Pattern` 资源的形式绘制在页面内容流中。本工具会扫描每一页的内容流，识别使用 `/Pattern` 颜色空间、矩形填充操作绘制的目标图案，移除对应绘制指令，并清理不再使用的图案资源。

该方法不会对 PDF 页面进行截图或 OCR，因此不会主动改变页面分辨率，也不会把文本转换成图片。

## 环境要求

- Python 3.10 或更高版本
- `pypdf` 6.10.0 或更高版本
- 一个由 CodeCV 导出的 PDF 文件

## 安装

推荐使用虚拟环境。

### Windows PowerShell

```powershell
py -3 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
```

如果 PowerShell 阻止执行激活脚本，可以不激活虚拟环境，直接使用虚拟环境中的 Python：

```powershell
\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

### macOS / Linux

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
```

也可以直接在已有 Python 环境中安装依赖：

```bash
python -m pip install -r requirements.txt
```

## 使用方法

### 命令行使用

指定输出文件：

```powershell
python .\remove_codecv_watermark.py .\resume.pdf .\resume-clean.pdf
```

不指定输出文件时，默认生成：

```powershell
python .\remove_codecv_watermark.py .\resume.pdf
```

输出文件为：

```text
.
└── resume.clean.pdf
```

macOS / Linux 可将命令中的 `python` 和路径分隔符替换为对应环境的写法：

```bash
python3 remove_codecv_watermark.py ./resume.pdf ./resume-clean.pdf
```

处理成功时会输出类似信息：

```text
Removed 2 CodeCV watermark pattern fill(s).
Wrote: resume.clean.pdf
```

查看帮助：

```powershell
python .\remove_codecv_watermark.py --help
```

### Windows 一键使用

完成依赖安装后，双击 `run.bat`：

1. 选择交互模式。
2. 将 PDF 文件拖入窗口，或手动输入文件路径。
3. 按回车开始处理。

也可以从命令行直接调用：

```powershell
.\run.bat ".\resume.pdf"
```

指定输出文件：

```powershell
.\run.bat ".\resume.pdf" ".\resume-clean.pdf"
```

`run.bat` 默认调用项目目录下 `.venv\Scripts\python.exe` 对应环境中的 Python。建议先按上面的安装步骤创建 `.venv` 并安装依赖。

## 参数说明

```text
python remove_codecv_watermark.py INPUT_PDF [OUTPUT_PDF]
```

| 参数 | 说明 |
| --- | --- |
| `INPUT_PDF` | 必填，待处理的 CodeCV 导出 PDF 路径。 |
| `OUTPUT_PDF` | 可选，清理后 PDF 的输出路径；省略时使用 `<输入文件名>.clean.pdf`。 |

输出目录不存在时，工具会自动创建目录。建议不要将输出路径设置为输入文件本身，以免覆盖原始文件。

## 返回值

- `0`：检测并移除了至少一个目标水印图案。
- `1`：未检测到目标水印图案，或命令执行过程中出现处理错误。

未检测到水印时，工具仍可能写出一个内容未修改的输出 PDF；请根据终端提示检查结果，并保留原始文件作为备份。

## 限制与排查

- 本工具针对 CodeCV 当前导出的 `/Pattern` 平铺水印实现，不保证适用于其他网站或其他类型的水印。
- 如果水印已经被栅格化到页面图片中，或使用了不同的 PDF 绘制结构，本工具无法识别。
- 处理后请打开输出 PDF 检查页面内容，尤其是字体、图片、超链接和排版。
- 如果提示未检测到水印，请确认输入文件确实来自 CodeCV，并尝试使用 `--help` 检查命令是否正确。
- 如果出现 `ModuleNotFoundError: No module named 'pypdf'`，请在当前 Python 环境中执行 `python -m pip install -r requirements.txt`。

## 项目结构

```text
.
├── remove_codecv_watermark.py  # 核心 PDF 处理脚本
├── run.bat                     # Windows 交互式启动脚本
├── requirements.txt            # Python 依赖
└── README.md                   # 项目说明
```

## 许可证

当前仓库未附带单独的许可证文件。如需公开发布或集成到其他项目，请先确认代码使用权限以及待处理 PDF 的版权和授权范围。
