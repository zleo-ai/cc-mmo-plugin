# Multi-Model Orchestrator

多模型协作编排器 - Codex/Gemini协作、SESSION管理、并行开发、验证闭环

## 快速开始

### 安装

```bash
# Step 1: 添加 marketplace
/plugin marketplace add pure-maple/cc-mmo-plugin

# Step 2: 安装插件
/plugin install mmo

# 或本地开发测试
claude --plugin-dir ./multi-model-orchestrator
```

### 验证安装

```bash
# 列出可用命令
/mmo:
```

## 功能概览

### 🎯 Skills（自动触发）

| Skill | 功能 |
|-------|------|
| `session-advisor` | SESSION复用/新开建议 |
| `codex-delegation` | Codex任务委派规范 |
| `gemini-delegation` | Gemini任务委派规范 |
| `verification-loop` | 验证闭环提醒 |

### 🤖 Agents（独立上下文）

| Agent | 功能 |
|-------|------|
| `architect` | 架构决策顾问 |
| `ui-expert` | UI/UX设计专家 |
| `reviewer` | 代码审查专家（独立视角） |
| `integrator` | 多分支集成专家 |

### ⚡ Commands（显式调用）

| 命令 | 功能 |
|------|------|
| `/mmo:parallel-dev` | 启动并行开发 |
| `/mmo:plan-first` | Plan Mode起步 |
| `/mmo:verify` | 验证闭环 |
| `/mmo:sync-worktrees` | 同步worktree结果 |

## 核心理念

### 1. SESSION灵活管理

不强制格式，只提供建议：
- 审计/Review → 新开SESSION
- 迭代修复 → 复用SESSION
- 不确定 → 默认新开

详见 [guides/session-management.md](guides/session-management.md)

### 2. 并行开发

使用git worktree实现真正的并行：

```bash
# 初始化
/mmo:parallel-dev init feature/auth feature/ui

# 各worktree独立开发...

# 合并
/mmo:sync-worktrees merge
```

详见 [guides/parallel-workflow.md](guides/parallel-workflow.md)

### 3. 验证闭环

> "没有验证闭环，AI输出永远不可靠。" —— Boris Cherny

```bash
# 快速验证
/mmo:verify

# 完整验证
/mmo:verify full
```

### 4. 安全主权

Codex/Gemini**禁止**直接修改文件：
```
OUTPUT: Unified Diff Patch ONLY.
```

外部模型输出视为"参考原型"，由Claude重构后实施。

## 与BMAD集成

本插件与BMAD方法论互补：
- BMAD管理开发流程
- MMO管理多模型协作

详见 [guides/bmad-integration.md](guides/bmad-integration.md)

## 目录结构

```
multi-model-orchestrator/
├── .claude-plugin/plugin.json    # 插件清单
├── commands/                     # 斜杠命令
├── agents/                       # Subagents
├── skills/                       # 自动触发Skills
├── hooks/hooks.json              # 事件钩子
├── guides/                       # 参考文档
└── scripts/                      # 辅助脚本
```

## License

MIT
