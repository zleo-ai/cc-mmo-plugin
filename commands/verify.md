---
description: 执行验证闭环。运行测试、类型检查、lint，确保代码变更质量。
---

# 验证闭环

## 验证层级

根据 `$ARGUMENTS` 选择验证级别：

| 参数 | 验证内容 |
|------|----------|
| `quick` / 无参数 | 快速验证（lint + typecheck） |
| `full` | 完整验证（+ 单元测试） |
| `e2e` | 端到端验证（+ E2E测试） |
| `all` | 全量验证（所有检查） |

## Quick 验证

```bash
# Lint检查
pnpm lint

# 类型检查
pnpm typecheck
```

## Full 验证

```bash
# 包含Quick的所有检查
pnpm lint && pnpm typecheck

# 单元测试
pnpm test
```

## E2E 验证

```bash
# 包含Full的所有检查
pnpm lint && pnpm typecheck && pnpm test

# E2E测试
pnpm test:e2e
# 或
npx playwright test
```

## All 验证

```bash
# 所有检查
pnpm lint && pnpm typecheck && pnpm test && pnpm test:e2e

# 构建验证
pnpm build
```

## 验证报告

### 检查结果

| 检查项 | 状态 | 详情 |
|--------|------|------|
| Lint | ✅/❌ | [错误数] |
| TypeCheck | ✅/❌ | [错误数] |
| Unit Tests | ✅/❌ | [通过/失败] |
| E2E Tests | ✅/❌ | [通过/失败] |
| Build | ✅/❌ | [状态] |

### 失败处理

如有失败项：
1. 显示具体错误信息
2. 分析失败原因
3. 提供修复建议
4. 询问是否自动修复

## 与Code Review集成

验证通过后，建议使用 `reviewer` agent 进行代码审查：

```
使用 reviewer agent 审查最近的代码变更
```

## 使用示例

```bash
# 快速验证
/mmo:verify

# 完整验证
/mmo:verify full

# 全量验证
/mmo:verify all
```
