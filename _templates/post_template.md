---
#layout: post
title: {{ title }}
date: {{ date }}
description: # 검색어 및 글요약
categories: [Main_category, Sub_category]        # 메인 카테고리, 하위 카테고리(생략가능)
tags:           # 반드시 소문자로 작성, 한글가능
- 
- 
#pin: true # 해당글을 홈에서 고정시킬지
#toc: false # 오른쪽 목차 설정
#comments: false # 댓글 설정

#image: # 미리보기 이미지 설정
#  path: /path/to/image # 경로
#  alt: image alternative text # 이미지 설명 (생략가능)

#mermaid: true # 다이어그램 생성 도구 (https://github.com/mermaid-js/mermaid)
#math : true # 수학도구
---

## 목차 1
---
### 목차 1-1
#### 목차 1-1-1

## 목차 2
---
### 목차 2-1
#### 목차 2-1-1

## 목차 3
---
### 목차 3-1
#### 목차 3-1-1

## 목차 4
---
 1. 111
    1. 1-111
 2. 222
 3. 333

### 목차 4-1
- 첫번째
  - 두번째
    - 세번째
    - 네번째
      - 첫번째

#### 목차 4-1-1
- [ ] ToDo list
    - [ ] 리스트1
    - [x] 리스트2
    - [ ] 리스트3
      - [x] 리스트4




### 아래는 작성후 삭제
ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
https://chirpy.cotes.page/posts/text-and-typography/
https://docs.github.com/ko/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax

## [참고] 줄 맨끝 스페이스 두번 → 줄바꿈

### 줄만들기
---

## 글꼴 설정
**굵게**  
*기울기*  
~~취소선~~  
***굵고 기울게***  
테스트용<sub>아래첨자</sub>텍스트  
테스트용<sup>위첨자</sup>텍스트  

## 글색상 설정
<span style="color:red"> red </span>  
<span style="color:blue"> blue </span>  
<span style="color:brown"> brown </span>  
<span style="color:orange"> orange </span>  
<span style="color:blueviolet"> blueviolet </span>  

<span style="background-color:#fff5b1"> yellow </span>  
<span style="background-color:#FFE6E6"> red </span>  
<span style="background-color:#E6E6FA"> violet </span>  
<span style="background-color:#DCFFE4"> green </span>  


# 제일 큰 제목 (목차아님)
## 목차1
### 목차1에 소목차
#### 목차1에 소목차의 소목차

↓ 제목크기를 목차로 쓰고싶지 않을때
<!-- markdownlint-capture -->
<!-- markdownlint-disable -->
# H1 — heading
{: .mt-4 .mb-0 }
## H2 — heading
{: data-toc-skip='' .mt-4 .mb-0 }
### H3 — heading
{: data-toc-skip='' .mt-4 .mb-0 }
#### H4 — heading
{: data-toc-skip='' .mt-4 }
<!-- markdownlint-restore -->

# 설명리스트
설명
: 위에단어를 들여쓰기해서 설명하는 리스트다

# 블록인용
> 이키를 누르면 블록이 생성된다
> > 두번누르면 이중으로 블록이 생성된다
> >> 세번도 가능하다 그 이상도 가능하다

## html과 css사용하여 블록인용 색넣기 (파란색)
<div class="ghd-alert ghd-alert-accent ghd-spotlight-accent">
<div style="border-left: 4px solid blue; padding-left: 10px;">
<p><strong>설명:</strong></p>
<ul>
<li>파란색으로</li>
<li>블록인용 색이 바뀐다</li>
</ul>
</div>
</div>

# 프롬프트
{: .prompt-info }
> 내용  
info : tip, info, warning, danger

# 인라인코드
`내용`

# 파일 경로 강조
Here is the `/path/to/the/file.extend`{: .filepath}.

# 코드블록 (text, bash, python, sql, ruby)
```text
This is a plaintext code snippet.
```
{: .nolineno } # 코드 줄표시 안하려면  
{: file='path/to/text.txt'} # 가운데 상단 코드 언어표시를 파일이름으로 대체

# 테이블
| 테이블 |   정렬   |     이다 |
| :----- | :------: | -------: |
| 왼쪽   |  가운데  |   오른쪽 |
| 이렇게 | 테이블을 | 사용한다 |
| 계속   |  만들수  |     있다 |

# 링크
<http://127.0.0.1:4000>  
[글자링크는이렇게](http://127.0.0.1:4000)
<a href="https://github.com" target="_blank">GitHub 새 창에서 열기</a>

# 각주
각주를 이렇게[^1] 혹은 저렇게[^2] 아님 요렇게[^3]  

# 각주내용
[^1]: 이렇게 각주
[^2]: 저렇게 각주
[^3]: 요렇게 각주

# 이모지
https://github.com/ikatyang/emoji-cheat-sheet/blob/master/README.md#face-smiling

# 이미지 아래 캡션 표시하고싶을때
## [다른원격저장소] 자료링크는 해당 파일 permailnk 넣기
![img-description](/path/to/image)
_Image Caption_

# 이미지 크기설정 (약어 입력 가능)
![Desktop View](/assets/img/sample/mockup.png){: width="700" height="400" }
![Desktop View](/assets/img/sample/mockup.png){: w="700" h="400" }

# 이미지 위치설정 (위치설정시 캡션 사용불가)
중앙(기본설정) 
![Desktop View](/assets/img/sample/mockup.png){: .normal }
왼쪽
![Desktop View](/assets/img/sample/mockup.png){: .left }
오른쪽
![Desktop View](/assets/img/sample/mockup.png){: .right }


# 동영상 ([]까지 지우고 바꾸기)
1) 소셜 미디어 플랫폼 가져오기
{% include embed/[Platform].html id='[ID]' %}
Platform : youtube, twitch, bilibili
ID : v={}, videos/{}, video{}

2) 직접 올리기
{% include embed/video.html src='{URL}' %}

# 오디오
{% include embed/audio.html src='{URL}' %}