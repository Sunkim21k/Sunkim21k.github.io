---
#layout: post
title: 데이콘 프로젝트 - 농산물 가격예측 1-2 데이터 전처리
date: 2024-10-09
description: # 검색어 및 글요약
categories: [Data_analysis, Team_dacon_project1]        # 메인 카테고리, 하위 카테고리(생략가능)
tags:           # 반드시 소문자로 작성, 한글가능
- Data_analysis
- Dacon
#pin: true # 해당글을 홈에서 고정시킬지
#toc: false # 오른쪽 목차 설정
#comments: false # 댓글 설정

#image: # 미리보기 이미지 설정
#  path: /path/to/image # 경로
#  alt: image alternative text # 이미지 설명 (생략가능)

#mermaid: true # 다이어그램 생성 도구 (https://github.com/mermaid-js/mermaid)
#math : true # 수학도구
---

> 데이터분석가로 공부를 하면서, 데이터에 흥미를 갖기위해 관심있는 수강생들과함께 데이콘에 참여해보기로 했습니다. 처음으로 대회를 참여해보는데요, 흥미와 경험목적으로 참여하는만큼, 부담없이 최대한 즐기는 느낌으로 프로젝트를 진행하고자 합니다. 저희가 참여하는 대회는 `국민생활과 밀접한 10가지 농산물 품목의 가격을 예측`해야하는데요, 첫번째로 대회에서 제공하는 데이터들을 살펴보는 시간을 가졌고, **데이터 전처리 정리과정**을 기록으로 남기고자합니다.


## 데이터 전처리


```python
import pandas as pd

# train 폴더 파일 읽기
train_file_path = '/content/drive/MyDrive/데이콘/농산물/train/train.csv'
train = pd.read_csv(train_file_path)

meta_sanji_file_path = '/content/drive/MyDrive/데이콘/농산물/train/meta/TRAIN_산지공판장_2018-2021.csv'
train_sanji = pd.read_csv(meta_sanji_file_path)

meta_jeonguk_file_path = '/content/drive/MyDrive/데이콘/농산물/train/meta/TRAIN_전국도매_2018-2021.csv'
train_jeon = pd.read_csv(meta_jeonguk_file_path)
```


```python
train.head()
```





  <div id="df-c75dabb6-5306-450b-8651-4e72cd044013" class="colab-df-container">
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
      <th>시점</th>
      <th>품목명</th>
      <th>품종명</th>
      <th>거래단위</th>
      <th>등급</th>
      <th>평년 평균가격(원)</th>
      <th>평균가격(원)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>201801상순</td>
      <td>건고추</td>
      <td>화건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>381666.666667</td>
      <td>590000.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>201801중순</td>
      <td>건고추</td>
      <td>화건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>380809.666667</td>
      <td>590000.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>201801하순</td>
      <td>건고추</td>
      <td>화건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>380000.000000</td>
      <td>590000.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>201802상순</td>
      <td>건고추</td>
      <td>화건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>380000.000000</td>
      <td>590000.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>201802중순</td>
      <td>건고추</td>
      <td>화건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>376666.666667</td>
      <td>590000.0</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-c75dabb6-5306-450b-8651-4e72cd044013')"
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
        document.querySelector('#df-c75dabb6-5306-450b-8651-4e72cd044013 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-c75dabb6-5306-450b-8651-4e72cd044013');
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


<div id="df-4d95e16a-63b5-489f-8ee4-8efefdf972f4">
  <button class="colab-df-quickchart" onclick="quickchart('df-4d95e16a-63b5-489f-8ee4-8efefdf972f4')"
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
        document.querySelector('#df-4d95e16a-63b5-489f-8ee4-8efefdf972f4 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
train_sanji.head()
```





  <div id="df-e40401df-3575-43d0-a50e-b2106a2a66c9" class="colab-df-container">
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
      <th>시점</th>
      <th>공판장코드</th>
      <th>공판장명</th>
      <th>품목코드</th>
      <th>품목명</th>
      <th>품종코드</th>
      <th>품종명</th>
      <th>등급코드</th>
      <th>등급명</th>
      <th>총반입량(kg)</th>
      <th>...</th>
      <th>평균가(원/kg)</th>
      <th>중간가(원/kg)</th>
      <th>최저가(원/kg)</th>
      <th>최고가(원/kg)</th>
      <th>경매 건수</th>
      <th>전순 평균가격(원) PreVious SOON</th>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <th>평년 평균가격(원) Common Year SOON</th>
      <th>연도</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>201801상순</td>
      <td>1000000000</td>
      <td>*전국농협공판장</td>
      <td>501</td>
      <td>감자</td>
      <td>50101</td>
      <td>수미</td>
      <td>11</td>
      <td>특</td>
      <td>15470.0</td>
      <td>...</td>
      <td>1712.637363</td>
      <td>1723.961039</td>
      <td>1545.454545</td>
      <td>2320.666667</td>
      <td>7</td>
      <td>1947.350427</td>
      <td>1769.858320</td>
      <td>1023.982379</td>
      <td>0.0</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>1</th>
      <td>201801상순</td>
      <td>1000000000</td>
      <td>*전국농협공판장</td>
      <td>501</td>
      <td>감자</td>
      <td>50101</td>
      <td>수미</td>
      <td>12</td>
      <td>상</td>
      <td>2900.0</td>
      <td>...</td>
      <td>1198.655172</td>
      <td>1252.737207</td>
      <td>893.055556</td>
      <td>1417.857143</td>
      <td>4</td>
      <td>1301.239669</td>
      <td>1348.253676</td>
      <td>571.311475</td>
      <td>0.0</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>2</th>
      <td>201801상순</td>
      <td>1000000000</td>
      <td>*전국농협공판장</td>
      <td>501</td>
      <td>감자</td>
      <td>50199</td>
      <td>기타감자</td>
      <td>13</td>
      <td>보통</td>
      <td>1320.0</td>
      <td>...</td>
      <td>615.000000</td>
      <td>600.000000</td>
      <td>240.000000</td>
      <td>911.875000</td>
      <td>7</td>
      <td>630.851064</td>
      <td>449.166667</td>
      <td>473.032787</td>
      <td>0.0</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>3</th>
      <td>201801상순</td>
      <td>1000000000</td>
      <td>*전국농협공판장</td>
      <td>501</td>
      <td>감자</td>
      <td>50199</td>
      <td>기타감자</td>
      <td>12</td>
      <td>상</td>
      <td>460.0</td>
      <td>...</td>
      <td>544.130435</td>
      <td>365.000000</td>
      <td>200.000000</td>
      <td>1650.000000</td>
      <td>5</td>
      <td>1088.046875</td>
      <td>1129.600000</td>
      <td>734.024390</td>
      <td>0.0</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>4</th>
      <td>201801상순</td>
      <td>1000000000</td>
      <td>*전국농협공판장</td>
      <td>501</td>
      <td>감자</td>
      <td>50199</td>
      <td>기타감자</td>
      <td>11</td>
      <td>특</td>
      <td>30967.0</td>
      <td>...</td>
      <td>1876.454484</td>
      <td>2010.440477</td>
      <td>1598.327715</td>
      <td>2438.720588</td>
      <td>8</td>
      <td>2126.402457</td>
      <td>1779.262728</td>
      <td>1750.544700</td>
      <td>0.0</td>
      <td>2018</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 21 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-e40401df-3575-43d0-a50e-b2106a2a66c9')"
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
        document.querySelector('#df-e40401df-3575-43d0-a50e-b2106a2a66c9 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-e40401df-3575-43d0-a50e-b2106a2a66c9');
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


<div id="df-117156a5-42d5-4790-8d8b-02b4c0f3652d">
  <button class="colab-df-quickchart" onclick="quickchart('df-117156a5-42d5-4790-8d8b-02b4c0f3652d')"
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
        document.querySelector('#df-117156a5-42d5-4790-8d8b-02b4c0f3652d button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
train_jeon.head()
```





  <div id="df-0f83b36e-142d-4b83-a906-9c1935820441" class="colab-df-container">
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
      <th>시점</th>
      <th>시장코드</th>
      <th>시장명</th>
      <th>품목코드</th>
      <th>품목명</th>
      <th>품종코드</th>
      <th>품종명</th>
      <th>총반입량(kg)</th>
      <th>총거래금액(원)</th>
      <th>평균가(원/kg)</th>
      <th>...</th>
      <th>저가(20%) 평균가</th>
      <th>중간가(원/kg)</th>
      <th>최저가(원/kg)</th>
      <th>최고가(원/kg)</th>
      <th>경매 건수</th>
      <th>전순 평균가격(원) PreVious SOON</th>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <th>평년 평균가격(원) Common Year SOON</th>
      <th>연도</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>201801상순</td>
      <td>100000</td>
      <td>*전국도매시장</td>
      <td>501</td>
      <td>감자</td>
      <td>50124</td>
      <td>깐감자</td>
      <td>20.0</td>
      <td>86520</td>
      <td>4326.000000</td>
      <td>...</td>
      <td>4326.000000</td>
      <td>4326.000000</td>
      <td>4326.0</td>
      <td>4326.000000</td>
      <td>1</td>
      <td>0.000000</td>
      <td>4009.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>1</th>
      <td>201801상순</td>
      <td>100000</td>
      <td>*전국도매시장</td>
      <td>501</td>
      <td>감자</td>
      <td>50121</td>
      <td>돼지감자</td>
      <td>12380.0</td>
      <td>11650810</td>
      <td>941.099354</td>
      <td>...</td>
      <td>545.105717</td>
      <td>1010.000000</td>
      <td>200.0</td>
      <td>3000.000000</td>
      <td>117</td>
      <td>11213.358450</td>
      <td>9174.196723</td>
      <td>8167.895632</td>
      <td>0.000000</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>2</th>
      <td>201801상순</td>
      <td>100000</td>
      <td>*전국도매시장</td>
      <td>501</td>
      <td>감자</td>
      <td>50110</td>
      <td>자주감자</td>
      <td>240.0</td>
      <td>158400</td>
      <td>660.000000</td>
      <td>...</td>
      <td>500.000000</td>
      <td>550.000000</td>
      <td>500.0</td>
      <td>1000.000000</td>
      <td>7</td>
      <td>12553.279352</td>
      <td>12612.216445</td>
      <td>24990.324897</td>
      <td>18483.961304</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>3</th>
      <td>201801상순</td>
      <td>100000</td>
      <td>*전국도매시장</td>
      <td>501</td>
      <td>감자</td>
      <td>50111</td>
      <td>가을감자</td>
      <td>10.0</td>
      <td>37500</td>
      <td>3750.000000</td>
      <td>...</td>
      <td>3700.000000</td>
      <td>3750.000000</td>
      <td>3700.0</td>
      <td>3800.000000</td>
      <td>2</td>
      <td>24929.463415</td>
      <td>40365.081269</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>4</th>
      <td>201801상순</td>
      <td>100000</td>
      <td>*전국도매시장</td>
      <td>501</td>
      <td>감자</td>
      <td>50199</td>
      <td>기타감자</td>
      <td>1367301.3</td>
      <td>2403199462</td>
      <td>1757.622451</td>
      <td>...</td>
      <td>955.289668</td>
      <td>1360.453431</td>
      <td>0.0</td>
      <td>10581.081081</td>
      <td>872</td>
      <td>30806.779529</td>
      <td>27661.150770</td>
      <td>23741.953223</td>
      <td>19340.121989</td>
      <td>2018</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 22 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-0f83b36e-142d-4b83-a906-9c1935820441')"
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
        document.querySelector('#df-0f83b36e-142d-4b83-a906-9c1935820441 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-0f83b36e-142d-4b83-a906-9c1935820441');
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


<div id="df-3e592678-1e7b-44e1-9ee3-31f637a5edf3">
  <button class="colab-df-quickchart" onclick="quickchart('df-3e592678-1e7b-44e1-9ee3-31f637a5edf3')"
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
        document.querySelector('#df-3e592678-1e7b-44e1-9ee3-31f637a5edf3 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




### 결측치 처리

1) 중위값    

    - 장점: 계산이 간단하고 이상치에 덜 민감합니다.
    - 단점: 데이터의 분포를 고려하지 않고, 결측치가 많은 경우 정보 손실이 발생할 수 있습니다.    


```python
# # 1) 중위값으로 결측치 처리
# # 가격 정보가 0인 데이터들을 결측치로 변환
# train.replace({'평균가격(원)': 0}, pd.NA, inplace=True)
# train_sanji.replace({'평균가(원/kg)': 0}, pd.NA, inplace=True)
# train_jeon.replace({'평균가(원/kg)': 0}, pd.NA, inplace=True)

# # 품목별 중위값으로 결측치를 채움
# train['평균가격(원)'] = train.groupby('품목명')['평균가격(원)'].transform(lambda x: x.fillna(x.median()))
# train_sanji['평균가(원/kg)'] = train_sanji.groupby('품목명')['평균가(원/kg)'].transform(lambda x: x.fillna(x.median()))
# train_jeon['평균가(원/kg)'] = train_jeon.groupby('품목명')['평균가(원/kg)'].transform(lambda x: x.fillna(x.median()))
```

2) 보간법    

    - 장점: 주변 데이터를 활용하여 결측치를 추정하므로, 데이터의 추세를 반영할 수 있습니다.
    - 단점: 결측치가 많은 경우 정확도가 떨어질 수 있고, 이상치에 민감합니다.    


```python
# # 2) 보간법으로 결측치 처리
# # 시간 순으로 정렬
# train.sort_values(by='시점', inplace=True)
# train_sanji.sort_values(by='시점', inplace=True)
# train_jeon.sort_values(by='시점', inplace=True)

# # 선형 보간법으로 결측치를 채움
# train['평균가격(원)'] = train.groupby('품목명')['평균가격(원)'].transform(lambda x: x.interpolate(method='linear'))
# train_sanji['평균가(원/kg)'] = train_sanji.groupby('품목명')['평균가(원/kg)'].transform(lambda x: x.interpolate(method='linear'))
# train_jeon['평균가(원/kg)'] = train_jeon.groupby('품목명')['평균가(원/kg)'].transform(lambda x: x.interpolate(method='linear'))
```

3) 이동 평균법    

    - 장점: 시계열 데이터의 추세를 반영하고, 노이즈를 줄여 결측치를 추정할 수 있습니다.
    - 단점: window 크기에 따라 성능이 달라질 수 있고, 과거 데이터에 의존하여 미래 예측에 대한 정확도가 떨어질 수 있습니다.     


```python
# # 3) 이동 평균법으로 결측치 처리
# # 품목별 3개월 이동 평균으로 결측치를 채움
# train['평균가격(원)'] = train.groupby('품목명')['평균가격(원)'].transform(lambda x: x.fillna(x.rolling(window=3, center=True).mean()))
# train_sanji['평균가(원/kg)'] = train_sanji.groupby('품목명')['평균가(원/kg)'].transform(lambda x: x.fillna(x.rolling(window=3, center=True).mean()))
# train_jeon['평균가(원/kg)'] = train_jeon.groupby('품목명')['평균가(원/kg)'].transform(lambda x: x.fillna(x.rolling(window=3, center=True).mean()))
```

#### 최적의 결측치 처리 방안

- 품목별 특성, 시점의 특성, 다른 변수와의 관계, 도메인 지식 등을 종합적으로 고려하여 결측치 처리

    - 기본적으로 선형 보간법을 사용. 시계열 데이터의 추세를 반영하면서도, 중위값이나 이동 평균법보다 더 많은 정보를 활용할 수 있기 때문
    - 결측치가 연속적으로 발생한 경우, 이동 평균법을 적용. 연속적인 결측치는 선형 보간법으로 처리하기 어려울 수 있으므로, 주변 데이터의 평균을 활용하는 이동 평균법을 사용


```python
# 가격 정보가 0인 데이터들을 결측치로 변환
train.replace({'평균가격(원)': 0}, pd.NA, inplace=True)
train_sanji.replace({'평균가(원/kg)': 0}, pd.NA, inplace=True)
train_jeon.replace({'평균가(원/kg)': 0}, pd.NA, inplace=True)

# 가격 정보가 0인 데이터들을 결측치로 변환
train['평균가격(원)'] = pd.to_numeric(train['평균가격(원)'], errors='coerce')

# '평균가(원/kg)' 열을 숫자형으로 변환
train_sanji['평균가(원/kg)'] = pd.to_numeric(train_sanji['평균가(원/kg)'], errors='coerce')
train_jeon['평균가(원/kg)'] = pd.to_numeric(train_jeon['평균가(원/kg)'], errors='coerce')

# 시간 순으로 정렬
train.sort_values(by='시점', inplace=True)
train_sanji.sort_values(by='시점', inplace=True)
train_jeon.sort_values(by='시점', inplace=True)

# 품목별 특성을 고려하여 결측치 처리
for 품목 in train['품목명'].unique():
    # 선형 보간법 적용
    train['평균가격(원)'] = train.groupby('품목명')['평균가격(원)'].transform(lambda x: x.interpolate(method='linear'))
    train_sanji['평균가(원/kg)'] = train_sanji.groupby('품목명')['평균가(원/kg)'].transform(lambda x: x.interpolate(method='linear'))
    train_jeon['평균가(원/kg)'] = train_jeon.groupby('품목명')['평균가(원/kg)'].transform(lambda x: x.interpolate(method='linear'))

    # 결측치가 연속적으로 발생한 경우, 이동 평균법 적용
    train['평균가격(원)'] = train.groupby('품목명')['평균가격(원)'].transform(lambda x: x.fillna(x.rolling(window=3, center=True).mean()))
    train_sanji['평균가(원/kg)'] = train_sanji.groupby('품목명')['평균가(원/kg)'].transform(lambda x: x.fillna(x.rolling(window=3, center=True).mean()))
    train_jeon['평균가(원/kg)'] = train_jeon.groupby('품목명')['평균가(원/kg)'].transform(lambda x: x.fillna(x.rolling(window=3, center=True).mean()))
```

### 이상치 처리 : 제거안함
- 농산물 가격은 작황, 수급 상황, 계절적 요인 등에 따라 변동 될수있어 사분위수 범위를 벗어난 가격이라 하더라도, 실제로는 정상적인 가격 변동일 가능성이 높다
- 그렇기때문에 이상치 제거시 농산물 가격 변동 정보가 손실될 수 있다. 농산물 가격에서 극단적인 가격 변동은 예측 모델 학습에 중요한 정보일 수 있다
- 이상치 제거로 훈련 데이터의 분포를 제한하면 과적합 위험이 발생될 수 있다
- 로그 변환, Box-Cox 변환 등을 사용하거나 윈저화(winsorizing)를 통해 극단적인 상위/하위 백분위수(5%이하, 95%이상 등) 값으로 대체 등의 이상치 처리를 고려할 수 있다

- **이상치 처리 대안**
  - 농산물 데이터는 이상치를 제거하거나 변환하는 것보다 `robustscaler : 중앙값과 사분위수 범위를 사용하여 스케일링` 등 스케일링을 추천

### 스케일링 : RobustScaler 방식 사용
- `RobustScaler`는 중앙값과 사분위수 범위를 사용하여 스케일링하는 기법으로 데이터의 정보를 최대한 보존하면서 스케일링을 수행할 수 있다
- 농산물 가격은 이상치가 많이 발생할 수 있기에, 이상치에 덜 민감한 robustscaler 방식을 사용하는 것이 적절해 보인다


```python
# # 정규화 스케일링
# from sklearn.preprocessing import MinMaxScaler

# # MinMaxScaler 객체 생성
# scaler = MinMaxScaler()

# # 스케일링 적용할 컬럼 선택
# num_cols = train.select_dtypes(include=['number']).columns

# # train 데이터에 MinMaxScaler 적용
# train[num_cols] = scaler.fit_transform(train[num_cols])

# # train_sanji 데이터에 MinMaxScaler 적용
# num_cols_sanji = train_sanji.select_dtypes(include=['number']).columns
# # '공판장코드', '품목코드', '품종코드', '등급코드', '연도' 열은 제외합니다.
# num_cols_sanji = num_cols_sanji.drop(['공판장코드', '품목코드', '품종코드', '등급코드', '연도'])
# train_sanji[num_cols_sanji] = scaler.fit_transform(train_sanji[num_cols_sanji])

# # train_jeon 데이터에 MinMaxScaler 적용
# num_cols_jeon = train_jeon.select_dtypes(include=['number']).columns
# # '시장코드', '품목코드', '품종코드', '연도' 열은 제외합니다.
# num_cols_jeon = num_cols_jeon.drop(['시장코드', '품목코드', '품종코드', '연도'])
# train_jeon[num_cols_jeon] = scaler.fit_transform(train_jeon[num_cols_jeon])
```


```python
# # 표준화 스케일링
# from sklearn.preprocessing import StandardScaler

# # StandardScaler 객체 생성
# scaler = StandardScaler()

# # 스케일링 적용할 컬럼 선택
# num_cols = train.select_dtypes(include=['number']).columns

# # train 데이터에 StandardScaler 적용
# train[num_cols] = scaler.fit_transform(train[num_cols])

# # train_sanji 데이터에 StandardScaler 적용
# num_cols_sanji = train_sanji.select_dtypes(include=['number']).columns
# # '공판장코드', '품목코드', '품종코드', '등급코드', '연도' 열은 제외합니다.
# num_cols_sanji = num_cols_sanji.drop(['공판장코드', '품목코드', '품종코드', '등급코드', '연도'])
# train_sanji[num_cols_sanji] = scaler.fit_transform(train_sanji[num_cols_sanji])

# # train_jeon 데이터에 StandardScaler 적용
# num_cols_jeon = train_jeon.select_dtypes(include=['number']).columns
# # '시장코드', '품목코드', '품종코드', '연도' 열은 제외합니다.
# num_cols_jeon = num_cols_jeon.drop(['시장코드', '품목코드', '품종코드', '연도'])
# train_jeon[num_cols_jeon] = scaler.fit_transform(train_jeon[num_cols_jeon])
```


```python
# robustscaler 스케일링
from sklearn.preprocessing import RobustScaler, LabelEncoder

# RobustScaler 객체 생성
scaler = RobustScaler()

# 스케일링 적용할 컬럼 선택
num_cols = train.select_dtypes(include=['number']).columns

# train 데이터에 RobustScaler 적용
train[num_cols] = scaler.fit_transform(train[num_cols])

# train_sanji 데이터에 RobustScaler 적용
num_cols_sanji = train_sanji.select_dtypes(include=['number']).columns
# '공판장코드', '품목코드', '품종코드', '등급코드', '연도' 열은 제외합니다.
num_cols_sanji = num_cols_sanji.drop(['공판장코드', '품목코드', '품종코드', '등급코드', '연도'])
train_sanji[num_cols_sanji] = scaler.fit_transform(train_sanji[num_cols_sanji])

# train_jeon 데이터에 RobustScaler 적용
num_cols_jeon = train_jeon.select_dtypes(include=['number']).columns
# '시장코드', '품목코드', '품종코드', '연도' 열은 제외합니다.
num_cols_jeon = num_cols_jeon.drop(['시장코드', '품목코드', '품종코드', '연도'])
train_jeon[num_cols_jeon] = scaler.fit_transform(train_jeon[num_cols_jeon])
```


```python
# 파생변수 생성
def create_date_features(df):
    # '상순', '중순', '하순'을 숫자로 변환하는 함수
    def convert_soon(soon):
        if soon == '상순':
            return '1'
        elif soon == '중순':
            return '11'
        elif soon == '하순':
            return '21'
        else:
            return soon  # 숫자 형태 그대로 반환

    # '시점' 열에서 '상순', '중순', '하순'을 숫자로 변환
    df['시점'] = df['시점'].astype(str).str[:-2] + df['시점'].astype(str).str[-2:].apply(convert_soon)

    # 변환된 '시점' 열을 datetime 형식으로 변환
    df['시점'] = pd.to_datetime(df['시점'], format='%Y%m%d')

    df['연도'] = df['시점'].dt.year
    df['월'] = df['시점'].dt.month
    df['순'] = df['시점'].dt.day // 10 + 1  # 1, 2, 3으로 변환
    df['계절'] = (df['월'] // 3) % 4  # 0: 봄, 1: 여름, 2: 가을, 3: 겨울
    df['요일'] = df['시점'].dt.dayofweek
    return df

train = create_date_features(train)
train_sanji = create_date_features(train_sanji)
train_jeon = create_date_features(train_jeon)
```


```python
# 2. 품목 및 품종 관련 특징
encoder = LabelEncoder()
train['품목_인코딩'] = encoder.fit_transform(train['품목명'])
train['품종_인코딩'] = encoder.fit_transform(train['품종명'])

# 3. 가격 관련 특징
def create_price_features(df, col_name):
    # 품목별, 연도별, 월별 평균 가격 계산
    df['평균_가격'] = df.groupby(['품목명', '연도', '월'])[col_name].transform('mean')

    # 전년 동월 대비 가격 변화율 계산
    df['전년_동월_대비_가격_변화율'] = df.groupby(['품목명', '월'])[col_name].pct_change(periods=12)

    # 전순 대비 가격 변화율 계산
    df['전순_대비_가격_변화율'] = df.groupby(['품목명'])[col_name].pct_change(periods=1)

    # 3개월 이동 평균 계산
    df['이동_평균_3개월'] = df.groupby(['품목명'])[col_name].rolling(window=3, center=True).mean().reset_index(level=0, drop=True)

    # 6개월 이동 평균 계산
    df['이동_평균_6개월'] = df.groupby(['품목명'])[col_name].rolling(window=6, center=True).mean().reset_index(level=0, drop=True)

    return df

train = create_price_features(train, '평균가격(원)')
train_sanji = create_price_features(train_sanji, '평균가(원/kg)')
train_jeon = create_price_features(train_jeon, '평균가(원/kg)')
```

    <ipython-input-48-19f3df8e9be8>:12: FutureWarning: The default fill_method='ffill' in SeriesGroupBy.pct_change is deprecated and will be removed in a future version. Either fill in any non-leading NA values prior to calling pct_change or specify 'fill_method=None' to not fill NA values.
      df['전년_동월_대비_가격_변화율'] = df.groupby(['품목명', '월'])[col_name].pct_change(periods=12)
    <ipython-input-48-19f3df8e9be8>:15: FutureWarning: The default fill_method='ffill' in SeriesGroupBy.pct_change is deprecated and will be removed in a future version. Either fill in any non-leading NA values prior to calling pct_change or specify 'fill_method=None' to not fill NA values.
      df['전순_대비_가격_변화율'] = df.groupby(['품목명'])[col_name].pct_change(periods=1)
    


```python
# 4. 기타 특징
def create_other_features(df):
    # 품목별 평균 총반입량 계산
    df['평균_총반입량'] = df.groupby('품목명')['총반입량(kg)'].transform('mean')

    # 전년 동월 대비 총반입량 변화율 계산
    df['전년_동월_대비_총반입량_변화율'] = df.groupby(['품목명', '월'])['총반입량(kg)'].pct_change(periods=12)

    # 품목별 평균 경매 건수 계산
    df['평균_경매_건수'] = df.groupby('품목명')['경매 건수'].transform('mean')

    # 전년 동월 대비 경매 건수 변화율 계산
    df['전년_동월_대비_경매_건수_변화율'] = df.groupby(['품목명', '월'])['경매 건수'].pct_change(periods=12)

    return df

train_sanji = create_other_features(train_sanji)
train_jeon = create_other_features(train_jeon)
```


```python
# 데이터 필터링
def filter_data(df, item_name):
    if item_name == '무':
        df = df[df['품종명'].isin(['봄무', '여름무', '가을무', '기타무', '다발무'])]
    elif item_name == '사과':
        df = df[df['품종명'].isin(['홍로', '후지'])]
    elif item_name == '양파':
        df = df[df['품종명'].isin(['양파', '기타양파'])]
    elif item_name == '배추':
        df = df[df['품종명'].isin(['배추', '쌈배추'])]
    elif item_name == '건고추':
        df = df[df['품종명'].isin(['화건', '꼭지건고추'])]
    elif item_name == '깐마늘(국산)':
        df = df[df['품종명'].isin(['깐마늘(국산)', '깐마늘'])]
    elif item_name == '대파':
        df = df[df['품종명'].isin(['대파', '대파(일반)'])]
    elif item_name == '감자':
        df = df[df['품종명'].isin(['감자 수미', '수미'])]
    elif item_name == '배':
        df = df[df['품종명'].isin(['신고', '기타배'])]
    elif item_name == '상추':
        df = df[df['품종명'].isin(['청상추', '청', '적상추'])]

    return df
```
