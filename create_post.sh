#!/bin/bash

# 사용법: ./create_post.sh "Post Title"
POST_TITLE="$1"
POST_DATE=$(date +"%Y-%m-%d")
POST_NAME=$(echo "$POST_TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
POST_PATH="_posts/${POST_DATE}-${POST_NAME}.md"

# 템플릿 파일 읽기
TEMPLATE=$(cat _templates/post_template.md)

# 템플릿에서 치환
TEMPLATE="${TEMPLATE//\{\{ title \}\}/$POST_TITLE}"
TEMPLATE="${TEMPLATE//\{\{ date \}\}/$POST_DATE}"

# 새로 생성된 포스트 파일에 템플릿 내용 쓰기
echo "$TEMPLATE" > "$POST_PATH"

echo "Post created at $POST_PATH"