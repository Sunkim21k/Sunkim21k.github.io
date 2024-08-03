---
#layout: post
title: Chirpy 테마를 사용하여 GitHub 블로그 생성하기 - 2 블로그 작성 및 템플릿 설정
date: 2024-08-03
description: Chirpy테마를 사용하여 로컬저장소에서 GitHub 블로그를 작성하고 원격저장소에 전송하는 방법과 블로그 기본 템플릿 설정을 알아보겠습니다.  # 검색어 및 글요약
categories: [Git, Github]        # 메인 카테고리, 하위 카테고리(생략가능)
tags:           # 반드시 소문자로 작성, 한글가능
- Git
- Github
#pin: true # 해당글을 홈에서 고정시킬지
#toc: false # 오른쪽 목차 설정
#comments: false # 댓글 설정

#image: # 미리보기 이미지 설정
#  path: /path/to/image # 경로
#  alt: image alternative text # 이미지 설명 (생략가능)

#mermaid: true # 다이어그램 생성 도구 (https://github.com/mermaid-js/mermaid)
#math : true # 수학도구
---


> 개발 공부를 기록하기위해 GitHub 블로그를 생성하면서 어려움을 겪어 비슷한 경험이 있는분들에게 도움이되고자 기록을 남깁니다.  
  - 이번 게시글에서는 로컬저장소에서 블로그 포스팅 세팅에 대해 알아보겠습니다.     


> ***작성자의 깃허브 블로그 설치환경입니다.***   
> - 운영체제 : windows 10    
> - 사용테마 : chirpy(v7.0.1)   
> - 이 글은 2024년 7월 기준으로 작성되었으며,  
> - 작성자의 환경과 다르거나 최신버전에서는 일부 내용이 달라질 수 있습니다.  
{: .prompt-info }  


## 로컬 저장소에서 블로그 포스팅 작성후 원격저장소 전송  
---

> 편의를 위해 `Visual Studio Code`등 텍스트 에디터에서 작업을 추천합니다.   

- 로컬 게시글 작성경로와 파일명 설정   
  - 게시글 작성경로 : `_posts`디렉토리에 마크다운 형식으로 파일을 생성합니다.      
  - 파일명 : `yyyy-mm-dd-제목.md` 이며 제목은 url 주소에 포함되므로 영어를 권장합니다.   

- Front matter 설정 : 블로그 포스트 설정을 위해 마크다운 맨 위에 Front matter를 작성합니다. 주요 설정은 아래와 같으며, categories 밑으로는 생략가능합니다. 저는 tags까지만 사용하고 나머지는 주석처리했습니다.     

```yaml
title: 글제목(검색어)
description: 글요약(검색어와 게시물 페이지에서 게시물 제목 아래에 표기됨)
date: YYYY-MM-DD HH:MM:SS +09:00  # 서울기준시간
categories: [메인카테고리, 하위카테고리]  # 하위 카테고리 생략가능

# 생략 가능
tags: [tag]  # 반드시 소문자로 작성, 한글가능
pin: true # 해당글을 홈에서 고정시킬지
toc: true # 오른쪽 목차 여부 설정
comments: false # 댓글 설정
image:  # 이미지 설정
  path: /path/to/image # 경로
  alt: image alternative text # 이미지 설명 (없어도됨)
mermaid: true # 다이어그램 생성 도구 (https://github.com/mermaid-js/mermaid)
```  


> **참고 : Front matter 설정과 마크다운 가이드**     
> [참고1](https://chirpy.cotes.page/posts/text-and-typography/)   
> [참고2](https://chirpy.cotes.page/posts/write-a-new-post/)     
{: .prompt-info }    




- (생략가능) 로컬저장소에서 게시글이 제대로 작성되었는지 점검합니다.     
  - git bash에서 로컬 접속   

```bash
  $ bundle exec jekyll serve
```  


- 게시글 내용 작성 후 git을 사용하여 원격저장소에 전송합니다.

```bash
  $ git add .
  $ git commit -m "새 포스트 작성: [포스트 제목]"
  $ git push
```  

- github 원격저장소에서 actions `success`확인후 게시글 확인합니다.   

<br>


## 블로그 템플릿 설정 및 생성
---

> 매번 새로운 포스트를 작성할 때 Front Matter 설정과 자주사용하는 마크다운 형식을 직접 설정하는 것이 피로감이 들 수 있습니다. 이를 극복하기위해 스크립트를 작성하여 자동화 하는 작업을 설정하는 것을 추천합니다.   


- 마크다운 템플릿 파일 생성   
   - 블로그 프로젝트 내 마크다운(md) 템플릿 파일 생성후 원하는 기본 설정 넣기   
   - ex) `_templates/post_template.md` 파일 생성   
   - 템플릿 내용 작성 : 상기 Front matter 설정과 원하는 마크다운 형식(목차 등)을 작성합니다.   


```text
---
title: {{ title }}
date: {{ date }}
description: # 검색어 및 글요약
categories: [메인카테고리, 하위카테고리]
tags: # 반드시 소문자로 작성, 한글가능
- 
- 
# pin: true # 해당글을 홈에서 고정시킬지
# toc: false # 오른쪽 목차 설정
# comments: false # 댓글 설정
# image: # 미리보기 이미지 설정
#   path: /path/to/image # 경로
#   alt: image alternative text # 이미지 설명 (생략가능)
# mermaid: true # 다이어그램 생성 도구 (https://github.com/mermaid-js/mermaid)
---

# 하단은 마크다운 템플릿 작성
```   


- 자동화 스크립트 작성   
   - 프로젝트 최상위 디렉토리에 새로운 포스트를 생성하는 스크립트 `create_post.sh` 파일을 생성합니다.   
   - 해당 파일에 아래와 같이 스크립트를 생성합니다. 저는 템플릿 파일에 title과 date를 자동화했기때문에 해당설정과 템플릿 파일경로는 다를 수 있습니다.    

   
```
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
```    

- 스크립트에 실행 권한 부여   
작성한 스크립트에 실행 권한을 부여합니다.   

```bash
  chmod +x create_post.sh
```  

- 스크립트 실행용 alias 설정   
스크립트를 간단하게 실행할 수 있도록 alias를 설정합니다. 저는 `post "글제목"` 형식으로 간단히 포스트를 생성하도록 코드를 구성했습니다.   


```bash
  $ vi ~/.bashrc
  $ alias post='/프로젝트경로/create_post.sh'
  $ source ~/.bashrc
```  

- 작동확인   
alias를 사용하여 포스트가 생성되고 템플릿이 정상적으로 나오는지 확인합니다.   

```bash
  $ post "My New Blog Post"
```  


<br>
