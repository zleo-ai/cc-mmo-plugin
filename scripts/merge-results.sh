#!/bin/bash
# merge-results.sh - 合并所有feature分支到main
# 用法: ./merge-results.sh

set -e

echo "=== 合并Worktree结果 ==="

# 确保在主仓库
if [ ! -d ".git" ]; then
    echo "错误: 请在主仓库目录运行此脚本"
    exit 1
fi

# 获取当前分支
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ] && [ "$current_branch" != "master" ]; then
    echo "切换到main分支..."
    git checkout main 2>/dev/null || git checkout master
fi

# 获取所有worktree
echo ""
echo "当前Worktrees:"
git worktree list

# 获取feature分支
echo ""
echo "Feature分支:"
feature_branches=$(git branch | grep "feature/" | tr -d ' ')

if [ -z "$feature_branches" ]; then
    echo "没有找到feature分支"
    exit 0
fi

echo "$feature_branches"
echo ""

# 逐个合并
for branch in $feature_branches; do
    echo "--- 合并 $branch ---"

    # 检查是否有未合并的提交
    commits=$(git log main..$branch --oneline 2>/dev/null | wc -l | tr -d ' ')

    if [ "$commits" -eq 0 ]; then
        echo "  已是最新，跳过"
        continue
    fi

    echo "  有 $commits 个新提交"

    # 尝试合并
    if git merge "$branch" --no-ff -m "Merge $branch into main"; then
        echo "  ✅ 合并成功"
    else
        echo "  ❌ 合并冲突，请手动解决"
        echo "  运行 'git merge --abort' 取消合并"
        exit 1
    fi
done

echo ""
echo "=== 合并完成 ==="
echo ""
echo "下一步："
echo "  1. 运行测试验证: pnpm test"
echo "  2. 清理worktree: ./scripts/cleanup.sh"
