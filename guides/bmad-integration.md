# BMAD集成说明

## 概述

`multi-model-orchestrator` 插件与BMAD方法论互补，不替代。

- **BMAD**：管理开发流程（产品→架构→开发→测试）
- **MMO插件**：管理多模型协作（Codex/Gemini/Claude编排）

## 集成架构

```
┌─────────────────────────────────────────────────────────────────┐
│                        BMAD 工作流                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │ 产品规划  │→│ 架构设计  │→│ 开发实施  │→│ 测试交付  │       │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘       │
└─────────────────────────────────────────────────────────────────┘
                       ↑              ↑              ↑
                       │              │              │
┌─────────────────────────────────────────────────────────────────┐
│                  multi-model-orchestrator                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │ architect │  │ ui-expert│  │ reviewer │  │integrator│       │
│  │  agent   │  │  agent   │  │  agent   │  │  agent   │       │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘       │
└─────────────────────────────────────────────────────────────────┘
```

## BMAD阶段 × MMO能力

### Phase 1: 产品规划

| BMAD工作流 | MMO辅助 |
|-----------|---------|
| create-product-brief | - |
| create-prd | - |
| research | `mcp__ace-tool__search_context` |

### Phase 2: 架构设计

| BMAD工作流 | MMO辅助 |
|-----------|---------|
| create-architecture | `architect` agent + Codex |
| create-ux-design | `ui-expert` agent + Gemini |
| check-implementation-readiness | 多模型交叉验证 |

### Phase 3: 开发实施

| BMAD工作流 | MMO辅助 |
|-----------|---------|
| create-epics-and-stories | - |
| sprint-planning | `/mmo:parallel-dev` 分配任务 |
| dev-story | Codex(后端) / Gemini(前端) |
| code-review | `reviewer` agent (独立SESSION) |

### Phase 4: 测试交付

| BMAD工作流 | MMO辅助 |
|-----------|---------|
| testarch-* | `/mmo:verify` 验证闭环 |
| retrospective | - |

## 实战示例

### 场景：实现用户认证Epic

```markdown
# Sprint规划（BMAD: sprint-planning）

Epic: 用户认证系统
├── Story 1: 后端认证API
├── Story 2: 登录界面UI
├── Story 3: 集成测试

# 并行开发（MMO: parallel-dev）

/mmo:parallel-dev init feature/auth-api feature/login-ui

# 后端开发（Worktree A）
使用 codex-delegation skill 调用Codex实现API

# 前端开发（Worktree B）
使用 gemini-delegation skill 调用Gemini实现UI

# 同步合并
/mmo:sync-worktrees merge

# 代码审查（BMAD: code-review + MMO: reviewer）
使用 reviewer agent 进行独立审查

# 验证（MMO: verify）
/mmo:verify full
```

## SESSION管理与BMAD

| BMAD阶段 | SESSION策略 |
|----------|-------------|
| 同一Story内 | 可复用 |
| 跨Story | 新开 |
| code-review | 强制新开 |
| 跨Epic | 新开 |

## 命令快速参考

| 场景 | 命令 |
|------|------|
| 规划任务 | `/mmo:plan-first <任务描述>` |
| 并行开发 | `/mmo:parallel-dev init <分支...>` |
| 验证变更 | `/mmo:verify [quick\|full\|all]` |
| 同步结果 | `/mmo:sync-worktrees merge` |

## 注意事项

1. **不要混用**：在BMAD工作流中使用MMO能力，但不要让它们相互干扰
2. **遵循阶段**：MMO增强能力，但不跳过BMAD阶段
3. **保持记录**：重要决策记录在BMAD文档中，SESSION只是过程
