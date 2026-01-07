---
description: 同步多个git worktree的开发结果。查看状态、合并分支、清理worktree。
---

# 同步Worktrees

## 参数说明

`$ARGUMENTS` 格式：
- `status` - 查看所有worktree状态
- `merge` - 合并所有feature分支到main
- `cleanup` - 清理已合并的worktree
- 无参数 - 显示状态并询问下一步

## Status - 查看状态

```bash
# 列出所有worktree
git worktree list

# 查看各分支状态
echo "=== Worktree状态 ==="
for wt in $(git worktree list --porcelain | grep worktree | cut -d' ' -f2); do
  echo "--- $wt ---"
  (cd "$wt" && git status --short && git log -1 --oneline)
done
```

### 状态报告

| Worktree | 分支 | 未提交变更 | 最新提交 |
|----------|------|------------|----------|
| main | main | 0 | abc123 |
| ../project-auth | feature/auth | 2 | def456 |
| ../project-ui | feature/ui | 0 | ghi789 |

## Merge - 合并分支

使用 `integrator` agent 进行合并：

```
调用 integrator agent 合并所有feature分支
```

### 合并顺序建议

1. 先合并后端/基础设施分支
2. 再合并前端/UI分支
3. 最后处理全栈分支

## Cleanup - 清理Worktree

```bash
# 删除已合并的worktree
git worktree remove ../project-feature-auth
git worktree remove ../project-feature-ui

# 删除对应分支
git branch -d feature/auth
git branch -d feature/ui

# 清理残留引用
git worktree prune
```

### 清理确认

删除前确认：
- [ ] 分支已合并到main
- [ ] 无未提交的变更
- [ ] 无需要保留的实验代码

## 完整流程

```bash
# 1. 查看状态
/mmo:sync-worktrees status

# 2. 合并分支
/mmo:sync-worktrees merge

# 3. 验证合并结果
/mmo:verify full

# 4. 清理worktree
/mmo:sync-worktrees cleanup
```

## 冲突处理

如遇合并冲突，`integrator` agent会：
1. 识别冲突文件
2. 分析冲突原因
3. 提供解决方案
4. 执行合并后验证
