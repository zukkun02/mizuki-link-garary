#!/bin/bash
# links.csv からボタンHTMLを生成し、index.html に埋め込む
# 使い方: bash generate.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CSV_FILE="$SCRIPT_DIR/links.csv"
OUTPUT_FILE="$SCRIPT_DIR/index.html"

if [ ! -f "$CSV_FILE" ]; then
  echo "エラー: links.csv が見つかりません"
  exit 1
fi

# CSVからボタンHTML生成（ヘッダー行スキップ）
BUTTONS=""
while IFS=',' read -r name url; do
  [ -z "$name" ] && continue
  BUTTONS="$BUTTONS      <a href=\"$url\" class=\"link-btn\" target=\"_blank\" rel=\"noopener noreferrer\">$name</a>\n"
done < <(tail -n +2 "$CSV_FILE")

cat > "$OUTPUT_FILE" << 'HEADER'
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mizuki | DXコンサルタント</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@300;400;500;700&family=Noto+Serif+JP:wght@500;700&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

    :root {
      --primary: #0F172A;
      --secondary: #334155;
      --accent: #0369A1;
      --bg: #F8FAFC;
      --card-bg: #FFFFFF;
      --text: #020617;
      --text-muted: #64748B;
      --border: #E2E8F0;
      --shadow-sm: 0 1px 3px rgba(15,23,42,0.04), 0 1px 2px rgba(15,23,42,0.06);
      --shadow-md: 0 4px 12px rgba(15,23,42,0.06), 0 2px 4px rgba(15,23,42,0.04);
      --shadow-lg: 0 12px 32px rgba(15,23,42,0.08), 0 4px 8px rgba(15,23,42,0.04);
      --radius: 14px;
    }

    body {
      font-family: "Noto Sans JP", -apple-system, BlinkMacSystemFont, sans-serif;
      background: var(--bg);
      min-height: 100vh;
      display: flex;
      justify-content: center;
      padding: 40px 20px 60px;
      color: var(--text);
      -webkit-font-smoothing: antialiased;
    }

    .container {
      width: 100%;
      max-width: 440px;
    }

    .profile-card {
      background: var(--card-bg);
      border-radius: 20px;
      padding: 40px 32px 32px;
      text-align: center;
      box-shadow: var(--shadow-md);
      border: 1px solid var(--border);
      margin-bottom: 20px;
      position: relative;
      overflow: hidden;
    }

    .profile-card::before {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 100px;
      background: linear-gradient(135deg, var(--primary) 0%, #1E3A5F 100%);
    }

    .profile-photo-wrapper {
      position: relative;
      z-index: 1;
      margin-bottom: 20px;
    }

    .profile-photo {
      width: 110px;
      height: 110px;
      border-radius: 50%;
      object-fit: cover;
      object-position: center top;
      border: 4px solid var(--card-bg);
      box-shadow: var(--shadow-lg);
      background: var(--bg);
    }

    .profile-card h1 {
      font-family: "Noto Serif JP", serif;
      font-size: 17px;
      font-weight: 700;
      color: var(--primary);
      line-height: 1.6;
      letter-spacing: 0.02em;
      margin-bottom: 16px;
    }

    .divider {
      width: 40px;
      height: 2px;
      background: var(--accent);
      margin: 0 auto 16px;
      border-radius: 1px;
    }

    .bio {
      font-size: 13px;
      color: var(--text-muted);
      line-height: 1.8;
      font-weight: 400;
    }

    .links {
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .link-btn {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      width: 100%;
      padding: 16px 24px;
      background: var(--card-bg);
      color: var(--primary);
      text-decoration: none;
      text-align: center;
      font-size: 14px;
      font-weight: 500;
      border-radius: var(--radius);
      border: 1px solid var(--border);
      box-shadow: var(--shadow-sm);
      transition: all 0.2s ease;
      cursor: pointer;
      position: relative;
      letter-spacing: 0.01em;
    }

    .link-btn:hover {
      background: var(--primary);
      color: #fff;
      border-color: var(--primary);
      box-shadow: var(--shadow-lg);
      transform: translateY(-2px);
    }

    .link-btn:active {
      transform: translateY(0);
      box-shadow: var(--shadow-sm);
    }

    .link-btn:focus-visible {
      outline: 2px solid var(--accent);
      outline-offset: 2px;
    }

    .link-btn::after {
      content: "";
      position: absolute;
      right: 20px;
      top: 50%;
      width: 6px;
      height: 6px;
      border-right: 1.5px solid var(--text-muted);
      border-top: 1.5px solid var(--text-muted);
      transform: translateY(-50%) rotate(45deg);
      transition: border-color 0.2s ease;
    }

    .link-btn:hover::after {
      border-color: rgba(255,255,255,0.6);
    }

    .footer {
      text-align: center;
      margin-top: 32px;
      font-size: 11px;
      color: #CBD5E1;
      letter-spacing: 0.05em;
    }

    @media (prefers-reduced-motion: reduce) {
      .link-btn { transition: none; }
      .link-btn:hover { transform: none; }
    }

    @media (max-width: 480px) {
      body { padding: 24px 16px 48px; }
      .profile-card { padding: 36px 24px 28px; }
      .profile-card h1 { font-size: 16px; }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="profile-card">
      <div class="profile-photo-wrapper">
        <img src="俺透過.png" alt="プロフィール写真" class="profile-photo">
      </div>
      <h1>Notionを中心としたDXコンサルタント<br>（運用支援・構築）</h1>
      <div class="divider"></div>
      <p class="bio">
        2001年愛知県生まれ、25歳。<br>
        名城大学理工学部応用化学科卒（学士）。<br>
        DXコンサルティングと塾講師をしています。
      </p>
    </div>

    <div class="links">
HEADER

# ボタン挿入
echo -e "$BUTTONS" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" << 'FOOTER'
    </div>

    <div class="footer">&copy; 2026 Mizuki</div>
  </div>
</body>
</html>
FOOTER

echo "✓ index.html を生成しました（$(( $(tail -n +2 "$CSV_FILE" | grep -c ',') )) 件のリンク）"
