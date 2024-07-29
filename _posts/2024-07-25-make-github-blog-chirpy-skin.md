---
#layout: post
title: Chirpy 테마를 사용하여 GitHub 블로그 생성하기 - 1 스킨 선택부터 블로그 생성까지
date: 2024-07-25
description: Chirpy테마를 사용하여 GitHub 블로그를 생성하는 방법까지 과정을 알아보겠습니다.  # 검색어 및 글요약
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
  - 이번 게시글에서는 원하는 블로그 스킨을 선택해서 블로그 생성까지 알아보겠습니다!   


> ***작성자의 깃허브 블로그 설치환경입니다.***   
> - 운영체제 : windows 10    
> - 사용테마 : chirpy(v7.0.1)   
> - 이 글은 2024년 7월 기준으로 작성되었으며,  
> - 작성자의 환경과 다르거나 최신버전에서는 일부 내용이 달라질 수 있습니다.  
{: .prompt-info }  


## GitHub 블로그 선택 계기  
---

1. **자율성** : 블로그 플랫폼 규정이나 제한없이 자유롭게 커스텀마이징 가능   
2. **디자인** : jekyll 기반 다양한 블로그 디자인이 공유되고있음    
3. **Git과 마크다운 사용** : 익숙해질 필요가있는 git과 마크다운을 블로그를 통해 자연스럽게 적응할 수 있음  
4. **Github이력** : 블로그 게시글도 소소하게 Github에 기록되어 관리됨 (+잔디도 주고...)

**원활한 이미지나 동영상 업로드가 다른 블로그 플랫폼보다 불편할 수 있습니다.**   
**요즘에는 마크다운 플러그인도 다양하게 있어 이부분도 보완이 가능합니다.**    

<br>


## Chirpy 테마를 사용하여 GitHub 블로그 생성하기
---

> GitHub 블로그는 Jekyll 기반으로 생성하는 테마(블로그스킨)를 선택하여 블로그를 생성합니다.  


<br>


### 1. Ruby 설치   
---

> Jekyll은 Ruby로 작성되어 로컬 설정을 위해 Ruby를 먼저 설치해야합니다.   

<a href="https://rubyinstaller.org/downloads/" target="_blank">RubyInstaller</a> 에서 운영체제에 맞게 **Ruby+Devkit**을 설치합니다.   

설치 도중 `[MSYS2 and MINGW development tool chain]`을 선택하여 설치합니다.  

<br>


### 2. Ruby 설치 확인   
---
터미널을 열고 아래 명령어로 Ruby가 올바르게 설치되었는지 확인합니다.  

```bash
  ruby -v
```  


<br>


### 3. Jekyll과 Bundler 설치     
---
Jekyll과 Bundler를 설치한 후, 설치가 잘 되었는지 확인합니다.  

```bash
  gem install jekyll bundler
  jekyll -v
```  

<br>


### 4. Jekyll 테마 선택   
---

<a href="https://github.com/topics/jekyll-theme" target="_blank">Jekyll 테마 목록</a> 에서 원하는 테마를 선택합니다.  
이 글에서는 **chripy**테마 기반으로 작성합니다. 다른 테마를 선택할 경우 해당 테마 개발자의 가이드라인을 참고하세요.  

<br>


### 5. 원하는 테마를 GitHub에서 Fork   
---

선택한 테마의 GitHub 리포지토리를 본인의 GitHub 계정으로 `Fork`합니다.  

<br>


### 6. Fork된 리포지토리와 브랜치 이름 변경        
---

본인의 GitHub계정으로 Fork한 리포지토리로 이동한뒤,  
설정(Settings)-General-Repository name으로 이동하여 리포지토리 이름을 `githubID.github.io` 형태로 변경합니다.  
그리고 리포지토리의 기본 브랜치가 `master`인 경우, `main`으로 변경합니다.  

<br>


### 7. 로컬 저장소에 복제하기   
---
GitHub에서 Fork한 리포지토리를 로컬에서 작업하기위해 작업하고싶은 컴퓨터에 복제합니다.  

```bash
  git clone [원격저장소주소]
```  


<br>


### 8. Node.js 설치 및 프로젝트 초기화   
---

<a href="https://nodejs.org/en" target="_blank">Node.js</a> 를 설치한 후, 프로젝트폴더(블로그폴더)를 초기화합니다.   
`Node.js`는 윈도우에서 기본적으로 설치되어있지않아 직접 설치해야합니다.   

```bash
  bash tools/init.sh
```    

 - **참고1** : 
     - 일부 정보글에서 윈도우는 `Node.js`가 없어 초기화 명령어가 작동하지않아 파일을 직접 삭제하라는 내용이 있지만, 
     - 테마 개발자가 제시한 가이드라인에 따라 Node.js 설치후 초기화를 권장합니다.  
 - **참고2** : <a href="https://chirpy.cotes.page/posts/getting-started/" target="_blank">Chirpy Getting Started</a>  

<br>


### 9. Jekyll 설치 및 초기화     
---

로컬에서 jekyll 기반 블로그를 가동하기위해 프로젝트폴더(블로그폴더)에서 jekyll을 설치합니다.  
이 과정에서 몇가지 경고 또는 오류가 발생할 수 있습니다.  

```bash
  bundle
```    

#### wdm 관련 오류    

> wdm 오류가 발생할 경우, 아래 명령어로 해결할 수 있습니다.   
> wdm은 실시간 새로고침 기능과 관련있지만, 9년 전에 업데이트가 중단되었습니다.   
> 이 기능을 제거해도 블로그 작성에 큰 문제는 없지만, 이를 해결하고 싶다면 다음과 같이 실행합니다.   
> 하기 명령어는 `wdm` gem을 설치할 때 특정 경고를 무시하도록 설정합니다.  

```bash
  gem install wdm -- --with-cflags=-Wno-implicit-function-declaration
```   

#### CSV, Base64, TZInfo 경고      

> 만약 `csv`, `base64`, `tzinfo` 관련 경고나 오류가 발생한다면 아래 방법을 참고하세요.   

1. 프로젝트 폴더의 `Gemfile`에 다음 내용을 추가합니다.   

```ruby
  gem "csv"
  gem "base64"

  # Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
  # and associated library.
  platforms :mingw, :x64_mingw, :mswin, :jruby do
    gem "tzinfo", ">= 1", "< 3"
    gem "tzinfo-data"
  end

  gem 'wdm', '>= 0.1.0' if Gem.win_platform?
```   

2. 터미널을 열고 다음 명령어를 실행하여 gem을 설치합니다.   

```bash
  bundle install
```   

<br>


### 10. 블로그 기본 설정 변경   
---
> 블로그의 기본 설정을 변경합니다. 설정 파일은 주로 `_config.yml`과 `_data`폴더에서 수정합니다.  

1. **일반 설정:** _config.yml   
주요 설정 항목은 다음과 같습니다.   

   - lang: 웹페이지 언어 선택 (지원언어확인: /data/locales/)   
   - timezone: Asia/Seoul로 시간 설정   
   - title: 블로그 제목 (예: my blog)   
   - tagline: 블로그의 짧은 설명   
   - description: 블로그 소개 문구 (검색 키워드)   
   - url: https://githubID.github.io 형태로 설정   
   - github_username: GitHub 사용자 이름    
   - social_name, email, links: 블로그 작성자 이름, 이메일, 기타 링크   
   - avatar: 프로필 사진   
   - toc: 블로그 오른쪽 목차 기능   
   - paginate: 페이지당 노출되는 글 수   
  
2. **소셜 계정:** _data/contact.yml   
소셜 계정 정보를 입력하여 블로그에 표시할 수 있습니다.   

3. **파비콘 변경:** /assets/img/favicons   
블로그의 파비콘을 변경할 수 있습니다.   
자세한 내용은 <a href="https://chirpy.cotes.page/posts/customize-the-favicon/" target="_blank">Chirpy 파비콘 변경 방법</a>을 참고하세요.   



<br>


### 11. 로컬 환경에서 작동 확인   
---
> 로컬 환경에서 블로그가 작동되는지 확인합니다.   

```bash
  bundle exec jekyll serve
```   

> 상기 명령어를 실행하면 브라우저에서 `http://localhost:4000`에 접속하여 블로그를 미리 볼 수 있습니다.   


<br>


### 12. 원격에서 블로그 작동 확인   
---
> GitHub에 블로그를 배포하고 정상적으로 작동하는지 확인합니다.   

1. **GitHub Actions 설정**   
  - GitHub 리포지토리 `설정(Settings)`-`Pages`에서 `Build and deployment`로 이동하여 Source를 `GitHub Actions`로 변경합니다.   
  - `Configure` 버튼을 클릭합니다.
  - `Commit changes` 버튼을 클릭하여 설정을 저장합니다.   

2. **`github` 폴더 설정**   
  - 로컬 폴더의 `.github/workflows` 폴더에서 `pages-deploy.yml` 파일을 삭제합니다.
  - 다음 명령어로 변경 사항을 가져옵니다.   
```bash
  git pull
```   

3. **포스트(블로그 게시글) 생성 및 커밋**   

`_posts` 폴더에 새로운 포스트 파일을 생성합니다. 파일명은 `yyyy-mm-dd-"제목".md` 형식을 따릅니다. 이 파일을 생성한 후 커밋하고 푸시합니다.   

```bash
  git add .
  git commit -m "check"
```   

> **LF 오류 발생 시**   
{: .prompt-warning }   

```bash
  git config --global core.autocrlf true
```   

<br>

변경 사항을 원격 저장소로 전달합니다.  

```bash
  git push
```  

> **프로필에 커밋 잔디가 채워지지 않을 때**   
> GitHub에서는 테마를 Fork할 경우 GitHub의 정책상 잔디가 채워지지 않습니다.   
> 만약 커밋 잔디를 채우고 싶다면, GitHub에 Ticket을 제출하여 Fork한 저장소를 독립된 저장소로 분리할 수 있습니다.   
{: .prompt-tip }   

Fork한 저장소를 분리하려면 <a href="https://support.github.com/contact?tags=rr-forks&subject=Detach%20Fork&flow=detach_fork" target="_blank">GitHub 지원 페이지</a>를 통해 요청할 수 있습니다.   

<br>

