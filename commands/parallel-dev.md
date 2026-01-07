---
description: 启动并行多Agent开发流程。使用git worktree创建独立工作区，分配Codex/Gemini任务并行执行。
---

# 并行开发流程

## 参数说明

`$ARGUMENTS` 格式：
- `init <branch1> <branch2> ...` - 初始化worktree
- `<任务描述>` - 分析任务并推荐并行策略

## Phase 1: 任务分解

分析 "$ARGUMENTS"，识别可并行的独立模块：

**判断标准**：
- 模块间无直接依赖
- 可以独立测试
- 不同技术栈（后端/前端）

**分配策略**：
| 任务类型 | 分配模型 | 工作分支 |
|----------|----------|----------|
| 后端逻辑 | Codex | feature/backend-* |
| 前端UI | Gemini | feature/ui-* |
| 全栈 | Claude | feature/full-* |

## Phase 2: 初始化Worktrees

```bash
# 创建worktree
git worktree add ../project-feature-auth feature/auth
git worktree add ../project-feature-ui feature/ui

# 验证创建成功
git worktree list
```

每个worktree会继承主仓库的 `.claude/` 配置。

## Phase 3: 并行执行

在每个worktree目录中启动独立Claude会话：

```bash
# 终端1 - 后端任务
cd ../project-feature-auth
claude

# 终端2 - 前端任务
cd ../project-feature-ui
claude
```

**执行规范**：
- 各自使用**独立SESSION**
- 后台运行 (`run_in_background: true`)
- 不设置timeout
- 使用系统通知跟踪进度

## Phase 4: 同步合并

1. 各worktree完成后，使用 `integrator` agent合并
2. 解决可能的冲突
3. 运行 `/mmo:verify` 进行统一验证

## 快速命令

```bash
# 初始化两个并行分支
/mmo:parallel-dev init feature/auth feature/ui

# 分析任务并推荐策略
/mmo:parallel-dev 实现用户认证和登录界面
```

## 注意事项

- 确保main分支是干净的再创建worktree
- 每个worktree的SESSION相互隔离
- 合并阶段使用 `reviewer` agent 确保独立审查视角
