---
#layout: post
title: 파이썬 데이터분석 - 장바구니 분석(연관분석) 실습
date: 2024-10-01
description: # 검색어 및 글요약
categories: [Data_analysis, Python_DA_Library]        # 메인 카테고리, 하위 카테고리(생략가능)
tags:           # 반드시 소문자로 작성, 한글가능
- Market Basket Analysis
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

> 이번 미션에서는 베이커리 구매 데이터를 분석해볼 예정입니다.
> 사용할 데이터는 에든버러에 있는 베이커리의 고객 구매 데이터입니다. 
> 이 데이터셋은 2016/1/11에서 2017/12/03까지 베이커리에서 제품을 구매한 고객들의 제품 구매 데이터입니다.

> 이 미션에서는 베이커리의 사장이라고 가정을 해보고, 고객의 구매 패턴을 분석하여 상품 간의 상호 작용이나 구매 행동의 흥미로운 패턴을 파악해 보아요. 데이터 EDA와 장바구니 분석을 적용하여 분석 결과를 도출해 봅시다. 이를 통해 베이커리의 매출을 증대시키고, 고객 만족도를 높이는 방법을 찾는 것이 목표입니다. 데이터 분석을 통해 어떤 전략이 효과적일지 아이디어를 얻어보세요.


```python
### 개발환경 세팅하기

# ▶ 한글 폰트 다운로드
!sudo apt-get install -y fonts-nanum
!sudo fc-cache -fv
!rm ~/.cache/matplotlib -rf
```

    Reading package lists... Done
    Building dependency tree... Done
    Reading state information... Done
    fonts-nanum is already the newest version (20200506-1).
    0 upgraded, 0 newly installed, 0 to remove and 49 not upgraded.
    /usr/share/fonts: caching, new cache contents: 0 fonts, 1 dirs
    /usr/share/fonts/truetype: caching, new cache contents: 0 fonts, 3 dirs
    /usr/share/fonts/truetype/humor-sans: caching, new cache contents: 1 fonts, 0 dirs
    /usr/share/fonts/truetype/liberation: caching, new cache contents: 16 fonts, 0 dirs
    /usr/share/fonts/truetype/nanum: caching, new cache contents: 12 fonts, 0 dirs
    /usr/local/share/fonts: caching, new cache contents: 0 fonts, 0 dirs
    /root/.local/share/fonts: skipping, no such directory
    /root/.fonts: skipping, no such directory
    /usr/share/fonts/truetype: skipping, looped directory detected
    /usr/share/fonts/truetype/humor-sans: skipping, looped directory detected
    /usr/share/fonts/truetype/liberation: skipping, looped directory detected
    /usr/share/fonts/truetype/nanum: skipping, looped directory detected
    /var/cache/fontconfig: cleaning cache directory
    /root/.cache/fontconfig: not cleaning non-existent cache directory
    /root/.fontconfig: not cleaning non-existent cache directory
    fc-cache: succeeded
    


```python
# ▶ 한글 폰트 설정하기
import matplotlib.pyplot as plt
plt.rc('font', family='NanumBarunGothic')
plt.rcParams['axes.unicode_minus'] =False

# ▶ Warnings 제거
import warnings
warnings.filterwarnings('ignore')

# ▶ Google drive mount or 폴더 클릭 후 구글드라이브 연결
from google.colab import drive
drive.mount('/content/drive')
```

    Drive already mounted at /content/drive; to attempt to forcibly remount, call drive.mount("/content/drive", force_remount=True).
    


```python
import warnings
warnings.simplefilter('ignore')
```


```python
##########################################
### 한글이 깨지는 경우 아래 코드 실행하기 !!!###
##########################################
import matplotlib.pyplot as plt
import matplotlib.font_manager as fm

# 나눔고딕 폰트를 설치합니다.
!apt-get install -y fonts-nanum
!fc-cache -fv

# 설치된 나눔고딕 폰트를 matplotlib에 등록합니다.
font_path = '/usr/share/fonts/truetype/nanum/NanumGothic.ttf'
fm.fontManager.addfont(font_path)
plt.rcParams['font.family'] = 'NanumGothic'
```

    Reading package lists... Done
    Building dependency tree... Done
    Reading state information... Done
    fonts-nanum is already the newest version (20200506-1).
    0 upgraded, 0 newly installed, 0 to remove and 49 not upgraded.
    /usr/share/fonts: caching, new cache contents: 0 fonts, 1 dirs
    /usr/share/fonts/truetype: caching, new cache contents: 0 fonts, 3 dirs
    /usr/share/fonts/truetype/humor-sans: caching, new cache contents: 1 fonts, 0 dirs
    /usr/share/fonts/truetype/liberation: caching, new cache contents: 16 fonts, 0 dirs
    /usr/share/fonts/truetype/nanum: caching, new cache contents: 12 fonts, 0 dirs
    /usr/local/share/fonts: caching, new cache contents: 0 fonts, 0 dirs
    /root/.local/share/fonts: skipping, no such directory
    /root/.fonts: skipping, no such directory
    /usr/share/fonts/truetype: skipping, looped directory detected
    /usr/share/fonts/truetype/humor-sans: skipping, looped directory detected
    /usr/share/fonts/truetype/liberation: skipping, looped directory detected
    /usr/share/fonts/truetype/nanum: skipping, looped directory detected
    /var/cache/fontconfig: cleaning cache directory
    /root/.cache/fontconfig: not cleaning non-existent cache directory
    /root/.fontconfig: not cleaning non-existent cache directory
    fc-cache: succeeded
    


```python
import os
import pandas as pd
import numpy as np
import seaborn as sns
```

## **데이터 준비하기**
---

> **데이터 준비하기**

- 데이터 출처: [Kaggle](https://www.kaggle.com/datasets/akashdeepkuila/bakery) `Bakery Sales Dataset`

- 데이터 설명

| 컬럼명        | 설명                                      |
| ------------- | ----------------------------------------- |
| TransactionNo | 거래 ID                                   |
| Items         | 구매한 제품명                             |
| DateTime      | 거래 날짜 및 시각                         |
| Daypart       | 아침/오후/저녁/밤 중 언제 구매했는지 여부 |
| DayType       | 주중/주말 중 언제 구매했는지 여부         |




## 데이터 전처리


```python
pd.set_option('display.max_rows', 50)  # 모든 행을 표시하도록 설정
```


```python
# 데이터 불러오기
df = pd.read_csv("/content/drive/MyDrive/Bakery.csv")
df
```





  <div id="df-c32ff100-07d1-4f35-9a4e-1b937179f3ad" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>TransactionNo</th>
      <th>Items</th>
      <th>DateTime</th>
      <th>Daypart</th>
      <th>DayType</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>Bread</td>
      <td>2016.10.30 9:58</td>
      <td>Morning</td>
      <td>Weekend</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>Scandinavian</td>
      <td>2016.10.30 10:05</td>
      <td>Morning</td>
      <td>Weekend</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>Scandinavian</td>
      <td>2016.10.30 10:05</td>
      <td>Morning</td>
      <td>Weekend</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3</td>
      <td>Hot chocolate</td>
      <td>2016.10.30 10:07</td>
      <td>Morning</td>
      <td>Weekend</td>
    </tr>
    <tr>
      <th>4</th>
      <td>3</td>
      <td>Jam</td>
      <td>2016.10.30 10:07</td>
      <td>Morning</td>
      <td>Weekend</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>20502</th>
      <td>9682</td>
      <td>Coffee</td>
      <td>2017.9.4 14:32</td>
      <td>Afternoon</td>
      <td>Weekend</td>
    </tr>
    <tr>
      <th>20503</th>
      <td>9682</td>
      <td>Tea</td>
      <td>2017.9.4 14:32</td>
      <td>Afternoon</td>
      <td>Weekend</td>
    </tr>
    <tr>
      <th>20504</th>
      <td>9683</td>
      <td>Coffee</td>
      <td>2017.9.4 14:57</td>
      <td>Afternoon</td>
      <td>Weekend</td>
    </tr>
    <tr>
      <th>20505</th>
      <td>9683</td>
      <td>Pastry</td>
      <td>2017.9.4 14:57</td>
      <td>Afternoon</td>
      <td>Weekend</td>
    </tr>
    <tr>
      <th>20506</th>
      <td>9684</td>
      <td>Smoothies</td>
      <td>2017.9.4 15:04</td>
      <td>Afternoon</td>
      <td>Weekend</td>
    </tr>
  </tbody>
</table>
<p>20507 rows × 5 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-c32ff100-07d1-4f35-9a4e-1b937179f3ad')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-c32ff100-07d1-4f35-9a4e-1b937179f3ad button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-c32ff100-07d1-4f35-9a4e-1b937179f3ad');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-b877447b-a607-43d7-8858-c8840895d9be">
  <button class="colab-df-quickchart" onclick="quickchart('df-b877447b-a607-43d7-8858-c8840895d9be')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-b877447b-a607-43d7-8858-c8840895d9be button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_ae9851d6-b333-4587-81b2-90f312ee0a06">
    <style>
      .colab-df-generate {
        background-color: #E8F0FE;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        display: none;
        fill: #1967D2;
        height: 32px;
        padding: 0 0 0 0;
        width: 32px;
      }

      .colab-df-generate:hover {
        background-color: #E2EBFA;
        box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
        fill: #174EA6;
      }

      [theme=dark] .colab-df-generate {
        background-color: #3B4455;
        fill: #D2E3FC;
      }

      [theme=dark] .colab-df-generate:hover {
        background-color: #434B5C;
        box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
        filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
        fill: #FFFFFF;
      }
    </style>
    <button class="colab-df-generate" onclick="generateWithVariable('df')"
            title="Generate code using this dataframe."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
       width="24px">
    <path d="M7,19H8.4L18.45,9,17,7.55,7,17.6ZM5,21V16.75L18.45,3.32a2,2,0,0,1,2.83,0l1.4,1.43a1.91,1.91,0,0,1,.58,1.4,1.91,1.91,0,0,1-.58,1.4L9.25,21ZM18.45,9,17,7.55Zm-12,3A5.31,5.31,0,0,0,4.9,8.1,5.31,5.31,0,0,0,1,6.5,5.31,5.31,0,0,0,4.9,4.9,5.31,5.31,0,0,0,6.5,1,5.31,5.31,0,0,0,8.1,4.9,5.31,5.31,0,0,0,12,6.5,5.46,5.46,0,0,0,6.5,12Z"/>
  </svg>
    </button>
    <script>
      (() => {
      const buttonEl =
        document.querySelector('#id_ae9851d6-b333-4587-81b2-90f312ee0a06 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('df');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 기본정보 확인
df.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 20507 entries, 0 to 20506
    Data columns (total 5 columns):
     #   Column         Non-Null Count  Dtype 
    ---  ------         --------------  ----- 
     0   TransactionNo  20507 non-null  int64 
     1   Items          20507 non-null  object
     2   DateTime       20507 non-null  object
     3   Daypart        20507 non-null  object
     4   DayType        20507 non-null  object
    dtypes: int64(1), object(4)
    memory usage: 801.2+ KB
    


```python
# 각 변수의 기술통계량 확인
df.describe(include='all')
```





  <div id="df-acba8b9e-ef78-42a0-8289-31a40215cf15" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>TransactionNo</th>
      <th>Items</th>
      <th>DateTime</th>
      <th>Daypart</th>
      <th>DayType</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>20507.000000</td>
      <td>20507</td>
      <td>20507</td>
      <td>20507</td>
      <td>20507</td>
    </tr>
    <tr>
      <th>unique</th>
      <td>NaN</td>
      <td>94</td>
      <td>9182</td>
      <td>4</td>
      <td>2</td>
    </tr>
    <tr>
      <th>top</th>
      <td>NaN</td>
      <td>Coffee</td>
      <td>2017.5.2 11:58</td>
      <td>Afternoon</td>
      <td>Weekday</td>
    </tr>
    <tr>
      <th>freq</th>
      <td>NaN</td>
      <td>5471</td>
      <td>12</td>
      <td>11569</td>
      <td>12807</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>4976.202370</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>std</th>
      <td>2796.203001</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>min</th>
      <td>1.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>2552.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>5137.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>7357.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>max</th>
      <td>9684.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-acba8b9e-ef78-42a0-8289-31a40215cf15')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-acba8b9e-ef78-42a0-8289-31a40215cf15 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-acba8b9e-ef78-42a0-8289-31a40215cf15');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-51bedc10-85e6-40ed-b34c-576aeb9c9df6">
  <button class="colab-df-quickchart" onclick="quickchart('df-51bedc10-85e6-40ed-b34c-576aeb9c9df6')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-51bedc10-85e6-40ed-b34c-576aeb9c9df6 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




### 중복값 처리


```python
# 중복값 확인
df.duplicated().sum()
```




    1620




```python
# 중복값 내용 확인
duplicate_rows = df[df.duplicated(keep=False)]
print(duplicate_rows)
```

           TransactionNo         Items          DateTime    Daypart  DayType
    1                  2  Scandinavian  2016.10.30 10:05    Morning  Weekend
    2                  2  Scandinavian  2016.10.30 10:05    Morning  Weekend
    23                11         Bread  2016.10.30 10:27    Morning  Weekend
    25                11         Bread  2016.10.30 10:27    Morning  Weekend
    48                21        Coffee  2016.10.30 10:49    Morning  Weekend
    ...              ...           ...               ...        ...      ...
    20423           9634        Coffee    2017.8.4 16:30  Afternoon  Weekend
    20464           9664        Coffee    2017.9.4 11:40    Morning  Weekend
    20465           9664        Coffee    2017.9.4 11:40    Morning  Weekend
    20472           9667      Sandwich    2017.9.4 12:04  Afternoon  Weekend
    20473           9667      Sandwich    2017.9.4 12:04  Afternoon  Weekend
    
    [3140 rows x 5 columns]
    


```python
# 중복값 제거 : 똑같은걸 2개를 산건지 전산오류인지 수량의 정보가없어 확인할 방법이 없다. 본 분석에서는 중복값을 전부 제거하고 진행한다
print(f"중복값 제거 전 : {df.shape}")
df.drop_duplicates(inplace=True)
df.reset_index(drop=True, inplace=True)
print(f"중복값 제거 후 : {df.shape}")
```

    중복값 제거 전 : (20507, 5)
    중복값 제거 후 : (18887, 5)
    


```python
# 중복값 확인
df.duplicated().sum()
```




    0



### 결측치 처리


```python
# 결측치 확인
df.isna().sum().sort_values(ascending=False)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>0</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>TransactionNo</th>
      <td>0</td>
    </tr>
    <tr>
      <th>Items</th>
      <td>0</td>
    </tr>
    <tr>
      <th>DateTime</th>
      <td>0</td>
    </tr>
    <tr>
      <th>Daypart</th>
      <td>0</td>
    </tr>
    <tr>
      <th>DayType</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
# 이상치는 특이사항 없는것으로 판단됐으나, 파생변수를 생성하면서 특이사항이 발견됨
```

### 파생변수 생성


```python
# DateTime열을 년, 월, 요일, 시간으로 구분한다
# DateTime 변수를 datetime 형식으로 변환
df['DateTime'] = pd.to_datetime(df['DateTime'], format='%Y.%m.%d %H:%M')

# 파생변수 생성
df['Year'] = df['DateTime'].dt.year
df['Month'] = df['DateTime'].dt.month
df['Day'] = df['DateTime'].dt.day
df['DayOfWeek'] = df['DateTime'].dt.day_name()  # 요일
df['Hour'] = df['DateTime'].dt.hour

# 기존 DateTime 변수 제거
df.drop(columns=['DateTime'], inplace=True)

df
```





  <div id="df-eb684c3f-670a-4d76-98e9-229c439a0495" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>TransactionNo</th>
      <th>Items</th>
      <th>Daypart</th>
      <th>DayType</th>
      <th>Year</th>
      <th>Month</th>
      <th>Day</th>
      <th>DayOfWeek</th>
      <th>Hour</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>Bread</td>
      <td>Morning</td>
      <td>Weekend</td>
      <td>2016</td>
      <td>10</td>
      <td>30</td>
      <td>Sunday</td>
      <td>9</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>Scandinavian</td>
      <td>Morning</td>
      <td>Weekend</td>
      <td>2016</td>
      <td>10</td>
      <td>30</td>
      <td>Sunday</td>
      <td>10</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>Hot chocolate</td>
      <td>Morning</td>
      <td>Weekend</td>
      <td>2016</td>
      <td>10</td>
      <td>30</td>
      <td>Sunday</td>
      <td>10</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3</td>
      <td>Jam</td>
      <td>Morning</td>
      <td>Weekend</td>
      <td>2016</td>
      <td>10</td>
      <td>30</td>
      <td>Sunday</td>
      <td>10</td>
    </tr>
    <tr>
      <th>4</th>
      <td>3</td>
      <td>Cookies</td>
      <td>Morning</td>
      <td>Weekend</td>
      <td>2016</td>
      <td>10</td>
      <td>30</td>
      <td>Sunday</td>
      <td>10</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>18882</th>
      <td>9682</td>
      <td>Coffee</td>
      <td>Afternoon</td>
      <td>Weekend</td>
      <td>2017</td>
      <td>9</td>
      <td>4</td>
      <td>Monday</td>
      <td>14</td>
    </tr>
    <tr>
      <th>18883</th>
      <td>9682</td>
      <td>Tea</td>
      <td>Afternoon</td>
      <td>Weekend</td>
      <td>2017</td>
      <td>9</td>
      <td>4</td>
      <td>Monday</td>
      <td>14</td>
    </tr>
    <tr>
      <th>18884</th>
      <td>9683</td>
      <td>Coffee</td>
      <td>Afternoon</td>
      <td>Weekend</td>
      <td>2017</td>
      <td>9</td>
      <td>4</td>
      <td>Monday</td>
      <td>14</td>
    </tr>
    <tr>
      <th>18885</th>
      <td>9683</td>
      <td>Pastry</td>
      <td>Afternoon</td>
      <td>Weekend</td>
      <td>2017</td>
      <td>9</td>
      <td>4</td>
      <td>Monday</td>
      <td>14</td>
    </tr>
    <tr>
      <th>18886</th>
      <td>9684</td>
      <td>Smoothies</td>
      <td>Afternoon</td>
      <td>Weekend</td>
      <td>2017</td>
      <td>9</td>
      <td>4</td>
      <td>Monday</td>
      <td>15</td>
    </tr>
  </tbody>
</table>
<p>18887 rows × 9 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-eb684c3f-670a-4d76-98e9-229c439a0495')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-eb684c3f-670a-4d76-98e9-229c439a0495 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-eb684c3f-670a-4d76-98e9-229c439a0495');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-8b76bbed-18f8-4850-8435-164b9d519c6d">
  <button class="colab-df-quickchart" onclick="quickchart('df-8b76bbed-18f8-4850-8435-164b9d519c6d')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-8b76bbed-18f8-4850-8435-164b9d519c6d button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_685b7c88-1792-455e-bcef-a85354417822">
    <style>
      .colab-df-generate {
        background-color: #E8F0FE;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        display: none;
        fill: #1967D2;
        height: 32px;
        padding: 0 0 0 0;
        width: 32px;
      }

      .colab-df-generate:hover {
        background-color: #E2EBFA;
        box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
        fill: #174EA6;
      }

      [theme=dark] .colab-df-generate {
        background-color: #3B4455;
        fill: #D2E3FC;
      }

      [theme=dark] .colab-df-generate:hover {
        background-color: #434B5C;
        box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
        filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
        fill: #FFFFFF;
      }
    </style>
    <button class="colab-df-generate" onclick="generateWithVariable('df')"
            title="Generate code using this dataframe."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
       width="24px">
    <path d="M7,19H8.4L18.45,9,17,7.55,7,17.6ZM5,21V16.75L18.45,3.32a2,2,0,0,1,2.83,0l1.4,1.43a1.91,1.91,0,0,1,.58,1.4,1.91,1.91,0,0,1-.58,1.4L9.25,21ZM18.45,9,17,7.55Zm-12,3A5.31,5.31,0,0,0,4.9,8.1,5.31,5.31,0,0,0,1,6.5,5.31,5.31,0,0,0,4.9,4.9,5.31,5.31,0,0,0,6.5,1,5.31,5.31,0,0,0,8.1,4.9,5.31,5.31,0,0,0,12,6.5,5.46,5.46,0,0,0,6.5,12Z"/>
  </svg>
    </button>
    <script>
      (() => {
      const buttonEl =
        document.querySelector('#id_685b7c88-1792-455e-bcef-a85354417822 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('df');
      }
      })();
    </script>
  </div>

    </div>
  </div>




### 이상치 처리


```python
# 어라? 거래번호 9684는 DayType은 주말인데 DayOfWeek는 월요일이네? 이런데이터들이 얼마나 있을까?

# 조건 1: DayOfWeek가 일요일 또는 토요일인데 DayType이 'Weekend'가 아닌 데이터
condition1 = df[(df['DayOfWeek'].isin(['Saturday', 'Sunday'])) & (df['DayType'] != 'Weekend')]

# 조건 2: DayType이 'Weekend'인데 DayOfWeek가 일요일 또는 토요일이 아닌 데이터
condition2 = df[(df['DayType'] == 'Weekend') & (~df['DayOfWeek'].isin(['Saturday', 'Sunday']))]

# 결과
result1_count = condition1.shape[0]  # 조건 1의 수
result2_count = condition2.shape[0]  # 조건 2의 수

# 결과 출력
print(f"조건 1의 수: {result1_count}")
print(f"조건 2의 수: {result2_count}")
```

    조건 1의 수: 955
    조건 2의 수: 1882
    


```python
df['DayType'].unique()
```




    array(['Weekend', 'Weekday'], dtype=object)




```python
df['Daypart'].unique()
```




    array(['Morning', 'Afternoon', 'Evening', 'Night'], dtype=object)




```python
# Daypart도 확인해볼필요가있다
# 각 Daypart별로 Hour의 고유값 확인
hour_by_daypart = df.groupby('Daypart')['Hour'].unique()

hour_by_daypart
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Hour</th>
    </tr>
    <tr>
      <th>Daypart</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Afternoon</th>
      <td>[12, 13, 14, 15, 16]</td>
    </tr>
    <tr>
      <th>Evening</th>
      <td>[17, 18, 19, 20]</td>
    </tr>
    <tr>
      <th>Morning</th>
      <td>[9, 10, 11, 8, 7, 1]</td>
    </tr>
    <tr>
      <th>Night</th>
      <td>[21, 23, 22]</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> object</label>




```python
# 아침인데 새벽1시 데이터만 수상해보인다
# Hour가 1인 데이터 필터링
hour_1_data = df[df['Hour'] == 1]

hour_1_data
```





  <div id="df-00e8c420-4022-43ef-bb44-52999316d276" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>TransactionNo</th>
      <th>Items</th>
      <th>Daypart</th>
      <th>DayType</th>
      <th>Year</th>
      <th>Month</th>
      <th>Day</th>
      <th>DayOfWeek</th>
      <th>Hour</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>7594</th>
      <td>4090</td>
      <td>Bread</td>
      <td>Morning</td>
      <td>Weekend</td>
      <td>2017</td>
      <td>1</td>
      <td>1</td>
      <td>Sunday</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-00e8c420-4022-43ef-bb44-52999316d276')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-00e8c420-4022-43ef-bb44-52999316d276 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-00e8c420-4022-43ef-bb44-52999316d276');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


  <div id="id_bd7b264b-2307-4dc5-9ce2-e7a0b8b2dceb">
    <style>
      .colab-df-generate {
        background-color: #E8F0FE;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        display: none;
        fill: #1967D2;
        height: 32px;
        padding: 0 0 0 0;
        width: 32px;
      }

      .colab-df-generate:hover {
        background-color: #E2EBFA;
        box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
        fill: #174EA6;
      }

      [theme=dark] .colab-df-generate {
        background-color: #3B4455;
        fill: #D2E3FC;
      }

      [theme=dark] .colab-df-generate:hover {
        background-color: #434B5C;
        box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
        filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
        fill: #FFFFFF;
      }
    </style>
    <button class="colab-df-generate" onclick="generateWithVariable('hour_1_data')"
            title="Generate code using this dataframe."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
       width="24px">
    <path d="M7,19H8.4L18.45,9,17,7.55,7,17.6ZM5,21V16.75L18.45,3.32a2,2,0,0,1,2.83,0l1.4,1.43a1.91,1.91,0,0,1,.58,1.4,1.91,1.91,0,0,1-.58,1.4L9.25,21ZM18.45,9,17,7.55Zm-12,3A5.31,5.31,0,0,0,4.9,8.1,5.31,5.31,0,0,0,1,6.5,5.31,5.31,0,0,0,4.9,4.9,5.31,5.31,0,0,0,6.5,1,5.31,5.31,0,0,0,8.1,4.9,5.31,5.31,0,0,0,12,6.5,5.46,5.46,0,0,0,6.5,12Z"/>
  </svg>
    </button>
    <script>
      (() => {
      const buttonEl =
        document.querySelector('#id_bd7b264b-2307-4dc5-9ce2-e7a0b8b2dceb button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('hour_1_data');
      }
      })();
    </script>
  </div>

    </div>
  </div>




#### 이상치 처리방안
  - 조건1 : 'DayOfWeek'열에서 평일인데 'DayType'값이 'Weekend'라면 'Weekday'로 바꾼다
  - 조건2 : 'DayOfWeek'열에서 주말인데 'DayType'값이 'Weekday'라면 'Weekend'로 바꾼다
  - 조건3 : 'Hour'열에서 새벽1시인데 'Daypart'값이 'Morning'라면 'Night'로 바꾼다


```python
# 이상치 처리

# 조건 1: 평일인데 DayType이 'Weekend'인 데이터 수 확인 및 변경
condition1 = df[(df['DayOfWeek'].isin(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'])) &
                 (df['DayType'] == 'Weekend')]
condition1_count = condition1.shape[0]  # 데이터 수

# 데이터 변경
df.loc[condition1.index, 'DayType'] = 'Weekday'

# 조건 2: 주말인데 DayType이 'Weekday'인 데이터 수 확인 및 변경
condition2 = df[(df['DayOfWeek'].isin(['Saturday', 'Sunday'])) &
                 (df['DayType'] == 'Weekday')]
condition2_count = condition2.shape[0]  # 데이터 수

# 데이터 변경
df.loc[condition2.index, 'DayType'] = 'Weekend'

# 조건 3: 새벽 1시인데 Daypart가 'Morning'인 데이터 수 확인 및 변경
condition3 = df[(df['Hour'] == 1) & (df['Daypart'] == 'Morning')]
condition3_count = condition3.shape[0]  # 데이터 수

# 데이터 변경
df.loc[condition3.index, 'Daypart'] = 'Night'

# 결과 출력
print(f"조건 1의 데이터 수: {condition1_count}")
print(f"조건 2의 데이터 수: {condition2_count}")
print(f"조건 3의 데이터 수: {condition3_count}")

df
```

    조건 1의 데이터 수: 1882
    조건 2의 데이터 수: 955
    조건 3의 데이터 수: 1
    





  <div id="df-1f6cf0e8-fd70-42ee-b473-c20ceb94f525" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>TransactionNo</th>
      <th>Items</th>
      <th>Daypart</th>
      <th>DayType</th>
      <th>Year</th>
      <th>Month</th>
      <th>Day</th>
      <th>DayOfWeek</th>
      <th>Hour</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>Bread</td>
      <td>Morning</td>
      <td>Weekend</td>
      <td>2016</td>
      <td>10</td>
      <td>30</td>
      <td>Sunday</td>
      <td>9</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>Scandinavian</td>
      <td>Morning</td>
      <td>Weekend</td>
      <td>2016</td>
      <td>10</td>
      <td>30</td>
      <td>Sunday</td>
      <td>10</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>Hot chocolate</td>
      <td>Morning</td>
      <td>Weekend</td>
      <td>2016</td>
      <td>10</td>
      <td>30</td>
      <td>Sunday</td>
      <td>10</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3</td>
      <td>Jam</td>
      <td>Morning</td>
      <td>Weekend</td>
      <td>2016</td>
      <td>10</td>
      <td>30</td>
      <td>Sunday</td>
      <td>10</td>
    </tr>
    <tr>
      <th>4</th>
      <td>3</td>
      <td>Cookies</td>
      <td>Morning</td>
      <td>Weekend</td>
      <td>2016</td>
      <td>10</td>
      <td>30</td>
      <td>Sunday</td>
      <td>10</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>18882</th>
      <td>9682</td>
      <td>Coffee</td>
      <td>Afternoon</td>
      <td>Weekday</td>
      <td>2017</td>
      <td>9</td>
      <td>4</td>
      <td>Monday</td>
      <td>14</td>
    </tr>
    <tr>
      <th>18883</th>
      <td>9682</td>
      <td>Tea</td>
      <td>Afternoon</td>
      <td>Weekday</td>
      <td>2017</td>
      <td>9</td>
      <td>4</td>
      <td>Monday</td>
      <td>14</td>
    </tr>
    <tr>
      <th>18884</th>
      <td>9683</td>
      <td>Coffee</td>
      <td>Afternoon</td>
      <td>Weekday</td>
      <td>2017</td>
      <td>9</td>
      <td>4</td>
      <td>Monday</td>
      <td>14</td>
    </tr>
    <tr>
      <th>18885</th>
      <td>9683</td>
      <td>Pastry</td>
      <td>Afternoon</td>
      <td>Weekday</td>
      <td>2017</td>
      <td>9</td>
      <td>4</td>
      <td>Monday</td>
      <td>14</td>
    </tr>
    <tr>
      <th>18886</th>
      <td>9684</td>
      <td>Smoothies</td>
      <td>Afternoon</td>
      <td>Weekday</td>
      <td>2017</td>
      <td>9</td>
      <td>4</td>
      <td>Monday</td>
      <td>15</td>
    </tr>
  </tbody>
</table>
<p>18887 rows × 9 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-1f6cf0e8-fd70-42ee-b473-c20ceb94f525')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-1f6cf0e8-fd70-42ee-b473-c20ceb94f525 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-1f6cf0e8-fd70-42ee-b473-c20ceb94f525');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-726584b3-03bf-44cd-8b28-010ce4d1d7a5">
  <button class="colab-df-quickchart" onclick="quickchart('df-726584b3-03bf-44cd-8b28-010ce4d1d7a5')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-726584b3-03bf-44cd-8b28-010ce4d1d7a5 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_bb5d3117-2570-475d-b0bc-e73d0d181867">
    <style>
      .colab-df-generate {
        background-color: #E8F0FE;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        display: none;
        fill: #1967D2;
        height: 32px;
        padding: 0 0 0 0;
        width: 32px;
      }

      .colab-df-generate:hover {
        background-color: #E2EBFA;
        box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
        fill: #174EA6;
      }

      [theme=dark] .colab-df-generate {
        background-color: #3B4455;
        fill: #D2E3FC;
      }

      [theme=dark] .colab-df-generate:hover {
        background-color: #434B5C;
        box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
        filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
        fill: #FFFFFF;
      }
    </style>
    <button class="colab-df-generate" onclick="generateWithVariable('df')"
            title="Generate code using this dataframe."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
       width="24px">
    <path d="M7,19H8.4L18.45,9,17,7.55,7,17.6ZM5,21V16.75L18.45,3.32a2,2,0,0,1,2.83,0l1.4,1.43a1.91,1.91,0,0,1,.58,1.4,1.91,1.91,0,0,1-.58,1.4L9.25,21ZM18.45,9,17,7.55Zm-12,3A5.31,5.31,0,0,0,4.9,8.1,5.31,5.31,0,0,0,1,6.5,5.31,5.31,0,0,0,4.9,4.9,5.31,5.31,0,0,0,6.5,1,5.31,5.31,0,0,0,8.1,4.9,5.31,5.31,0,0,0,12,6.5,5.46,5.46,0,0,0,6.5,12Z"/>
  </svg>
    </button>
    <script>
      (() => {
      const buttonEl =
        document.querySelector('#id_bb5d3117-2570-475d-b0bc-e73d0d181867 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('df');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 이상치가 처리됐는지 확인

# 조건 1: 평일인데 DayType이 'Weekend'인 데이터 수 확인
condition1 = df[(df['DayOfWeek'].isin(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'])) &
                 (df['DayType'] == 'Weekend')]
condition1_count = condition1.shape[0]  # 데이터 수

# 조건 2: 주말인데 DayType이 'Weekday'인 데이터 수 확인
condition2 = df[(df['DayOfWeek'].isin(['Saturday', 'Sunday'])) &
                 (df['DayType'] == 'Weekday')]
condition2_count = condition2.shape[0]  # 데이터 수

# 조건 3: 새벽 1시인데 Daypart가 'Morning'인 데이터 수 확인
condition3 = df[(df['Hour'] == 1) & (df['Daypart'] == 'Morning')]
condition3_count = condition3.shape[0]  # 데이터 수

print(f"조건 1의 데이터 수: {condition1_count}")
print(f"조건 2의 데이터 수: {condition2_count}")
print(f"조건 3의 데이터 수: {condition3_count}")
```

    조건 1의 데이터 수: 0
    조건 2의 데이터 수: 0
    조건 3의 데이터 수: 0
    

## EDA


```python
# 각 변수의 기술통계량 확인
df.describe(include='all')
```





  <div id="df-10bfb277-205c-4b59-9a73-8c6343393351" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>TransactionNo</th>
      <th>Items</th>
      <th>Daypart</th>
      <th>DayType</th>
      <th>Year</th>
      <th>Month</th>
      <th>Day</th>
      <th>DayOfWeek</th>
      <th>Hour</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>18887.000000</td>
      <td>18887</td>
      <td>18887</td>
      <td>18887</td>
      <td>18887.000000</td>
      <td>18887.000000</td>
      <td>18887.000000</td>
      <td>18887</td>
      <td>18887.000000</td>
    </tr>
    <tr>
      <th>unique</th>
      <td>NaN</td>
      <td>94</td>
      <td>4</td>
      <td>2</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>7</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>top</th>
      <td>NaN</td>
      <td>Coffee</td>
      <td>Afternoon</td>
      <td>Weekday</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>Saturday</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>freq</th>
      <td>NaN</td>
      <td>4528</td>
      <td>10687</td>
      <td>12757</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>3274</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>4951.051517</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2016.597924</td>
      <td>6.047016</td>
      <td>14.948589</td>
      <td>NaN</td>
      <td>12.276116</td>
    </tr>
    <tr>
      <th>std</th>
      <td>2811.619306</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>0.490330</td>
      <td>4.141418</td>
      <td>9.272868</td>
      <td>NaN</td>
      <td>2.342972</td>
    </tr>
    <tr>
      <th>min</th>
      <td>1.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2016.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>NaN</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>2496.500000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2016.000000</td>
      <td>2.000000</td>
      <td>4.000000</td>
      <td>NaN</td>
      <td>10.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>5082.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017.000000</td>
      <td>5.000000</td>
      <td>15.000000</td>
      <td>NaN</td>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>7378.500000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017.000000</td>
      <td>11.000000</td>
      <td>23.000000</td>
      <td>NaN</td>
      <td>14.000000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>9684.000000</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017.000000</td>
      <td>12.000000</td>
      <td>31.000000</td>
      <td>NaN</td>
      <td>23.000000</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-10bfb277-205c-4b59-9a73-8c6343393351')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-10bfb277-205c-4b59-9a73-8c6343393351 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-10bfb277-205c-4b59-9a73-8c6343393351');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-3ed7eb33-de24-4a4b-b5d7-610ded334432">
  <button class="colab-df-quickchart" onclick="quickchart('df-3ed7eb33-de24-4a4b-b5d7-610ded334432')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-3ed7eb33-de24-4a4b-b5d7-610ded334432 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
# 무엇이 많이 팔렸나
df['Items'].value_counts().head(20)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>count</th>
    </tr>
    <tr>
      <th>Items</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Coffee</th>
      <td>4528</td>
    </tr>
    <tr>
      <th>Bread</th>
      <td>3097</td>
    </tr>
    <tr>
      <th>Tea</th>
      <td>1350</td>
    </tr>
    <tr>
      <th>Cake</th>
      <td>983</td>
    </tr>
    <tr>
      <th>Pastry</th>
      <td>815</td>
    </tr>
    <tr>
      <th>Sandwich</th>
      <td>680</td>
    </tr>
    <tr>
      <th>Medialuna</th>
      <td>585</td>
    </tr>
    <tr>
      <th>Hot chocolate</th>
      <td>552</td>
    </tr>
    <tr>
      <th>Cookies</th>
      <td>515</td>
    </tr>
    <tr>
      <th>Brownie</th>
      <td>379</td>
    </tr>
    <tr>
      <th>Farm House</th>
      <td>371</td>
    </tr>
    <tr>
      <th>Juice</th>
      <td>365</td>
    </tr>
    <tr>
      <th>Muffin</th>
      <td>364</td>
    </tr>
    <tr>
      <th>Alfajores</th>
      <td>344</td>
    </tr>
    <tr>
      <th>Scone</th>
      <td>327</td>
    </tr>
    <tr>
      <th>Soup</th>
      <td>326</td>
    </tr>
    <tr>
      <th>Toast</th>
      <td>318</td>
    </tr>
    <tr>
      <th>Scandinavian</th>
      <td>275</td>
    </tr>
    <tr>
      <th>Truffles</th>
      <td>192</td>
    </tr>
    <tr>
      <th>Coke</th>
      <td>184</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
# 상위20개 하위20개 아이템 비율로 시각화하기

# 아이템별 판매량 계산
item_counts = df['Items'].value_counts()

# 전체 판매량 계산
total_sales = item_counts.sum()

# 비율 계산
item_ratios = (item_counts / total_sales) * 100

# 상위 20
top_items = item_ratios.nlargest(20).sort_values(ascending=True)

# 하위 20
bottom_items = item_ratios.nsmallest(20).sort_values(ascending=False)

# 서브플롯 생성
fig, axes = plt.subplots(1, 2, figsize=(12, 5))

# 상위20 아이템 시각화
top_items.plot(kind='barh', ax=axes[0], color='skyblue')
axes[0].set_title('Top 20 Best Selling Items by Percentage')
axes[0].set_ylabel('')
axes[0].spines[['top','right']].set_visible(False)

# 막대 옆에 비율 표시
for index, value in enumerate(top_items):
    axes[0].text(value, index, f'{value:.1f}%', va='center')

# 하위20 아이템 시각화
bottom_items.plot(kind='barh', ax=axes[1], color='salmon')
axes[1].set_title('Bottom 20 Selling Items by Percentage')
axes[1].set_ylabel('')
axes[1].spines[['top','right']].set_visible(False)

# 막대 옆에 비율 표시
for index, value in enumerate(bottom_items):
    axes[1].text(value, index, f'{value:.3f}%', va='center')

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py5_files/py5_33_0.png)
    


- 상위 판매 아이템 : 커피, 빵, 차, 케이크, 페이스트리 등이 잘나간다.
- 하위 판매 아이템 : 베이컨, 폴렌타, 오일 등 일반적인 베이커리 메뉴가 아닌 제품들의 판매비중이 0.03% 미만으로 관찰되었다


```python
# 아이템별 판매비중이 심각하게 차이난다. 전체 94종류에서 메뉴를 개선할 필요가 있다
print(f"전체대비 0.5%미만 판매된 아이템 : 총 {item_ratios[item_ratios < 0.5].shape[0]}종류({(item_ratios[item_ratios < 0.5].shape[0]/df['Items'].nunique())*100:.2f}%) ")
item_ratios[item_ratios < 0.5]
```

    전체대비 0.5%미만 판매된 아이템 : 총 64종류(68.09%) 
    




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>count</th>
    </tr>
    <tr>
      <th>Items</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Frittata</th>
      <td>0.428866</td>
    </tr>
    <tr>
      <th>Smoothies</th>
      <td>0.407688</td>
    </tr>
    <tr>
      <th>Keeping It Local</th>
      <td>0.333563</td>
    </tr>
    <tr>
      <th>The Nomad</th>
      <td>0.307090</td>
    </tr>
    <tr>
      <th>Focaccia</th>
      <td>0.285911</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
    </tr>
    <tr>
      <th>Bacon</th>
      <td>0.005295</td>
    </tr>
    <tr>
      <th>Gift voucher</th>
      <td>0.005295</td>
    </tr>
    <tr>
      <th>Olum &amp; polenta</th>
      <td>0.005295</td>
    </tr>
    <tr>
      <th>Raw bars</th>
      <td>0.005295</td>
    </tr>
    <tr>
      <th>Polenta</th>
      <td>0.005295</td>
    </tr>
  </tbody>
</table>
<p>64 rows × 1 columns</p>
</div><br><label><b>dtype:</b> float64</label>



- 2년동안 판매한 베이커리 아이템중에 0.5% 미만 판매된 아이템이 64종류나있고 전체중 68%를 차지한다.
- 즉, 판매하고있는아이템 2/3가 상품가치가 떨어지고 메뉴를 간소화하는 방안을 고민할 필요가있다


```python
# 년도별 월별 판매수를 알아보자

# 월별 아이템 판매 수 집계
monthly_sales = df.groupby(['Year', 'Month']).size().unstack(fill_value=0)


fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(12, 6), sharey=True)

# 2016년 판매 수 시각화
monthly_sales.loc[2016].plot(kind='bar', ax=axes[0], color='skyblue')
axes[0].set_title('2016년 월별 판매수')
axes[0].set_xlabel('')
axes[0].set_ylabel('')
axes[0].set_xticklabels(monthly_sales.columns, rotation=0)

# 2017년 판매 수 시각화
monthly_sales.loc[2017].plot(kind='bar', ax=axes[1], color='skyblue')
axes[1].set_title('2017년 월별 판매수')
axes[1].set_xlabel('')
axes[1].set_xticklabels(monthly_sales.columns, rotation=0)

# 레이아웃 조정
plt.tight_layout()
plt.show()

```


    
![png](/assets/img/py5_files/py5_37_0.png)
    


 - 2016년 11월 ~ 2017년 3월 까지 판매량이 많았는데 그 이후로 판매량이 저조하다
 - 겨울이 성수기라면, 2016년 1월 ~ 2016년 3월, 2017년 11월 ~ 2017년 12월 판매량은 왜 적을까?


```python
# 년도별 월별 매장운영일수 확인

# 운영일수 집계 (중복된 날짜를 제외하기 위해 unique count)
operating_days = df.groupby(['Year', 'Month'])['Day'].nunique().unstack(fill_value=0)

# 서브플롯 생성
fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(12, 6), sharey=True)

# 2016년 운영일수 시각화
bars_2016 = operating_days.loc[2016].plot(kind='bar', ax=axes[0], color='purple')
axes[0].set_title('2016년 월별 매장 운영일수')
axes[0].set_xlabel('')
axes[0].set_ylabel('운영일수')
axes[0].set_xticklabels(operating_days.columns, rotation=0)

# 막대 위에 숫자 표시
for bar in bars_2016.patches:
    axes[0].text(bar.get_x() + bar.get_width() / 2, bar.get_height(),
                  int(bar.get_height()), ha='center', va='bottom')

# 2017년 운영일수 시각화
bars_2017 = operating_days.loc[2017].plot(kind='bar', ax=axes[1], color='purple')
axes[1].set_title('2017년 월별 매장 운영일수')
axes[1].set_xlabel('')
axes[1].set_ylabel('운영일수')
axes[1].set_xticklabels(operating_days.columns, rotation=0)

# 막대 위에 숫자 표시
for bar in bars_2017.patches:
    axes[1].text(bar.get_x() + bar.get_width() / 2, bar.get_height(),
                  int(bar.get_height()), ha='center', va='bottom')

# 레이아웃 조정
plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py5_files/py5_39_0.png)
    


- 성수기 비수기 차이가아니라 일을안한게 문제였다


```python
for i in range(1, 13):
    mask111 = df[(df['Year'].isin([2016])) & (df['Month'].isin([i]))]
    print(f"2016년 {i}월 매장운영일 : {mask111['Day'].unique()}")

for i in range(1, 13):
    mask111 = df[(df['Year'].isin([2017])) & (df['Month'].isin([i]))]
    print(f"2017년 {i}월 매장운영일 : {mask111['Day'].unique()}")
```

    2016년 1월 매장운영일 : [11 12]
    2016년 2월 매장운영일 : [11 12]
    2016년 3월 매장운영일 : [11 12]
    2016년 4월 매장운영일 : [11 12]
    2016년 5월 매장운영일 : [11 12]
    2016년 6월 매장운영일 : [11 12]
    2016년 7월 매장운영일 : [11 12]
    2016년 8월 매장운영일 : [11 12]
    2016년 9월 매장운영일 : [11 12]
    2016년 10월 매장운영일 : [30 31 11 12]
    2016년 11월 매장운영일 : [11 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 12]
    2016년 12월 매장운영일 : [11 12 13 14 15 16 17 18 19 20 21 22 23 24 27 28 29 30 31]
    2017년 1월 매장운영일 : [ 1 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31  2  3  4]
    2017년 2월 매장운영일 : [ 2 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28  3  4]
    2017년 3월 매장운영일 : [ 1  2  3 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31  4]
    2017년 4월 매장운영일 : [1 2 3 4]
    2017년 5월 매장운영일 : [1 2 3 4]
    2017년 6월 매장운영일 : [1 2 3 4]
    2017년 7월 매장운영일 : [1 2 3 4]
    2017년 8월 매장운영일 : [1 2 3 4]
    2017년 9월 매장운영일 : [1 2 3 4]
    2017년 10월 매장운영일 : [1 2 3]
    2017년 11월 매장운영일 : [1 2 3]
    2017년 12월 매장운영일 : [1 2 3]
    


```python
# 년도별 월별 매장운영일수 대비 판매수 확인

# 판매수 집계
monthly_sales = df.groupby(['Year', 'Month']).size().unstack(fill_value=0)

# 운영일수 집계 (중복된 날짜를 제외하기 위해 unique count)
operating_days = df.groupby(['Year', 'Month'])['Day'].nunique().unstack(fill_value=0)

# 월별 하루 평균 판매수 계산
average_sales_per_day = monthly_sales.div(operating_days)

# 서브플롯 생성
fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(12, 6), sharey=True)

# 2016년 월별 판매수 대비 운영일수 시각화
average_sales_per_day.loc[2016].plot(kind='bar', ax=axes[0], color='skyblue')
axes[0].set_title('2016년 월별 하루 평균 판매수')
axes[0].set_xlabel('')
axes[0].set_ylabel('하루 평균 판매수')
axes[0].set_xticklabels(average_sales_per_day.columns, rotation=0)

# 막대 위에 숫자 표시
for bar in axes[0].patches:
    axes[0].text(bar.get_x() + bar.get_width() / 2, bar.get_height(),
                  f'{bar.get_height():.0f}', ha='center', va='bottom')

# 2017년 월별 판매수 대비 운영일수 시각화
average_sales_per_day.loc[2017].plot(kind='bar', ax=axes[1], color='skyblue')
axes[1].set_title('2017년 월별 하루 평균 판매수')
axes[1].set_xlabel('')
axes[1].set_ylabel('하루 평균 판매수')
axes[1].set_xticklabels(average_sales_per_day.columns, rotation=0)

# 막대 위에 숫자 표시
for bar in axes[1].patches:
    axes[1].text(bar.get_x() + bar.get_width() / 2, bar.get_height(),
                  f'{bar.get_height():.0f}', ha='center', va='bottom')

# 레이아웃 조정
plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py5_files/py5_42_0.png)
    


- 평균적으로 월별 하루 판매수는 100개 이상이고, 일부 달에는 평균보다 2배이상 판매를 하고있지만 대부분의 매장운영일수가 월별 4일 이하로 데이터가 부족하다
- 현재 데이터상으로는 하루 판매수를 일정하다고 간주할 수 있다


```python
df['Daypart'].unique()
```




    array(['Morning', 'Afternoon', 'Evening', 'Night'], dtype=object)




```python
# 시간대별 판매수 확인

# 판매수 집계
daypart_sales = df['Daypart'].value_counts()

# 시각화
plt.figure(figsize=(8, 5))
daypart_sales.plot(kind='bar', color='skyblue')
plt.title('Daypart별 판매수')
plt.xlabel('Daypart')
plt.ylabel('판매수')
plt.xticks(rotation=0)

# 막대 위에 숫자 표시
for index, value in enumerate(daypart_sales):
    plt.text(index, value, str(value), ha='center', va='bottom')

# 그래프 표시
plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py5_files/py5_45_0.png)
    


- 아침과 오후에 판매량이 압도적으로 많다


```python
# 시간대별 매장운영일수 확인

# 운영일수 집계 (Daypart별로 Year, Month, Day가 중복되지 않도록)
operating_days = df.groupby(['Daypart', 'Year', 'Month', 'Day']).size().reset_index(name='Count')

# Daypart별 운영일수 계산
total_operating_days = operating_days.groupby('Daypart').size().reset_index(name='Operating Days')

# 시각화
plt.figure(figsize=(10, 6))
plt.bar(total_operating_days['Daypart'], total_operating_days['Operating Days'], color='skyblue')
plt.title('Daypart별 매장 운영일수 (2016-2017년)')
plt.xlabel('Daypart')
plt.ylabel('운영일수')

# 막대 위에 숫자 표시
for index, value in enumerate(total_operating_days['Operating Days']):
    plt.text(index, value, str(value), ha='center', va='bottom')

# 그래프 표시
plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py5_files/py5_47_0.png)
    



```python
# 2년동안 몇일 일했나?

unique_days = df[['Year', 'Month', 'Day']].drop_duplicates()
total_operating_days = unique_days.shape[0]
print(f'총 매장 운영일수: {total_operating_days}일')
```

    총 매장 운영일수: 159일
    

- 약 2년동안 단 159일만 장사를 진행하였고, 오전과 오후는 하루제외하고 전부 장사했다
- 매장운영중 절반이상은 저녁까지 장사를 진행하였고, 늦은저녁에는 거의 장사를 하지않았다


```python
# 시간대별 일평균 판매수

# 판매수 집계 (Daypart별)
daypart_sales = df['Daypart'].value_counts().reset_index(name='Total Sales').rename(columns={'index': 'Daypart'})

# 운영일수 집계 (Daypart별로 Year, Month, Day가 중복되지 않도록)
operating_days = df.groupby(['Daypart', 'Year', 'Month', 'Day']).size().reset_index(name='Count')

# Daypart별 운영일수 계산
total_operating_days = operating_days.groupby('Daypart').size().reset_index(name='Operating Days')

# 일평균 판매수 계산
average_sales_per_daypart = daypart_sales.merge(total_operating_days, on='Daypart')
average_sales_per_daypart['Average Sales'] = average_sales_per_daypart['Total Sales'] / average_sales_per_daypart['Operating Days']

# 시각화
plt.figure(figsize=(10, 6))
plt.bar(average_sales_per_daypart['Daypart'], average_sales_per_daypart['Average Sales'], color='skyblue')
plt.title('Daypart별 일평균 판매수 (2016-2017년)')
plt.xlabel('Daypart')
plt.ylabel('일평균 판매수')

# 막대 위에 숫자 표시
for index, value in enumerate(average_sales_per_daypart['Average Sales']):
    plt.text(index, value, f'{value:.0f}', ha='center', va='bottom')

# 그래프 표시
plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py5_files/py5_50_0.png)
    


 - 하루 중 대부분의 판매는 오전과 오후에 거래가 됐고, 그 이후는 현저하게 판매량이 적었다
 - 매장 운영일수 대비 저녁장사는 소득이 적었다


```python
# 월별 상위 10개 아이템 판매수 확인

# 월별 아이템 판매 수 집계
monthly_sales = df.groupby(['Month', 'Items']).size().reset_index(name='Quantity')

# 월별 상위 10개 아이템 추출
top_items = monthly_sales.groupby('Month').apply(lambda x: x.nlargest(10, 'Quantity')).reset_index(drop=True)

# 시각화
plt.figure(figsize=(20, 6))
colors = sns.color_palette('Paired')

# 각 월별로 상위 10개 아이템 시각화
for i in range(1, 13):  # 1부터 12까지 반복
    plt.subplot(2, 6, i)
    pr = top_items[top_items['Month'] == i]

    ax = sns.barplot(data=pr, x='Quantity', y='Items', palette=colors)

    for container in ax.containers:
        ax.bar_label(container)

    plt.xlabel('')
    plt.ylabel('')
    plt.title(f'{i}월 상위 10개 아이템 판매수', size=15)
    ax.spines[['top','right']].set_visible(False)

# 그래프 레이아웃 조정
plt.tight_layout()
plt.show()
```

    /usr/local/lib/python3.10/dist-packages/ipykernel/ipkernel.py:283: DeprecationWarning: `should_run_async` will not call `transform_cell` automatically in the future. Please pass the result to `transformed_cell` argument and any exception that happen during thetransform in `preprocessing_exc_tuple` in IPython 7.17 and above.
      and should_run_async(code)
    


    
![png](/assets/img/py5_files/py5_52_1.png)
    


- 커피, 빵(bread), 차는 월별 고정 Top 3로 관찰됨
- 케이크, 페이스트리, 샌드위치, 브라우니가 Top 4~6에서 주로 관찰됨
- 메디아루나와 핫초코가 겨울에 어느정도 매출성과를 내고있음


```python
# 요일별 일평균 판매수

# 요일별 운영일수 집계
operating_days = df.groupby('DayOfWeek')['Day'].nunique().reset_index(name='Operating Days')

# 요일별 판매수 집계
sales_per_day = df.groupby('DayOfWeek')['Items'].count().reset_index(name='Total Sales')

# 데이터 병합
weekly_data = operating_days.merge(sales_per_day, on='DayOfWeek')

# 요일별 일평균 판매수 계산 및 반올림
weekly_data['Average Sales'] = (weekly_data['Total Sales'] / weekly_data['Operating Days']).round().astype(int)

# 요일 순서 설정
day_order = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
weekly_data['DayOfWeek'] = pd.Categorical(weekly_data['DayOfWeek'], categories=day_order, ordered=True)

# 시각화
plt.figure(figsize=(12, 6))
ax = sns.barplot(data=weekly_data, x='DayOfWeek', y='Average Sales', color='skyblue')

# 그래프 위에 숫자 표시
for container in ax.containers:
    ax.bar_label(container)

# 그래프 설정
plt.xlabel('')
plt.ylabel('')
plt.title('요일별 일평균 판매수', size=15)

# 그래프 레이아웃 조정
plt.xticks(rotation=0)
plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py5_files/py5_54_0.png)
    


- 전반적으로 고르게 판매되고 있으며, 주말이 조금더 많은 판매를 하고있는것으로 관찰됨

## 연관분석 (Apriori 알고리즘)


```python
# 최소지지도
df.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 18887 entries, 0 to 18886
    Data columns (total 9 columns):
     #   Column         Non-Null Count  Dtype 
    ---  ------         --------------  ----- 
     0   TransactionNo  18887 non-null  int64 
     1   Items          18887 non-null  object
     2   Daypart        18887 non-null  object
     3   DayType        18887 non-null  object
     4   Year           18887 non-null  int32 
     5   Month          18887 non-null  int32 
     6   Day            18887 non-null  int32 
     7   DayOfWeek      18887 non-null  object
     8   Hour           18887 non-null  int32 
    dtypes: int32(4), int64(1), object(4)
    memory usage: 1.0+ MB
    


```python
from mlxtend.frequent_patterns import apriori, association_rules

# 거래번호에 따라 아이템을 묶기
basket = df.groupby(['TransactionNo', 'Items'])['Items'].count().unstack().reset_index().fillna(0).set_index('TransactionNo')
basket = basket.applymap(lambda x: 1 if x > 0 else 0)  # 1은 아이템이 존재함을 나타내고, 0은 존재하지 않음을 나타냄

# Apriori 알고리즘 수행 (최소 지지도 : 0.025, 최소 향상도 1)
frequent_itemsets = apriori(basket, min_support=0.025, use_colnames=True)
rules = association_rules(frequent_itemsets, metric="lift", min_threshold=1)

# 결과를 Lift 기준으로 정렬
rules = rules.sort_values(by='lift', ascending=False)

# 소수점 둘째 자리까지 포맷팅
rules['support'] = rules['support'].round(2)
rules['confidence'] = rules['confidence'].round(2)
rules['lift'] = rules['lift'].round(2)

# 결과 출력
print("Frequent Itemsets:")
frequent_itemsets
```

    /usr/local/lib/python3.10/dist-packages/ipykernel/ipkernel.py:283: DeprecationWarning: `should_run_async` will not call `transform_cell` automatically in the future. Please pass the result to `transformed_cell` argument and any exception that happen during thetransform in `preprocessing_exc_tuple` in IPython 7.17 and above.
      and should_run_async(code)
    

    Frequent Itemsets:
    

    /usr/local/lib/python3.10/dist-packages/mlxtend/frequent_patterns/fpcommon.py:109: DeprecationWarning: DataFrames with non-bool types result in worse computationalperformance and their support might be discontinued in the future.Please use a DataFrame with bool type
      warnings.warn(
    





  <div id="df-b6924c7c-a137-4461-a844-7ca52db8c6eb" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>support</th>
      <th>itemsets</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.036344</td>
      <td>(Alfajores)</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.327205</td>
      <td>(Bread)</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.040042</td>
      <td>(Brownie)</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.103856</td>
      <td>(Cake)</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.478394</td>
      <td>(Coffee)</td>
    </tr>
    <tr>
      <th>5</th>
      <td>0.054411</td>
      <td>(Cookies)</td>
    </tr>
    <tr>
      <th>6</th>
      <td>0.039197</td>
      <td>(Farm House)</td>
    </tr>
    <tr>
      <th>7</th>
      <td>0.058320</td>
      <td>(Hot chocolate)</td>
    </tr>
    <tr>
      <th>8</th>
      <td>0.038563</td>
      <td>(Juice)</td>
    </tr>
    <tr>
      <th>9</th>
      <td>0.061807</td>
      <td>(Medialuna)</td>
    </tr>
    <tr>
      <th>10</th>
      <td>0.038457</td>
      <td>(Muffin)</td>
    </tr>
    <tr>
      <th>11</th>
      <td>0.086107</td>
      <td>(Pastry)</td>
    </tr>
    <tr>
      <th>12</th>
      <td>0.071844</td>
      <td>(Sandwich)</td>
    </tr>
    <tr>
      <th>13</th>
      <td>0.029054</td>
      <td>(Scandinavian)</td>
    </tr>
    <tr>
      <th>14</th>
      <td>0.034548</td>
      <td>(Scone)</td>
    </tr>
    <tr>
      <th>15</th>
      <td>0.034443</td>
      <td>(Soup)</td>
    </tr>
    <tr>
      <th>16</th>
      <td>0.142631</td>
      <td>(Tea)</td>
    </tr>
    <tr>
      <th>17</th>
      <td>0.033597</td>
      <td>(Toast)</td>
    </tr>
    <tr>
      <th>18</th>
      <td>0.090016</td>
      <td>(Coffee, Bread)</td>
    </tr>
    <tr>
      <th>19</th>
      <td>0.029160</td>
      <td>(Bread, Pastry)</td>
    </tr>
    <tr>
      <th>20</th>
      <td>0.028104</td>
      <td>(Tea, Bread)</td>
    </tr>
    <tr>
      <th>21</th>
      <td>0.054728</td>
      <td>(Cake, Coffee)</td>
    </tr>
    <tr>
      <th>22</th>
      <td>0.028209</td>
      <td>(Coffee, Cookies)</td>
    </tr>
    <tr>
      <th>23</th>
      <td>0.029583</td>
      <td>(Hot chocolate, Coffee)</td>
    </tr>
    <tr>
      <th>24</th>
      <td>0.035182</td>
      <td>(Coffee, Medialuna)</td>
    </tr>
    <tr>
      <th>25</th>
      <td>0.047544</td>
      <td>(Coffee, Pastry)</td>
    </tr>
    <tr>
      <th>26</th>
      <td>0.038246</td>
      <td>(Coffee, Sandwich)</td>
    </tr>
    <tr>
      <th>27</th>
      <td>0.049868</td>
      <td>(Coffee, Tea)</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-b6924c7c-a137-4461-a844-7ca52db8c6eb')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-b6924c7c-a137-4461-a844-7ca52db8c6eb button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-b6924c7c-a137-4461-a844-7ca52db8c6eb');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-7fe62a05-057d-4aa0-b148-26e449386336">
  <button class="colab-df-quickchart" onclick="quickchart('df-7fe62a05-057d-4aa0-b148-26e449386336')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-7fe62a05-057d-4aa0-b148-26e449386336 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_a03b442e-f84f-4d57-b87e-627522af6bb7">
    <style>
      .colab-df-generate {
        background-color: #E8F0FE;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        display: none;
        fill: #1967D2;
        height: 32px;
        padding: 0 0 0 0;
        width: 32px;
      }

      .colab-df-generate:hover {
        background-color: #E2EBFA;
        box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
        fill: #174EA6;
      }

      [theme=dark] .colab-df-generate {
        background-color: #3B4455;
        fill: #D2E3FC;
      }

      [theme=dark] .colab-df-generate:hover {
        background-color: #434B5C;
        box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
        filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
        fill: #FFFFFF;
      }
    </style>
    <button class="colab-df-generate" onclick="generateWithVariable('frequent_itemsets')"
            title="Generate code using this dataframe."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
       width="24px">
    <path d="M7,19H8.4L18.45,9,17,7.55,7,17.6ZM5,21V16.75L18.45,3.32a2,2,0,0,1,2.83,0l1.4,1.43a1.91,1.91,0,0,1,.58,1.4,1.91,1.91,0,0,1-.58,1.4L9.25,21ZM18.45,9,17,7.55Zm-12,3A5.31,5.31,0,0,0,4.9,8.1,5.31,5.31,0,0,0,1,6.5,5.31,5.31,0,0,0,4.9,4.9,5.31,5.31,0,0,0,6.5,1,5.31,5.31,0,0,0,8.1,4.9,5.31,5.31,0,0,0,12,6.5,5.46,5.46,0,0,0,6.5,12Z"/>
  </svg>
    </button>
    <script>
      (() => {
      const buttonEl =
        document.querySelector('#id_a03b442e-f84f-4d57-b87e-627522af6bb7 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('frequent_itemsets');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
print("\nAssociation Rules:")
rules
```

    
    Association Rules:
    

    /usr/local/lib/python3.10/dist-packages/ipykernel/ipkernel.py:283: DeprecationWarning: `should_run_async` will not call `transform_cell` automatically in the future. Please pass the result to `transformed_cell` argument and any exception that happen during thetransform in `preprocessing_exc_tuple` in IPython 7.17 and above.
      and should_run_async(code)
    





  <div id="df-79e8d3e4-0284-4a6e-9653-060c8f772b6d" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>antecedents</th>
      <th>consequents</th>
      <th>antecedent support</th>
      <th>consequent support</th>
      <th>support</th>
      <th>confidence</th>
      <th>lift</th>
      <th>leverage</th>
      <th>conviction</th>
      <th>zhangs_metric</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>8</th>
      <td>(Coffee)</td>
      <td>(Medialuna)</td>
      <td>0.478394</td>
      <td>0.061807</td>
      <td>0.04</td>
      <td>0.07</td>
      <td>1.19</td>
      <td>0.005614</td>
      <td>1.012667</td>
      <td>0.305936</td>
    </tr>
    <tr>
      <th>9</th>
      <td>(Medialuna)</td>
      <td>(Coffee)</td>
      <td>0.061807</td>
      <td>0.478394</td>
      <td>0.04</td>
      <td>0.57</td>
      <td>1.19</td>
      <td>0.005614</td>
      <td>1.210871</td>
      <td>0.170091</td>
    </tr>
    <tr>
      <th>10</th>
      <td>(Coffee)</td>
      <td>(Pastry)</td>
      <td>0.478394</td>
      <td>0.086107</td>
      <td>0.05</td>
      <td>0.10</td>
      <td>1.15</td>
      <td>0.006351</td>
      <td>1.014740</td>
      <td>0.256084</td>
    </tr>
    <tr>
      <th>11</th>
      <td>(Pastry)</td>
      <td>(Coffee)</td>
      <td>0.086107</td>
      <td>0.478394</td>
      <td>0.05</td>
      <td>0.55</td>
      <td>1.15</td>
      <td>0.006351</td>
      <td>1.164682</td>
      <td>0.146161</td>
    </tr>
    <tr>
      <th>12</th>
      <td>(Coffee)</td>
      <td>(Sandwich)</td>
      <td>0.478394</td>
      <td>0.071844</td>
      <td>0.04</td>
      <td>0.08</td>
      <td>1.11</td>
      <td>0.003877</td>
      <td>1.008807</td>
      <td>0.194321</td>
    </tr>
    <tr>
      <th>13</th>
      <td>(Sandwich)</td>
      <td>(Coffee)</td>
      <td>0.071844</td>
      <td>0.478394</td>
      <td>0.04</td>
      <td>0.53</td>
      <td>1.11</td>
      <td>0.003877</td>
      <td>1.115384</td>
      <td>0.109205</td>
    </tr>
    <tr>
      <th>2</th>
      <td>(Cake)</td>
      <td>(Coffee)</td>
      <td>0.103856</td>
      <td>0.478394</td>
      <td>0.05</td>
      <td>0.53</td>
      <td>1.10</td>
      <td>0.005044</td>
      <td>1.102664</td>
      <td>0.102840</td>
    </tr>
    <tr>
      <th>3</th>
      <td>(Coffee)</td>
      <td>(Cake)</td>
      <td>0.478394</td>
      <td>0.103856</td>
      <td>0.05</td>
      <td>0.11</td>
      <td>1.10</td>
      <td>0.005044</td>
      <td>1.011905</td>
      <td>0.176684</td>
    </tr>
    <tr>
      <th>4</th>
      <td>(Coffee)</td>
      <td>(Cookies)</td>
      <td>0.478394</td>
      <td>0.054411</td>
      <td>0.03</td>
      <td>0.06</td>
      <td>1.08</td>
      <td>0.002179</td>
      <td>1.004841</td>
      <td>0.148110</td>
    </tr>
    <tr>
      <th>5</th>
      <td>(Cookies)</td>
      <td>(Coffee)</td>
      <td>0.054411</td>
      <td>0.478394</td>
      <td>0.03</td>
      <td>0.52</td>
      <td>1.08</td>
      <td>0.002179</td>
      <td>1.083174</td>
      <td>0.081700</td>
    </tr>
    <tr>
      <th>6</th>
      <td>(Hot chocolate)</td>
      <td>(Coffee)</td>
      <td>0.058320</td>
      <td>0.478394</td>
      <td>0.03</td>
      <td>0.51</td>
      <td>1.06</td>
      <td>0.001683</td>
      <td>1.058553</td>
      <td>0.060403</td>
    </tr>
    <tr>
      <th>7</th>
      <td>(Coffee)</td>
      <td>(Hot chocolate)</td>
      <td>0.478394</td>
      <td>0.058320</td>
      <td>0.03</td>
      <td>0.06</td>
      <td>1.06</td>
      <td>0.001683</td>
      <td>1.003749</td>
      <td>0.109048</td>
    </tr>
    <tr>
      <th>0</th>
      <td>(Bread)</td>
      <td>(Pastry)</td>
      <td>0.327205</td>
      <td>0.086107</td>
      <td>0.03</td>
      <td>0.09</td>
      <td>1.03</td>
      <td>0.000985</td>
      <td>1.003306</td>
      <td>0.050231</td>
    </tr>
    <tr>
      <th>1</th>
      <td>(Pastry)</td>
      <td>(Bread)</td>
      <td>0.086107</td>
      <td>0.327205</td>
      <td>0.03</td>
      <td>0.34</td>
      <td>1.03</td>
      <td>0.000985</td>
      <td>1.017305</td>
      <td>0.036980</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-79e8d3e4-0284-4a6e-9653-060c8f772b6d')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-79e8d3e4-0284-4a6e-9653-060c8f772b6d button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-79e8d3e4-0284-4a6e-9653-060c8f772b6d');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-cb32d83f-4732-47aa-9c29-9540d833c4d5">
  <button class="colab-df-quickchart" onclick="quickchart('df-cb32d83f-4732-47aa-9c29-9540d833c4d5')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-cb32d83f-4732-47aa-9c29-9540d833c4d5 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_a07f67e9-9466-40c2-9bcd-520d4a9127c7">
    <style>
      .colab-df-generate {
        background-color: #E8F0FE;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        display: none;
        fill: #1967D2;
        height: 32px;
        padding: 0 0 0 0;
        width: 32px;
      }

      .colab-df-generate:hover {
        background-color: #E2EBFA;
        box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
        fill: #174EA6;
      }

      [theme=dark] .colab-df-generate {
        background-color: #3B4455;
        fill: #D2E3FC;
      }

      [theme=dark] .colab-df-generate:hover {
        background-color: #434B5C;
        box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
        filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
        fill: #FFFFFF;
      }
    </style>
    <button class="colab-df-generate" onclick="generateWithVariable('rules')"
            title="Generate code using this dataframe."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
       width="24px">
    <path d="M7,19H8.4L18.45,9,17,7.55,7,17.6ZM5,21V16.75L18.45,3.32a2,2,0,0,1,2.83,0l1.4,1.43a1.91,1.91,0,0,1,.58,1.4,1.91,1.91,0,0,1-.58,1.4L9.25,21ZM18.45,9,17,7.55Zm-12,3A5.31,5.31,0,0,0,4.9,8.1,5.31,5.31,0,0,0,1,6.5,5.31,5.31,0,0,0,4.9,4.9,5.31,5.31,0,0,0,6.5,1,5.31,5.31,0,0,0,8.1,4.9,5.31,5.31,0,0,0,12,6.5,5.46,5.46,0,0,0,6.5,12Z"/>
  </svg>
    </button>
    <script>
      (() => {
      const buttonEl =
        document.querySelector('#id_a07f67e9-9466-40c2-9bcd-520d4a9127c7 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('rules');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
selected_rules = rules[['antecedents', 'consequents', 'support', 'confidence', 'lift']]
selected_rules['support'] = selected_rules['support'].round(2)
selected_rules['confidence'] = selected_rules['confidence'].round(2)
selected_rules['lift'] = selected_rules['lift'].round(2)
selected_rules.sort_values(by='lift', ascending=False)
```

    /usr/local/lib/python3.10/dist-packages/ipykernel/ipkernel.py:283: DeprecationWarning: `should_run_async` will not call `transform_cell` automatically in the future. Please pass the result to `transformed_cell` argument and any exception that happen during thetransform in `preprocessing_exc_tuple` in IPython 7.17 and above.
      and should_run_async(code)
    





  <div id="df-5916ab96-79c8-427e-b2b3-9ec3905099bd" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>antecedents</th>
      <th>consequents</th>
      <th>support</th>
      <th>confidence</th>
      <th>lift</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>8</th>
      <td>(Coffee)</td>
      <td>(Medialuna)</td>
      <td>0.04</td>
      <td>0.07</td>
      <td>1.19</td>
    </tr>
    <tr>
      <th>9</th>
      <td>(Medialuna)</td>
      <td>(Coffee)</td>
      <td>0.04</td>
      <td>0.57</td>
      <td>1.19</td>
    </tr>
    <tr>
      <th>10</th>
      <td>(Coffee)</td>
      <td>(Pastry)</td>
      <td>0.05</td>
      <td>0.10</td>
      <td>1.15</td>
    </tr>
    <tr>
      <th>11</th>
      <td>(Pastry)</td>
      <td>(Coffee)</td>
      <td>0.05</td>
      <td>0.55</td>
      <td>1.15</td>
    </tr>
    <tr>
      <th>12</th>
      <td>(Coffee)</td>
      <td>(Sandwich)</td>
      <td>0.04</td>
      <td>0.08</td>
      <td>1.11</td>
    </tr>
    <tr>
      <th>13</th>
      <td>(Sandwich)</td>
      <td>(Coffee)</td>
      <td>0.04</td>
      <td>0.53</td>
      <td>1.11</td>
    </tr>
    <tr>
      <th>2</th>
      <td>(Cake)</td>
      <td>(Coffee)</td>
      <td>0.05</td>
      <td>0.53</td>
      <td>1.10</td>
    </tr>
    <tr>
      <th>3</th>
      <td>(Coffee)</td>
      <td>(Cake)</td>
      <td>0.05</td>
      <td>0.11</td>
      <td>1.10</td>
    </tr>
    <tr>
      <th>4</th>
      <td>(Coffee)</td>
      <td>(Cookies)</td>
      <td>0.03</td>
      <td>0.06</td>
      <td>1.08</td>
    </tr>
    <tr>
      <th>5</th>
      <td>(Cookies)</td>
      <td>(Coffee)</td>
      <td>0.03</td>
      <td>0.52</td>
      <td>1.08</td>
    </tr>
    <tr>
      <th>6</th>
      <td>(Hot chocolate)</td>
      <td>(Coffee)</td>
      <td>0.03</td>
      <td>0.51</td>
      <td>1.06</td>
    </tr>
    <tr>
      <th>7</th>
      <td>(Coffee)</td>
      <td>(Hot chocolate)</td>
      <td>0.03</td>
      <td>0.06</td>
      <td>1.06</td>
    </tr>
    <tr>
      <th>0</th>
      <td>(Bread)</td>
      <td>(Pastry)</td>
      <td>0.03</td>
      <td>0.09</td>
      <td>1.03</td>
    </tr>
    <tr>
      <th>1</th>
      <td>(Pastry)</td>
      <td>(Bread)</td>
      <td>0.03</td>
      <td>0.34</td>
      <td>1.03</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-5916ab96-79c8-427e-b2b3-9ec3905099bd')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-5916ab96-79c8-427e-b2b3-9ec3905099bd button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-5916ab96-79c8-427e-b2b3-9ec3905099bd');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-f749558a-3b46-46fb-80c9-3e519b1bbf4d">
  <button class="colab-df-quickchart" onclick="quickchart('df-f749558a-3b46-46fb-80c9-3e519b1bbf4d')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-f749558a-3b46-46fb-80c9-3e519b1bbf4d button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




- 빵이나 디저트를 구매하는 고객 2명 중 1명은 커피를 함께 구매한다
- 커피와 자주 구매되는 품목들(메디아루나, 페이스트리, 케이크 등)을 세트로 판매하는 방안을 검토해본다


```python
# 네트워크그래프 시각화
import networkx as nx
from mlxtend.frequent_patterns import apriori, association_rules

# 거래번호에 따라 아이템을 묶기
basket = df.groupby(['TransactionNo', 'Items'])['Items'].count().unstack().reset_index().fillna(0).set_index('TransactionNo')
basket = basket.applymap(lambda x: 1 if x > 0 else 0)

# Apriori 알고리즘 수행 (최소 지지도 : 0.025, 최소 향상도 1)
frequent_itemsets = apriori(basket, min_support=0.025, use_colnames=True)
rules = association_rules(frequent_itemsets, metric="lift", min_threshold=1)

# 네트워크 그래프 생성
G = nx.DiGraph()

# 노드와 엣지 추가
for _, rule in rules.iterrows():
    G.add_node(rule['antecedents'], label=', '.join(rule['antecedents']))
    G.add_node(rule['consequents'], label=', '.join(rule['consequents']))
    G.add_edge(rule['antecedents'], rule['consequents'], weight=rule['lift'], lift=rule['lift'])

# 노드 레이블 설정
labels = {node: G.nodes[node]['label'] for node in G.nodes()}

# 그래프 시각화
plt.figure(figsize=(12, 8))
pos = nx.spring_layout(G)  # 위치 설정
edges = G.edges(data=True)

# 엣지 그리기
nx.draw_networkx_edges(G, pos, edgelist=edges, width=[edge[2]['weight'] for edge in edges], alpha=0.5)

# 노드 그리기 (연한 갈색으로 설정)
nx.draw_networkx_nodes(G, pos, node_size=2000, node_color='salmon')

# 노드 레이블 그리기
nx.draw_networkx_labels(G, pos, labels, font_size=10)

# 엣지 위에 Lift 값 표시
edge_labels = {(rule['antecedents'], rule['consequents']): f"{rule['lift']:.2f}" for _, rule in rules.iterrows()}
nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_color='black')

# 그래프 제목
plt.title('네트워크그래프', size=15)
plt.axis('off')  # 축 숨기기
plt.show()
```

    /usr/local/lib/python3.10/dist-packages/ipykernel/ipkernel.py:283: DeprecationWarning: `should_run_async` will not call `transform_cell` automatically in the future. Please pass the result to `transformed_cell` argument and any exception that happen during thetransform in `preprocessing_exc_tuple` in IPython 7.17 and above.
      and should_run_async(code)
    /usr/local/lib/python3.10/dist-packages/mlxtend/frequent_patterns/fpcommon.py:109: DeprecationWarning: DataFrames with non-bool types result in worse computationalperformance and their support might be discontinued in the future.Please use a DataFrame with bool type
      warnings.warn(
    


    
![png](/assets/img/py5_files/py5_62_1.png)
    


- 커피는 다른 아이템들과 연관성이 뚜렷하게 높은것으로 관찰됨. 다른아이템들과 함께 자주 구매되고 있음
- 커피를 구매하는 고객이 빵(bread) 또는 페이스트리를 구매하는 경향이 관찰됨
