#!/bin/bash
# cleanup.sh - 清理已合并的worktree和分支
# 用法: ./cleanup.sh

set -e

echo "=== 清理Worktrees ==="

# 获取所有worktree（排除主仓库）
worktrees=$(git worktree list --porcelain | grep worktree | cut -d' ' -f2 | tail -n +2)

if [ -z "$worktrees" ]; then
    echo "没有需要清理的worktree"
    exit 0
fi

echo "找到以下worktrees:"
echo "$worktrees"
echo ""

read -p "确认删除这些worktrees? (y/N) " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "取消操作"
    exit 0
fi

# 删除worktrees
for wt in $worktrees; do
    echo "删除: $wt"
    git worktree remove "$wt" --force 2>/dev/null || rm -rf "$wt"
done

# 清理残留引用
git worktree prune

echo ""
echo "=== 清理已合并的分支 ==="

# 获取已合并的feature分支
merged_branches=$(git branch --merged main | grep "feature/" | tr -d ' ')

if [ -z "$merged_branches" ]; then
    echo "没有需要清理的分支"
else
    echo "已合并的分支:"
    echo "$merged_branches"
    echo ""

    read -p "确认删除这些分支? (y/N) " confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        for branch in $merged_branches; do
            echo "删除分支: $branch"
            git branch -d "$branch"
        done
    fi
fi

echo ""
echo "✅ 清理完成"
git worktree list
