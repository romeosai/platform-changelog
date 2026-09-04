#!/bin/bash
# 平台組大事記 - 一鍵部署腳本
# 用法：改完 index.html（EVENTS陣列）跟 platform-changelog.md 之後，在這個資料夾下執行 ./deploy.sh
# 會依序做：1) 部署到 Cloudflare Pages (platform-changelog.pages.dev)  2) commit + push 到 GitHub (romeosai/platform-changelog) 做版本備份
set -e
cd "$(dirname "$0")"

echo "=== 1/2 部署到 Cloudflare Pages ==="
npx wrangler pages deploy . --project-name=platform-changelog --commit-dirty=true

echo ""
echo "=== 2/2 commit + push 到 GitHub (版本備份) ==="
git add index.html platform-changelog.md README.md
if git diff --cached --quiet; then
  echo "沒有內容變更，跳過 commit/push"
else
  MSG="${1:-更新大事記 $(date +%Y-%m-%d)}"
  git commit -m "$MSG

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>"
  git push origin main
  echo "✅ 已 push 到 https://github.com/romeosai/platform-changelog"
fi

echo ""
echo "✅ 全部完成"
echo "   - 正式網址: https://platform-changelog.pages.dev"
echo "   - GitHub備份: https://github.com/romeosai/platform-changelog"
