#!/bin/bash
# init-worktrees.sh - 初始化多个git worktree用于并行开发
# 用法: ./init-worktrees.sh <branch1> <branch2> ...

set -e

if [ $# -eq 0 ]; then
    echo "用法: $0 <branch1> <branch2> ..."
    echo "示例: $0 feature/auth feature/ui"
    exit 1
fi

# 获取当前目录名
REPO_NAME=$(basename "$(pwd)")
PARENT_DIR=$(dirname "$(pwd)")

echo "=== 初始化Worktrees ==="
echo "仓库: $REPO_NAME"
echo "分支: $@"
echo ""

for branch in "$@"; do
    # 清理分支名（移除feature/前缀用于目录名）
    dir_name="${REPO_NAME}-${branch//\//-}"
    worktree_path="${PARENT_DIR}/${dir_name}"

    echo "创建: $worktree_path ($branch)"

    # 检查分支是否存在
    if git show-ref --verify --quiet "refs/heads/$branch"; then
        git worktree add "$worktree_path" "$branch"
    else
        git worktree add "$worktree_path" -b "$branch"
    fi
done

echo ""
echo "=== Worktree列表 ==="
git worktree list

echo ""
echo "✅ 初始化完成！"
echo ""
echo "下一步："
echo "  1. cd 到各worktree目录"
echo "  2. 启动独立的claude会话"
echo "  3. 完成后运行 /mmo:sync-worktrees merge"
