# 并行开发指南

## 概述

使用git worktree + 多Claude会话实现真正的并行开发。

## 为什么并行？

> "我每天同时跑10+个会话" —— Boris Cherny (Claude Code之父)

并行是大幅提升效率的关键。

## 架构

```
┌─────────────────────────────────────────────────────────────────┐
│                        主仓库 (main)                            │
│  ┌─────────────┐                                                │
│  │ .claude/    │  ← 共享配置                                    │
│  │ CLAUDE.md   │                                                │
│  └─────────────┘                                                │
└─────────────────────────────────────────────────────────────────┘
          │
          │ git worktree add
          ▼
┌─────────────────────────────────────────────────────────────────┐
│  Worktree 1: feature/auth          Worktree 2: feature/ui      │
│  ┌─────────────────────┐           ┌─────────────────────┐     │
│  │ Claude Session A    │           │ Claude Session B    │     │
│  │ + Codex             │           │ + Gemini            │     │
│  └─────────────────────┘           └─────────────────────┘     │
└─────────────────────────────────────────────────────────────────┘
```

## 快速开始

### 1. 创建Worktrees

```bash
# 创建后端worktree
git worktree add ../project-auth feature/auth -b feature/auth

# 创建前端worktree
git worktree add ../project-ui feature/ui -b feature/ui
```

### 2. 启动并行会话

**终端1 - 后端**
```bash
cd ../project-auth
claude
# 使用Codex处理后端逻辑
```

**终端2 - 前端**
```bash
cd ../project-ui
claude
# 使用Gemini处理UI设计
```

### 3. 合并结果

```bash
cd /path/to/main/repo
/mmo:sync-worktrees merge
```

## 任务分配策略

| 任务类型 | 分配模型 | Worktree命名 |
|----------|----------|--------------|
| 后端API | Codex | feature/api-* |
| 数据库 | Codex | feature/db-* |
| 前端组件 | Gemini | feature/ui-* |
| 样式/动画 | Gemini | feature/style-* |
| 全栈功能 | Claude | feature/full-* |

## SESSION隔离

**重要**：每个worktree使用独立SESSION

- Worktree A 调用Codex → SESSION_A
- Worktree B 调用Gemini → SESSION_B
- 两者互不影响

## 进度跟踪

### 方式1: 系统通知

Claude Code支持系统通知，后台任务完成时会提醒。

### 方式2: 定期检查

```bash
# 查看所有worktree状态
/mmo:sync-worktrees status
```

### 方式3: Web端

在claude.ai/code上也可以启动会话，多端联动。

## 冲突预防

1. **明确边界**：分配任务时确保模块独立
2. **接口先行**：先约定接口，再分头实现
3. **频繁同步**：不要等到最后才合并
4. **小步快跑**：小范围变更，频繁提交

## 与BMAD集成

```
Epic: 用户认证系统
├── Story 1: 后端认证API (Worktree A + Codex)
├── Story 2: 登录界面UI (Worktree B + Gemini)
└── Story 3: 集成测试 (Main + Claude)
```

## 常见问题

### Q: Worktree之间能共享SESSION吗？

不建议。每个worktree任务独立，共享SESSION可能导致上下文混乱。

### Q: 如何处理共享依赖？

在主仓库更新依赖后，各worktree执行 `git pull --rebase origin main`。

### Q: 合并冲突怎么办？

使用 `integrator` agent，它会分析冲突并提供解决方案。
