#!/bin/bash
# 平台組大事記 - 一鍵部署腳本
# 用法：改完 index.html（EVENTS陣列）跟 platform-changelog.md 之後，在這個資料夾下執行 ./deploy.sh
# 會依序做：1) 部署到 Cloudflare Pages (platform-changelog.pages.dev)  2) commit + push 到 GitHub (romeosai/platform-changelog) 做版本備份
set -e
cd "$(dirname "$0")"

echo "=== 1/2 部署到 Cloudflare Pages ==="
# 只上傳 index.html（公開網頁真正需要的檔案），不要把 deploy.sh/README.md/.git 等
# repo管理用的檔案也一起上傳成公開可存取的靜態資源（呼應之前 Workers assets.directory
# 誤指向 repo 根目錄外洩 .git 的教訓：一律用「只放真正要公開的檔案」的乾淨資料夾）
CF_STAGE=$(mktemp -d)
cp index.html "$CF_STAGE/"
npx wrangler pages deploy "$CF_STAGE" --project-name=platform-changelog --commit-dirty=true
rm -rf "$CF_STAGE"

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
