---
#layout: post
title: Chirpy 테마를 사용하여 GitHub 블로그 생성하기 - 3 댓글 추가, 검색엔진 등록, 폰트 수정 등
date: 2024-08-04
description: github blog를 운영할 때 여러 기능들을 추가하여 블로그를 효율적이고 다양하게 활용해보는 방법을 알아보겠습니다. # 검색어 및 글요약
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
  - 이번 게시글에서는 아래와같은 기능들을 추가하는 방법을 정리합니다.   
     1. Giscus 댓글 기능 추가하기
     2. 구글, 네이버 검색엔진 등록하기
     3. Google Analytics 추가하기
     4. 블로그 폰트 수정하기
     5. 크롬을 이용하여 블로그 커스터마이징 하기


> ***작성자의 깃허브 블로그 설치환경입니다.***   
> - 운영체제 : windows 10    
> - 사용테마 : chirpy(v7.0.1)   
> - 이 글은 2024년 7월 기준으로 작성되었으며,  
> - 작성자의 환경과 다르거나 최신버전에서는 일부 내용이 달라질 수 있습니다.  
{: .prompt-info }  


## Giscus 이용 댓글 기능 추가하기  
---

> GitHub 블로그는 댓글 기능이 기본으로 제공되지않아 Giscus를 이용하여 댓글 기능을 추가할 수 있습니다.
> `Giscus`는 GitHub Discussions를 기반으로 댓글 기능을 추가할 수 있습니다.


- Giscus App 설치   
<a href="https://github.com/apps/giscus" target="_blank">Giscus App</a>페이지에 접속하여 **블로그 저장소에** 앱을 설치합니다.  

- GitHub Discussions 활성화
  - Giscus를 사용할 Github 저장소로 이동하여 Discussions 활성화합니다.   
    - Settings → General 에서 Features의 Discussions   
  - 저장소의 Discussions 탭에서 필요한 설정을 완료합니다.       
- Giscus App 추가 설정   
<a href="https://giscus.app/ko" target="_blank">Giscus 설정</a>페이지에서 추가 설정을 진행합니다.     

  - 설정 → 저장소에서 블로그 저장소를 연결합니다.
  - 페이지 ↔ Discussions 연결에서 연결 방법을 선택합니다.
  - Discussion 카테고리를 설정합니다. (Announcements 권장)
  - 테마 설정후 script 코드를 복사합니다.
  - 블로그 프로젝트 최상위 디렉토리에서 `_layouts/post.html`에 script 코드를 붙여넣습니다.   


- git push후 블로그에서 Giscus 작동을 확인합니다.


<br>



## 구글, 네이버 검색엔진 등록하기   
---
> 검색엔진 등록을통해 검색 결과에 블로그 게시글이 나타나도록 할 수 있습니다.   


- 구글 검색엔진 등록하기   
<a href="https://search.google.com/search-console?hl=ko" target="_blank">구글 검색 콘솔</a>에 접속하여 **속성 추가**를 선택합니다.    

  - `URL 접두어`에 블로그 주소를 입력합니다.
  - `다른확인방법 → HTML 태그`에서 메타 태그를 복사합니다.
  - 테마의 `head` 또는 `config` 파일에 `google-site-verification` 메타 태그의 `content` 부분을 추가합니다.
  - git 커밋 후 푸쉬합니다.
  - 몇 분 기다린 후 `구글 검색 콘솔`에서 소유권 확인을 진행합니다.
  - `색인생성 → Sitemaps`에서 sitemap.xml 파일 경로를 제출합니다. (블로그/sitemap.xml 등)

- 네이버 검색엔진 등록하기   
<a href="https://searchadvisor.naver.com/" target="_blank">네이버 서치어드바이저</a>에서 `웹마스터 도구`를 클릭합니다.   

  - 블로그 사이트를 등록합니다.
  - HTML 태그를 복사하여 블로그 `head` 섹션에 붙여넣습니다.   

> **참고** : `head` 섹션은 테마 개발자 스타일에 따라    
> `_includes/head.html`등 head 파일에 직접 넣거나,   
> `config`파일에 naver 코드를 입력하는 코드가 있을 수 있습니다.   
> 혹은 html 파일을 업로드하는 방식을 이용할 수도 있습니다.       
{: .prompt-info }   

-    
       - git 커밋 후 푸쉬합니다.
       - 소유권 확인을 진행합니다.
       - 네이버 서치어드바이저에서 등록한 사이트 클릭 → 요청 → 사이트맵 제출을 선택합니다.
       - 블로그의 sitemap.xml 파일 경로를 제출합니다. (블로그/sitemap.xml 등)
       - 검증 → 수집요청을 진행합니다.
       - 상단의 `간단체크`로 블로그 사이트를 점검합니다.


<br>


## Google Analytics 추가하기  
---
> google analytics는 웹사이트 방문자 데이터를 분석할 수 있는 도구입니다.   


1. google analytics 계정 생성
<a href="https://analytics.google.com/analytics/web/?authuser=0#/provision/SignUp" target="_blank">google analytics</a>에서 계정을 생성합니다. (데이터 수집 플랫폼 웹 선택)  

2. 측정 ID 설정   
  - `스트림 세부정보`에서 `측정 ID`를 최상위 디렉토리 `_config.yml` 파일에 추가합니다.   
3. git 커밋 후 푸쉬합니다.
4. 소유권 확인을 진행합니다.   
  - 게시글이 없거나 적으면 몇 시간 후에 활성화될 수 있습니다.
  - 테마 개발자에 따라 `google-site-verification`이 필요할 수 있습니다.

<br>



## 블로그 폰트 수정하기  
---

- SCSS 파일에 폰트 삽입   
  - `_sass/main.scss` 파일에 @import 구문을 삽입하여 원하는 폰트를 추가합니다.   
  - 예시 코드   

```scss
  @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap');
```  

  - `_sass/addon/variables.scss`에 폰트를 설정합니다.
  - 예시 코드   

 ```scss
  $font-family-base: 'Roboto', sans-serif;
```  

- git 커밋 후 푸쉬합니다.
- 블로그 사이트에 접속하여 폰트가 수정됐는지 확인합니다.


<br>



## 크롬을 이용하여 블로그 커스터마이징 하기  
---
> 크롬 개발자 도구를 사용하여 블로그의 특정 구역을 찾아 커스터마이징 합니다.   


1. 크롬에서 블로그 사이트에 접속합니다.
2. `F12`를 눌러 개발자 도구를 엽니다.
3. 개발자 도구 왼쪽 상단에 `검사할 페이지 요소 선택` 아이콘을 클릭합니다.(`Ctrl+Shift+C`)
4. 바꾸고 싶은 구역(폰트, 색상, 글자, 목차, 카테고리 등)을 클릭하면 해당 소스 코드와 파일 출처 등이 표기되어 확인할 수 있습니다.
5. 표기된 부분을 찾아 수정하여 커밋 후 푸쉬합니다. (로컬에서 미리 확인할 수 있습니다.)


<br>






