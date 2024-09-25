---
#layout: post
title: 파이썬 데이터분석 데이터시각화 실습
date: 2024-09-26
description: # 검색어 및 글요약
categories: [Data_analysis, Python_DA_Library]        # 메인 카테고리, 하위 카테고리(생략가능)
tags:           # 반드시 소문자로 작성, 한글가능
- Python
- Data_analysis
#pin: true # 해당글을 홈에서 고정시킬지
#toc: false # 오른쪽 목차 설정
#comments: false # 댓글 설정

#image: # 미리보기 이미지 설정
#  path: /path/to/image # 경로
#  alt: image alternative text # 이미지 설명 (생략가능)

#mermaid: true # 다이어그램 생성 도구 (https://github.com/mermaid-js/mermaid)
#math : true # 수학도구
---

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

## 분석주제 : 회사의 매출 개선을 위한 고객의 구매 패턴 분석
- 고객의 사용 패턴을 분석하여 고객을 그룹화하고, 각 그룹에 맞는 마케팅 전략 수립
- 수립된 마케팅 전략을 통해 회사의 매출 증대 및 고객 만족도 제고


## **데이터 준비하기**
---

> **데이터 준비하기**

- 데이터 출처: [Kaggle](https://www.kaggle.com/datasets/arjunbhasin2013/ccdata/data) `Credit Card Dataset`

- 데이터 명세

| No. | 표준항목명            | 영문명                           | 설명                                     | 표현형식/단위 | 예시   |
| --- | --------------------- | -------------------------------- | ---------------------------------------- | ------------- | ------ |
| 1   | 고객 ID               | CUST_ID                          | 고객을 식별하기 위한 고유 ID             | -             | C10001 |
| 2   | 잔액                  | BALANCE                          | 신용카드 계좌의 현재 잔액                | N             | 40.9   |
| 3   | 잔액 업데이트 빈도    | BALANCE_FREQUENCY                | 잔액이 업데이트 되는 빈도                | N             | 0.818  |
| 4   | 총 구매액             | PURCHASES                        | 신용카드로 이루어진 총 구매액            | N             | 95.4   |
| 5   | 일회성 구매액         | ONEOFF_PURCHASES                 | 일회성으로 이루어진 구매액               | N             | 0.0    |
| 6   | 할부 구매액           | INSTALLMENTS_PURCHASES           | 할부로 이루어진 구매액                   | N             | 95.4   |
| 7   | 현금 서비스 금액      | CASH_ADVANCE                     | 현금 서비스로 인출한 금액                | N             | 0.0    |
| 8   | 구매 빈도             | PURCHASES_FREQUENCY              | 구매가 이루어진 빈도                     | N             | 0.167  |
| 9   | 일회성 구매 빈도      | ONEOFF_PURCHASES_FREQUENCY       | 일회성 구매가 이루어진 빈도              | N             | 0.0    |
| 10  | 할부 구매 빈도        | PURCHASES_INSTALLMENTS_FREQUENCY | 할부 구매가 이루어진 빈도                | N             | 0.083  |
| 11  | 현금 서비스 빈도      | CASH_ADVANCE_FREQUENCY           | 현금 서비스가 이루어진 빈도              | N             | 0.0    |
| 12  | 현금 서비스 거래 횟수 | CASH_ADVANCE_TRX                 | 현금 서비스 거래의 횟수                  | N             | 0      |
| 13  | 구매 횟수             | PURCHASES_TRX                    | 총 구매 거래의 횟수                      | N             | 2      |
| 14  | 신용 한도             | CREDIT_LIMIT                     | 신용카드의 신용 한도                     | N             | 1000.0 |
| 15  | 지불액                | PAYMENTS                         | 신용카드 계좌에 지불한 총 금액           | N             | 201.8  |
| 16  | 최소 지불액           | MINIMUM_PAYMENTS                 | 신용카드 계좌의 최소 지불액              | N             | 139.5  |
| 17  | 전액 지불 비율        | PRC_FULL_PAYMENT                 | 신용카드 결제 금액 중 전액을 지불한 비율 | N             | 0.0    |
| 18  | 카드 소지 기간        | TENURE                           | 신용카드 계좌를 소지한 기간 (월)         | N             | 12     |



## 데이터 전처리


```python
# 데이터 불러오기
data = pd.read_csv("/content/drive/MyDrive/CC GENERAL.csv")
data
```





  <div id="df-326f6e12-3f2c-4081-9de6-c57c7218ee7b" class="colab-df-container">
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
      <th>CUST_ID</th>
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>C10001</td>
      <td>40.900749</td>
      <td>0.818182</td>
      <td>95.40</td>
      <td>0.00</td>
      <td>95.40</td>
      <td>0.000000</td>
      <td>0.166667</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0</td>
      <td>2</td>
      <td>1000.0</td>
      <td>201.802084</td>
      <td>139.509787</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>1</th>
      <td>C10002</td>
      <td>3202.467416</td>
      <td>0.909091</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>6442.945483</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.250000</td>
      <td>4</td>
      <td>0</td>
      <td>7000.0</td>
      <td>4103.032597</td>
      <td>1072.340217</td>
      <td>0.222222</td>
      <td>12</td>
    </tr>
    <tr>
      <th>2</th>
      <td>C10003</td>
      <td>2495.148862</td>
      <td>1.000000</td>
      <td>773.17</td>
      <td>773.17</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>12</td>
      <td>7500.0</td>
      <td>622.066742</td>
      <td>627.284787</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>3</th>
      <td>C10004</td>
      <td>1666.670542</td>
      <td>0.636364</td>
      <td>1499.00</td>
      <td>1499.00</td>
      <td>0.00</td>
      <td>205.788017</td>
      <td>0.083333</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>1</td>
      <td>1</td>
      <td>7500.0</td>
      <td>0.000000</td>
      <td>NaN</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>4</th>
      <td>C10005</td>
      <td>817.714335</td>
      <td>1.000000</td>
      <td>16.00</td>
      <td>16.00</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>1</td>
      <td>1200.0</td>
      <td>678.334763</td>
      <td>244.791237</td>
      <td>0.000000</td>
      <td>12</td>
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
      <th>8945</th>
      <td>C19186</td>
      <td>28.493517</td>
      <td>1.000000</td>
      <td>291.12</td>
      <td>0.00</td>
      <td>291.12</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.833333</td>
      <td>0.000000</td>
      <td>0</td>
      <td>6</td>
      <td>1000.0</td>
      <td>325.594462</td>
      <td>48.886365</td>
      <td>0.500000</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8946</th>
      <td>C19187</td>
      <td>19.183215</td>
      <td>1.000000</td>
      <td>300.00</td>
      <td>0.00</td>
      <td>300.00</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.833333</td>
      <td>0.000000</td>
      <td>0</td>
      <td>6</td>
      <td>1000.0</td>
      <td>275.861322</td>
      <td>NaN</td>
      <td>0.000000</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8947</th>
      <td>C19188</td>
      <td>23.398673</td>
      <td>0.833333</td>
      <td>144.40</td>
      <td>0.00</td>
      <td>144.40</td>
      <td>0.000000</td>
      <td>0.833333</td>
      <td>0.000000</td>
      <td>0.666667</td>
      <td>0.000000</td>
      <td>0</td>
      <td>5</td>
      <td>1000.0</td>
      <td>81.270775</td>
      <td>82.418369</td>
      <td>0.250000</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8948</th>
      <td>C19189</td>
      <td>13.457564</td>
      <td>0.833333</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>36.558778</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.166667</td>
      <td>2</td>
      <td>0</td>
      <td>500.0</td>
      <td>52.549959</td>
      <td>55.755628</td>
      <td>0.250000</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8949</th>
      <td>C19190</td>
      <td>372.708075</td>
      <td>0.666667</td>
      <td>1093.25</td>
      <td>1093.25</td>
      <td>0.00</td>
      <td>127.040008</td>
      <td>0.666667</td>
      <td>0.666667</td>
      <td>0.000000</td>
      <td>0.333333</td>
      <td>2</td>
      <td>23</td>
      <td>1200.0</td>
      <td>63.165404</td>
      <td>88.288956</td>
      <td>0.000000</td>
      <td>6</td>
    </tr>
  </tbody>
</table>
<p>8950 rows × 18 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-326f6e12-3f2c-4081-9de6-c57c7218ee7b')"
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
        document.querySelector('#df-326f6e12-3f2c-4081-9de6-c57c7218ee7b button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-326f6e12-3f2c-4081-9de6-c57c7218ee7b');
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


<div id="df-0911f01f-cba6-461e-863b-1e7a58a022f1">
  <button class="colab-df-quickchart" onclick="quickchart('df-0911f01f-cba6-461e-863b-1e7a58a022f1')"
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
        document.querySelector('#df-0911f01f-cba6-461e-863b-1e7a58a022f1 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_ff7792d1-dc0e-4f92-9dc9-5e4819b9eaa5">
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
    <button class="colab-df-generate" onclick="generateWithVariable('data')"
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
        document.querySelector('#id_ff7792d1-dc0e-4f92-9dc9-5e4819b9eaa5 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('data');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 데이터프레임의 기본 정보 확인
data.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 8950 entries, 0 to 8949
    Data columns (total 18 columns):
     #   Column                            Non-Null Count  Dtype  
    ---  ------                            --------------  -----  
     0   CUST_ID                           8950 non-null   object 
     1   BALANCE                           8950 non-null   float64
     2   BALANCE_FREQUENCY                 8950 non-null   float64
     3   PURCHASES                         8950 non-null   float64
     4   ONEOFF_PURCHASES                  8950 non-null   float64
     5   INSTALLMENTS_PURCHASES            8950 non-null   float64
     6   CASH_ADVANCE                      8950 non-null   float64
     7   PURCHASES_FREQUENCY               8950 non-null   float64
     8   ONEOFF_PURCHASES_FREQUENCY        8950 non-null   float64
     9   PURCHASES_INSTALLMENTS_FREQUENCY  8950 non-null   float64
     10  CASH_ADVANCE_FREQUENCY            8950 non-null   float64
     11  CASH_ADVANCE_TRX                  8950 non-null   int64  
     12  PURCHASES_TRX                     8950 non-null   int64  
     13  CREDIT_LIMIT                      8949 non-null   float64
     14  PAYMENTS                          8950 non-null   float64
     15  MINIMUM_PAYMENTS                  8637 non-null   float64
     16  PRC_FULL_PAYMENT                  8950 non-null   float64
     17  TENURE                            8950 non-null   int64  
    dtypes: float64(14), int64(3), object(1)
    memory usage: 1.2+ MB
    


```python
# 각 변수의 기술 통계량 확인
data.describe()
```





  <div id="df-c9dc5124-8cde-4483-ac3f-6cc4d0be3432" class="colab-df-container">
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
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8949.000000</td>
      <td>8950.000000</td>
      <td>8637.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>1564.474828</td>
      <td>0.877271</td>
      <td>1003.204834</td>
      <td>592.437371</td>
      <td>411.067645</td>
      <td>978.871112</td>
      <td>0.490351</td>
      <td>0.202458</td>
      <td>0.364437</td>
      <td>0.135144</td>
      <td>3.248827</td>
      <td>14.709832</td>
      <td>4494.449450</td>
      <td>1733.143852</td>
      <td>864.206542</td>
      <td>0.153715</td>
      <td>11.517318</td>
    </tr>
    <tr>
      <th>std</th>
      <td>2081.531879</td>
      <td>0.236904</td>
      <td>2136.634782</td>
      <td>1659.887917</td>
      <td>904.338115</td>
      <td>2097.163877</td>
      <td>0.401371</td>
      <td>0.298336</td>
      <td>0.397448</td>
      <td>0.200121</td>
      <td>6.824647</td>
      <td>24.857649</td>
      <td>3638.815725</td>
      <td>2895.063757</td>
      <td>2372.446607</td>
      <td>0.292499</td>
      <td>1.338331</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>50.000000</td>
      <td>0.000000</td>
      <td>0.019163</td>
      <td>0.000000</td>
      <td>6.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>128.281915</td>
      <td>0.888889</td>
      <td>39.635000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>1600.000000</td>
      <td>383.276166</td>
      <td>169.123707</td>
      <td>0.000000</td>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>873.385231</td>
      <td>1.000000</td>
      <td>361.280000</td>
      <td>38.000000</td>
      <td>89.000000</td>
      <td>0.000000</td>
      <td>0.500000</td>
      <td>0.083333</td>
      <td>0.166667</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>7.000000</td>
      <td>3000.000000</td>
      <td>856.901546</td>
      <td>312.343947</td>
      <td>0.000000</td>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>2054.140036</td>
      <td>1.000000</td>
      <td>1110.130000</td>
      <td>577.405000</td>
      <td>468.637500</td>
      <td>1113.821139</td>
      <td>0.916667</td>
      <td>0.300000</td>
      <td>0.750000</td>
      <td>0.222222</td>
      <td>4.000000</td>
      <td>17.000000</td>
      <td>6500.000000</td>
      <td>1901.134317</td>
      <td>825.485459</td>
      <td>0.142857</td>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>19043.138560</td>
      <td>1.000000</td>
      <td>49039.570000</td>
      <td>40761.250000</td>
      <td>22500.000000</td>
      <td>47137.211760</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.500000</td>
      <td>123.000000</td>
      <td>358.000000</td>
      <td>30000.000000</td>
      <td>50721.483360</td>
      <td>76406.207520</td>
      <td>1.000000</td>
      <td>12.000000</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-c9dc5124-8cde-4483-ac3f-6cc4d0be3432')"
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
        document.querySelector('#df-c9dc5124-8cde-4483-ac3f-6cc4d0be3432 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-c9dc5124-8cde-4483-ac3f-6cc4d0be3432');
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


<div id="df-a027c065-2050-42d4-970c-e978f16fd027">
  <button class="colab-df-quickchart" onclick="quickchart('df-a027c065-2050-42d4-970c-e978f16fd027')"
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
        document.querySelector('#df-a027c065-2050-42d4-970c-e978f16fd027 button');
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
data.duplicated(keep=False).sum()
```




    0



### 결측치 처리


```python
data = data.drop(columns='CUST_ID')
data.isna().sum().sort_values(ascending=False)
# 최소 지불액 변수에서 313개 결측치, 신용 한도에서 1개 결측치 관찰됨
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
      <th>MINIMUM_PAYMENTS</th>
      <td>313</td>
    </tr>
    <tr>
      <th>CREDIT_LIMIT</th>
      <td>1</td>
    </tr>
    <tr>
      <th>BALANCE</th>
      <td>0</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PRC_FULL_PAYMENT</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PAYMENTS</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES_TRX</th>
      <td>0</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_TRX</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>BALANCE_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE</th>
      <td>0</td>
    </tr>
    <tr>
      <th>INSTALLMENTS_PURCHASES</th>
      <td>0</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES</th>
      <td>0</td>
    </tr>
    <tr>
      <th>TENURE</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
# 신용 한도 결측치 1개는 단순제거를 수행한다
data = data.dropna(subset=['CREDIT_LIMIT'])

data['MINIMUM_PAYMENTS'].describe()
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
      <th>MINIMUM_PAYMENTS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>8636.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>864.304943</td>
    </tr>
    <tr>
      <th>std</th>
      <td>2372.566350</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.019163</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>169.163545</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>312.452292</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>825.496463</td>
    </tr>
    <tr>
      <th>max</th>
      <td>76406.207520</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> float64</label>




```python
# 최소 지불액 시각화 : 75%가 825인데 max값이 76406이다. 결측치는 중앙값처리가 더 적절해보인다.
sns.histplot(data['MINIMUM_PAYMENTS'])
plt.title("MINIMUM_PAYMENTS의 데이터 분포")
plt.show()
```


    
![png](/assets/img/py3_files/py3_15_0.png)
    



```python
# 최소지불액과 지불액 관계 : 최소지불액 결측치가 지불액에서 어떻게 나타나는지 확인
data['PAYMENTS'][data['MINIMUM_PAYMENTS'].isna()].value_counts().sort_values(ascending=False)
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
      <th>PAYMENTS</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0.000000</th>
      <td>240</td>
    </tr>
    <tr>
      <th>432.927281</th>
      <td>1</td>
    </tr>
    <tr>
      <th>746.691026</th>
      <td>1</td>
    </tr>
    <tr>
      <th>1159.135064</th>
      <td>1</td>
    </tr>
    <tr>
      <th>29272.486070</th>
      <td>1</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
    </tr>
    <tr>
      <th>295.937124</th>
      <td>1</td>
    </tr>
    <tr>
      <th>3905.430817</th>
      <td>1</td>
    </tr>
    <tr>
      <th>5.070726</th>
      <td>1</td>
    </tr>
    <tr>
      <th>578.819329</th>
      <td>1</td>
    </tr>
    <tr>
      <th>275.861322</th>
      <td>1</td>
    </tr>
  </tbody>
</table>
<p>74 rows × 1 columns</p>
</div><br><label><b>dtype:</b> int64</label>




```python
# 최소지불액 결측치 처리
# 1) 지불액 변수값이 0이다 : 최소지불액 결측치도 0으로 처리
# 2) 지불액 변수값이 0이 아니다 : 최소지불액 결측치 중앙값 처리
median_minimum_payments = data['MINIMUM_PAYMENTS'].median()

for index, row in data.iterrows():
    if pd.isnull(row['MINIMUM_PAYMENTS']):
        if row['PAYMENTS'] == 0:
            data.at[index, 'MINIMUM_PAYMENTS'] = 0
        else:
            data.at[index, 'MINIMUM_PAYMENTS'] = median_minimum_payments

data.isna().sum().sort_values(ascending=False)
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
      <th>BALANCE</th>
      <td>0</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PRC_FULL_PAYMENT</th>
      <td>0</td>
    </tr>
    <tr>
      <th>MINIMUM_PAYMENTS</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PAYMENTS</th>
      <td>0</td>
    </tr>
    <tr>
      <th>CREDIT_LIMIT</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES_TRX</th>
      <td>0</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_TRX</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>BALANCE_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE</th>
      <td>0</td>
    </tr>
    <tr>
      <th>INSTALLMENTS_PURCHASES</th>
      <td>0</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES</th>
      <td>0</td>
    </tr>
    <tr>
      <th>TENURE</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>



### 이상치 처리


```python
data.columns
```




    Index(['BALANCE', 'BALANCE_FREQUENCY', 'PURCHASES', 'ONEOFF_PURCHASES',
           'INSTALLMENTS_PURCHASES', 'CASH_ADVANCE', 'PURCHASES_FREQUENCY',
           'ONEOFF_PURCHASES_FREQUENCY', 'PURCHASES_INSTALLMENTS_FREQUENCY',
           'CASH_ADVANCE_FREQUENCY', 'CASH_ADVANCE_TRX', 'PURCHASES_TRX',
           'CREDIT_LIMIT', 'PAYMENTS', 'MINIMUM_PAYMENTS', 'PRC_FULL_PAYMENT',
           'TENURE'],
          dtype='object')




```python
# 이상치 제거 전 시각화
plt.figure(figsize=(20,16))
for index, col in enumerate(data):
    plt.subplot(4, 5, index + 1)
    sns.boxplot(data=data, y=col)
    plt.title(f"{col} 데이터 분포")
    plt.xlabel('')
    plt.ylabel('')

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py3_files/py3_20_0.png)
    



```python
fig, ax = plt.subplots(figsize=(12, 4))
sns.boxplot(data=data[['PURCHASES','ONEOFF_PURCHASES','INSTALLMENTS_PURCHASES']], orient='h')
sns.despine()
```


    
![png](/assets/img/py3_files/py3_21_0.png)
    



```python
# 이상치가 전반적으로 많다. 조금 넓게 범위를 잡아 이상치를 처리해보자
# 이상치 처리 : IQR 0.10 ~ 0.90 기준
data1 = data.copy()
def get_outlier_mask(df, weight=1.5):
    Q1 = df.quantile(0.10)
    Q3 = df.quantile(0.90)

    IQR = Q3 - Q1
    IQR_weight = IQR * weight

    range_min = Q1 - IQR_weight
    range_max = Q3 + IQR_weight

    outlier_per_column = (df < range_min) | (df > range_max)

    is_outlier = outlier_per_column.any(axis=1)

    return is_outlier

outlier_idx_cust_df = get_outlier_mask(data1, weight=1.5)

# 이상치를 제거한 데이터 프레임만 추가
data1 = data1[~outlier_idx_cust_df]
data1
```





  <div id="df-863758fd-0e76-45f7-af26-d2d3328fd33f" class="colab-df-container">
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
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>40.900749</td>
      <td>0.818182</td>
      <td>95.40</td>
      <td>0.00</td>
      <td>95.40</td>
      <td>0.000000</td>
      <td>0.166667</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0</td>
      <td>2</td>
      <td>1000.0</td>
      <td>201.802084</td>
      <td>139.509787</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3202.467416</td>
      <td>0.909091</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>6442.945483</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.250000</td>
      <td>4</td>
      <td>0</td>
      <td>7000.0</td>
      <td>4103.032597</td>
      <td>1072.340217</td>
      <td>0.222222</td>
      <td>12</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2495.148862</td>
      <td>1.000000</td>
      <td>773.17</td>
      <td>773.17</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>12</td>
      <td>7500.0</td>
      <td>622.066742</td>
      <td>627.284787</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1666.670542</td>
      <td>0.636364</td>
      <td>1499.00</td>
      <td>1499.00</td>
      <td>0.00</td>
      <td>205.788017</td>
      <td>0.083333</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>1</td>
      <td>1</td>
      <td>7500.0</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>4</th>
      <td>817.714335</td>
      <td>1.000000</td>
      <td>16.00</td>
      <td>16.00</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>1</td>
      <td>1200.0</td>
      <td>678.334763</td>
      <td>244.791237</td>
      <td>0.000000</td>
      <td>12</td>
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
      <th>8908</th>
      <td>21.357267</td>
      <td>1.000000</td>
      <td>212.87</td>
      <td>0.00</td>
      <td>212.87</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.857143</td>
      <td>0.000000</td>
      <td>0</td>
      <td>7</td>
      <td>1000.0</td>
      <td>169.713838</td>
      <td>103.387362</td>
      <td>1.000000</td>
      <td>7</td>
    </tr>
    <tr>
      <th>8909</th>
      <td>641.282519</td>
      <td>1.000000</td>
      <td>750.00</td>
      <td>750.00</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>0.142857</td>
      <td>0.142857</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>1</td>
      <td>1000.0</td>
      <td>105.582942</td>
      <td>302.743881</td>
      <td>0.000000</td>
      <td>7</td>
    </tr>
    <tr>
      <th>8910</th>
      <td>356.108694</td>
      <td>1.000000</td>
      <td>465.00</td>
      <td>465.00</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>0.142857</td>
      <td>0.142857</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>1</td>
      <td>1000.0</td>
      <td>118.775188</td>
      <td>109.227176</td>
      <td>0.000000</td>
      <td>7</td>
    </tr>
    <tr>
      <th>8911</th>
      <td>30.709172</td>
      <td>0.285714</td>
      <td>693.42</td>
      <td>0.00</td>
      <td>693.42</td>
      <td>0.000000</td>
      <td>0.714286</td>
      <td>0.000000</td>
      <td>0.571429</td>
      <td>0.000000</td>
      <td>0</td>
      <td>7</td>
      <td>1000.0</td>
      <td>1154.520085</td>
      <td>15.853873</td>
      <td>0.000000</td>
      <td>7</td>
    </tr>
    <tr>
      <th>8912</th>
      <td>376.547421</td>
      <td>0.857143</td>
      <td>520.00</td>
      <td>280.00</td>
      <td>240.00</td>
      <td>1178.402416</td>
      <td>0.857143</td>
      <td>0.142857</td>
      <td>0.714286</td>
      <td>0.714286</td>
      <td>9</td>
      <td>7</td>
      <td>1000.0</td>
      <td>929.415656</td>
      <td>103.927887</td>
      <td>0.200000</td>
      <td>7</td>
    </tr>
  </tbody>
</table>
<p>7860 rows × 17 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-863758fd-0e76-45f7-af26-d2d3328fd33f')"
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
        document.querySelector('#df-863758fd-0e76-45f7-af26-d2d3328fd33f button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-863758fd-0e76-45f7-af26-d2d3328fd33f');
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


<div id="df-3ba3a603-6db7-4aa0-92ca-106073a9e661">
  <button class="colab-df-quickchart" onclick="quickchart('df-3ba3a603-6db7-4aa0-92ca-106073a9e661')"
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
        document.querySelector('#df-3ba3a603-6db7-4aa0-92ca-106073a9e661 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_3c3ad725-de32-4d6f-af0e-17252817d456">
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
    <button class="colab-df-generate" onclick="generateWithVariable('data1')"
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
        document.querySelector('#id_3c3ad725-de32-4d6f-af0e-17252817d456 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('data1');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 이상치 처리후 약 88% 데이터가 남아있음
```


```python
# 이상치 제거 후 시각화
plt.figure(figsize=(20,16))
for index, col in enumerate(data1):
    plt.subplot(4, 5, index + 1)
    sns.boxplot(data=data1, y=col)
    plt.title(f"{col} 데이터 분포")
    plt.xlabel('')
    plt.ylabel('')

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py3_files/py3_24_0.png)
    



```python
fig, ax = plt.subplots(figsize=(12, 4))
sns.boxplot(data=data1[['PURCHASES','ONEOFF_PURCHASES','INSTALLMENTS_PURCHASES']], orient='h')
sns.despine()
```


    
![png](/assets/img/py3_files/py3_25_0.png)
    



```python
print(data.shape)
print(data1.shape)
```

    (8949, 17)
    (7860, 17)
    

### 데이터 스케일링(표준화)


```python
from sklearn.preprocessing import StandardScaler
X = pd.DataFrame(StandardScaler().fit_transform(data1))
X.columns = data1.columns
X
```





  <div id="df-d418e7ab-cc57-4e68-a13d-b9497c53eb72" class="colab-df-container">
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
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-0.759230</td>
      <td>-0.215174</td>
      <td>-0.647074</td>
      <td>-0.563016</td>
      <td>-0.438529</td>
      <td>-0.554399</td>
      <td>-0.781710</td>
      <td>-0.655372</td>
      <td>-0.686239</td>
      <td>-0.681795</td>
      <td>-0.583719</td>
      <td>-0.642731</td>
      <td>-0.963612</td>
      <td>-0.757110</td>
      <td>-0.619439</td>
      <td>-0.519522</td>
      <td>0.342786</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.133722</td>
      <td>0.157732</td>
      <td>-0.749856</td>
      <td>-0.563016</td>
      <td>-0.636488</td>
      <td>4.353856</td>
      <td>-1.201890</td>
      <td>-0.655372</td>
      <td>-0.899298</td>
      <td>0.741350</td>
      <td>0.340635</td>
      <td>-0.777428</td>
      <td>0.887054</td>
      <td>2.054270</td>
      <td>0.839021</td>
      <td>0.253579</td>
      <td>0.342786</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.710223</td>
      <td>0.530637</td>
      <td>0.083143</td>
      <td>0.554549</td>
      <td>-0.636488</td>
      <td>-0.554399</td>
      <td>1.319186</td>
      <td>2.889453</td>
      <td>-0.899298</td>
      <td>-0.681795</td>
      <td>-0.583719</td>
      <td>0.030752</td>
      <td>1.041276</td>
      <td>-0.454251</td>
      <td>0.143187</td>
      <td>-0.519522</td>
      <td>0.342786</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.214181</td>
      <td>-0.960985</td>
      <td>0.865139</td>
      <td>1.603686</td>
      <td>-0.636488</td>
      <td>-0.397629</td>
      <td>-0.991802</td>
      <td>-0.359971</td>
      <td>-0.899298</td>
      <td>-0.207415</td>
      <td>-0.352631</td>
      <td>-0.710080</td>
      <td>1.041276</td>
      <td>-0.902537</td>
      <td>-0.837560</td>
      <td>-0.519522</td>
      <td>0.342786</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-0.294122</td>
      <td>0.530637</td>
      <td>-0.732618</td>
      <td>-0.539889</td>
      <td>-0.636488</td>
      <td>-0.554399</td>
      <td>-0.991802</td>
      <td>-0.359971</td>
      <td>-0.899298</td>
      <td>-0.681795</td>
      <td>-0.583719</td>
      <td>-0.710080</td>
      <td>-0.901923</td>
      <td>-0.413702</td>
      <td>-0.454834</td>
      <td>-0.519522</td>
      <td>0.342786</td>
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
      <th>7855</th>
      <td>-0.770931</td>
      <td>0.530637</td>
      <td>-0.520514</td>
      <td>-0.563016</td>
      <td>-0.194773</td>
      <td>-0.554399</td>
      <td>1.319186</td>
      <td>-0.655372</td>
      <td>1.292180</td>
      <td>-0.681795</td>
      <td>-0.583719</td>
      <td>-0.305989</td>
      <td>-0.963612</td>
      <td>-0.780234</td>
      <td>-0.675916</td>
      <td>2.959437</td>
      <td>-4.300951</td>
    </tr>
    <tr>
      <th>7856</th>
      <td>-0.399758</td>
      <td>0.530637</td>
      <td>0.058180</td>
      <td>0.521058</td>
      <td>-0.636488</td>
      <td>-0.554399</td>
      <td>-0.841737</td>
      <td>-0.148969</td>
      <td>-0.899298</td>
      <td>-0.681795</td>
      <td>-0.583719</td>
      <td>-0.710080</td>
      <td>-0.963612</td>
      <td>-0.826449</td>
      <td>-0.364226</td>
      <td>-0.519522</td>
      <td>-4.300951</td>
    </tr>
    <tr>
      <th>7857</th>
      <td>-0.570503</td>
      <td>0.530637</td>
      <td>-0.248873</td>
      <td>0.109110</td>
      <td>-0.636488</td>
      <td>-0.554399</td>
      <td>-0.841737</td>
      <td>-0.148969</td>
      <td>-0.899298</td>
      <td>-0.681795</td>
      <td>-0.583719</td>
      <td>-0.710080</td>
      <td>-0.963612</td>
      <td>-0.816943</td>
      <td>-0.666785</td>
      <td>-0.519522</td>
      <td>-4.300951</td>
    </tr>
    <tr>
      <th>7858</th>
      <td>-0.765332</td>
      <td>-2.399339</td>
      <td>-0.002778</td>
      <td>-0.563016</td>
      <td>0.802390</td>
      <td>-0.554399</td>
      <td>0.598879</td>
      <td>-0.655372</td>
      <td>0.561688</td>
      <td>-0.681795</td>
      <td>-0.583719</td>
      <td>-0.305989</td>
      <td>-0.963612</td>
      <td>-0.070544</td>
      <td>-0.812773</td>
      <td>-0.519522</td>
      <td>-4.300951</td>
    </tr>
    <tr>
      <th>7859</th>
      <td>-0.558265</td>
      <td>-0.055357</td>
      <td>-0.189617</td>
      <td>-0.158295</td>
      <td>-0.138477</td>
      <td>0.343312</td>
      <td>0.959032</td>
      <td>-0.148969</td>
      <td>0.926934</td>
      <td>3.384336</td>
      <td>1.496078</td>
      <td>-0.305989</td>
      <td>-0.963612</td>
      <td>-0.232763</td>
      <td>-0.675071</td>
      <td>0.176270</td>
      <td>-4.300951</td>
    </tr>
  </tbody>
</table>
<p>7860 rows × 17 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-d418e7ab-cc57-4e68-a13d-b9497c53eb72')"
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
        document.querySelector('#df-d418e7ab-cc57-4e68-a13d-b9497c53eb72 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-d418e7ab-cc57-4e68-a13d-b9497c53eb72');
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


<div id="df-ffdf4943-87a5-4a10-8a3d-2a185ff277d8">
  <button class="colab-df-quickchart" onclick="quickchart('df-ffdf4943-87a5-4a10-8a3d-2a185ff277d8')"
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
        document.querySelector('#df-ffdf4943-87a5-4a10-8a3d-2a185ff277d8 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_7edcfa88-3bbd-42f4-8c7c-e1129f6d2b4d">
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
    <button class="colab-df-generate" onclick="generateWithVariable('X')"
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
        document.querySelector('#id_7edcfa88-3bbd-42f4-8c7c-e1129f6d2b4d button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('X');
      }
      })();
    </script>
  </div>

    </div>
  </div>




## 데이터 분석


```python
data1.describe()
```





  <div id="df-07cf2770-1029-407b-ae1f-c2bad5b21406" class="colab-df-container">
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
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>7860.000000</td>
      <td>7860.000000</td>
      <td>7860.000000</td>
      <td>7860.000000</td>
      <td>7860.000000</td>
      <td>7860.000000</td>
      <td>7860.000000</td>
      <td>7860.000000</td>
      <td>7860.000000</td>
      <td>7860.000000</td>
      <td>7860.000000</td>
      <td>7860.000000</td>
      <td>7860.000000</td>
      <td>7860.000000</td>
      <td>7860.000000</td>
      <td>7860.000000</td>
      <td>7860.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>1308.949829</td>
      <td>0.870638</td>
      <td>695.998356</td>
      <td>389.514023</td>
      <td>306.734674</td>
      <td>727.745525</td>
      <td>0.476737</td>
      <td>0.184881</td>
      <td>0.351739</td>
      <td>0.119769</td>
      <td>2.525954</td>
      <td>11.543384</td>
      <td>4124.103510</td>
      <td>1252.410911</td>
      <td>535.702676</td>
      <td>0.149333</td>
      <td>11.630916</td>
    </tr>
    <tr>
      <th>std</th>
      <td>1670.284112</td>
      <td>0.243801</td>
      <td>928.235177</td>
      <td>691.878859</td>
      <td>481.947855</td>
      <td>1312.758971</td>
      <td>0.396681</td>
      <td>0.282119</td>
      <td>0.391150</td>
      <td>0.175678</td>
      <td>4.327621</td>
      <td>14.849117</td>
      <td>3242.284051</td>
      <td>1387.744782</td>
      <td>639.640053</td>
      <td>0.287461</td>
      <td>1.076788</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>50.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>7.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>101.167029</td>
      <td>0.875000</td>
      <td>37.877500</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>1500.000000</td>
      <td>368.707269</td>
      <td>161.920832</td>
      <td>0.000000</td>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>757.818931</td>
      <td>1.000000</td>
      <td>338.645000</td>
      <td>20.000000</td>
      <td>79.925000</td>
      <td>0.000000</td>
      <td>0.416667</td>
      <td>0.083333</td>
      <td>0.166667</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>7.000000</td>
      <td>3000.000000</td>
      <td>771.822248</td>
      <td>269.924755</td>
      <td>0.000000</td>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>1765.044917</td>
      <td>1.000000</td>
      <td>972.447500</td>
      <td>483.605000</td>
      <td>426.602500</td>
      <td>950.978173</td>
      <td>0.916667</td>
      <td>0.250000</td>
      <td>0.750000</td>
      <td>0.166667</td>
      <td>3.000000</td>
      <td>15.000000</td>
      <td>6000.000000</td>
      <td>1605.538063</td>
      <td>666.702914</td>
      <td>0.125000</td>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>10598.467770</td>
      <td>1.000000</td>
      <td>6058.030000</td>
      <td>4000.000000</td>
      <td>2840.060000</td>
      <td>7663.906258</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>25.000000</td>
      <td>92.000000</td>
      <td>21500.000000</td>
      <td>9481.484058</td>
      <td>4192.565071</td>
      <td>1.000000</td>
      <td>12.000000</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-07cf2770-1029-407b-ae1f-c2bad5b21406')"
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
        document.querySelector('#df-07cf2770-1029-407b-ae1f-c2bad5b21406 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-07cf2770-1029-407b-ae1f-c2bad5b21406');
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


<div id="df-17b5ce13-aee8-4d31-b576-1f4d6410ed00">
  <button class="colab-df-quickchart" onclick="quickchart('df-17b5ce13-aee8-4d31-b576-1f4d6410ed00')"
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
        document.querySelector('#df-17b5ce13-aee8-4d31-b576-1f4d6410ed00 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




### EDA


```python
plt.figure(figsize=(10,8))
sns.heatmap(data1.corr(), annot=True, fmt='.2f')
```




    <Axes: >




    
![png](/assets/img/py3_files/py3_32_1.png)
    



```python
corr_list = data1.corr()['PURCHASES'].abs().sort_values(ascending = False)
corr_list
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
      <th>PURCHASES</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>PURCHASES</th>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES</th>
      <td>0.862674</td>
    </tr>
    <tr>
      <th>PURCHASES_TRX</th>
      <td>0.750810</td>
    </tr>
    <tr>
      <th>INSTALLMENTS_PURCHASES</th>
      <td>0.687412</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <td>0.616113</td>
    </tr>
    <tr>
      <th>PURCHASES_FREQUENCY</th>
      <td>0.571824</td>
    </tr>
    <tr>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <td>0.437147</td>
    </tr>
    <tr>
      <th>PAYMENTS</th>
      <td>0.407756</td>
    </tr>
    <tr>
      <th>CREDIT_LIMIT</th>
      <td>0.279801</td>
    </tr>
    <tr>
      <th>PRC_FULL_PAYMENT</th>
      <td>0.196942</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <td>0.189060</td>
    </tr>
    <tr>
      <th>BALANCE_FREQUENCY</th>
      <td>0.171853</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_TRX</th>
      <td>0.157633</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE</th>
      <td>0.148370</td>
    </tr>
    <tr>
      <th>TENURE</th>
      <td>0.089850</td>
    </tr>
    <tr>
      <th>MINIMUM_PAYMENTS</th>
      <td>0.048712</td>
    </tr>
    <tr>
      <th>BALANCE</th>
      <td>0.039330</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> float64</label>



- 총 구매액 관련 상관관계는 일회성 구매액, 구매 횟수, 할부 구매액, 구매빈도 등이 높은 상관관계가 관찰되었다


```python
plt.figure(figsize=(20,16))
for index, col in enumerate(data1):
    plt.subplot(4, 5, index + 1)
    sns.histplot(data1[col], kde=True)
    plt.title(f"{col} 데이터 분포")
    plt.xlabel('')
    plt.ylabel('')

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py3_files/py3_35_0.png)
    


- 대부분 한쪽으로 치우쳐진 분포를 보이며 정규분포 형태는 관찰되지않음

### 주성분분석(PCA)

#### 적절한 주성분 수 결정을 위해 분산 설명 비율 계산


```python
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA

pca = PCA()
pca.fit(X)

# 주성분의 설명력 (분산 설명 비율)
explained_variance = pca.explained_variance_ratio_

# 설명력 시각화
plt.figure(figsize=(10, 6))
plt.plot(range(1, len(explained_variance) + 1), explained_variance, marker='o')
plt.title('Explained Variance by Principal Components')
plt.xlabel('Principal Component')
plt.ylabel('Explained Variance Ratio')
plt.xticks(range(1, len(explained_variance) + 1))
plt.grid()
plt.show()

# 누적 분산 비율 계산
cumulative_variance_ratio = np.cumsum(pca.explained_variance_ratio_)
print(cumulative_variance_ratio)
```


    
![png](/assets/img/py3_files/py3_39_0.png)
    


    [0.28944758 0.50530762 0.59853074 0.67316781 0.73860167 0.79126589
     0.83743209 0.87564215 0.90736008 0.93555131 0.95312777 0.97006002
     0.982218   0.9918921  0.99784582 0.99999769 1.        ]
    


```python
# 주성분의 설명력이 70% 이상은 아니지만 완만하게 바뀌는 지점인 주성분 3차원 기준으로 데이터 변환 진행
pca = PCA(n_components=3)
pca.fit(X)
loadings = pd.DataFrame(pca.components_.T, columns=['PC1','PC2','PC3'], index=X.columns)
loadings
```





  <div id="df-35292b00-f3db-4371-b772-34a6c5d8c801" class="colab-df-container">
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
      <th>PC1</th>
      <th>PC2</th>
      <th>PC3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>BALANCE</th>
      <td>-0.090241</td>
      <td>0.420046</td>
      <td>0.082117</td>
    </tr>
    <tr>
      <th>BALANCE_FREQUENCY</th>
      <td>0.069763</td>
      <td>0.228970</td>
      <td>0.214685</td>
    </tr>
    <tr>
      <th>PURCHASES</th>
      <td>0.383308</td>
      <td>0.167065</td>
      <td>-0.174996</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES</th>
      <td>0.285660</td>
      <td>0.174523</td>
      <td>-0.462194</td>
    </tr>
    <tr>
      <th>INSTALLMENTS_PURCHASES</th>
      <td>0.328199</td>
      <td>0.071088</td>
      <td>0.326693</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE</th>
      <td>-0.188539</td>
      <td>0.361044</td>
      <td>0.050141</td>
    </tr>
    <tr>
      <th>PURCHASES_FREQUENCY</th>
      <td>0.378707</td>
      <td>0.007412</td>
      <td>0.262844</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <td>0.273971</td>
      <td>0.140280</td>
      <td>-0.406676</td>
    </tr>
    <tr>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <td>0.320546</td>
      <td>-0.021893</td>
      <td>0.494744</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <td>-0.220366</td>
      <td>0.343392</td>
      <td>0.084174</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_TRX</th>
      <td>-0.201693</td>
      <td>0.349779</td>
      <td>0.094663</td>
    </tr>
    <tr>
      <th>PURCHASES_TRX</th>
      <td>0.383084</td>
      <td>0.128440</td>
      <td>0.078035</td>
    </tr>
    <tr>
      <th>CREDIT_LIMIT</th>
      <td>0.089493</td>
      <td>0.256659</td>
      <td>-0.178085</td>
    </tr>
    <tr>
      <th>PAYMENTS</th>
      <td>0.110607</td>
      <td>0.295697</td>
      <td>-0.151794</td>
    </tr>
    <tr>
      <th>MINIMUM_PAYMENTS</th>
      <td>-0.054220</td>
      <td>0.354595</td>
      <td>0.193431</td>
    </tr>
    <tr>
      <th>PRC_FULL_PAYMENT</th>
      <td>0.174370</td>
      <td>-0.137956</td>
      <td>-0.008513</td>
    </tr>
    <tr>
      <th>TENURE</th>
      <td>0.066260</td>
      <td>0.048020</td>
      <td>-0.007403</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-35292b00-f3db-4371-b772-34a6c5d8c801')"
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
        document.querySelector('#df-35292b00-f3db-4371-b772-34a6c5d8c801 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-35292b00-f3db-4371-b772-34a6c5d8c801');
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


<div id="df-10716147-d12e-4e08-88e6-c323263d8076">
  <button class="colab-df-quickchart" onclick="quickchart('df-10716147-d12e-4e08-88e6-c323263d8076')"
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
        document.querySelector('#df-10716147-d12e-4e08-88e6-c323263d8076 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_2935b338-c70d-4671-a767-d96733cb6d5d">
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
    <button class="colab-df-generate" onclick="generateWithVariable('loadings')"
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
        document.querySelector('#id_2935b338-c70d-4671-a767-d96733cb6d5d button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('loadings');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 각 주성분별 막대 그래프 생성
fig, axes = plt.subplots(1, 3, figsize=(15, 6))
axes = axes.flatten()

# 각 주성분별 막대 그래프 생성
for i in range(3):
    loadings.iloc[:, i].sort_values(ascending=True).plot(kind='barh', ax=axes[i])
    axes[i].set_title(f'주성분 {i+1}')

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py3_files/py3_41_0.png)
    


- 주성분1 : 구매 관련 변수에서 높은 수치, 현금서비스 관련 낮은 수치가 관찰됨
- 주성분2 : 잔액과 현금서비스, 지불액에서 높은 수치, 구매 관련 변수에서 낮은
수치가 관찰됨
- 주성분3 : 할부 구매 관련 변수에서 높은 수치, 일회성 구매는 낮은 수치가 관찰됨


### PCA이용 차원축소후 K-means 클러스터링


```python
pca.fit(X)
x_pca = pca.transform(X)
pca_df = pd.DataFrame(x_pca, columns=['PC1', 'PC2', 'PC3'])
pca_df.head()
```





  <div id="df-a23e5d6b-65d6-456e-aac7-70f1027ff1d6" class="colab-df-container">
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
      <th>PC1</th>
      <th>PC2</th>
      <th>PC3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-1.272830</td>
      <td>-2.012145</td>
      <td>-0.178806</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-2.694168</td>
      <td>3.122301</td>
      <td>-0.243752</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1.308845</td>
      <td>0.557380</td>
      <td>-1.804754</td>
    </tr>
    <tr>
      <th>3</th>
      <td>-0.377355</td>
      <td>-0.426880</td>
      <td>-2.183236</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-1.412074</td>
      <td>-1.458696</td>
      <td>-0.358182</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-a23e5d6b-65d6-456e-aac7-70f1027ff1d6')"
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
        document.querySelector('#df-a23e5d6b-65d6-456e-aac7-70f1027ff1d6 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-a23e5d6b-65d6-456e-aac7-70f1027ff1d6');
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


<div id="df-e4b87ae6-c8c7-47b1-83d8-13ff4f4ccf83">
  <button class="colab-df-quickchart" onclick="quickchart('df-e4b87ae6-c8c7-47b1-83d8-13ff4f4ccf83')"
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
        document.querySelector('#df-e4b87ae6-c8c7-47b1-83d8-13ff4f4ccf83 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
# 엘보우 기법 사용 적절한 k값 찾기
from sklearn.cluster import KMeans

ks = range(1,10)
inertias = []

for k in ks:
    model = KMeans(n_clusters=k)
    model.fit(pca_df)
    inertias.append(model.inertia_)

#시각화
sns.lineplot(x=ks, y=inertias, marker='o')
```




    <Axes: >




    
![png](/assets/img/py3_files/py3_45_1.png)
    



```python
# 엘보우기법 시각화결과 군집개수 4개 기준으로 클러스터링 수행
optimal_k = 4
kmeans = KMeans(n_clusters=optimal_k, random_state=21)
pca_df['cluster'] = kmeans.fit_predict(pca_df)
pca_df
```





  <div id="df-3cf367c2-805f-4f8c-9708-98ff1e577039" class="colab-df-container">
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
      <th>PC1</th>
      <th>PC2</th>
      <th>PC3</th>
      <th>cluster</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-1.272830</td>
      <td>-2.012145</td>
      <td>-0.178806</td>
      <td>2</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-2.694168</td>
      <td>3.122301</td>
      <td>-0.243752</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1.308845</td>
      <td>0.557380</td>
      <td>-1.804754</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>-0.377355</td>
      <td>-0.426880</td>
      <td>-2.183236</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-1.412074</td>
      <td>-1.458696</td>
      <td>-0.358182</td>
      <td>2</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>7855</th>
      <td>0.767003</td>
      <td>-2.522112</td>
      <td>1.592477</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7856</th>
      <td>-1.045493</td>
      <td>-1.483827</td>
      <td>-0.916429</td>
      <td>2</td>
    </tr>
    <tr>
      <th>7857</th>
      <td>-1.248002</td>
      <td>-1.783215</td>
      <td>-0.746284</td>
      <td>2</td>
    </tr>
    <tr>
      <th>7858</th>
      <td>0.060164</td>
      <td>-2.381332</td>
      <td>0.543761</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7859</th>
      <td>-1.056441</td>
      <td>0.633322</td>
      <td>1.301161</td>
      <td>2</td>
    </tr>
  </tbody>
</table>
<p>7860 rows × 4 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-3cf367c2-805f-4f8c-9708-98ff1e577039')"
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
        document.querySelector('#df-3cf367c2-805f-4f8c-9708-98ff1e577039 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-3cf367c2-805f-4f8c-9708-98ff1e577039');
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


<div id="df-0d5d2f1d-1b6f-479b-be05-f2dd7c849549">
  <button class="colab-df-quickchart" onclick="quickchart('df-0d5d2f1d-1b6f-479b-be05-f2dd7c849549')"
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
        document.querySelector('#df-0d5d2f1d-1b6f-479b-be05-f2dd7c849549 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_aea2ea13-fd37-448e-a33d-d90ac6d2e67f">
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
    <button class="colab-df-generate" onclick="generateWithVariable('pca_df')"
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
        document.querySelector('#id_aea2ea13-fd37-448e-a33d-d90ac6d2e67f button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('pca_df');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 클러스터 개수 확인
cluster_counts = pca_df['cluster'].value_counts()
print("Cluster Counts:")
print(cluster_counts)
```

    Cluster Counts:
    cluster
    2    3360
    0    2048
    1    1336
    3    1116
    Name: count, dtype: int64
    


```python
# 3D 시각화
fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111, projection='3d')

# 클러스터에 따라 다른 색상으로 시각화
scatter = ax.scatter(pca_df['PC1'], pca_df['PC2'], pca_df['PC3'],
                     c=pca_df['cluster'], cmap='viridis', s=50)

# 축 레이블 설정
ax.set_xlabel('PC1')
ax.set_ylabel('PC2')
ax.set_zlabel('PC3')
ax.set_title('3D PCA 클러스터링 결과')

# 범례 추가
legend1 = ax.legend(*scatter.legend_elements(), title="Clusters")
ax.add_artist(legend1)

plt.show()
```


    
![png](/assets/img/py3_files/py3_48_0.png)
    



```python
data3 = X.copy()
data3['cluster'] = pca_df['cluster']
```


```python
data3
```





  <div id="df-3c34c13f-8197-4d34-a058-c5390b64a789" class="colab-df-container">
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
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
      <th>cluster</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-0.759230</td>
      <td>-0.215174</td>
      <td>-0.647074</td>
      <td>-0.563016</td>
      <td>-0.438529</td>
      <td>-0.554399</td>
      <td>-0.781710</td>
      <td>-0.655372</td>
      <td>-0.686239</td>
      <td>-0.681795</td>
      <td>-0.583719</td>
      <td>-0.642731</td>
      <td>-0.963612</td>
      <td>-0.757110</td>
      <td>-0.619439</td>
      <td>-0.519522</td>
      <td>0.342786</td>
      <td>2</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.133722</td>
      <td>0.157732</td>
      <td>-0.749856</td>
      <td>-0.563016</td>
      <td>-0.636488</td>
      <td>4.353856</td>
      <td>-1.201890</td>
      <td>-0.655372</td>
      <td>-0.899298</td>
      <td>0.741350</td>
      <td>0.340635</td>
      <td>-0.777428</td>
      <td>0.887054</td>
      <td>2.054270</td>
      <td>0.839021</td>
      <td>0.253579</td>
      <td>0.342786</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.710223</td>
      <td>0.530637</td>
      <td>0.083143</td>
      <td>0.554549</td>
      <td>-0.636488</td>
      <td>-0.554399</td>
      <td>1.319186</td>
      <td>2.889453</td>
      <td>-0.899298</td>
      <td>-0.681795</td>
      <td>-0.583719</td>
      <td>0.030752</td>
      <td>1.041276</td>
      <td>-0.454251</td>
      <td>0.143187</td>
      <td>-0.519522</td>
      <td>0.342786</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.214181</td>
      <td>-0.960985</td>
      <td>0.865139</td>
      <td>1.603686</td>
      <td>-0.636488</td>
      <td>-0.397629</td>
      <td>-0.991802</td>
      <td>-0.359971</td>
      <td>-0.899298</td>
      <td>-0.207415</td>
      <td>-0.352631</td>
      <td>-0.710080</td>
      <td>1.041276</td>
      <td>-0.902537</td>
      <td>-0.837560</td>
      <td>-0.519522</td>
      <td>0.342786</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-0.294122</td>
      <td>0.530637</td>
      <td>-0.732618</td>
      <td>-0.539889</td>
      <td>-0.636488</td>
      <td>-0.554399</td>
      <td>-0.991802</td>
      <td>-0.359971</td>
      <td>-0.899298</td>
      <td>-0.681795</td>
      <td>-0.583719</td>
      <td>-0.710080</td>
      <td>-0.901923</td>
      <td>-0.413702</td>
      <td>-0.454834</td>
      <td>-0.519522</td>
      <td>0.342786</td>
      <td>2</td>
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
      <th>7855</th>
      <td>-0.770931</td>
      <td>0.530637</td>
      <td>-0.520514</td>
      <td>-0.563016</td>
      <td>-0.194773</td>
      <td>-0.554399</td>
      <td>1.319186</td>
      <td>-0.655372</td>
      <td>1.292180</td>
      <td>-0.681795</td>
      <td>-0.583719</td>
      <td>-0.305989</td>
      <td>-0.963612</td>
      <td>-0.780234</td>
      <td>-0.675916</td>
      <td>2.959437</td>
      <td>-4.300951</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7856</th>
      <td>-0.399758</td>
      <td>0.530637</td>
      <td>0.058180</td>
      <td>0.521058</td>
      <td>-0.636488</td>
      <td>-0.554399</td>
      <td>-0.841737</td>
      <td>-0.148969</td>
      <td>-0.899298</td>
      <td>-0.681795</td>
      <td>-0.583719</td>
      <td>-0.710080</td>
      <td>-0.963612</td>
      <td>-0.826449</td>
      <td>-0.364226</td>
      <td>-0.519522</td>
      <td>-4.300951</td>
      <td>2</td>
    </tr>
    <tr>
      <th>7857</th>
      <td>-0.570503</td>
      <td>0.530637</td>
      <td>-0.248873</td>
      <td>0.109110</td>
      <td>-0.636488</td>
      <td>-0.554399</td>
      <td>-0.841737</td>
      <td>-0.148969</td>
      <td>-0.899298</td>
      <td>-0.681795</td>
      <td>-0.583719</td>
      <td>-0.710080</td>
      <td>-0.963612</td>
      <td>-0.816943</td>
      <td>-0.666785</td>
      <td>-0.519522</td>
      <td>-4.300951</td>
      <td>2</td>
    </tr>
    <tr>
      <th>7858</th>
      <td>-0.765332</td>
      <td>-2.399339</td>
      <td>-0.002778</td>
      <td>-0.563016</td>
      <td>0.802390</td>
      <td>-0.554399</td>
      <td>0.598879</td>
      <td>-0.655372</td>
      <td>0.561688</td>
      <td>-0.681795</td>
      <td>-0.583719</td>
      <td>-0.305989</td>
      <td>-0.963612</td>
      <td>-0.070544</td>
      <td>-0.812773</td>
      <td>-0.519522</td>
      <td>-4.300951</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7859</th>
      <td>-0.558265</td>
      <td>-0.055357</td>
      <td>-0.189617</td>
      <td>-0.158295</td>
      <td>-0.138477</td>
      <td>0.343312</td>
      <td>0.959032</td>
      <td>-0.148969</td>
      <td>0.926934</td>
      <td>3.384336</td>
      <td>1.496078</td>
      <td>-0.305989</td>
      <td>-0.963612</td>
      <td>-0.232763</td>
      <td>-0.675071</td>
      <td>0.176270</td>
      <td>-4.300951</td>
      <td>2</td>
    </tr>
  </tbody>
</table>
<p>7860 rows × 18 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-3c34c13f-8197-4d34-a058-c5390b64a789')"
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
        document.querySelector('#df-3c34c13f-8197-4d34-a058-c5390b64a789 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-3c34c13f-8197-4d34-a058-c5390b64a789');
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


<div id="df-88a00363-5b2b-46c6-bf4f-21c18ef3a5aa">
  <button class="colab-df-quickchart" onclick="quickchart('df-88a00363-5b2b-46c6-bf4f-21c18ef3a5aa')"
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
        document.querySelector('#df-88a00363-5b2b-46c6-bf4f-21c18ef3a5aa button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_8057915d-7788-45f6-b762-6b825f7b8922">
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
    <button class="colab-df-generate" onclick="generateWithVariable('data3')"
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
        document.querySelector('#id_8057915d-7788-45f6-b762-6b825f7b8922 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('data3');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 클러스터별 고객 특성 파악하기
mask1 = data3.groupby('cluster').mean()
mask1['cluster_counts'] = data3['cluster'].value_counts()
mask1.T
```





  <div id="df-29a23efb-354c-41fb-a680-7cc9ad5ad05d" class="colab-df-container">
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
      <th>cluster</th>
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>BALANCE</th>
      <td>-0.439621</td>
      <td>1.345252</td>
      <td>-0.311816</td>
      <td>0.135114</td>
    </tr>
    <tr>
      <th>BALANCE_FREQUENCY</th>
      <td>0.161979</td>
      <td>0.409125</td>
      <td>-0.393979</td>
      <td>0.399143</td>
    </tr>
    <tr>
      <th>PURCHASES</th>
      <td>0.060833</td>
      <td>-0.425654</td>
      <td>-0.476633</td>
      <td>1.832951</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES</th>
      <td>-0.364703</td>
      <td>-0.291965</td>
      <td>-0.270482</td>
      <td>1.833151</td>
    </tr>
    <tr>
      <th>INSTALLMENTS_PURCHASES</th>
      <td>0.641619</td>
      <td>-0.401137</td>
      <td>-0.529912</td>
      <td>0.898198</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE</th>
      <td>-0.450776</td>
      <td>1.544578</td>
      <td>-0.238864</td>
      <td>-0.302675</td>
    </tr>
    <tr>
      <th>PURCHASES_FREQUENCY</th>
      <td>0.982258</td>
      <td>-0.612000</td>
      <td>-0.702782</td>
      <td>1.045982</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <td>-0.350751</td>
      <td>-0.291416</td>
      <td>-0.253245</td>
      <td>1.754995</td>
    </tr>
    <tr>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <td>1.164645</td>
      <td>-0.535940</td>
      <td>-0.688415</td>
      <td>0.576969</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <td>-0.508466</td>
      <td>1.524861</td>
      <td>-0.181088</td>
      <td>-0.347151</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_TRX</th>
      <td>-0.457004</td>
      <td>1.552293</td>
      <td>-0.232616</td>
      <td>-0.319293</td>
    </tr>
    <tr>
      <th>PURCHASES_TRX</th>
      <td>0.360227</td>
      <td>-0.449306</td>
      <td>-0.558947</td>
      <td>1.559669</td>
    </tr>
    <tr>
      <th>CREDIT_LIMIT</th>
      <td>-0.286768</td>
      <td>0.553079</td>
      <td>-0.293469</td>
      <td>0.747710</td>
    </tr>
    <tr>
      <th>PAYMENTS</th>
      <td>-0.277961</td>
      <td>0.578240</td>
      <td>-0.341514</td>
      <td>0.846080</td>
    </tr>
    <tr>
      <th>MINIMUM_PAYMENTS</th>
      <td>-0.193486</td>
      <td>1.073920</td>
      <td>-0.320739</td>
      <td>0.035110</td>
    </tr>
    <tr>
      <th>PRC_FULL_PAYMENT</th>
      <td>0.402595</td>
      <td>-0.433647</td>
      <td>-0.201980</td>
      <td>0.388433</td>
    </tr>
    <tr>
      <th>TENURE</th>
      <td>-0.002320</td>
      <td>-0.029130</td>
      <td>-0.061053</td>
      <td>0.222947</td>
    </tr>
    <tr>
      <th>cluster_counts</th>
      <td>2048.000000</td>
      <td>1336.000000</td>
      <td>3360.000000</td>
      <td>1116.000000</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-29a23efb-354c-41fb-a680-7cc9ad5ad05d')"
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
        document.querySelector('#df-29a23efb-354c-41fb-a680-7cc9ad5ad05d button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-29a23efb-354c-41fb-a680-7cc9ad5ad05d');
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


<div id="df-e68c6843-0dff-443a-aaba-ce40f1663bb0">
  <button class="colab-df-quickchart" onclick="quickchart('df-e68c6843-0dff-443a-aaba-ce40f1663bb0')"
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
        document.querySelector('#df-e68c6843-0dff-443a-aaba-ce40f1663bb0 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
for i in range(4):  # 0, 1, 2, 3 클러스터 모두 포함
    if i not in mask1.index:
        mask1.loc[i] = [0] * (mask1.shape[1] - 1) + [0]  # 평균값 0으로 설정
    else:
        mask1.loc[i, 'cluster_counts'] = mask1['cluster_counts'].get(i, 0)  # 클러스터 개수 유지

mask1 = mask1.sort_index()  # 인덱스 정렬

# 그래프 생성
fig, axes = plt.subplots(3, 2, figsize=(12, 18))  # 3행 2열의 서브플롯 설정
axes = axes.flatten()

# 각 클러스터별 평균값 시각화
for i in range(len(mask1) - 1):  # 클러스터 평균값에 대해서만
    mask1.iloc[i].drop('cluster_counts').sort_values(ascending=True).plot(kind='barh', ax=axes[i])
    axes[i].set_title(f'클러스터 {i}')

# 클러스터 개수 그래프
mask1['cluster_counts'][:4].plot(kind='barh', ax=axes[4], color='orange')
axes[4].set_xlabel('고객 수')
axes[4].set_ylabel('클러스터')

# 남는 서브플롯 비우기
axes[5].axis('off')  # 여섯 번째 서브플롯은 비워둡니다.

plt.tight_layout()
plt.show()

```


    
![png](/assets/img/py3_files/py3_52_0.png)
    


- 클러스터0(할부 구매가 활발한 고객)   
   - 구매 빈도와 할부 구매 비율이 높고, 현금서비스와 일회성 구매는 낮게 관찰됨
   - 일회성 구매보다는 소액으로 나누어 자주 구매하는 성향을 보이고 있음
   - 마케팅 전략
      - 장기 할부 혜택이나 포인트 적립 프로그램을 제안하여 다양한 상품을 구매할 수 있도록 유도.특정 고가의 상품을 할부로 구매하는 방향도 검토 필요
      - 해당유형은 빈번한 할부 구매로 회사의 제품에 만족하고있다. 지인을 추천할 경우 다양한 혜택을 제공하여 더많은 충성고객 확보(비슷한 성향의 사람들이 유입되어 충성고객이 늘어날 수 있음
- 클러스터1(현금 서비스 이용고객)
  - 현금 서비스 사용 빈도가 높고 잔액과 최소지불액 또한 높게 관찰됨
  - 구매 관련 변수들이 평균이하로, 구매보다는 현금 서비스를 많이 이용하는 고객
  - 마케팅 전략
     - 대출 이자율을 개선해주는 프로모션이나 현금서비스 대체 상품 프로그램 제공
     - 고객의 재무관리 상담 서비스를 도입하여 원활한 현금흐름 유도

- 클러스터2(소극적인 고객)
   - 모든 지표들이 평균이하로, 특히 구매관련빈도가 매우 낮게 관찰됨
   - 카드 사용 활동이 거의 없고, 소비에 대해 신중해 구매를 자주하지 않고 필요할 때만 거래를 하는 경향이 관찰됨
   - 마케팅 전략
      - 카드 사용 유도를 위해 사용 빈도에 따라 할인 혜택을 제공하거나 초기 혜택 제공
      - 관심 상품들을 분석하여 특별 할인이나 1+1 행사 등 관심을 지속적으로 유도하여 구매빈도를 높임
      - 고객의 구매 주기를 파악하여 적절한 주기를 설정하여 관심 상품에 대한 안내를 개인화하여 고객의 관심유도
      - 현금서비스 이용을 유도하기 위해 낮은 이자율이나 장기적인 대출 서비스 제공 검토 혹은 재무관리 상담 서비스 제공

- 클러스터3(VIP 고객)
   - 총 구매액과 일회성 구매액, 구매 빈도 등 가장 높게 관찰됨
   - 현금서비스 이용은 평균이하로 관찰되며, 고액상품을 일시불로 구매하는 유형
   - 마케팅 전략
      - VIP서비스나 고액상품 구매시 제공되는 혜택을 강조하고, VIP대상 이벤트나 한정된 고가상품 구매 우선권 제공 등 구매를 유도할 수 있는 이벤트 제공   


