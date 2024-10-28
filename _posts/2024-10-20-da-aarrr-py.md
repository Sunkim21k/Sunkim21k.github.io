---
#layout: post
title: 파이썬 데이터분석 - aarrr 분석 실습
date: 2024-10-20
description: # 검색어 및 글요약
categories: [Data_analysis, Python_DA_Library]        # 메인 카테고리, 하위 카테고리(생략가능)
tags:           # 반드시 소문자로 작성, 한글가능
- AARRR
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


```python
import os
import pandas as pd
import numpy as np
import seaborn as sns
```

## 데이터 준비하기 + 전처리
- 실습내용 : 브라질의 이커머스 기업 Olist 데이터분석 (EDA + AARRR)
- 데이터출처 : [캐글](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## 각 테이블 별로 간단한 EDA를 진행해보고 각 테이블이 어떤 의미와 특성을 가지고 있는지 파악하고, 테이블 간의 관계도 파악해보기

### 1. Customers (olist_customers_dataset.csv)

| 컬럼 이름                | 데이터 타입 | 설명                   |
| ------------------------ | ----------- | ---------------------- |
| customer_id              | VARCHAR     | 고객 고유 식별자       |
| customer_unique_id       | VARCHAR     | 고객의 고유 ID         |
| customer_zip_code_prefix | INT         | 고객의 우편번호 앞부분 |
| customer_city            | VARCHAR     | 고객의 도시 정보       |
| customer_state           | VARCHAR     | 고객의 주 정보         |



```python
df = pd.read_csv('/content/drive/MyDrive/archive/olist_customers_dataset.csv')
df
```





  <div id="df-0f7258d7-159b-4462-adad-1b058286a6b2" class="colab-df-container">
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
      <th>customer_id</th>
      <th>customer_unique_id</th>
      <th>customer_zip_code_prefix</th>
      <th>customer_city</th>
      <th>customer_state</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>06b8999e2fba1a1fbc88172c00ba8bc7</td>
      <td>861eff4711a542e4b93843c6dd7febb0</td>
      <td>14409</td>
      <td>franca</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>1</th>
      <td>18955e83d337fd6b2def6b18a428ac77</td>
      <td>290c77bc529b7ac935b93aa66c333dc3</td>
      <td>9790</td>
      <td>sao bernardo do campo</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>2</th>
      <td>4e7b3e00288586ebd08712fdd0374a03</td>
      <td>060e732b5b29e8181a18229c7b0b2b5e</td>
      <td>1151</td>
      <td>sao paulo</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>3</th>
      <td>b2b6027bc5c5109e529d4dc6358b12c3</td>
      <td>259dac757896d24d7702b9acbbff3f3c</td>
      <td>8775</td>
      <td>mogi das cruzes</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4f2d8ab171c80ec8364f7c12e35b23ad</td>
      <td>345ecd01c38d18a9036ed96c73b8d066</td>
      <td>13056</td>
      <td>campinas</td>
      <td>SP</td>
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
      <th>99436</th>
      <td>17ddf5dd5d51696bb3d7c6291687be6f</td>
      <td>1a29b476fee25c95fbafc67c5ac95cf8</td>
      <td>3937</td>
      <td>sao paulo</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>99437</th>
      <td>e7b71a9017aa05c9a7fd292d714858e8</td>
      <td>d52a67c98be1cf6a5c84435bd38d095d</td>
      <td>6764</td>
      <td>taboao da serra</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>99438</th>
      <td>5e28dfe12db7fb50a4b2f691faecea5e</td>
      <td>e9f50caf99f032f0bf3c55141f019d99</td>
      <td>60115</td>
      <td>fortaleza</td>
      <td>CE</td>
    </tr>
    <tr>
      <th>99439</th>
      <td>56b18e2166679b8a959d72dd06da27f9</td>
      <td>73c2643a0a458b49f58cea58833b192e</td>
      <td>92120</td>
      <td>canoas</td>
      <td>RS</td>
    </tr>
    <tr>
      <th>99440</th>
      <td>274fa6071e5e17fe303b9748641082c8</td>
      <td>84732c5050c01db9b23e19ba39899398</td>
      <td>6703</td>
      <td>cotia</td>
      <td>SP</td>
    </tr>
  </tbody>
</table>
<p>99441 rows × 5 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-0f7258d7-159b-4462-adad-1b058286a6b2')"
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
        document.querySelector('#df-0f7258d7-159b-4462-adad-1b058286a6b2 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-0f7258d7-159b-4462-adad-1b058286a6b2');
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


<div id="df-8dd58f36-e968-499f-a984-5adf73bb1391">
  <button class="colab-df-quickchart" onclick="quickchart('df-8dd58f36-e968-499f-a984-5adf73bb1391')"
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
        document.querySelector('#df-8dd58f36-e968-499f-a984-5adf73bb1391 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_41a6caba-802b-43ff-8617-9d882e04abb3">
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
        document.querySelector('#id_41a6caba-802b-43ff-8617-9d882e04abb3 button.colab-df-generate');
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
      <th>customer_id</th>
      <td>0</td>
    </tr>
    <tr>
      <th>customer_unique_id</th>
      <td>0</td>
    </tr>
    <tr>
      <th>customer_zip_code_prefix</th>
      <td>0</td>
    </tr>
    <tr>
      <th>customer_city</th>
      <td>0</td>
    </tr>
    <tr>
      <th>customer_state</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
# 중복값 확인
df.duplicated().sum()
```




    0




```python
# 중복값 확인
df['customer_id'].duplicated().sum()
```




    0




```python
df['customer_unique_id'].duplicated().sum()
```




    3345




```python
df[df['customer_unique_id'].duplicated(keep=False)].sort_values(by=['customer_unique_id'])
```





  <div id="df-4bc46886-534c-4a74-b853-6167756caef5" class="colab-df-container">
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
      <th>customer_id</th>
      <th>customer_unique_id</th>
      <th>customer_zip_code_prefix</th>
      <th>customer_city</th>
      <th>customer_state</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>35608</th>
      <td>24b0e2bd287e47d54d193e7bbb51103f</td>
      <td>00172711b30d52eea8b313a7f2cced02</td>
      <td>45200</td>
      <td>jequie</td>
      <td>BA</td>
    </tr>
    <tr>
      <th>19299</th>
      <td>1afe8a9c67eec3516c09a8bdcc539090</td>
      <td>00172711b30d52eea8b313a7f2cced02</td>
      <td>45200</td>
      <td>jequie</td>
      <td>BA</td>
    </tr>
    <tr>
      <th>20023</th>
      <td>1b4a75b3478138e99902678254b260f4</td>
      <td>004288347e5e88a27ded2bb23747066c</td>
      <td>26220</td>
      <td>nova iguacu</td>
      <td>RJ</td>
    </tr>
    <tr>
      <th>22066</th>
      <td>f6efe5d5c7b85e12355f9d5c3db46da2</td>
      <td>004288347e5e88a27ded2bb23747066c</td>
      <td>26220</td>
      <td>nova iguacu</td>
      <td>RJ</td>
    </tr>
    <tr>
      <th>72451</th>
      <td>49cf243e0d353cd418ca77868e24a670</td>
      <td>004b45ec5c64187465168251cd1c9c2f</td>
      <td>57055</td>
      <td>maceio</td>
      <td>AL</td>
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
      <th>75057</th>
      <td>1ae563fdfa500d150be6578066d83998</td>
      <td>ff922bdd6bafcdf99cb90d7f39cea5b3</td>
      <td>17340</td>
      <td>barra bonita</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>27992</th>
      <td>bec0bf00ac5bee64ce8ef5283051a70c</td>
      <td>ff922bdd6bafcdf99cb90d7f39cea5b3</td>
      <td>17340</td>
      <td>barra bonita</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>79859</th>
      <td>d064be88116eb8b958727aec4cf56a59</td>
      <td>ff922bdd6bafcdf99cb90d7f39cea5b3</td>
      <td>17340</td>
      <td>barra bonita</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>64323</th>
      <td>4b231c90751c27521f7ee27ed2dc3b8f</td>
      <td>ffe254cc039740e17dd15a5305035928</td>
      <td>37640</td>
      <td>extrema</td>
      <td>MG</td>
    </tr>
    <tr>
      <th>12133</th>
      <td>0088395699ea0fcd459bfbef084997db</td>
      <td>ffe254cc039740e17dd15a5305035928</td>
      <td>37640</td>
      <td>extrema</td>
      <td>MG</td>
    </tr>
  </tbody>
</table>
<p>6342 rows × 5 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-4bc46886-534c-4a74-b853-6167756caef5')"
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
        document.querySelector('#df-4bc46886-534c-4a74-b853-6167756caef5 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-4bc46886-534c-4a74-b853-6167756caef5');
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


<div id="df-242291dc-7512-43e2-a7f9-189779137760">
  <button class="colab-df-quickchart" onclick="quickchart('df-242291dc-7512-43e2-a7f9-189779137760')"
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
        document.querySelector('#df-242291dc-7512-43e2-a7f9-189779137760 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
# 보유 고객중 2번이상 구매를 시도한 고객 비중은?
round(df['customer_unique_id'].duplicated().sum() / (df.shape[0] - df['customer_unique_id'].duplicated().sum()) * 100,2)
```




    3.48



- 고객마다 고유 customer_unique_id가 있으며, 주문마다 고유의 customer_id가 생성된다
- customer_unique_id 중복값이 존재한다 → **2번이상 구매를 시도한 고객**(재주문 혹은 주문취소포함 등) → **3,345명의 고객이 관찰됨 (약 3.5%)**
- **대부분 1회성 고객**임을 알 수 있다 → 재구매율을 높일지 회원수 확보를 높일지 전략을 세울필요가 있음
- customer_id컬럼과 orders데이터의 order_id컬럼이 1:1 매칭된다. 특정 고객이 주문하면 주문아이디와 매칭되는 커스텀아이디를 부여한다. 그렇기때문에 customer_id가 중복되는 경우는 존재하지 않는다


```python
# 'customer_city'와 'customer_state' 상위 10 확인
city_counts = df['customer_city'].value_counts().head(10)
state_counts = df['customer_state'].value_counts().head(10)

# subplot 설정
fig, axs = plt.subplots(1, 2, figsize=(12, 5))

# 'customer_city' 그래프
axs[0].barh(city_counts.index[::-1], city_counts.values[::-1], color='skyblue')
axs[0].set_title('상위 10개 고객 도시')

# 빈도수 표시
for index, value in enumerate(city_counts.values[::-1]):
    axs[0].text(value, index, str(value))

axs[0].spines['top'].set_visible(False)
axs[0].spines['right'].set_visible(False)

# 'customer_state' 그래프
axs[1].barh(state_counts.index[::-1], state_counts.values[::-1], color='salmon')
axs[1].set_title('상위 10개 고객 주')

# 빈도수 표시
for index, value in enumerate(state_counts.values[::-1]):
    axs[1].text(value, index, str(value))

axs[1].spines['top'].set_visible(False)
axs[1].spines['right'].set_visible(False)

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_15_0.png)
    


- olist고객 중 약 70%는 3개 주 (SP, RJ, MG)에 거주하고있고, 상파울로주(SP)는 전체 고객 중 43%가 거주하고있다

### 2. Orders (olist_orders_dataset.csv)

| 컬럼 이름                     | 데이터 타입 | 설명                                |
| ----------------------------- | ----------- | ----------------------------------- |
| order_id                      | VARCHAR     | 주문 고유 식별자                    |
| customer_id                   | VARCHAR     | 고객 테이블과 연결되는 고객 식별자  |
| order_status                  | VARCHAR     | 주문 상태 (배송 완료, 결제 완료 등) |
| order_purchase_timestamp      | TIMESTAMP   | 고객이 주문한 시각                  |
| order_delivered_carrier_date  | TIMESTAMP   | 운송사가 배송을 시작한 시각         |
| order_delivered_customer_date | TIMESTAMP   | 고객에게 최종 배송된 날짜           |
| order_estimated_delivery_date | TIMESTAMP   | 예상 배송 날짜                      |



```python
df2 = pd.read_csv('/content/drive/MyDrive/archive/olist_orders_dataset.csv')
df2
```





  <div id="df-f18dbd04-e8f2-4f08-b761-f52cedef410b" class="colab-df-container">
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
      <th>order_id</th>
      <th>customer_id</th>
      <th>order_status</th>
      <th>order_purchase_timestamp</th>
      <th>order_approved_at</th>
      <th>order_delivered_carrier_date</th>
      <th>order_delivered_customer_date</th>
      <th>order_estimated_delivery_date</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>e481f51cbdc54678b7cc49136f2d6af7</td>
      <td>9ef432eb6251297304e76186b10a928d</td>
      <td>delivered</td>
      <td>2017-10-02 10:56:33</td>
      <td>2017-10-02 11:07:15</td>
      <td>2017-10-04 19:55:00</td>
      <td>2017-10-10 21:25:13</td>
      <td>2017-10-18 00:00:00</td>
    </tr>
    <tr>
      <th>1</th>
      <td>53cdb2fc8bc7dce0b6741e2150273451</td>
      <td>b0830fb4747a6c6d20dea0b8c802d7ef</td>
      <td>delivered</td>
      <td>2018-07-24 20:41:37</td>
      <td>2018-07-26 03:24:27</td>
      <td>2018-07-26 14:31:00</td>
      <td>2018-08-07 15:27:45</td>
      <td>2018-08-13 00:00:00</td>
    </tr>
    <tr>
      <th>2</th>
      <td>47770eb9100c2d0c44946d9cf07ec65d</td>
      <td>41ce2a54c0b03bf3443c3d931a367089</td>
      <td>delivered</td>
      <td>2018-08-08 08:38:49</td>
      <td>2018-08-08 08:55:23</td>
      <td>2018-08-08 13:50:00</td>
      <td>2018-08-17 18:06:29</td>
      <td>2018-09-04 00:00:00</td>
    </tr>
    <tr>
      <th>3</th>
      <td>949d5b44dbf5de918fe9c16f97b45f8a</td>
      <td>f88197465ea7920adcdbec7375364d82</td>
      <td>delivered</td>
      <td>2017-11-18 19:28:06</td>
      <td>2017-11-18 19:45:59</td>
      <td>2017-11-22 13:39:59</td>
      <td>2017-12-02 00:28:42</td>
      <td>2017-12-15 00:00:00</td>
    </tr>
    <tr>
      <th>4</th>
      <td>ad21c59c0840e6cb83a9ceb5573f8159</td>
      <td>8ab97904e6daea8866dbdbc4fb7aad2c</td>
      <td>delivered</td>
      <td>2018-02-13 21:18:39</td>
      <td>2018-02-13 22:20:29</td>
      <td>2018-02-14 19:46:34</td>
      <td>2018-02-16 18:17:02</td>
      <td>2018-02-26 00:00:00</td>
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
    </tr>
    <tr>
      <th>99436</th>
      <td>9c5dedf39a927c1b2549525ed64a053c</td>
      <td>39bd1228ee8140590ac3aca26f2dfe00</td>
      <td>delivered</td>
      <td>2017-03-09 09:54:05</td>
      <td>2017-03-09 09:54:05</td>
      <td>2017-03-10 11:18:03</td>
      <td>2017-03-17 15:08:01</td>
      <td>2017-03-28 00:00:00</td>
    </tr>
    <tr>
      <th>99437</th>
      <td>63943bddc261676b46f01ca7ac2f7bd8</td>
      <td>1fca14ff2861355f6e5f14306ff977a7</td>
      <td>delivered</td>
      <td>2018-02-06 12:58:58</td>
      <td>2018-02-06 13:10:37</td>
      <td>2018-02-07 23:22:42</td>
      <td>2018-02-28 17:37:56</td>
      <td>2018-03-02 00:00:00</td>
    </tr>
    <tr>
      <th>99438</th>
      <td>83c1379a015df1e13d02aae0204711ab</td>
      <td>1aa71eb042121263aafbe80c1b562c9c</td>
      <td>delivered</td>
      <td>2017-08-27 14:46:43</td>
      <td>2017-08-27 15:04:16</td>
      <td>2017-08-28 20:52:26</td>
      <td>2017-09-21 11:24:17</td>
      <td>2017-09-27 00:00:00</td>
    </tr>
    <tr>
      <th>99439</th>
      <td>11c177c8e97725db2631073c19f07b62</td>
      <td>b331b74b18dc79bcdf6532d51e1637c1</td>
      <td>delivered</td>
      <td>2018-01-08 21:28:27</td>
      <td>2018-01-08 21:36:21</td>
      <td>2018-01-12 15:35:03</td>
      <td>2018-01-25 23:32:54</td>
      <td>2018-02-15 00:00:00</td>
    </tr>
    <tr>
      <th>99440</th>
      <td>66dea50a8b16d9b4dee7af250b4be1a5</td>
      <td>edb027a75a1449115f6b43211ae02a24</td>
      <td>delivered</td>
      <td>2018-03-08 20:57:30</td>
      <td>2018-03-09 11:20:28</td>
      <td>2018-03-09 22:11:59</td>
      <td>2018-03-16 13:08:30</td>
      <td>2018-04-03 00:00:00</td>
    </tr>
  </tbody>
</table>
<p>99441 rows × 8 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-f18dbd04-e8f2-4f08-b761-f52cedef410b')"
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
        document.querySelector('#df-f18dbd04-e8f2-4f08-b761-f52cedef410b button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-f18dbd04-e8f2-4f08-b761-f52cedef410b');
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


<div id="df-f4516924-4e64-4aa8-9860-94115928f7af">
  <button class="colab-df-quickchart" onclick="quickchart('df-f4516924-4e64-4aa8-9860-94115928f7af')"
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
        document.querySelector('#df-f4516924-4e64-4aa8-9860-94115928f7af button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_e87e972e-7503-49bb-9bee-1862a9e67ce2">
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
    <button class="colab-df-generate" onclick="generateWithVariable('df2')"
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
        document.querySelector('#id_e87e972e-7503-49bb-9bee-1862a9e67ce2 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('df2');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 결측치 확인
df2.isna().sum().sort_values(ascending=False)
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
      <th>order_delivered_customer_date</th>
      <td>2965</td>
    </tr>
    <tr>
      <th>order_delivered_carrier_date</th>
      <td>1783</td>
    </tr>
    <tr>
      <th>order_approved_at</th>
      <td>160</td>
    </tr>
    <tr>
      <th>order_id</th>
      <td>0</td>
    </tr>
    <tr>
      <th>customer_id</th>
      <td>0</td>
    </tr>
    <tr>
      <th>order_status</th>
      <td>0</td>
    </tr>
    <tr>
      <th>order_purchase_timestamp</th>
      <td>0</td>
    </tr>
    <tr>
      <th>order_estimated_delivery_date</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
df2[df2['order_delivered_customer_date'].isna()]
```





  <div id="df-95f7a39a-7406-49c1-a0c0-3ba18727e8fb" class="colab-df-container">
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
      <th>order_id</th>
      <th>customer_id</th>
      <th>order_status</th>
      <th>order_purchase_timestamp</th>
      <th>order_approved_at</th>
      <th>order_delivered_carrier_date</th>
      <th>order_delivered_customer_date</th>
      <th>order_estimated_delivery_date</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>6</th>
      <td>136cce7faa42fdb2cefd53fdc79a6098</td>
      <td>ed0271e0b7da060a393796590e7b737a</td>
      <td>invoiced</td>
      <td>2017-04-11 12:22:08</td>
      <td>2017-04-13 13:25:17</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-05-09 00:00:00</td>
    </tr>
    <tr>
      <th>44</th>
      <td>ee64d42b8cf066f35eac1cf57de1aa85</td>
      <td>caded193e8e47b8362864762a83db3c5</td>
      <td>shipped</td>
      <td>2018-06-04 16:44:48</td>
      <td>2018-06-05 04:31:18</td>
      <td>2018-06-05 14:32:00</td>
      <td>NaN</td>
      <td>2018-06-28 00:00:00</td>
    </tr>
    <tr>
      <th>103</th>
      <td>0760a852e4e9d89eb77bf631eaaf1c84</td>
      <td>d2a79636084590b7465af8ab374a8cf5</td>
      <td>invoiced</td>
      <td>2018-08-03 17:44:42</td>
      <td>2018-08-07 06:15:14</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-08-21 00:00:00</td>
    </tr>
    <tr>
      <th>128</th>
      <td>15bed8e2fec7fdbadb186b57c46c92f2</td>
      <td>f3f0e613e0bdb9c7cee75504f0f90679</td>
      <td>processing</td>
      <td>2017-09-03 14:22:03</td>
      <td>2017-09-03 14:30:09</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-10-03 00:00:00</td>
    </tr>
    <tr>
      <th>154</th>
      <td>6942b8da583c2f9957e990d028607019</td>
      <td>52006a9383bf149a4fb24226b173106f</td>
      <td>shipped</td>
      <td>2018-01-10 11:33:07</td>
      <td>2018-01-11 02:32:30</td>
      <td>2018-01-11 19:39:23</td>
      <td>NaN</td>
      <td>2018-02-07 00:00:00</td>
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
    </tr>
    <tr>
      <th>99283</th>
      <td>3a3cddda5a7c27851bd96c3313412840</td>
      <td>0b0d6095c5555fe083844281f6b093bb</td>
      <td>canceled</td>
      <td>2018-08-31 16:13:44</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-10-01 00:00:00</td>
    </tr>
    <tr>
      <th>99313</th>
      <td>e9e64a17afa9653aacf2616d94c005b8</td>
      <td>b4cd0522e632e481f8eaf766a2646e86</td>
      <td>processing</td>
      <td>2018-01-05 23:07:24</td>
      <td>2018-01-09 07:18:05</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-02-06 00:00:00</td>
    </tr>
    <tr>
      <th>99347</th>
      <td>a89abace0dcc01eeb267a9660b5ac126</td>
      <td>2f0524a7b1b3845a1a57fcf3910c4333</td>
      <td>canceled</td>
      <td>2018-09-06 18:45:47</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-09-27 00:00:00</td>
    </tr>
    <tr>
      <th>99348</th>
      <td>a69ba794cc7deb415c3e15a0a3877e69</td>
      <td>726f0894b5becdf952ea537d5266e543</td>
      <td>unavailable</td>
      <td>2017-08-23 16:28:04</td>
      <td>2017-08-28 15:44:47</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-09-15 00:00:00</td>
    </tr>
    <tr>
      <th>99415</th>
      <td>5fabc81b6322c8443648e1b21a6fef21</td>
      <td>32c9df889d41b0ee8309a5efb6855dcb</td>
      <td>unavailable</td>
      <td>2017-10-10 10:50:03</td>
      <td>2017-10-14 18:35:57</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-10-23 00:00:00</td>
    </tr>
  </tbody>
</table>
<p>2965 rows × 8 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-95f7a39a-7406-49c1-a0c0-3ba18727e8fb')"
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
        document.querySelector('#df-95f7a39a-7406-49c1-a0c0-3ba18727e8fb button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-95f7a39a-7406-49c1-a0c0-3ba18727e8fb');
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


<div id="df-aee06c31-76f0-46bc-96dd-dadea6edee62">
  <button class="colab-df-quickchart" onclick="quickchart('df-aee06c31-76f0-46bc-96dd-dadea6edee62')"
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
        document.querySelector('#df-aee06c31-76f0-46bc-96dd-dadea6edee62 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
mask1 = df2[df2['order_delivered_customer_date'].isna()]
mask1['order_status'].value_counts()
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
      <th>order_status</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>shipped</th>
      <td>1107</td>
    </tr>
    <tr>
      <th>canceled</th>
      <td>619</td>
    </tr>
    <tr>
      <th>unavailable</th>
      <td>609</td>
    </tr>
    <tr>
      <th>invoiced</th>
      <td>314</td>
    </tr>
    <tr>
      <th>processing</th>
      <td>301</td>
    </tr>
    <tr>
      <th>delivered</th>
      <td>8</td>
    </tr>
    <tr>
      <th>created</th>
      <td>5</td>
    </tr>
    <tr>
      <th>approved</th>
      <td>2</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
mask1[mask1['order_status'] == 'delivered']
```





  <div id="df-a7bda51e-24d1-4763-9e7a-3829720ede07" class="colab-df-container">
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
      <th>order_id</th>
      <th>customer_id</th>
      <th>order_status</th>
      <th>order_purchase_timestamp</th>
      <th>order_approved_at</th>
      <th>order_delivered_carrier_date</th>
      <th>order_delivered_customer_date</th>
      <th>order_estimated_delivery_date</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>3002</th>
      <td>2d1e2d5bf4dc7227b3bfebb81328c15f</td>
      <td>ec05a6d8558c6455f0cbbd8a420ad34f</td>
      <td>delivered</td>
      <td>2017-11-28 17:44:07</td>
      <td>2017-11-28 17:56:40</td>
      <td>2017-11-30 18:12:23</td>
      <td>NaN</td>
      <td>2017-12-18 00:00:00</td>
    </tr>
    <tr>
      <th>20618</th>
      <td>f5dd62b788049ad9fc0526e3ad11a097</td>
      <td>5e89028e024b381dc84a13a3570decb4</td>
      <td>delivered</td>
      <td>2018-06-20 06:58:43</td>
      <td>2018-06-20 07:19:05</td>
      <td>2018-06-25 08:05:00</td>
      <td>NaN</td>
      <td>2018-07-16 00:00:00</td>
    </tr>
    <tr>
      <th>43834</th>
      <td>2ebdfc4f15f23b91474edf87475f108e</td>
      <td>29f0540231702fda0cfdee0a310f11aa</td>
      <td>delivered</td>
      <td>2018-07-01 17:05:11</td>
      <td>2018-07-01 17:15:12</td>
      <td>2018-07-03 13:57:00</td>
      <td>NaN</td>
      <td>2018-07-30 00:00:00</td>
    </tr>
    <tr>
      <th>79263</th>
      <td>e69f75a717d64fc5ecdfae42b2e8e086</td>
      <td>cfda40ca8dd0a5d486a9635b611b398a</td>
      <td>delivered</td>
      <td>2018-07-01 22:05:55</td>
      <td>2018-07-01 22:15:14</td>
      <td>2018-07-03 13:57:00</td>
      <td>NaN</td>
      <td>2018-07-30 00:00:00</td>
    </tr>
    <tr>
      <th>82868</th>
      <td>0d3268bad9b086af767785e3f0fc0133</td>
      <td>4f1d63d35fb7c8999853b2699f5c7649</td>
      <td>delivered</td>
      <td>2018-07-01 21:14:02</td>
      <td>2018-07-01 21:29:54</td>
      <td>2018-07-03 09:28:00</td>
      <td>NaN</td>
      <td>2018-07-24 00:00:00</td>
    </tr>
    <tr>
      <th>92643</th>
      <td>2d858f451373b04fb5c984a1cc2defaf</td>
      <td>e08caf668d499a6d643dafd7c5cc498a</td>
      <td>delivered</td>
      <td>2017-05-25 23:22:43</td>
      <td>2017-05-25 23:30:16</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-06-23 00:00:00</td>
    </tr>
    <tr>
      <th>97647</th>
      <td>ab7c89dc1bf4a1ead9d6ec1ec8968a84</td>
      <td>dd1b84a7286eb4524d52af4256c0ba24</td>
      <td>delivered</td>
      <td>2018-06-08 12:09:39</td>
      <td>2018-06-08 12:36:39</td>
      <td>2018-06-12 14:10:00</td>
      <td>NaN</td>
      <td>2018-06-26 00:00:00</td>
    </tr>
    <tr>
      <th>98038</th>
      <td>20edc82cf5400ce95e1afacc25798b31</td>
      <td>28c37425f1127d887d7337f284080a0f</td>
      <td>delivered</td>
      <td>2018-06-27 16:09:12</td>
      <td>2018-06-27 16:29:30</td>
      <td>2018-07-03 19:26:00</td>
      <td>NaN</td>
      <td>2018-07-19 00:00:00</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-a7bda51e-24d1-4763-9e7a-3829720ede07')"
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
        document.querySelector('#df-a7bda51e-24d1-4763-9e7a-3829720ede07 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-a7bda51e-24d1-4763-9e7a-3829720ede07');
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


<div id="df-706c66c2-433f-4b3d-87ac-d71aacf9e424">
  <button class="colab-df-quickchart" onclick="quickchart('df-706c66c2-433f-4b3d-87ac-d71aacf9e424')"
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
        document.querySelector('#df-706c66c2-433f-4b3d-87ac-d71aacf9e424 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
mask2 = df2[~df2['order_delivered_customer_date'].isna()]
mask2['order_status'].value_counts()
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
      <th>order_status</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>delivered</th>
      <td>96470</td>
    </tr>
    <tr>
      <th>canceled</th>
      <td>6</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
mask3 = df2[df2['order_delivered_carrier_date'].isna()]
mask3['order_status'].value_counts()
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
      <th>order_status</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>unavailable</th>
      <td>609</td>
    </tr>
    <tr>
      <th>canceled</th>
      <td>550</td>
    </tr>
    <tr>
      <th>invoiced</th>
      <td>314</td>
    </tr>
    <tr>
      <th>processing</th>
      <td>301</td>
    </tr>
    <tr>
      <th>created</th>
      <td>5</td>
    </tr>
    <tr>
      <th>approved</th>
      <td>2</td>
    </tr>
    <tr>
      <th>delivered</th>
      <td>2</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
mask4 = df2[df2['order_approved_at'].isna()]
mask4['order_status'].value_counts()
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
      <th>order_status</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>canceled</th>
      <td>141</td>
    </tr>
    <tr>
      <th>delivered</th>
      <td>14</td>
    </tr>
    <tr>
      <th>created</th>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>



- 일부 결측치가 관찰(배달이 완료됐는데 배송날짜가 안적혀있다던지 등)되었지만, 그 수가 100개 미만이고, 해당 결측치들에서 활용할수있는 유의미한 정보가(어떤것을 주문하고 판매됐고 가격, 카테고리 정보 등) 남아있다고 판단하기에 결측치를 제거하지않음


```python
# 중복값 확인
df2.duplicated().sum()
```




    0




```python
df2['order_id'].duplicated().sum() + df2['customer_id'].duplicated().sum()
```




    0




```python
# customers 와 orders 데이터 customer_id 확인
merged_check_customer = pd.merge(df, df2, on='customer_id', how='outer', indicator=True)
merged_check_customer['_merge'].value_counts()
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
      <th>_merge</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>both</th>
      <td>99441</td>
    </tr>
    <tr>
      <th>left_only</th>
      <td>0</td>
    </tr>
    <tr>
      <th>right_only</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>



- customers와 orders 데이터의 customer_id는 1:1로 정확히 매칭된다
- 다른데이터들과 order_id와 customer_id로 연결되고있다


```python
df2['order_status'].value_counts()
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
      <th>order_status</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>delivered</th>
      <td>96478</td>
    </tr>
    <tr>
      <th>shipped</th>
      <td>1107</td>
    </tr>
    <tr>
      <th>canceled</th>
      <td>625</td>
    </tr>
    <tr>
      <th>unavailable</th>
      <td>609</td>
    </tr>
    <tr>
      <th>invoiced</th>
      <td>314</td>
    </tr>
    <tr>
      <th>processing</th>
      <td>301</td>
    </tr>
    <tr>
      <th>created</th>
      <td>5</td>
    </tr>
    <tr>
      <th>approved</th>
      <td>2</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
round(df2[df2['order_status'] == 'canceled'].shape[0] / df2.shape[0] * 100, 2)
```




    0.63




```python
round(((df2[df2['order_status'] == 'canceled'].shape[0]) + (df2[df2['order_status'] == 'unavailable'].shape[0])) / df2.shape[0] * 100, 2)
```




    1.24



- 대부분의 주문이 배달이 완료된 상황이고, 취소율은 0.6%(unavailable 포함시 1.2%)로 낮은수준으로 관찰됨


```python
# 'order_purchase_timestamp' 컬럼을 datetime 형식으로 변환
df2['order_purchase_timestamp'] = pd.to_datetime(df2['order_purchase_timestamp'])

# 연도와 월별로 그룹화하여 주문 수 계산
monthly_orders = df2.groupby(df2['order_purchase_timestamp'].dt.to_period('M')).size()

# 시각화
plt.figure(figsize=(10, 6))
bars = plt.bar(monthly_orders.index.astype(str), monthly_orders.values, color='skyblue')

# 주문 수 표시
for bar in bars:
    yval = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2, yval, str(yval), ha='center', va='bottom')

plt.title('월별 주문 수')
plt.xlabel('연도-월')
plt.ylabel('주문 수')
plt.xticks(rotation=45)
plt.grid(axis='y')

# 레이아웃 조정 및 그래프 표시
plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_35_0.png)
    


- 월별 주문수는 상승곡선을 보이고 있음


```python
# 파생변수 배송기간 생성 (고객 배송일 - 고객 주문일 )
df2['order_delivered_customer_date'] = pd.to_datetime(df2['order_delivered_customer_date'])
df2['delivery_time'] = (df2['order_delivered_customer_date'] - df2['order_purchase_timestamp']).dt.days
```


```python
plt.figure(figsize=(12, 6))
n, bins, patches = plt.hist(df2['delivery_time'], bins=range(0, int(df2['delivery_time'].max()) + 5, 5), color='skyblue', edgecolor='black')

for count, x in zip(n, bins):
    plt.text(x + 2.5, count, str(int(count)), ha='center', va='bottom')

plt.title('배송 기간 분포 (5일 단위)')
plt.xlabel('배송 기간 (일)')
plt.ylabel('주문 수')
plt.xticks(range(0, int(df2['delivery_time'].max()) + 5, 5))
plt.grid(axis='y')

# 레이아웃 조정 및 그래프 표시
plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_38_0.png)
    


- 대부분 1달 이내 배달이 완료되고 5일~10일 분포가 가장 많음. 1달 뒤에 배송되는것도 일부 존재하고 배송에 2달 걸리는 배달도 다수있음


```python
merged_df_delivery = pd.merge(df, df2[['customer_id', 'delivery_time']], on='customer_id', how='left')
merged_df_delivery
```





  <div id="df-441d9168-382f-4621-b7e5-1564202c112f" class="colab-df-container">
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
      <th>customer_id</th>
      <th>customer_unique_id</th>
      <th>customer_zip_code_prefix</th>
      <th>customer_city</th>
      <th>customer_state</th>
      <th>delivery_time</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>06b8999e2fba1a1fbc88172c00ba8bc7</td>
      <td>861eff4711a542e4b93843c6dd7febb0</td>
      <td>14409</td>
      <td>franca</td>
      <td>SP</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>18955e83d337fd6b2def6b18a428ac77</td>
      <td>290c77bc529b7ac935b93aa66c333dc3</td>
      <td>9790</td>
      <td>sao bernardo do campo</td>
      <td>SP</td>
      <td>16.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>4e7b3e00288586ebd08712fdd0374a03</td>
      <td>060e732b5b29e8181a18229c7b0b2b5e</td>
      <td>1151</td>
      <td>sao paulo</td>
      <td>SP</td>
      <td>26.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>b2b6027bc5c5109e529d4dc6358b12c3</td>
      <td>259dac757896d24d7702b9acbbff3f3c</td>
      <td>8775</td>
      <td>mogi das cruzes</td>
      <td>SP</td>
      <td>14.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4f2d8ab171c80ec8364f7c12e35b23ad</td>
      <td>345ecd01c38d18a9036ed96c73b8d066</td>
      <td>13056</td>
      <td>campinas</td>
      <td>SP</td>
      <td>11.0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>99436</th>
      <td>17ddf5dd5d51696bb3d7c6291687be6f</td>
      <td>1a29b476fee25c95fbafc67c5ac95cf8</td>
      <td>3937</td>
      <td>sao paulo</td>
      <td>SP</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>99437</th>
      <td>e7b71a9017aa05c9a7fd292d714858e8</td>
      <td>d52a67c98be1cf6a5c84435bd38d095d</td>
      <td>6764</td>
      <td>taboao da serra</td>
      <td>SP</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>99438</th>
      <td>5e28dfe12db7fb50a4b2f691faecea5e</td>
      <td>e9f50caf99f032f0bf3c55141f019d99</td>
      <td>60115</td>
      <td>fortaleza</td>
      <td>CE</td>
      <td>30.0</td>
    </tr>
    <tr>
      <th>99439</th>
      <td>56b18e2166679b8a959d72dd06da27f9</td>
      <td>73c2643a0a458b49f58cea58833b192e</td>
      <td>92120</td>
      <td>canoas</td>
      <td>RS</td>
      <td>12.0</td>
    </tr>
    <tr>
      <th>99440</th>
      <td>274fa6071e5e17fe303b9748641082c8</td>
      <td>84732c5050c01db9b23e19ba39899398</td>
      <td>6703</td>
      <td>cotia</td>
      <td>SP</td>
      <td>7.0</td>
    </tr>
  </tbody>
</table>
<p>99441 rows × 6 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-441d9168-382f-4621-b7e5-1564202c112f')"
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
        document.querySelector('#df-441d9168-382f-4621-b7e5-1564202c112f button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-441d9168-382f-4621-b7e5-1564202c112f');
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


<div id="df-a943cadd-de96-4d81-86d2-0d918669a9e5">
  <button class="colab-df-quickchart" onclick="quickchart('df-a943cadd-de96-4d81-86d2-0d918669a9e5')"
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
        document.querySelector('#df-a943cadd-de96-4d81-86d2-0d918669a9e5 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_7cdcd4f6-85fa-4598-bd8f-5810f8615f22">
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
    <button class="colab-df-generate" onclick="generateWithVariable('merged_df_delivery')"
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
        document.querySelector('#id_7cdcd4f6-85fa-4598-bd8f-5810f8615f22 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('merged_df_delivery');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
top_states = ['SP', 'RJ', 'MG']
fig, axs = plt.subplots(len(top_states), 1, figsize=(10, 15))

for i, state in enumerate(top_states):
    state_data = merged_df_delivery[merged_df_delivery['customer_state'] == state]

    # max 값을 int로 변환하여 range에 사용
    max_delivery_time = int(state_data['delivery_time'].max())

    axs[i].hist(state_data['delivery_time'],
                 bins=range(0, max_delivery_time + 10, 10),
                 color='skyblue', edgecolor='black', alpha=0.7)

    axs[i].set_title(f'{state} - 배송 기간 분포 (10일 단위)')
    axs[i].set_xlabel('배송 기간 (일)')
    axs[i].set_ylabel('주문 수')
    axs[i].grid(axis='y')

    # 각 막대 위에 카운트 표시
    counts, bins = np.histogram(state_data['delivery_time'], bins=range(0, max_delivery_time + 10, 10))
    for j in range(len(counts)):
        axs[i].text(bins[j] + 5, counts[j], str(counts[j]), ha='center', va='bottom')

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_41_0.png)
    


- 상위 3개 주 (전체 고객 중 70%) 배송기간은 RJ가 장기배송이 일부 있지만 대부분 20일 이내 배송되고 있음

### 3. Order Items (olist_order_items_dataset.csv)

| 컬럼 이름           | 데이터 타입 | 설명                                 |
| ------------------- | ----------- | ------------------------------------ |
| order_id            | VARCHAR     | 주문 고유 식별자                     |
| order_item_id       | INT         | 주문 내에서의 각 상품의 식별자       |
| product_id          | VARCHAR     | 상품 고유 식별자                     |
| seller_id           | VARCHAR     | 판매자 고유 식별자                   |
| shipping_limit_date | TIMESTAMP   | 판매자가 상품을 발송해야 하는 마감일 |
| price               | FLOAT       | 주문된 상품의 가격                   |
| freight_value       | FLOAT       | 상품의 배송비                        |



```python
df3 = pd.read_csv('/content/drive/MyDrive/archive/olist_order_items_dataset.csv')
df3
```





  <div id="df-b54ee5ad-d2bc-4062-b3d2-f07c4682bbfb" class="colab-df-container">
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
      <th>order_id</th>
      <th>order_item_id</th>
      <th>product_id</th>
      <th>seller_id</th>
      <th>shipping_limit_date</th>
      <th>price</th>
      <th>freight_value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>00010242fe8c5a6d1ba2dd792cb16214</td>
      <td>1</td>
      <td>4244733e06e7ecb4970a6e2683c13e61</td>
      <td>48436dade18ac8b2bce089ec2a041202</td>
      <td>2017-09-19 09:45:35</td>
      <td>58.90</td>
      <td>13.29</td>
    </tr>
    <tr>
      <th>1</th>
      <td>00018f77f2f0320c557190d7a144bdd3</td>
      <td>1</td>
      <td>e5f2d52b802189ee658865ca93d83a8f</td>
      <td>dd7ddc04e1b6c2c614352b383efe2d36</td>
      <td>2017-05-03 11:05:13</td>
      <td>239.90</td>
      <td>19.93</td>
    </tr>
    <tr>
      <th>2</th>
      <td>000229ec398224ef6ca0657da4fc703e</td>
      <td>1</td>
      <td>c777355d18b72b67abbeef9df44fd0fd</td>
      <td>5b51032eddd242adc84c38acab88f23d</td>
      <td>2018-01-18 14:48:30</td>
      <td>199.00</td>
      <td>17.87</td>
    </tr>
    <tr>
      <th>3</th>
      <td>00024acbcdf0a6daa1e931b038114c75</td>
      <td>1</td>
      <td>7634da152a4610f1595efa32f14722fc</td>
      <td>9d7a1d34a5052409006425275ba1c2b4</td>
      <td>2018-08-15 10:10:18</td>
      <td>12.99</td>
      <td>12.79</td>
    </tr>
    <tr>
      <th>4</th>
      <td>00042b26cf59d7ce69dfabb4e55b4fd9</td>
      <td>1</td>
      <td>ac6c3623068f30de03045865e4e10089</td>
      <td>df560393f3a51e74553ab94004ba5c87</td>
      <td>2017-02-13 13:57:51</td>
      <td>199.90</td>
      <td>18.14</td>
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
    </tr>
    <tr>
      <th>112645</th>
      <td>fffc94f6ce00a00581880bf54a75a037</td>
      <td>1</td>
      <td>4aa6014eceb682077f9dc4bffebc05b0</td>
      <td>b8bc237ba3788b23da09c0f1f3a3288c</td>
      <td>2018-05-02 04:11:01</td>
      <td>299.99</td>
      <td>43.41</td>
    </tr>
    <tr>
      <th>112646</th>
      <td>fffcd46ef2263f404302a634eb57f7eb</td>
      <td>1</td>
      <td>32e07fd915822b0765e448c4dd74c828</td>
      <td>f3c38ab652836d21de61fb8314b69182</td>
      <td>2018-07-20 04:31:48</td>
      <td>350.00</td>
      <td>36.53</td>
    </tr>
    <tr>
      <th>112647</th>
      <td>fffce4705a9662cd70adb13d4a31832d</td>
      <td>1</td>
      <td>72a30483855e2eafc67aee5dc2560482</td>
      <td>c3cfdc648177fdbbbb35635a37472c53</td>
      <td>2017-10-30 17:14:25</td>
      <td>99.90</td>
      <td>16.95</td>
    </tr>
    <tr>
      <th>112648</th>
      <td>fffe18544ffabc95dfada21779c9644f</td>
      <td>1</td>
      <td>9c422a519119dcad7575db5af1ba540e</td>
      <td>2b3e4a2a3ea8e01938cabda2a3e5cc79</td>
      <td>2017-08-21 00:04:32</td>
      <td>55.99</td>
      <td>8.72</td>
    </tr>
    <tr>
      <th>112649</th>
      <td>fffe41c64501cc87c801fd61db3f6244</td>
      <td>1</td>
      <td>350688d9dc1e75ff97be326363655e01</td>
      <td>f7ccf836d21b2fb1de37564105216cc1</td>
      <td>2018-06-12 17:10:13</td>
      <td>43.00</td>
      <td>12.79</td>
    </tr>
  </tbody>
</table>
<p>112650 rows × 7 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-b54ee5ad-d2bc-4062-b3d2-f07c4682bbfb')"
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
        document.querySelector('#df-b54ee5ad-d2bc-4062-b3d2-f07c4682bbfb button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-b54ee5ad-d2bc-4062-b3d2-f07c4682bbfb');
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


<div id="df-400ebe67-efc7-492a-8ae5-fc3994f82e2b">
  <button class="colab-df-quickchart" onclick="quickchart('df-400ebe67-efc7-492a-8ae5-fc3994f82e2b')"
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
        document.querySelector('#df-400ebe67-efc7-492a-8ae5-fc3994f82e2b button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_7fd8e595-f21e-42e3-8f6a-cfc83d1612bd">
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
    <button class="colab-df-generate" onclick="generateWithVariable('df3')"
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
        document.querySelector('#id_7fd8e595-f21e-42e3-8f6a-cfc83d1612bd button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('df3');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 결측치 확인
df3.isna().sum().sort_values(ascending=False)
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
      <th>order_id</th>
      <td>0</td>
    </tr>
    <tr>
      <th>order_item_id</th>
      <td>0</td>
    </tr>
    <tr>
      <th>product_id</th>
      <td>0</td>
    </tr>
    <tr>
      <th>seller_id</th>
      <td>0</td>
    </tr>
    <tr>
      <th>shipping_limit_date</th>
      <td>0</td>
    </tr>
    <tr>
      <th>price</th>
      <td>0</td>
    </tr>
    <tr>
      <th>freight_value</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
# 중복값 확인
df3.duplicated().sum()
```




    0




```python
df3['order_id'].duplicated().sum()
```




    13984




```python
df3[df3['order_id'].duplicated()].sort_values(by=['product_id', 'order_item_id'])
```





  <div id="df-a5e65d6c-c347-43c7-baee-a681ba9a9302" class="colab-df-container">
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
      <th>order_id</th>
      <th>order_item_id</th>
      <th>product_id</th>
      <th>seller_id</th>
      <th>shipping_limit_date</th>
      <th>price</th>
      <th>freight_value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>82591</th>
      <td>bb9552306cf6879fde49f4ba3bd94299</td>
      <td>2</td>
      <td>0011c512eb256aa0dbbb544d8dffcf6e</td>
      <td>b4ffb71f0cb1b1c3d63fad021ecf93e1</td>
      <td>2017-12-22 20:38:29</td>
      <td>52.00</td>
      <td>15.80</td>
    </tr>
    <tr>
      <th>86374</th>
      <td>c432657bb18ddf7f48b7227db09048d4</td>
      <td>2</td>
      <td>001795ec6f1b187d37335e1c4704762e</td>
      <td>8b321bb669392f5163d04c59e235e066</td>
      <td>2017-12-18 00:39:25</td>
      <td>38.90</td>
      <td>16.11</td>
    </tr>
    <tr>
      <th>97530</th>
      <td>dd436680fbd2d38edb26277f5b8379dc</td>
      <td>2</td>
      <td>001795ec6f1b187d37335e1c4704762e</td>
      <td>8b321bb669392f5163d04c59e235e066</td>
      <td>2017-12-29 15:30:50</td>
      <td>38.90</td>
      <td>9.34</td>
    </tr>
    <tr>
      <th>49689</th>
      <td>70ed857e24fd6bf1e25a9bc791a2f6b9</td>
      <td>2</td>
      <td>001b72dfd63e9833e8c02742adf472e3</td>
      <td>8a32e327fe2c1b3511609d81aaf9f042</td>
      <td>2017-09-06 12:35:16</td>
      <td>34.99</td>
      <td>9.90</td>
    </tr>
    <tr>
      <th>85437</th>
      <td>c214276ccd69c3953f880b487209f47e</td>
      <td>2</td>
      <td>001b72dfd63e9833e8c02742adf472e3</td>
      <td>8a32e327fe2c1b3511609d81aaf9f042</td>
      <td>2017-07-13 15:43:15</td>
      <td>34.99</td>
      <td>7.78</td>
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
    </tr>
    <tr>
      <th>56508</th>
      <td>808b7fff91e537a5df90717957ee5bb1</td>
      <td>2</td>
      <td>ffef256879dbadcab7e77950f4f4a195</td>
      <td>113e3a788b935f48aad63e1c41dac1bd</td>
      <td>2018-06-15 19:54:42</td>
      <td>31.78</td>
      <td>18.23</td>
    </tr>
    <tr>
      <th>83782</th>
      <td>be48bdef069ed1eb0d320bfe65d26351</td>
      <td>2</td>
      <td>fff0a542c3c62682f23305214eaeaa24</td>
      <td>08d2d642cf72b622b14dde1d2f5eb2f5</td>
      <td>2017-12-07 19:53:44</td>
      <td>7.50</td>
      <td>12.69</td>
    </tr>
    <tr>
      <th>106253</th>
      <td>f179e0782e0180bc2ec9ce167d4cf245</td>
      <td>2</td>
      <td>fff0a542c3c62682f23305214eaeaa24</td>
      <td>08d2d642cf72b622b14dde1d2f5eb2f5</td>
      <td>2017-12-12 02:35:39</td>
      <td>7.50</td>
      <td>16.11</td>
    </tr>
    <tr>
      <th>106254</th>
      <td>f179e0782e0180bc2ec9ce167d4cf245</td>
      <td>3</td>
      <td>fff0a542c3c62682f23305214eaeaa24</td>
      <td>08d2d642cf72b622b14dde1d2f5eb2f5</td>
      <td>2017-12-12 02:35:39</td>
      <td>7.50</td>
      <td>16.11</td>
    </tr>
    <tr>
      <th>106255</th>
      <td>f179e0782e0180bc2ec9ce167d4cf245</td>
      <td>4</td>
      <td>fff0a542c3c62682f23305214eaeaa24</td>
      <td>08d2d642cf72b622b14dde1d2f5eb2f5</td>
      <td>2017-12-12 02:35:39</td>
      <td>7.50</td>
      <td>16.11</td>
    </tr>
  </tbody>
</table>
<p>13984 rows × 7 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-a5e65d6c-c347-43c7-baee-a681ba9a9302')"
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
        document.querySelector('#df-a5e65d6c-c347-43c7-baee-a681ba9a9302 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-a5e65d6c-c347-43c7-baee-a681ba9a9302');
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


<div id="df-cf5cd97f-14d3-443b-ae34-11b659f88b20">
  <button class="colab-df-quickchart" onclick="quickchart('df-cf5cd97f-14d3-443b-ae34-11b659f88b20')"
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
        document.querySelector('#df-cf5cd97f-14d3-443b-ae34-11b659f88b20 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
df3.sort_values(by=['order_item_id'])
```





  <div id="df-98dba7f2-2007-4542-8874-822f5a01bda4" class="colab-df-container">
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
      <th>order_id</th>
      <th>order_item_id</th>
      <th>product_id</th>
      <th>seller_id</th>
      <th>shipping_limit_date</th>
      <th>price</th>
      <th>freight_value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>00010242fe8c5a6d1ba2dd792cb16214</td>
      <td>1</td>
      <td>4244733e06e7ecb4970a6e2683c13e61</td>
      <td>48436dade18ac8b2bce089ec2a041202</td>
      <td>2017-09-19 09:45:35</td>
      <td>58.90</td>
      <td>13.29</td>
    </tr>
    <tr>
      <th>72706</th>
      <td>a5c7406fd66b64f69acd95538f35b97e</td>
      <td>1</td>
      <td>06edb72f1e0c64b14c5b79353f7abea3</td>
      <td>391fc6631aebcf3004804e51b40bcf1e</td>
      <td>2017-08-28 21:25:19</td>
      <td>45.95</td>
      <td>15.10</td>
    </tr>
    <tr>
      <th>72705</th>
      <td>a5c681209e1bcb90066e530c285ce2c5</td>
      <td>1</td>
      <td>eec68ed7d496bb2ee6aa0a69bb78acd2</td>
      <td>5f5b43b2bffa8656e4bc6efeb13cc649</td>
      <td>2017-12-21 20:51:36</td>
      <td>89.00</td>
      <td>9.44</td>
    </tr>
    <tr>
      <th>72704</th>
      <td>a5c654c2a0126153f98af71a65a159de</td>
      <td>1</td>
      <td>b37a8cda46313ac91d79f16601ca5253</td>
      <td>955fee9216a65b617aa5c0531780ce60</td>
      <td>2018-06-12 12:10:35</td>
      <td>95.00</td>
      <td>20.72</td>
    </tr>
    <tr>
      <th>72703</th>
      <td>a5c523f7f14f85ee88f26643f9a99e66</td>
      <td>1</td>
      <td>4b96786612ebe7463132fce2c4dca136</td>
      <td>d94a40fd42351c259927028d163af842</td>
      <td>2018-06-14 08:31:15</td>
      <td>129.00</td>
      <td>26.05</td>
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
    </tr>
    <tr>
      <th>11950</th>
      <td>1b15974a0141d54e36626dca3fdc731a</td>
      <td>19</td>
      <td>ee3d532c8a438679776d222e997606b3</td>
      <td>8e6d7754bc7e0f22c96d255ebda59eba</td>
      <td>2018-03-01 02:50:48</td>
      <td>100.00</td>
      <td>10.12</td>
    </tr>
    <tr>
      <th>11951</th>
      <td>1b15974a0141d54e36626dca3fdc731a</td>
      <td>20</td>
      <td>ee3d532c8a438679776d222e997606b3</td>
      <td>8e6d7754bc7e0f22c96d255ebda59eba</td>
      <td>2018-03-01 02:50:48</td>
      <td>100.00</td>
      <td>10.12</td>
    </tr>
    <tr>
      <th>75122</th>
      <td>ab14fdcfbe524636d65ee38360e22ce8</td>
      <td>20</td>
      <td>9571759451b1d780ee7c15012ea109d4</td>
      <td>ce27a3cc3c8cc1ea79d11e561e9bebb6</td>
      <td>2017-08-30 14:30:23</td>
      <td>98.70</td>
      <td>14.44</td>
    </tr>
    <tr>
      <th>57316</th>
      <td>8272b63d03f5f79c56e9e4120aec44ef</td>
      <td>20</td>
      <td>270516a3f41dc035aa87d220228f844c</td>
      <td>2709af9587499e95e803a6498a5a56e9</td>
      <td>2017-07-21 18:25:23</td>
      <td>1.20</td>
      <td>7.89</td>
    </tr>
    <tr>
      <th>57317</th>
      <td>8272b63d03f5f79c56e9e4120aec44ef</td>
      <td>21</td>
      <td>79ce45dbc2ea29b22b5a261bbb7b7ee7</td>
      <td>2709af9587499e95e803a6498a5a56e9</td>
      <td>2017-07-21 18:25:23</td>
      <td>7.80</td>
      <td>6.57</td>
    </tr>
  </tbody>
</table>
<p>112650 rows × 7 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-98dba7f2-2007-4542-8874-822f5a01bda4')"
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
        document.querySelector('#df-98dba7f2-2007-4542-8874-822f5a01bda4 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-98dba7f2-2007-4542-8874-822f5a01bda4');
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


<div id="df-cafb9a5b-e007-4df8-9b9c-21d1cea554b4">
  <button class="colab-df-quickchart" onclick="quickchart('df-cafb9a5b-e007-4df8-9b9c-21d1cea554b4')"
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
        document.querySelector('#df-cafb9a5b-e007-4df8-9b9c-21d1cea554b4 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
df3[df3['product_id'] == 'fff0a542c3c62682f23305214eaeaa24']
```





  <div id="df-a953b4a1-80ee-4de1-8a18-d2705ea1879b" class="colab-df-container">
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
      <th>order_id</th>
      <th>order_item_id</th>
      <th>product_id</th>
      <th>seller_id</th>
      <th>shipping_limit_date</th>
      <th>price</th>
      <th>freight_value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>31855</th>
      <td>4838d1c1cbef87593a3921429e633ccc</td>
      <td>1</td>
      <td>fff0a542c3c62682f23305214eaeaa24</td>
      <td>08d2d642cf72b622b14dde1d2f5eb2f5</td>
      <td>2017-11-17 20:50:31</td>
      <td>7.3</td>
      <td>15.10</td>
    </tr>
    <tr>
      <th>47963</th>
      <td>6d03ab0713a35b9475f6c5ed0d989976</td>
      <td>1</td>
      <td>fff0a542c3c62682f23305214eaeaa24</td>
      <td>08d2d642cf72b622b14dde1d2f5eb2f5</td>
      <td>2017-12-07 14:11:22</td>
      <td>7.5</td>
      <td>16.11</td>
    </tr>
    <tr>
      <th>83781</th>
      <td>be48bdef069ed1eb0d320bfe65d26351</td>
      <td>1</td>
      <td>fff0a542c3c62682f23305214eaeaa24</td>
      <td>08d2d642cf72b622b14dde1d2f5eb2f5</td>
      <td>2017-12-07 19:53:44</td>
      <td>7.5</td>
      <td>12.69</td>
    </tr>
    <tr>
      <th>83782</th>
      <td>be48bdef069ed1eb0d320bfe65d26351</td>
      <td>2</td>
      <td>fff0a542c3c62682f23305214eaeaa24</td>
      <td>08d2d642cf72b622b14dde1d2f5eb2f5</td>
      <td>2017-12-07 19:53:44</td>
      <td>7.5</td>
      <td>12.69</td>
    </tr>
    <tr>
      <th>106252</th>
      <td>f179e0782e0180bc2ec9ce167d4cf245</td>
      <td>1</td>
      <td>fff0a542c3c62682f23305214eaeaa24</td>
      <td>08d2d642cf72b622b14dde1d2f5eb2f5</td>
      <td>2017-12-12 02:35:39</td>
      <td>7.5</td>
      <td>16.11</td>
    </tr>
    <tr>
      <th>106253</th>
      <td>f179e0782e0180bc2ec9ce167d4cf245</td>
      <td>2</td>
      <td>fff0a542c3c62682f23305214eaeaa24</td>
      <td>08d2d642cf72b622b14dde1d2f5eb2f5</td>
      <td>2017-12-12 02:35:39</td>
      <td>7.5</td>
      <td>16.11</td>
    </tr>
    <tr>
      <th>106254</th>
      <td>f179e0782e0180bc2ec9ce167d4cf245</td>
      <td>3</td>
      <td>fff0a542c3c62682f23305214eaeaa24</td>
      <td>08d2d642cf72b622b14dde1d2f5eb2f5</td>
      <td>2017-12-12 02:35:39</td>
      <td>7.5</td>
      <td>16.11</td>
    </tr>
    <tr>
      <th>106255</th>
      <td>f179e0782e0180bc2ec9ce167d4cf245</td>
      <td>4</td>
      <td>fff0a542c3c62682f23305214eaeaa24</td>
      <td>08d2d642cf72b622b14dde1d2f5eb2f5</td>
      <td>2017-12-12 02:35:39</td>
      <td>7.5</td>
      <td>16.11</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-a953b4a1-80ee-4de1-8a18-d2705ea1879b')"
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
        document.querySelector('#df-a953b4a1-80ee-4de1-8a18-d2705ea1879b button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-a953b4a1-80ee-4de1-8a18-d2705ea1879b');
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


<div id="df-efd4f850-d678-4051-a0b8-8972a4cac502">
  <button class="colab-df-quickchart" onclick="quickchart('df-efd4f850-d678-4051-a0b8-8972a4cac502')"
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
        document.querySelector('#df-efd4f850-d678-4051-a0b8-8972a4cac502 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




- 같은 주문번호/상품번호는 같은 상품을 n개 샀다는 의미이다 → 해당주문번호의 payment_value값과 (price + freight_value)*n이 동일함
- 또한, 같은 상품번호는 해당 상품을 현재 데이터기간동안(2016년~2018년) n개 판매했다는 의미이다. 예시에서 'fff0a542c3c62682f23305214eaeaa24' 상품이 총 8번 판매되었다


```python
df3['order_item_id'].value_counts()
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
      <th>order_item_id</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>98666</td>
    </tr>
    <tr>
      <th>2</th>
      <td>9803</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2287</td>
    </tr>
    <tr>
      <th>4</th>
      <td>965</td>
    </tr>
    <tr>
      <th>5</th>
      <td>460</td>
    </tr>
    <tr>
      <th>6</th>
      <td>256</td>
    </tr>
    <tr>
      <th>7</th>
      <td>58</td>
    </tr>
    <tr>
      <th>8</th>
      <td>36</td>
    </tr>
    <tr>
      <th>9</th>
      <td>28</td>
    </tr>
    <tr>
      <th>10</th>
      <td>25</td>
    </tr>
    <tr>
      <th>11</th>
      <td>17</td>
    </tr>
    <tr>
      <th>12</th>
      <td>13</td>
    </tr>
    <tr>
      <th>13</th>
      <td>8</td>
    </tr>
    <tr>
      <th>14</th>
      <td>7</td>
    </tr>
    <tr>
      <th>15</th>
      <td>5</td>
    </tr>
    <tr>
      <th>16</th>
      <td>3</td>
    </tr>
    <tr>
      <th>17</th>
      <td>3</td>
    </tr>
    <tr>
      <th>18</th>
      <td>3</td>
    </tr>
    <tr>
      <th>19</th>
      <td>3</td>
    </tr>
    <tr>
      <th>20</th>
      <td>3</td>
    </tr>
    <tr>
      <th>21</th>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>



- order_item_id가 order 데이터의 order_id 수보다 775개 작다 (99441 > 98666)


```python
not_in_df2 = df3[~df3['order_id'].isin(df2['order_id'])]
not_in_df3 = df2[~df2['order_id'].isin(df3['order_id'])]

print("df3에만 있는 order_id:")
print(not_in_df2['order_id'])

print("\ndf2에만 있는 order_id:")
print(not_in_df3['order_id'])
```

    df3에만 있는 order_id:
    Series([], Name: order_id, dtype: object)
    
    df2에만 있는 order_id:
    266      8e24261a7e58791d10cb1bf9da94df5c
    586      c272bcd21c287498b4883c7512019702
    687      37553832a3a89c9b2db59701c357ca67
    737      d57e15fb07fd180f06ab3926b39edcd2
    1130     00b1cb0320190ca0daa2c88b35206009
                           ...               
    99252    aaab15da689073f8f9aa978a390a69d1
    99283    3a3cddda5a7c27851bd96c3313412840
    99347    a89abace0dcc01eeb267a9660b5ac126
    99348    a69ba794cc7deb415c3e15a0a3877e69
    99415    5fabc81b6322c8443648e1b21a6fef21
    Name: order_id, Length: 775, dtype: object
    


```python
# order_items에 없는 주문들은 무엇일까
not_in_df3
```





  <div id="df-42a082e8-738e-40a5-9f52-4b325dfb6cc4" class="colab-df-container">
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
      <th>order_id</th>
      <th>customer_id</th>
      <th>order_status</th>
      <th>order_purchase_timestamp</th>
      <th>order_approved_at</th>
      <th>order_delivered_carrier_date</th>
      <th>order_delivered_customer_date</th>
      <th>order_estimated_delivery_date</th>
      <th>delivery_time</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>266</th>
      <td>8e24261a7e58791d10cb1bf9da94df5c</td>
      <td>64a254d30eed42cd0e6c36dddb88adf0</td>
      <td>unavailable</td>
      <td>2017-11-16 15:09:28</td>
      <td>2017-11-16 15:26:57</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>2017-12-05 00:00:00</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>586</th>
      <td>c272bcd21c287498b4883c7512019702</td>
      <td>9582c5bbecc65eb568e2c1d839b5cba1</td>
      <td>unavailable</td>
      <td>2018-01-31 11:31:37</td>
      <td>2018-01-31 14:23:50</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>2018-02-16 00:00:00</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>687</th>
      <td>37553832a3a89c9b2db59701c357ca67</td>
      <td>7607cd563696c27ede287e515812d528</td>
      <td>unavailable</td>
      <td>2017-08-14 17:38:02</td>
      <td>2017-08-17 00:15:18</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>2017-09-05 00:00:00</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>737</th>
      <td>d57e15fb07fd180f06ab3926b39edcd2</td>
      <td>470b93b3f1cde85550fc74cd3a476c78</td>
      <td>unavailable</td>
      <td>2018-01-08 19:39:03</td>
      <td>2018-01-09 07:26:08</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>2018-02-06 00:00:00</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1130</th>
      <td>00b1cb0320190ca0daa2c88b35206009</td>
      <td>3532ba38a3fd242259a514ac2b6ae6b6</td>
      <td>canceled</td>
      <td>2018-08-28 15:26:39</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>2018-09-12 00:00:00</td>
      <td>NaN</td>
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
      <th>99252</th>
      <td>aaab15da689073f8f9aa978a390a69d1</td>
      <td>df20748206e4b865b2f14a5eabbfcf34</td>
      <td>unavailable</td>
      <td>2018-01-16 14:27:59</td>
      <td>2018-01-17 03:37:34</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>2018-02-06 00:00:00</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>99283</th>
      <td>3a3cddda5a7c27851bd96c3313412840</td>
      <td>0b0d6095c5555fe083844281f6b093bb</td>
      <td>canceled</td>
      <td>2018-08-31 16:13:44</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>2018-10-01 00:00:00</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>99347</th>
      <td>a89abace0dcc01eeb267a9660b5ac126</td>
      <td>2f0524a7b1b3845a1a57fcf3910c4333</td>
      <td>canceled</td>
      <td>2018-09-06 18:45:47</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>2018-09-27 00:00:00</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>99348</th>
      <td>a69ba794cc7deb415c3e15a0a3877e69</td>
      <td>726f0894b5becdf952ea537d5266e543</td>
      <td>unavailable</td>
      <td>2017-08-23 16:28:04</td>
      <td>2017-08-28 15:44:47</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>2017-09-15 00:00:00</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>99415</th>
      <td>5fabc81b6322c8443648e1b21a6fef21</td>
      <td>32c9df889d41b0ee8309a5efb6855dcb</td>
      <td>unavailable</td>
      <td>2017-10-10 10:50:03</td>
      <td>2017-10-14 18:35:57</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>2017-10-23 00:00:00</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
<p>775 rows × 9 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-42a082e8-738e-40a5-9f52-4b325dfb6cc4')"
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
        document.querySelector('#df-42a082e8-738e-40a5-9f52-4b325dfb6cc4 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-42a082e8-738e-40a5-9f52-4b325dfb6cc4');
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


<div id="df-104c93b4-54f4-43ea-8fd4-eb7c7e9f2d9b">
  <button class="colab-df-quickchart" onclick="quickchart('df-104c93b4-54f4-43ea-8fd4-eb7c7e9f2d9b')"
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
        document.querySelector('#df-104c93b4-54f4-43ea-8fd4-eb7c7e9f2d9b button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_4c7362e2-89cc-4d80-8586-c3a9d76e4efc">
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
    <button class="colab-df-generate" onclick="generateWithVariable('not_in_df3')"
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
        document.querySelector('#id_4c7362e2-89cc-4d80-8586-c3a9d76e4efc button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('not_in_df3');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
print(not_in_df3['order_status'].value_counts())
print(not_in_df3['order_purchase_timestamp'].isna().sum())
print(not_in_df3['order_delivered_carrier_date'].unique())
print(not_in_df3['order_delivered_customer_date'].unique())
```

    order_status
    unavailable    603
    canceled       164
    created          5
    invoiced         2
    shipped          1
    Name: count, dtype: int64
    0
    [nan '2016-11-07 16:37:37']
    <DatetimeArray>
    ['NaT']
    Length: 1, dtype: datetime64[ns]
    


```python
not_in_df3[not_in_df3['order_status'] == 'shipped']
```





  <div id="df-6658093f-5d72-4f1a-b347-13072213dee5" class="colab-df-container">
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
      <th>order_id</th>
      <th>customer_id</th>
      <th>order_status</th>
      <th>order_purchase_timestamp</th>
      <th>order_approved_at</th>
      <th>order_delivered_carrier_date</th>
      <th>order_delivered_customer_date</th>
      <th>order_estimated_delivery_date</th>
      <th>delivery_time</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>23254</th>
      <td>a68ce1686d536ca72bd2dadc4b8671e5</td>
      <td>d7bed5fac093a4136216072abaf599d5</td>
      <td>shipped</td>
      <td>2016-10-05 01:47:40</td>
      <td>2016-10-07 03:11:22</td>
      <td>2016-11-07 16:37:37</td>
      <td>NaT</td>
      <td>2016-12-01 00:00:00</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-6658093f-5d72-4f1a-b347-13072213dee5')"
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
        document.querySelector('#df-6658093f-5d72-4f1a-b347-13072213dee5 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-6658093f-5d72-4f1a-b347-13072213dee5');
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


    </div>
  </div>




- 상품 취소나 시스템 오류 등으로 주문번호는 남아있지만 최종적으로 고객에게 배송되지않고 상품관련정보도 전부삭제된 데이터이다. 결측치로 제거할수도있지만, 사용자가 구매시도한 데이터에는 결측치가 없었다. 따라서 사용자가 구매를 시도한후 변경된 데이터들이다. 따라서 해당 데이터를 제거하지 않기로 결정함


```python
df3['shipping_limit_date'].isna().sum()
```




    0




```python
df3['shipping_limit_date'].describe()
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
      <th>shipping_limit_date</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>112650</td>
    </tr>
    <tr>
      <th>unique</th>
      <td>93318</td>
    </tr>
    <tr>
      <th>top</th>
      <td>2017-07-21 18:25:23</td>
    </tr>
    <tr>
      <th>freq</th>
      <td>21</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> object</label>




```python
(df3['freight_value'] > df3['price']).sum()
```




    4124



- 상품보다 배송비가 더 비싼 건이 전체 거래 대비 약 4% 발생한것으로 관찰됨


```python
# 연도와 월별로 그룹화하여 주문 수 계산
monthly_orders = df2.groupby(df2['order_purchase_timestamp'].dt.to_period('M')).size()

# 1. 'shipping_limit_date'를 datetime 형식으로 변환
df3['shipping_limit_date'] = pd.to_datetime(df3['shipping_limit_date'])

# 2. 월별 매출액 집계
monthly_sales = df3.resample('M', on='shipping_limit_date')['price'].sum()

# 3. 2018년 8월까지의 데이터만 필터링
monthly_sales = monthly_sales[monthly_sales.index <= '2018-08-31']

# 4. subplot 생성
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 12))

# 첫 번째 차트: 월별 주문 수
bars = ax1.bar(monthly_orders.index.astype(str), monthly_orders.values, color='skyblue')

# 주문 수 표시
for bar in bars:
    yval = bar.get_height()
    ax1.text(bar.get_x() + bar.get_width()/2, yval, str(yval), ha='center', va='bottom')

ax1.set_title('월별 주문 수')
ax1.set_xlabel('연도-월')
ax1.set_ylabel('주문 수')
ax1.set_xticks(range(len(monthly_orders.index)))  # x축 위치 설정
ax1.set_xticklabels(monthly_orders.index.astype(str), rotation=45)  # 레이블과 회전 설정
ax1.grid(axis='y')

# 두 번째 차트: 월별 매출액 추이
ax2.plot(monthly_sales.index, monthly_sales.values, marker='o')

# 매출액 숫자 표기
for x, y in zip(monthly_sales.index, monthly_sales.values):
    ax2.text(x, y, f'{y:,.0f}', fontsize=9, ha='center', va='bottom')

# x축을 3개월 단위로 설정
ax2.set_xticks(monthly_sales.index[::3])
ax2.set_title('월별 매출액 추이')
ax2.set_xlabel('월')
ax2.set_ylabel('매출액')
ax2.set_xlim(pd.Timestamp('2016-09-01'), pd.Timestamp('2018-08-31'))  # x축 범위 설정
ax2.grid()

# 레이아웃 조정 및 그래프 표시
plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_63_0.png)
    



```python
# 1. 상품별 판매 빈도수와 총 매출액 계산
product_sales = df3.groupby('product_id').agg(
    sales_count=('price', 'size'),  # 판매 빈도수
    total_revenue=('price', 'sum')  # 총 매출액
).reset_index()

# 2. 총 매출액 기준으로 정렬하고 상위 10개 선택
top_products = product_sales.sort_values(by='total_revenue', ascending=False).head(10)

# 3. 상품 순서를 총 매출액 기준으로 역순으로 설정
top_products = top_products.sort_values(by='total_revenue', ascending=True)

# 4. subplot 생성
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 6))

# 5. 왼쪽 차트: 총 매출액
bars1 = ax1.barh(top_products['product_id'], top_products['total_revenue'], color='skyblue')
ax1.set_title('상품별 총 매출액 (상위 10개 상품)')
ax1.set_xlabel('총 매출액')
ax1.grid(axis='x')
ax1.spines['top'].set_visible(False)
ax1.spines['right'].set_visible(False)

# 6. 숫자 표기
for bar in bars1:
    ax1.text(bar.get_width(), bar.get_y() + bar.get_height()/2, f'{bar.get_width():,.0f}',
             va='center', ha='left', fontsize=9)

# 7. 오른쪽 차트: 판매 빈도수
bars2 = ax2.barh(top_products['product_id'], top_products['sales_count'], color='lightgreen')
ax2.set_title('상품별 판매 빈도수 (상위 10개 상품)')
ax2.set_xlabel('판매 빈도수')
ax2.grid(axis='x')
ax2.set_yticklabels([])
ax2.spines['top'].set_visible(False)
ax2.spines['right'].set_visible(False)

# 8. 숫자 표기
for bar in bars2:
    ax2.text(bar.get_width(), bar.get_y() + bar.get_height()/2, f'{bar.get_width():,.0f}',
             va='center', ha='left', fontsize=9)

# 9. 레이아웃 조정 및 그래프 표시
plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_64_0.png)
    


- 주문수와 매출액 추이는 비슷한 흐름으로 이루어져있음
- 총 매출액이 높다고 많이 팔리는 상품은 아닌것으로 관찰됐고, 해당 상품의 카테고리는 products데이터를 활용하면 확인할수있음

### 4. Products (olist_products_dataset.csv)

| 컬럼 이름                  | 데이터 타입 | 설명                 |
| -------------------------- | ----------- | -------------------- |
| product_id                 | VARCHAR     | 상품 고유 식별자     |
| product_category_name      | VARCHAR     | 상품의 카테고리 이름 |
| product_name_length        | INT         | 상품 이름의 길이     |
| product_description_length | INT         | 상품 설명의 길이     |
| product_photos_qty         | INT         | 상품 사진의 개수     |
| product_weight_g           | FLOAT       | 상품의 무게 (그램)   |
| product_length_cm          | FLOAT       | 상품 길이 (센티미터) |
| product_height_cm          | FLOAT       | 상품 높이 (센티미터) |
| product_width_cm           | FLOAT       | 상품 폭 (센티미터)   |



```python
df4 = pd.read_csv('/content/drive/MyDrive/archive/olist_products_dataset.csv')
df4
```





  <div id="df-dc52eb35-8405-4c01-b7ec-342e2b79c6bc" class="colab-df-container">
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
      <th>product_id</th>
      <th>product_category_name</th>
      <th>product_name_lenght</th>
      <th>product_description_lenght</th>
      <th>product_photos_qty</th>
      <th>product_weight_g</th>
      <th>product_length_cm</th>
      <th>product_height_cm</th>
      <th>product_width_cm</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1e9e8ef04dbcff4541ed26657ea517e5</td>
      <td>perfumaria</td>
      <td>40.0</td>
      <td>287.0</td>
      <td>1.0</td>
      <td>225.0</td>
      <td>16.0</td>
      <td>10.0</td>
      <td>14.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3aa071139cb16b67ca9e5dea641aaa2f</td>
      <td>artes</td>
      <td>44.0</td>
      <td>276.0</td>
      <td>1.0</td>
      <td>1000.0</td>
      <td>30.0</td>
      <td>18.0</td>
      <td>20.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>96bd76ec8810374ed1b65e291975717f</td>
      <td>esporte_lazer</td>
      <td>46.0</td>
      <td>250.0</td>
      <td>1.0</td>
      <td>154.0</td>
      <td>18.0</td>
      <td>9.0</td>
      <td>15.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>cef67bcfe19066a932b7673e239eb23d</td>
      <td>bebes</td>
      <td>27.0</td>
      <td>261.0</td>
      <td>1.0</td>
      <td>371.0</td>
      <td>26.0</td>
      <td>4.0</td>
      <td>26.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>9dc1a7de274444849c219cff195d0b71</td>
      <td>utilidades_domesticas</td>
      <td>37.0</td>
      <td>402.0</td>
      <td>4.0</td>
      <td>625.0</td>
      <td>20.0</td>
      <td>17.0</td>
      <td>13.0</td>
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
      <th>32946</th>
      <td>a0b7d5a992ccda646f2d34e418fff5a0</td>
      <td>moveis_decoracao</td>
      <td>45.0</td>
      <td>67.0</td>
      <td>2.0</td>
      <td>12300.0</td>
      <td>40.0</td>
      <td>40.0</td>
      <td>40.0</td>
    </tr>
    <tr>
      <th>32947</th>
      <td>bf4538d88321d0fd4412a93c974510e6</td>
      <td>construcao_ferramentas_iluminacao</td>
      <td>41.0</td>
      <td>971.0</td>
      <td>1.0</td>
      <td>1700.0</td>
      <td>16.0</td>
      <td>19.0</td>
      <td>16.0</td>
    </tr>
    <tr>
      <th>32948</th>
      <td>9a7c6041fa9592d9d9ef6cfe62a71f8c</td>
      <td>cama_mesa_banho</td>
      <td>50.0</td>
      <td>799.0</td>
      <td>1.0</td>
      <td>1400.0</td>
      <td>27.0</td>
      <td>7.0</td>
      <td>27.0</td>
    </tr>
    <tr>
      <th>32949</th>
      <td>83808703fc0706a22e264b9d75f04a2e</td>
      <td>informatica_acessorios</td>
      <td>60.0</td>
      <td>156.0</td>
      <td>2.0</td>
      <td>700.0</td>
      <td>31.0</td>
      <td>13.0</td>
      <td>20.0</td>
    </tr>
    <tr>
      <th>32950</th>
      <td>106392145fca363410d287a815be6de4</td>
      <td>cama_mesa_banho</td>
      <td>58.0</td>
      <td>309.0</td>
      <td>1.0</td>
      <td>2083.0</td>
      <td>12.0</td>
      <td>2.0</td>
      <td>7.0</td>
    </tr>
  </tbody>
</table>
<p>32951 rows × 9 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-dc52eb35-8405-4c01-b7ec-342e2b79c6bc')"
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
        document.querySelector('#df-dc52eb35-8405-4c01-b7ec-342e2b79c6bc button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-dc52eb35-8405-4c01-b7ec-342e2b79c6bc');
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


<div id="df-4be174aa-f896-46ff-ab5f-89bccfca82db">
  <button class="colab-df-quickchart" onclick="quickchart('df-4be174aa-f896-46ff-ab5f-89bccfca82db')"
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
        document.querySelector('#df-4be174aa-f896-46ff-ab5f-89bccfca82db button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_638dc194-5103-4287-8615-c18d7ad6cfc3">
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
    <button class="colab-df-generate" onclick="generateWithVariable('df4')"
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
        document.querySelector('#id_638dc194-5103-4287-8615-c18d7ad6cfc3 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('df4');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 결측치 찾기
df4.isna().sum().sort_values(ascending=False)
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
      <th>product_category_name</th>
      <td>610</td>
    </tr>
    <tr>
      <th>product_name_lenght</th>
      <td>610</td>
    </tr>
    <tr>
      <th>product_description_lenght</th>
      <td>610</td>
    </tr>
    <tr>
      <th>product_photos_qty</th>
      <td>610</td>
    </tr>
    <tr>
      <th>product_weight_g</th>
      <td>2</td>
    </tr>
    <tr>
      <th>product_length_cm</th>
      <td>2</td>
    </tr>
    <tr>
      <th>product_height_cm</th>
      <td>2</td>
    </tr>
    <tr>
      <th>product_width_cm</th>
      <td>2</td>
    </tr>
    <tr>
      <th>product_id</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
mask1_df4 = df4[df4['product_category_name'].isna()]
df3[df3['product_id'].isin(mask1_df4['product_id'])]
```





  <div id="df-8127f5f2-8655-41b2-a4f6-ce2654adcd23" class="colab-df-container">
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
      <th>order_id</th>
      <th>order_item_id</th>
      <th>product_id</th>
      <th>seller_id</th>
      <th>shipping_limit_date</th>
      <th>price</th>
      <th>freight_value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>123</th>
      <td>0046e1d57f4c07c8c92ab26be8c3dfc0</td>
      <td>1</td>
      <td>ff6caf9340512b8bf6d2a2a6df032cfa</td>
      <td>38e6dada03429a47197d5d584d793b41</td>
      <td>2017-10-02 15:49:17</td>
      <td>7.79</td>
      <td>7.78</td>
    </tr>
    <tr>
      <th>125</th>
      <td>00482f2670787292280e0a8153d82467</td>
      <td>1</td>
      <td>a9c404971d1a5b1cbc2e4070e02731fd</td>
      <td>702835e4b785b67a084280efca355756</td>
      <td>2017-02-17 16:18:07</td>
      <td>7.60</td>
      <td>10.96</td>
    </tr>
    <tr>
      <th>132</th>
      <td>004f5d8f238e8908e6864b874eda3391</td>
      <td>1</td>
      <td>5a848e4ab52fd5445cdc07aab1c40e48</td>
      <td>c826c40d7b19f62a09e2d7c5e7295ee2</td>
      <td>2018-03-06 09:29:25</td>
      <td>122.99</td>
      <td>15.61</td>
    </tr>
    <tr>
      <th>142</th>
      <td>0057199db02d1a5ef41bacbf41f8f63b</td>
      <td>1</td>
      <td>41eee23c25f7a574dfaf8d5c151dbb12</td>
      <td>e5a3438891c0bfdb9394643f95273d8e</td>
      <td>2018-01-25 09:07:51</td>
      <td>20.30</td>
      <td>16.79</td>
    </tr>
    <tr>
      <th>171</th>
      <td>006cb7cafc99b29548d4f412c7f9f493</td>
      <td>1</td>
      <td>e10758160da97891c2fdcbc35f0f031d</td>
      <td>323ce52b5b81df2cd804b017b7f09aa7</td>
      <td>2018-02-22 13:35:28</td>
      <td>56.00</td>
      <td>14.14</td>
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
    </tr>
    <tr>
      <th>112306</th>
      <td>ff24fec69b7f3d30f9dc1ab3aee7c179</td>
      <td>1</td>
      <td>5a848e4ab52fd5445cdc07aab1c40e48</td>
      <td>c826c40d7b19f62a09e2d7c5e7295ee2</td>
      <td>2018-02-01 02:40:12</td>
      <td>122.99</td>
      <td>15.61</td>
    </tr>
    <tr>
      <th>112333</th>
      <td>ff3024474be86400847879103757d1fd</td>
      <td>1</td>
      <td>f9b1795281ce51b1cf39ef6d101ae8ab</td>
      <td>3771c85bac139d2344864ede5d9341e3</td>
      <td>2017-11-21 03:55:39</td>
      <td>39.90</td>
      <td>9.94</td>
    </tr>
    <tr>
      <th>112350</th>
      <td>ff3a45ee744a7c1f8096d2e72c1a23e4</td>
      <td>1</td>
      <td>b61d1388a17e3f547d2bc218df02335b</td>
      <td>07017df32dc5f2f1d2801e579548d620</td>
      <td>2017-05-10 10:15:19</td>
      <td>139.00</td>
      <td>21.42</td>
    </tr>
    <tr>
      <th>112438</th>
      <td>ff7b636282b98e0aa524264b295ed928</td>
      <td>1</td>
      <td>431df35e52c10451171d8037482eeb43</td>
      <td>6cd68b3ed6d59aaa9fece558ad360c0a</td>
      <td>2018-02-22 15:35:35</td>
      <td>49.90</td>
      <td>15.11</td>
    </tr>
    <tr>
      <th>112501</th>
      <td>ffa5e4c604dea4f0a59d19cc2322ac19</td>
      <td>2</td>
      <td>bd421826916d3e1d445cb860cea3c0fb</td>
      <td>59cd88080b93f3c18508673122d26169</td>
      <td>2017-12-11 08:41:20</td>
      <td>29.99</td>
      <td>15.10</td>
    </tr>
  </tbody>
</table>
<p>1603 rows × 7 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-8127f5f2-8655-41b2-a4f6-ce2654adcd23')"
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
        document.querySelector('#df-8127f5f2-8655-41b2-a4f6-ce2654adcd23 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-8127f5f2-8655-41b2-a4f6-ce2654adcd23');
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


<div id="df-bd73a6cc-b62c-45d3-80e8-f1e8c1e4c6cd">
  <button class="colab-df-quickchart" onclick="quickchart('df-bd73a6cc-b62c-45d3-80e8-f1e8c1e4c6cd')"
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
        document.querySelector('#df-bd73a6cc-b62c-45d3-80e8-f1e8c1e4c6cd button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
mask2_df4 = df3[df3['product_id'].isin(mask1_df4['product_id'])]
df2[df2['order_id'].isin(mask2_df4['order_id'])]
```





  <div id="df-851781b7-4a0e-4422-a248-c8a6faaefa45" class="colab-df-container">
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
      <th>order_id</th>
      <th>customer_id</th>
      <th>order_status</th>
      <th>order_purchase_timestamp</th>
      <th>order_approved_at</th>
      <th>order_delivered_carrier_date</th>
      <th>order_delivered_customer_date</th>
      <th>order_estimated_delivery_date</th>
      <th>delivery_time</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>6</th>
      <td>136cce7faa42fdb2cefd53fdc79a6098</td>
      <td>ed0271e0b7da060a393796590e7b737a</td>
      <td>invoiced</td>
      <td>2017-04-11 12:22:08</td>
      <td>2017-04-13 13:25:17</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>2017-05-09 00:00:00</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>107</th>
      <td>bfe42c22ecbf90bc9f35cf591270b6a7</td>
      <td>803ac05904124294f8767894d6da532b</td>
      <td>delivered</td>
      <td>2018-01-27 22:04:34</td>
      <td>2018-01-27 22:16:18</td>
      <td>2018-02-03 03:56:00</td>
      <td>2018-02-09 20:16:40</td>
      <td>2018-02-26 00:00:00</td>
      <td>12.0</td>
    </tr>
    <tr>
      <th>180</th>
      <td>58ac1947c1a9067b9f416cba6d844a3f</td>
      <td>ee8e1d37f563ecc11cc4dcb4dfd794c2</td>
      <td>delivered</td>
      <td>2017-09-13 09:18:50</td>
      <td>2017-09-13 13:45:43</td>
      <td>2017-09-14 21:20:03</td>
      <td>2017-09-21 21:16:17</td>
      <td>2017-09-25 00:00:00</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>228</th>
      <td>e22b71f6e4a481445ec4527cb4c405f7</td>
      <td>1faf89c8f142db3fca6cf314c51a37b6</td>
      <td>delivered</td>
      <td>2017-04-22 13:48:18</td>
      <td>2017-04-22 14:01:13</td>
      <td>2017-04-24 19:08:53</td>
      <td>2017-05-02 15:45:27</td>
      <td>2017-05-11 00:00:00</td>
      <td>10.0</td>
    </tr>
    <tr>
      <th>263</th>
      <td>a094215e786240fcfefb83d18036a1cd</td>
      <td>86acfb656743da0c113d176832c9d535</td>
      <td>delivered</td>
      <td>2018-02-08 18:56:45</td>
      <td>2018-02-08 19:32:18</td>
      <td>2018-02-09 21:41:54</td>
      <td>2018-02-19 13:28:50</td>
      <td>2018-02-22 00:00:00</td>
      <td>10.0</td>
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
      <th>99069</th>
      <td>1a10e938a1c7d8e5eecc3380f71ca76b</td>
      <td>8a81607347c25d881d995d94de6ad824</td>
      <td>delivered</td>
      <td>2018-07-25 08:58:35</td>
      <td>2018-07-26 03:10:20</td>
      <td>2018-07-27 11:32:00</td>
      <td>2018-08-01 19:28:20</td>
      <td>2018-08-10 00:00:00</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>99215</th>
      <td>e33865519137f5737444109ae8438633</td>
      <td>64b086bdcc54458af3ea3bd838db54a5</td>
      <td>delivered</td>
      <td>2018-05-28 00:44:06</td>
      <td>2018-05-29 03:31:17</td>
      <td>2018-05-30 13:13:00</td>
      <td>2018-06-01 22:25:39</td>
      <td>2018-06-20 00:00:00</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>99222</th>
      <td>f0dd9af88d8ef5a8e4670fbbedaf19c4</td>
      <td>30ddb50bd22ee927ebe308ea3da60735</td>
      <td>delivered</td>
      <td>2017-09-02 20:38:29</td>
      <td>2017-09-05 04:24:12</td>
      <td>2017-09-14 23:13:41</td>
      <td>2017-09-15 14:59:50</td>
      <td>2017-09-19 00:00:00</td>
      <td>12.0</td>
    </tr>
    <tr>
      <th>99228</th>
      <td>272874573723eec18f23c0471927d778</td>
      <td>48e080c8001e92ebea2b64e474f91a60</td>
      <td>delivered</td>
      <td>2017-12-20 23:10:33</td>
      <td>2017-12-20 23:29:37</td>
      <td>2017-12-21 21:49:35</td>
      <td>2017-12-26 22:29:32</td>
      <td>2018-01-09 00:00:00</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>99245</th>
      <td>dff2b9b8d7cfc595836945e1443789c3</td>
      <td>2436fb2666a65fbacae82532e797cabf</td>
      <td>delivered</td>
      <td>2018-07-16 12:59:02</td>
      <td>2018-07-17 04:21:00</td>
      <td>2018-07-17 15:08:00</td>
      <td>2018-07-20 20:41:32</td>
      <td>2018-08-07 00:00:00</td>
      <td>4.0</td>
    </tr>
  </tbody>
</table>
<p>1451 rows × 9 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-851781b7-4a0e-4422-a248-c8a6faaefa45')"
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
        document.querySelector('#df-851781b7-4a0e-4422-a248-c8a6faaefa45 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-851781b7-4a0e-4422-a248-c8a6faaefa45');
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


<div id="df-f93ceb9c-fea5-4e9b-92ad-344a78da2aa0">
  <button class="colab-df-quickchart" onclick="quickchart('df-f93ceb9c-fea5-4e9b-92ad-344a78da2aa0')"
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
        document.querySelector('#df-f93ceb9c-fea5-4e9b-92ad-344a78da2aa0 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




- 상품이 카테고리화되지 않았지만 배송완료된 주문이 있다. 카테고리 미분류 상품으로 취급해야한다.


```python
# 중복값 확인
df4['product_id'].duplicated().sum()
```




    0



- products 데이터는 주문된 상품들의 정보를 보여주고있음

### (참고) 상품명 번역 정보 (product_category_name_translation.csv)




```python
df4_name = pd.read_csv('/content/drive/MyDrive/archive/product_category_name_translation.csv')
df4_name
```





  <div id="df-88f7e31a-47a2-47a6-817d-32a12914879b" class="colab-df-container">
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
      <th>product_category_name</th>
      <th>product_category_name_english</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>beleza_saude</td>
      <td>health_beauty</td>
    </tr>
    <tr>
      <th>1</th>
      <td>informatica_acessorios</td>
      <td>computers_accessories</td>
    </tr>
    <tr>
      <th>2</th>
      <td>automotivo</td>
      <td>auto</td>
    </tr>
    <tr>
      <th>3</th>
      <td>cama_mesa_banho</td>
      <td>bed_bath_table</td>
    </tr>
    <tr>
      <th>4</th>
      <td>moveis_decoracao</td>
      <td>furniture_decor</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>66</th>
      <td>flores</td>
      <td>flowers</td>
    </tr>
    <tr>
      <th>67</th>
      <td>artes_e_artesanato</td>
      <td>arts_and_craftmanship</td>
    </tr>
    <tr>
      <th>68</th>
      <td>fraldas_higiene</td>
      <td>diapers_and_hygiene</td>
    </tr>
    <tr>
      <th>69</th>
      <td>fashion_roupa_infanto_juvenil</td>
      <td>fashion_childrens_clothes</td>
    </tr>
    <tr>
      <th>70</th>
      <td>seguros_e_servicos</td>
      <td>security_and_services</td>
    </tr>
  </tbody>
</table>
<p>71 rows × 2 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-88f7e31a-47a2-47a6-817d-32a12914879b')"
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
        document.querySelector('#df-88f7e31a-47a2-47a6-817d-32a12914879b button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-88f7e31a-47a2-47a6-817d-32a12914879b');
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


<div id="df-e41bbe39-1540-4f9b-9a6d-999a0c12b0ba">
  <button class="colab-df-quickchart" onclick="quickchart('df-e41bbe39-1540-4f9b-9a6d-999a0c12b0ba')"
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
        document.querySelector('#df-e41bbe39-1540-4f9b-9a6d-999a0c12b0ba button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_65e40aba-909d-41a4-a1da-8712f997b235">
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
    <button class="colab-df-generate" onclick="generateWithVariable('df4_name')"
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
        document.querySelector('#id_65e40aba-909d-41a4-a1da-8712f997b235 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('df4_name');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 카테고리 영어로 변경
category_map = df4_name.set_index('product_category_name')['product_category_name_english'].to_dict()
df4['product_category_name'] = df4['product_category_name'].map(category_map).fillna(df4['product_category_name'])
```


```python
df4['product_category_name'].unique()
```




    array(['perfumery', 'art', 'sports_leisure', 'baby', 'housewares',
           'musical_instruments', 'cool_stuff', 'furniture_decor',
           'home_appliances', 'toys', 'bed_bath_table',
           'construction_tools_safety', 'computers_accessories',
           'health_beauty', 'luggage_accessories', 'garden_tools',
           'office_furniture', 'auto', 'electronics', 'fashion_shoes',
           'telephony', 'stationery', 'fashion_bags_accessories', 'computers',
           'home_construction', 'watches_gifts',
           'construction_tools_construction', 'pet_shop', 'small_appliances',
           'agro_industry_and_commerce', nan, 'furniture_living_room',
           'signaling_and_security', 'air_conditioning', 'consoles_games',
           'books_general_interest', 'costruction_tools_tools',
           'fashion_underwear_beach', 'fashion_male_clothing',
           'kitchen_dining_laundry_garden_furniture',
           'industry_commerce_and_business', 'fixed_telephony',
           'construction_tools_lights', 'books_technical',
           'home_appliances_2', 'party_supplies', 'drinks', 'market_place',
           'la_cuisine', 'costruction_tools_garden', 'fashio_female_clothing',
           'home_confort', 'audio', 'food_drink', 'music', 'food',
           'tablets_printing_image', 'books_imported',
           'small_appliances_home_oven_and_coffee', 'fashion_sport',
           'christmas_supplies', 'fashion_childrens_clothes', 'dvds_blu_ray',
           'arts_and_craftmanship', 'pc_gamer', 'furniture_bedroom',
           'cine_photo', 'diapers_and_hygiene', 'flowers', 'home_comfort_2',
           'portateis_cozinha_e_preparadores_de_alimentos',
           'security_and_services', 'furniture_mattress_and_upholstery',
           'cds_dvds_musicals'], dtype=object)




```python
merged_df_product = pd.merge(df3, df4[['product_id', 'product_category_name']], on='product_id', how='left')
merged_df_product
```





  <div id="df-813b7300-5422-4754-84bd-e9c86b08b055" class="colab-df-container">
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
      <th>order_id</th>
      <th>order_item_id</th>
      <th>product_id</th>
      <th>seller_id</th>
      <th>shipping_limit_date</th>
      <th>price</th>
      <th>freight_value</th>
      <th>product_category_name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>00010242fe8c5a6d1ba2dd792cb16214</td>
      <td>1</td>
      <td>4244733e06e7ecb4970a6e2683c13e61</td>
      <td>48436dade18ac8b2bce089ec2a041202</td>
      <td>2017-09-19 09:45:35</td>
      <td>58.90</td>
      <td>13.29</td>
      <td>cool_stuff</td>
    </tr>
    <tr>
      <th>1</th>
      <td>00018f77f2f0320c557190d7a144bdd3</td>
      <td>1</td>
      <td>e5f2d52b802189ee658865ca93d83a8f</td>
      <td>dd7ddc04e1b6c2c614352b383efe2d36</td>
      <td>2017-05-03 11:05:13</td>
      <td>239.90</td>
      <td>19.93</td>
      <td>pet_shop</td>
    </tr>
    <tr>
      <th>2</th>
      <td>000229ec398224ef6ca0657da4fc703e</td>
      <td>1</td>
      <td>c777355d18b72b67abbeef9df44fd0fd</td>
      <td>5b51032eddd242adc84c38acab88f23d</td>
      <td>2018-01-18 14:48:30</td>
      <td>199.00</td>
      <td>17.87</td>
      <td>furniture_decor</td>
    </tr>
    <tr>
      <th>3</th>
      <td>00024acbcdf0a6daa1e931b038114c75</td>
      <td>1</td>
      <td>7634da152a4610f1595efa32f14722fc</td>
      <td>9d7a1d34a5052409006425275ba1c2b4</td>
      <td>2018-08-15 10:10:18</td>
      <td>12.99</td>
      <td>12.79</td>
      <td>perfumery</td>
    </tr>
    <tr>
      <th>4</th>
      <td>00042b26cf59d7ce69dfabb4e55b4fd9</td>
      <td>1</td>
      <td>ac6c3623068f30de03045865e4e10089</td>
      <td>df560393f3a51e74553ab94004ba5c87</td>
      <td>2017-02-13 13:57:51</td>
      <td>199.90</td>
      <td>18.14</td>
      <td>garden_tools</td>
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
    </tr>
    <tr>
      <th>112645</th>
      <td>fffc94f6ce00a00581880bf54a75a037</td>
      <td>1</td>
      <td>4aa6014eceb682077f9dc4bffebc05b0</td>
      <td>b8bc237ba3788b23da09c0f1f3a3288c</td>
      <td>2018-05-02 04:11:01</td>
      <td>299.99</td>
      <td>43.41</td>
      <td>housewares</td>
    </tr>
    <tr>
      <th>112646</th>
      <td>fffcd46ef2263f404302a634eb57f7eb</td>
      <td>1</td>
      <td>32e07fd915822b0765e448c4dd74c828</td>
      <td>f3c38ab652836d21de61fb8314b69182</td>
      <td>2018-07-20 04:31:48</td>
      <td>350.00</td>
      <td>36.53</td>
      <td>computers_accessories</td>
    </tr>
    <tr>
      <th>112647</th>
      <td>fffce4705a9662cd70adb13d4a31832d</td>
      <td>1</td>
      <td>72a30483855e2eafc67aee5dc2560482</td>
      <td>c3cfdc648177fdbbbb35635a37472c53</td>
      <td>2017-10-30 17:14:25</td>
      <td>99.90</td>
      <td>16.95</td>
      <td>sports_leisure</td>
    </tr>
    <tr>
      <th>112648</th>
      <td>fffe18544ffabc95dfada21779c9644f</td>
      <td>1</td>
      <td>9c422a519119dcad7575db5af1ba540e</td>
      <td>2b3e4a2a3ea8e01938cabda2a3e5cc79</td>
      <td>2017-08-21 00:04:32</td>
      <td>55.99</td>
      <td>8.72</td>
      <td>computers_accessories</td>
    </tr>
    <tr>
      <th>112649</th>
      <td>fffe41c64501cc87c801fd61db3f6244</td>
      <td>1</td>
      <td>350688d9dc1e75ff97be326363655e01</td>
      <td>f7ccf836d21b2fb1de37564105216cc1</td>
      <td>2018-06-12 17:10:13</td>
      <td>43.00</td>
      <td>12.79</td>
      <td>bed_bath_table</td>
    </tr>
  </tbody>
</table>
<p>112650 rows × 8 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-813b7300-5422-4754-84bd-e9c86b08b055')"
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
        document.querySelector('#df-813b7300-5422-4754-84bd-e9c86b08b055 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-813b7300-5422-4754-84bd-e9c86b08b055');
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


<div id="df-0a881e94-47ce-420b-949d-4076a6459398">
  <button class="colab-df-quickchart" onclick="quickchart('df-0a881e94-47ce-420b-949d-4076a6459398')"
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
        document.querySelector('#df-0a881e94-47ce-420b-949d-4076a6459398 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_9e2df7f7-01eb-483e-90f9-c68b9030d3cb">
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
    <button class="colab-df-generate" onclick="generateWithVariable('merged_df_product')"
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
        document.querySelector('#id_9e2df7f7-01eb-483e-90f9-c68b9030d3cb button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('merged_df_product');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 1. 'product_category_name'에 대한 빈도수 계산
category_counts = merged_df_product['product_category_name'].value_counts()
category_revenue = merged_df_product.groupby('product_category_name')['price'].sum()

# 2. 첫 번째 줄을 위한 상위 10개 카테고리 선택 및 정렬
top_categories_counts = category_counts.head(10).sort_values(ascending=True)
top_categories_revenue = category_revenue[top_categories_counts.index]

# 3. 두 번째 줄을 위한 총매출액 상위 10개 카테고리 선택 (정렬)
top_revenue_categories = category_revenue.nlargest(10).sort_values(ascending=True)

# 4. subplot 생성 (2x2)
fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(14, 10))

# 5. 차트 생성 함수
def create_bar_chart(ax, x_data, y_data, title, xlabel, color):
    bars = ax.barh(x_data, y_data, color=color)
    ax.set_title(title)
    ax.set_xlabel(xlabel)
    ax.grid(axis='x')
    for bar in bars:
        ax.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
                f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=9)

# 6. 첫 번째 차트: 'product_category_name' 빈도수 (상위 10개)
create_bar_chart(ax1, top_categories_counts.index, top_categories_counts.values,
                 '상품 카테고리별 빈도수 (상위 10개)', '빈도수', 'skyblue')

# 7. 두 번째 차트: 'product_category_name'의 총 매출액 (상위 10개)
create_bar_chart(ax2, top_categories_counts.index, top_categories_revenue,
                 '상품 카테고리별 총 매출액 (상위 10개)', '총 매출액', 'lightgreen')

# 8. 세 번째 차트: 총매출액 상위 10개의 상품 카테고리
create_bar_chart(ax3, top_revenue_categories.index, top_revenue_categories.values,
                 '총 매출액 상위 10개 상품 카테고리', '총 매출액', 'orange')

# 9. 네 번째 차트: 빈도수 (상위 10개 카테고리, 정렬하지 않음)
create_bar_chart(ax4, top_revenue_categories.index, category_counts[top_revenue_categories.index],
                 '상품 카테고리별 빈도수 (상위 10개)', '빈도수', 'skyblue')

ax2.yaxis.set_visible(False)
ax4.yaxis.set_visible(False)

for ax in [ax1, ax2, ax3, ax4]:
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_79_0.png)
    



```python
# 1. 'product_category_name'에 대한 빈도수 계산
category_counts = merged_df_product['product_category_name'].value_counts()
category_revenue = merged_df_product.groupby('product_category_name')['price'].sum()

# 2. 전체 매출액 및 전체 빈도수 계산
total_revenue = category_revenue.sum()
total_count = category_counts.sum()

# 3. 첫 번째 줄을 위한 상위 10개 카테고리 선택 및 정렬
top_categories_counts = category_counts.head(10).sort_values(ascending=True)
top_categories_revenue = category_revenue[top_categories_counts.index]

# 4. 상위 10개 카테고리의 매출 비중 및 빈도 비중 계산
top_revenue_percentage = (top_categories_revenue / total_revenue) * 100
top_count_percentage = (top_categories_counts / total_count) * 100

# 5. subplot 생성 (2x2)
fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(14, 10))

# 6. 차트 생성 함수
def create_bar_chart(ax, x_data, y_data, title, xlabel, color):
    bars = ax.barh(x_data, y_data, color=color)
    ax.set_title(title)
    ax.set_xlabel(xlabel)
    ax.grid(axis='x')
    for bar in bars:
        ax.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
                f'{bar.get_width():,.1f}%', va='center', ha='left', fontsize=9)

# 7. 첫 번째 차트: 'product_category_name' 빈도수 비중 (상위 10개)
create_bar_chart(ax1, top_categories_counts.index, top_count_percentage,
                 '상품 카테고리별 빈도수 비중 (%) (상위 10개)', '빈도수 비중 (%)', 'skyblue')

# 8. 두 번째 차트: 상위 10개 카테고리의 매출 비중
create_bar_chart(ax2, top_categories_counts.index, top_revenue_percentage,
                 '상품 카테고리별 매출 비중 (%) (상위 10개)', '매출 비중 (%)', 'lightgreen')

# 9. 세 번째 차트: 전체 매출액 상위 10개의 상품 카테고리 비중
top_revenue_categories = category_revenue.nlargest(10).sort_values(ascending=True)
top_revenue_categories_percentage = (top_revenue_categories / total_revenue) * 100
create_bar_chart(ax3, top_revenue_categories.index, top_revenue_categories_percentage,
                 '총 매출액 상위 10개 상품 카테고리 비중 (%)', '매출 비중 (%)', 'orange')

# 10. 네 번째 차트: 빈도수 (상위 10개 카테고리, 비중)
top_revenue_categories_counts = category_counts[top_revenue_categories.index]
top_revenue_categories_counts_percentage = (top_revenue_categories_counts / total_count) * 100
create_bar_chart(ax4, top_revenue_categories.index, top_revenue_categories_counts_percentage,
                 '상품 카테고리별 빈도수 비중 (%) (상위 10개)', '빈도수 비중 (%)', 'skyblue')

ax2.yaxis.set_visible(False)
ax4.yaxis.set_visible(False)

for ax in [ax1, ax2, ax3, ax4]:
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_80_0.png)
    


- 판매량과 매출액이 반드시 비례하는것은 아닌것으로 관찰됨
- 특정 카테고리 매출비중이 높지않고 고르게 매출이 발생하고있으며, 건강과 미용 상품과 선물용 시계 상품이 각각 전체매출에 약 9% 비중을 차지하는 상위품목으로 관찰됨

### 5. Sellers (olist_sellers_dataset.csv)

| 컬럼 이름              | 데이터 타입 | 설명                     |
| ---------------------- | ----------- | ------------------------ |
| seller_id              | VARCHAR     | 판매자 고유 식별자       |
| seller_zip_code_prefix | INT         | 판매자의 우편번호 앞부분 |
| seller_city            | VARCHAR     | 판매자의 도시 정보       |
| seller_state           | VARCHAR     | 판매자의 주 정보         |




```python
df5 = pd.read_csv('/content/drive/MyDrive/archive/olist_sellers_dataset.csv')
df5
```





  <div id="df-7b507821-873e-41d2-8bc4-ff59a1e049c9" class="colab-df-container">
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
      <th>seller_id</th>
      <th>seller_zip_code_prefix</th>
      <th>seller_city</th>
      <th>seller_state</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>3442f8959a84dea7ee197c632cb2df15</td>
      <td>13023</td>
      <td>campinas</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>1</th>
      <td>d1b65fc7debc3361ea86b5f14c68d2e2</td>
      <td>13844</td>
      <td>mogi guacu</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>2</th>
      <td>ce3ad9de960102d0677a81f5d0bb7b2d</td>
      <td>20031</td>
      <td>rio de janeiro</td>
      <td>RJ</td>
    </tr>
    <tr>
      <th>3</th>
      <td>c0f3eea2e14555b6faeea3dd58c1b1c3</td>
      <td>4195</td>
      <td>sao paulo</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>4</th>
      <td>51a04a8a6bdcb23deccc82b0b80742cf</td>
      <td>12914</td>
      <td>braganca paulista</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>3090</th>
      <td>98dddbc4601dd4443ca174359b237166</td>
      <td>87111</td>
      <td>sarandi</td>
      <td>PR</td>
    </tr>
    <tr>
      <th>3091</th>
      <td>f8201cab383e484733266d1906e2fdfa</td>
      <td>88137</td>
      <td>palhoca</td>
      <td>SC</td>
    </tr>
    <tr>
      <th>3092</th>
      <td>74871d19219c7d518d0090283e03c137</td>
      <td>4650</td>
      <td>sao paulo</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>3093</th>
      <td>e603cf3fec55f8697c9059638d6c8eb5</td>
      <td>96080</td>
      <td>pelotas</td>
      <td>RS</td>
    </tr>
    <tr>
      <th>3094</th>
      <td>9e25199f6ef7e7c347120ff175652c3b</td>
      <td>12051</td>
      <td>taubate</td>
      <td>SP</td>
    </tr>
  </tbody>
</table>
<p>3095 rows × 4 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-7b507821-873e-41d2-8bc4-ff59a1e049c9')"
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
        document.querySelector('#df-7b507821-873e-41d2-8bc4-ff59a1e049c9 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-7b507821-873e-41d2-8bc4-ff59a1e049c9');
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


<div id="df-98fda617-9952-4c21-acdf-497a65d2c53d">
  <button class="colab-df-quickchart" onclick="quickchart('df-98fda617-9952-4c21-acdf-497a65d2c53d')"
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
        document.querySelector('#df-98fda617-9952-4c21-acdf-497a65d2c53d button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_06222cb5-31ec-4b4c-b037-2a26376f91e1">
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
    <button class="colab-df-generate" onclick="generateWithVariable('df5')"
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
        document.querySelector('#id_06222cb5-31ec-4b4c-b037-2a26376f91e1 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('df5');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 결측치 확인
df5.isna().sum().sort_values(ascending=False)
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
      <th>seller_id</th>
      <td>0</td>
    </tr>
    <tr>
      <th>seller_zip_code_prefix</th>
      <td>0</td>
    </tr>
    <tr>
      <th>seller_city</th>
      <td>0</td>
    </tr>
    <tr>
      <th>seller_state</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
# 중복값 확인
df5['seller_id'].duplicated().sum()
```




    0



- sellers 데이터는 olist에서 판매중인 고객 정보를 담고있으며, 총 3,095명 고객이 판매를 하고있다


```python
df3_new = df3.copy()
df3_new = df3_new.merge(df2, on='order_id', how='left')
df3_new = df3_new.merge(df, on='customer_id', how='left')
df3_new = df3_new.merge(df5, on='seller_id', how='left')
```


```python
df3_new
```





  <div id="df-7621e610-71ff-4c0f-8204-45895c08c5df" class="colab-df-container">
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
      <th>order_id</th>
      <th>order_item_id</th>
      <th>product_id</th>
      <th>seller_id</th>
      <th>shipping_limit_date</th>
      <th>price</th>
      <th>freight_value</th>
      <th>customer_id</th>
      <th>order_status</th>
      <th>order_purchase_timestamp</th>
      <th>...</th>
      <th>order_delivered_customer_date</th>
      <th>order_estimated_delivery_date</th>
      <th>delivery_time</th>
      <th>customer_unique_id</th>
      <th>customer_zip_code_prefix</th>
      <th>customer_city</th>
      <th>customer_state</th>
      <th>seller_zip_code_prefix</th>
      <th>seller_city</th>
      <th>seller_state</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>00010242fe8c5a6d1ba2dd792cb16214</td>
      <td>1</td>
      <td>4244733e06e7ecb4970a6e2683c13e61</td>
      <td>48436dade18ac8b2bce089ec2a041202</td>
      <td>2017-09-19 09:45:35</td>
      <td>58.90</td>
      <td>13.29</td>
      <td>3ce436f183e68e07877b285a838db11a</td>
      <td>delivered</td>
      <td>2017-09-13 08:59:02</td>
      <td>...</td>
      <td>2017-09-20 23:43:48</td>
      <td>2017-09-29 00:00:00</td>
      <td>7.0</td>
      <td>871766c5855e863f6eccc05f988b23cb</td>
      <td>28013</td>
      <td>campos dos goytacazes</td>
      <td>RJ</td>
      <td>27277</td>
      <td>volta redonda</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>1</th>
      <td>00018f77f2f0320c557190d7a144bdd3</td>
      <td>1</td>
      <td>e5f2d52b802189ee658865ca93d83a8f</td>
      <td>dd7ddc04e1b6c2c614352b383efe2d36</td>
      <td>2017-05-03 11:05:13</td>
      <td>239.90</td>
      <td>19.93</td>
      <td>f6dd3ec061db4e3987629fe6b26e5cce</td>
      <td>delivered</td>
      <td>2017-04-26 10:53:06</td>
      <td>...</td>
      <td>2017-05-12 16:04:24</td>
      <td>2017-05-15 00:00:00</td>
      <td>16.0</td>
      <td>eb28e67c4c0b83846050ddfb8a35d051</td>
      <td>15775</td>
      <td>santa fe do sul</td>
      <td>SP</td>
      <td>3471</td>
      <td>sao paulo</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>2</th>
      <td>000229ec398224ef6ca0657da4fc703e</td>
      <td>1</td>
      <td>c777355d18b72b67abbeef9df44fd0fd</td>
      <td>5b51032eddd242adc84c38acab88f23d</td>
      <td>2018-01-18 14:48:30</td>
      <td>199.00</td>
      <td>17.87</td>
      <td>6489ae5e4333f3693df5ad4372dab6d3</td>
      <td>delivered</td>
      <td>2018-01-14 14:33:31</td>
      <td>...</td>
      <td>2018-01-22 13:19:16</td>
      <td>2018-02-05 00:00:00</td>
      <td>7.0</td>
      <td>3818d81c6709e39d06b2738a8d3a2474</td>
      <td>35661</td>
      <td>para de minas</td>
      <td>MG</td>
      <td>37564</td>
      <td>borda da mata</td>
      <td>MG</td>
    </tr>
    <tr>
      <th>3</th>
      <td>00024acbcdf0a6daa1e931b038114c75</td>
      <td>1</td>
      <td>7634da152a4610f1595efa32f14722fc</td>
      <td>9d7a1d34a5052409006425275ba1c2b4</td>
      <td>2018-08-15 10:10:18</td>
      <td>12.99</td>
      <td>12.79</td>
      <td>d4eb9395c8c0431ee92fce09860c5a06</td>
      <td>delivered</td>
      <td>2018-08-08 10:00:35</td>
      <td>...</td>
      <td>2018-08-14 13:32:39</td>
      <td>2018-08-20 00:00:00</td>
      <td>6.0</td>
      <td>af861d436cfc08b2c2ddefd0ba074622</td>
      <td>12952</td>
      <td>atibaia</td>
      <td>SP</td>
      <td>14403</td>
      <td>franca</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>4</th>
      <td>00042b26cf59d7ce69dfabb4e55b4fd9</td>
      <td>1</td>
      <td>ac6c3623068f30de03045865e4e10089</td>
      <td>df560393f3a51e74553ab94004ba5c87</td>
      <td>2017-02-13 13:57:51</td>
      <td>199.90</td>
      <td>18.14</td>
      <td>58dbd0b2d70206bf40e62cd34e84d795</td>
      <td>delivered</td>
      <td>2017-02-04 13:57:51</td>
      <td>...</td>
      <td>2017-03-01 16:42:31</td>
      <td>2017-03-17 00:00:00</td>
      <td>25.0</td>
      <td>64b576fb70d441e8f1b2d7d446e483c5</td>
      <td>13226</td>
      <td>varzea paulista</td>
      <td>SP</td>
      <td>87900</td>
      <td>loanda</td>
      <td>PR</td>
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
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>112645</th>
      <td>fffc94f6ce00a00581880bf54a75a037</td>
      <td>1</td>
      <td>4aa6014eceb682077f9dc4bffebc05b0</td>
      <td>b8bc237ba3788b23da09c0f1f3a3288c</td>
      <td>2018-05-02 04:11:01</td>
      <td>299.99</td>
      <td>43.41</td>
      <td>b51593916b4b8e0d6f66f2ae24f2673d</td>
      <td>delivered</td>
      <td>2018-04-23 13:57:06</td>
      <td>...</td>
      <td>2018-05-10 22:56:40</td>
      <td>2018-05-18 00:00:00</td>
      <td>17.0</td>
      <td>0c9aeda10a71f369396d0c04dce13a64</td>
      <td>65077</td>
      <td>sao luis</td>
      <td>MA</td>
      <td>88303</td>
      <td>itajai</td>
      <td>SC</td>
    </tr>
    <tr>
      <th>112646</th>
      <td>fffcd46ef2263f404302a634eb57f7eb</td>
      <td>1</td>
      <td>32e07fd915822b0765e448c4dd74c828</td>
      <td>f3c38ab652836d21de61fb8314b69182</td>
      <td>2018-07-20 04:31:48</td>
      <td>350.00</td>
      <td>36.53</td>
      <td>84c5d4fbaf120aae381fad077416eaa0</td>
      <td>delivered</td>
      <td>2018-07-14 10:26:46</td>
      <td>...</td>
      <td>2018-07-23 20:31:55</td>
      <td>2018-08-01 00:00:00</td>
      <td>9.0</td>
      <td>0da9fe112eae0c74d3ba1fe16de0988b</td>
      <td>81690</td>
      <td>curitiba</td>
      <td>PR</td>
      <td>1206</td>
      <td>sao paulo</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>112647</th>
      <td>fffce4705a9662cd70adb13d4a31832d</td>
      <td>1</td>
      <td>72a30483855e2eafc67aee5dc2560482</td>
      <td>c3cfdc648177fdbbbb35635a37472c53</td>
      <td>2017-10-30 17:14:25</td>
      <td>99.90</td>
      <td>16.95</td>
      <td>29309aa813182aaddc9b259e31b870e6</td>
      <td>delivered</td>
      <td>2017-10-23 17:07:56</td>
      <td>...</td>
      <td>2017-10-28 12:22:22</td>
      <td>2017-11-10 00:00:00</td>
      <td>4.0</td>
      <td>cd79b407828f02fdbba457111c38e4c4</td>
      <td>4039</td>
      <td>sao paulo</td>
      <td>SP</td>
      <td>80610</td>
      <td>curitiba</td>
      <td>PR</td>
    </tr>
    <tr>
      <th>112648</th>
      <td>fffe18544ffabc95dfada21779c9644f</td>
      <td>1</td>
      <td>9c422a519119dcad7575db5af1ba540e</td>
      <td>2b3e4a2a3ea8e01938cabda2a3e5cc79</td>
      <td>2017-08-21 00:04:32</td>
      <td>55.99</td>
      <td>8.72</td>
      <td>b5e6afd5a41800fdf401e0272ca74655</td>
      <td>delivered</td>
      <td>2017-08-14 23:02:59</td>
      <td>...</td>
      <td>2017-08-16 21:59:40</td>
      <td>2017-08-25 00:00:00</td>
      <td>1.0</td>
      <td>eb803377c9315b564bdedad672039306</td>
      <td>13289</td>
      <td>vinhedo</td>
      <td>SP</td>
      <td>4733</td>
      <td>sao paulo</td>
      <td>SP</td>
    </tr>
    <tr>
      <th>112649</th>
      <td>fffe41c64501cc87c801fd61db3f6244</td>
      <td>1</td>
      <td>350688d9dc1e75ff97be326363655e01</td>
      <td>f7ccf836d21b2fb1de37564105216cc1</td>
      <td>2018-06-12 17:10:13</td>
      <td>43.00</td>
      <td>12.79</td>
      <td>96d649da0cc4ff33bb408b199d4c7dcf</td>
      <td>delivered</td>
      <td>2018-06-09 17:00:18</td>
      <td>...</td>
      <td>2018-06-14 17:56:26</td>
      <td>2018-06-28 00:00:00</td>
      <td>5.0</td>
      <td>cd76a00d8e3ca5e6ab9ed9ecb6667ac4</td>
      <td>18605</td>
      <td>botucatu</td>
      <td>SP</td>
      <td>14940</td>
      <td>ibitinga</td>
      <td>SP</td>
    </tr>
  </tbody>
</table>
<p>112650 rows × 22 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-7621e610-71ff-4c0f-8204-45895c08c5df')"
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
        document.querySelector('#df-7621e610-71ff-4c0f-8204-45895c08c5df button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-7621e610-71ff-4c0f-8204-45895c08c5df');
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


<div id="df-39d2564c-32f3-4636-a3d0-dcefea83e187">
  <button class="colab-df-quickchart" onclick="quickchart('df-39d2564c-32f3-4636-a3d0-dcefea83e187')"
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
        document.querySelector('#df-39d2564c-32f3-4636-a3d0-dcefea83e187 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_8c56cc87-6176-4815-8037-71a13bbb7da2">
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
    <button class="colab-df-generate" onclick="generateWithVariable('df3_new')"
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
        document.querySelector('#id_8c56cc87-6176-4815-8037-71a13bbb7da2 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('df3_new');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 1. customer_state와 seller_state의 빈도수 계산
customer_state_counts = df3_new['customer_state'].value_counts().head(10).sort_values(ascending=True)
seller_state_counts = df3_new['seller_state'].value_counts().head(10).sort_values(ascending=True)

# 2. subplot 생성 (1x2)
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

# 3. 첫 번째 차트: customer_state 빈도수
bars1 = ax1.barh(customer_state_counts.index, customer_state_counts.values, color='skyblue')
ax1.set_title('상위 10개 고객 주(State) 빈도수')
ax1.set_xlabel('빈도수')
ax1.grid(axis='x')

# 4. 숫자 표기
for bar in bars1:
    ax1.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
             f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=9)

# 5. 두 번째 차트: seller_state 빈도수
bars2 = ax2.barh(seller_state_counts.index, seller_state_counts.values, color='lightgreen')
ax2.set_title('상위 10개 판매자 주(State) 빈도수')
ax2.set_xlabel('빈도수')
ax2.grid(axis='x')

for bar in bars2:
    ax2.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
             f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=9)

ax1.spines['top'].set_visible(False)
ax1.spines['right'].set_visible(False)
ax2.spines['top'].set_visible(False)
ax2.spines['right'].set_visible(False)

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_89_0.png)
    


- 대부분의 상품은 SP주에서 배송되고있으며, 구매 고객과 판매 고객의 위치 차이로 배송기간이 길어질 수 있음

### 6. Order Payments (olist_order_payments_dataset.csv)

| 컬럼 이름            | 데이터 타입 | 설명                          |
| -------------------- | ----------- | ----------------------------- |
| order_id             | VARCHAR     | 주문 고유 식별자              |
| payment_sequential   | INT         | 각 주문의 결제 수단 순서      |
| payment_type         | VARCHAR     | 결제 방식 (신용카드, 현금 등) |
| payment_installments | INT         | 할부 개월 수                  |
| payment_value        | FLOAT       | 결제 금액                     |



```python
df6 = pd.read_csv('/content/drive/MyDrive/archive/olist_order_payments_dataset.csv')
df6
```





  <div id="df-5c52fec2-1526-4eea-a20e-64fd483ba109" class="colab-df-container">
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
      <th>order_id</th>
      <th>payment_sequential</th>
      <th>payment_type</th>
      <th>payment_installments</th>
      <th>payment_value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>b81ef226f3fe1789b1e8b2acac839d17</td>
      <td>1</td>
      <td>credit_card</td>
      <td>8</td>
      <td>99.33</td>
    </tr>
    <tr>
      <th>1</th>
      <td>a9810da82917af2d9aefd1278f1dcfa0</td>
      <td>1</td>
      <td>credit_card</td>
      <td>1</td>
      <td>24.39</td>
    </tr>
    <tr>
      <th>2</th>
      <td>25e8ea4e93396b6fa0d3dd708e76c1bd</td>
      <td>1</td>
      <td>credit_card</td>
      <td>1</td>
      <td>65.71</td>
    </tr>
    <tr>
      <th>3</th>
      <td>ba78997921bbcdc1373bb41e913ab953</td>
      <td>1</td>
      <td>credit_card</td>
      <td>8</td>
      <td>107.78</td>
    </tr>
    <tr>
      <th>4</th>
      <td>42fdf880ba16b47b59251dd489d4441a</td>
      <td>1</td>
      <td>credit_card</td>
      <td>2</td>
      <td>128.45</td>
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
      <th>103881</th>
      <td>0406037ad97740d563a178ecc7a2075c</td>
      <td>1</td>
      <td>boleto</td>
      <td>1</td>
      <td>363.31</td>
    </tr>
    <tr>
      <th>103882</th>
      <td>7b905861d7c825891d6347454ea7863f</td>
      <td>1</td>
      <td>credit_card</td>
      <td>2</td>
      <td>96.80</td>
    </tr>
    <tr>
      <th>103883</th>
      <td>32609bbb3dd69b3c066a6860554a77bf</td>
      <td>1</td>
      <td>credit_card</td>
      <td>1</td>
      <td>47.77</td>
    </tr>
    <tr>
      <th>103884</th>
      <td>b8b61059626efa996a60be9bb9320e10</td>
      <td>1</td>
      <td>credit_card</td>
      <td>5</td>
      <td>369.54</td>
    </tr>
    <tr>
      <th>103885</th>
      <td>28bbae6599b09d39ca406b747b6632b1</td>
      <td>1</td>
      <td>boleto</td>
      <td>1</td>
      <td>191.58</td>
    </tr>
  </tbody>
</table>
<p>103886 rows × 5 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-5c52fec2-1526-4eea-a20e-64fd483ba109')"
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
        document.querySelector('#df-5c52fec2-1526-4eea-a20e-64fd483ba109 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-5c52fec2-1526-4eea-a20e-64fd483ba109');
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


<div id="df-3d9122b3-2c19-417e-81ef-27e740e9ce3e">
  <button class="colab-df-quickchart" onclick="quickchart('df-3d9122b3-2c19-417e-81ef-27e740e9ce3e')"
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
        document.querySelector('#df-3d9122b3-2c19-417e-81ef-27e740e9ce3e button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_5825535a-9cb3-4348-9c04-f52e08febba7">
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
    <button class="colab-df-generate" onclick="generateWithVariable('df6')"
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
        document.querySelector('#id_5825535a-9cb3-4348-9c04-f52e08febba7 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('df6');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 결측치 확인
df6.isna().sum().sort_values(ascending=False)
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
      <th>order_id</th>
      <td>0</td>
    </tr>
    <tr>
      <th>payment_sequential</th>
      <td>0</td>
    </tr>
    <tr>
      <th>payment_type</th>
      <td>0</td>
    </tr>
    <tr>
      <th>payment_installments</th>
      <td>0</td>
    </tr>
    <tr>
      <th>payment_value</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
# 중복값 확인
df6['order_id'].duplicated().sum()
```




    4446




```python
df6['payment_sequential'].value_counts()
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
      <th>payment_sequential</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>99360</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3039</td>
    </tr>
    <tr>
      <th>3</th>
      <td>581</td>
    </tr>
    <tr>
      <th>4</th>
      <td>278</td>
    </tr>
    <tr>
      <th>5</th>
      <td>170</td>
    </tr>
    <tr>
      <th>6</th>
      <td>118</td>
    </tr>
    <tr>
      <th>7</th>
      <td>82</td>
    </tr>
    <tr>
      <th>8</th>
      <td>54</td>
    </tr>
    <tr>
      <th>9</th>
      <td>43</td>
    </tr>
    <tr>
      <th>10</th>
      <td>34</td>
    </tr>
    <tr>
      <th>11</th>
      <td>29</td>
    </tr>
    <tr>
      <th>12</th>
      <td>21</td>
    </tr>
    <tr>
      <th>13</th>
      <td>13</td>
    </tr>
    <tr>
      <th>14</th>
      <td>10</td>
    </tr>
    <tr>
      <th>15</th>
      <td>8</td>
    </tr>
    <tr>
      <th>18</th>
      <td>6</td>
    </tr>
    <tr>
      <th>19</th>
      <td>6</td>
    </tr>
    <tr>
      <th>16</th>
      <td>6</td>
    </tr>
    <tr>
      <th>17</th>
      <td>6</td>
    </tr>
    <tr>
      <th>21</th>
      <td>4</td>
    </tr>
    <tr>
      <th>20</th>
      <td>4</td>
    </tr>
    <tr>
      <th>22</th>
      <td>3</td>
    </tr>
    <tr>
      <th>26</th>
      <td>2</td>
    </tr>
    <tr>
      <th>24</th>
      <td>2</td>
    </tr>
    <tr>
      <th>23</th>
      <td>2</td>
    </tr>
    <tr>
      <th>25</th>
      <td>2</td>
    </tr>
    <tr>
      <th>29</th>
      <td>1</td>
    </tr>
    <tr>
      <th>28</th>
      <td>1</td>
    </tr>
    <tr>
      <th>27</th>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
df6['payment_installments'].value_counts()
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
      <th>payment_installments</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>52546</td>
    </tr>
    <tr>
      <th>2</th>
      <td>12413</td>
    </tr>
    <tr>
      <th>3</th>
      <td>10461</td>
    </tr>
    <tr>
      <th>4</th>
      <td>7098</td>
    </tr>
    <tr>
      <th>10</th>
      <td>5328</td>
    </tr>
    <tr>
      <th>5</th>
      <td>5239</td>
    </tr>
    <tr>
      <th>8</th>
      <td>4268</td>
    </tr>
    <tr>
      <th>6</th>
      <td>3920</td>
    </tr>
    <tr>
      <th>7</th>
      <td>1626</td>
    </tr>
    <tr>
      <th>9</th>
      <td>644</td>
    </tr>
    <tr>
      <th>12</th>
      <td>133</td>
    </tr>
    <tr>
      <th>15</th>
      <td>74</td>
    </tr>
    <tr>
      <th>18</th>
      <td>27</td>
    </tr>
    <tr>
      <th>11</th>
      <td>23</td>
    </tr>
    <tr>
      <th>24</th>
      <td>18</td>
    </tr>
    <tr>
      <th>20</th>
      <td>17</td>
    </tr>
    <tr>
      <th>13</th>
      <td>16</td>
    </tr>
    <tr>
      <th>14</th>
      <td>15</td>
    </tr>
    <tr>
      <th>17</th>
      <td>8</td>
    </tr>
    <tr>
      <th>16</th>
      <td>5</td>
    </tr>
    <tr>
      <th>21</th>
      <td>3</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2</td>
    </tr>
    <tr>
      <th>22</th>
      <td>1</td>
    </tr>
    <tr>
      <th>23</th>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
round((df6[df6['payment_installments'] >= 6].shape[0] / df6.shape[0]) * 100, 2)
```




    15.52




```python
df6['payment_type'].value_counts()
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
      <th>payment_type</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>credit_card</th>
      <td>76795</td>
    </tr>
    <tr>
      <th>boleto</th>
      <td>19784</td>
    </tr>
    <tr>
      <th>voucher</th>
      <td>5775</td>
    </tr>
    <tr>
      <th>debit_card</th>
      <td>1529</td>
    </tr>
    <tr>
      <th>not_defined</th>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
round((df6[df6['payment_type'] == 'boleto'].shape[0] / df6.shape[0])*100, 2)
```




    19.04



- 주문별 결제수단을 1번혹은 여러번 사용
- order 데이터의 order_id보다 주문수가 적은것을 보아 취소나 변경 등 주문후 결제정보가 삭제된 데이터들이 존재함
- 6개월 이상 장기 할부 거래가 15% 정도 발생하고 있음(boleto 거래 포함시 약 34%)

### 7. Order Reviews (olist_order_reviews_dataset.csv)

| 컬럼 이름               | 데이터 타입 | 설명                           |
| ----------------------- | ----------- | ------------------------------ |
| review_id               | VARCHAR     | 리뷰 고유 식별자               |
| order_id                | VARCHAR     | 리뷰와 연결된 주문 고유 식별자 |
| review_score            | INT         | 고객이 남긴 평점               |
| review_comment_title    | VARCHAR     | 리뷰 제목                      |
| review_comment_message  | TEXT        | 리뷰 내용                      |
| review_creation_date    | TIMESTAMP   | 리뷰가 생성된 날짜             |
| review_answer_timestamp | TIMESTAMP   | 리뷰에 답변한 시각             |




```python
df7 = pd.read_csv('/content/drive/MyDrive/archive/olist_order_reviews_dataset.csv')
df7
```





  <div id="df-e85c124a-2eca-4751-83f6-6801dbc02a38" class="colab-df-container">
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
      <th>review_id</th>
      <th>order_id</th>
      <th>review_score</th>
      <th>review_comment_title</th>
      <th>review_comment_message</th>
      <th>review_creation_date</th>
      <th>review_answer_timestamp</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>7bc2406110b926393aa56f80a40eba40</td>
      <td>73fc7af87114b39712e6da79b0a377eb</td>
      <td>4</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-01-18 00:00:00</td>
      <td>2018-01-18 21:46:59</td>
    </tr>
    <tr>
      <th>1</th>
      <td>80e641a11e56f04c1ad469d5645fdfde</td>
      <td>a548910a1c6147796b98fdf73dbeba33</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-03-10 00:00:00</td>
      <td>2018-03-11 03:05:13</td>
    </tr>
    <tr>
      <th>2</th>
      <td>228ce5500dc1d8e020d8d1322874b6f0</td>
      <td>f9e4b658b201a9f2ecdecbb34bed034b</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-02-17 00:00:00</td>
      <td>2018-02-18 14:36:24</td>
    </tr>
    <tr>
      <th>3</th>
      <td>e64fb393e7b32834bb789ff8bb30750e</td>
      <td>658677c97b385a9be170737859d3511b</td>
      <td>5</td>
      <td>NaN</td>
      <td>Recebi bem antes do prazo estipulado.</td>
      <td>2017-04-21 00:00:00</td>
      <td>2017-04-21 22:02:06</td>
    </tr>
    <tr>
      <th>4</th>
      <td>f7c4243c7fe1938f181bec41a392bdeb</td>
      <td>8e6bfb81e283fa7e4f11123a3fb894f1</td>
      <td>5</td>
      <td>NaN</td>
      <td>Parabéns lojas lannister adorei comprar pela I...</td>
      <td>2018-03-01 00:00:00</td>
      <td>2018-03-02 10:26:53</td>
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
    </tr>
    <tr>
      <th>99219</th>
      <td>574ed12dd733e5fa530cfd4bbf39d7c9</td>
      <td>2a8c23fee101d4d5662fa670396eb8da</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-07-07 00:00:00</td>
      <td>2018-07-14 17:18:30</td>
    </tr>
    <tr>
      <th>99220</th>
      <td>f3897127253a9592a73be9bdfdf4ed7a</td>
      <td>22ec9f0669f784db00fa86d035cf8602</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-12-09 00:00:00</td>
      <td>2017-12-11 20:06:42</td>
    </tr>
    <tr>
      <th>99221</th>
      <td>b3de70c89b1510c4cd3d0649fd302472</td>
      <td>55d4004744368f5571d1f590031933e4</td>
      <td>5</td>
      <td>NaN</td>
      <td>Excelente mochila, entrega super rápida. Super...</td>
      <td>2018-03-22 00:00:00</td>
      <td>2018-03-23 09:10:43</td>
    </tr>
    <tr>
      <th>99222</th>
      <td>1adeb9d84d72fe4e337617733eb85149</td>
      <td>7725825d039fc1f0ceb7635e3f7d9206</td>
      <td>4</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-07-01 00:00:00</td>
      <td>2018-07-02 12:59:13</td>
    </tr>
    <tr>
      <th>99223</th>
      <td>efe49f1d6f951dd88b51e6ccd4cc548f</td>
      <td>90531360ecb1eec2a1fbb265a0db0508</td>
      <td>1</td>
      <td>NaN</td>
      <td>meu produto chegou e ja tenho que devolver, po...</td>
      <td>2017-07-03 00:00:00</td>
      <td>2017-07-03 21:01:49</td>
    </tr>
  </tbody>
</table>
<p>99224 rows × 7 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-e85c124a-2eca-4751-83f6-6801dbc02a38')"
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
        document.querySelector('#df-e85c124a-2eca-4751-83f6-6801dbc02a38 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-e85c124a-2eca-4751-83f6-6801dbc02a38');
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


<div id="df-7f1e16e4-6bec-4d78-b590-c0770918f90f">
  <button class="colab-df-quickchart" onclick="quickchart('df-7f1e16e4-6bec-4d78-b590-c0770918f90f')"
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
        document.querySelector('#df-7f1e16e4-6bec-4d78-b590-c0770918f90f button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_60be0f45-2067-4163-891f-a4e3b0edf45e">
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
    <button class="colab-df-generate" onclick="generateWithVariable('df7')"
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
        document.querySelector('#id_60be0f45-2067-4163-891f-a4e3b0edf45e button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('df7');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 결측치 확인
df7.isna().sum().sort_values(ascending=False)
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
      <th>review_comment_title</th>
      <td>87656</td>
    </tr>
    <tr>
      <th>review_comment_message</th>
      <td>58247</td>
    </tr>
    <tr>
      <th>review_id</th>
      <td>0</td>
    </tr>
    <tr>
      <th>order_id</th>
      <td>0</td>
    </tr>
    <tr>
      <th>review_score</th>
      <td>0</td>
    </tr>
    <tr>
      <th>review_creation_date</th>
      <td>0</td>
    </tr>
    <tr>
      <th>review_answer_timestamp</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>



- 리뷰를 안적는사람이 있기때문에 결측치가 아님


```python
# 중복값 확인
print(df7['order_id'].duplicated().sum())
print(df7['review_id'].duplicated().sum())
```

    551
    814
    


```python
df7[df7['order_id'].duplicated(keep=False)].sort_values(by=['order_id'])
```





  <div id="df-867f9de0-2bf8-4d79-a11c-56744184341b" class="colab-df-container">
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
      <th>review_id</th>
      <th>order_id</th>
      <th>review_score</th>
      <th>review_comment_title</th>
      <th>review_comment_message</th>
      <th>review_creation_date</th>
      <th>review_answer_timestamp</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>25612</th>
      <td>89a02c45c340aeeb1354a24e7d4b2c1e</td>
      <td>0035246a40f520710769010f752e7507</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-08-29 00:00:00</td>
      <td>2017-08-30 01:59:12</td>
    </tr>
    <tr>
      <th>22423</th>
      <td>2a74b0559eb58fc1ff842ecc999594cb</td>
      <td>0035246a40f520710769010f752e7507</td>
      <td>5</td>
      <td>NaN</td>
      <td>Estou acostumada a comprar produtos pelo barat...</td>
      <td>2017-08-25 00:00:00</td>
      <td>2017-08-29 21:45:57</td>
    </tr>
    <tr>
      <th>22779</th>
      <td>ab30810c29da5da8045216f0f62652a2</td>
      <td>013056cfe49763c6f66bda03396c5ee3</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-02-22 00:00:00</td>
      <td>2018-02-23 12:12:30</td>
    </tr>
    <tr>
      <th>68633</th>
      <td>73413b847f63e02bc752b364f6d05ee9</td>
      <td>013056cfe49763c6f66bda03396c5ee3</td>
      <td>4</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-03-04 00:00:00</td>
      <td>2018-03-05 17:02:00</td>
    </tr>
    <tr>
      <th>854</th>
      <td>830636803620cdf8b6ffaf1b2f6e92b2</td>
      <td>0176a6846bcb3b0d3aa3116a9a768597</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-12-30 00:00:00</td>
      <td>2018-01-02 10:54:06</td>
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
    </tr>
    <tr>
      <th>27465</th>
      <td>5e78482ee783451be6026e5cf0c72de1</td>
      <td>ff763b73e473d03c321bcd5a053316e8</td>
      <td>3</td>
      <td>NaN</td>
      <td>Não sei que haverá acontecido os demais chegaram</td>
      <td>2017-11-18 00:00:00</td>
      <td>2017-11-18 09:02:48</td>
    </tr>
    <tr>
      <th>41355</th>
      <td>39de8ad3a1a494fc68cc2d5382f052f4</td>
      <td>ff850ba359507b996e8b2fbb26df8d03</td>
      <td>5</td>
      <td>NaN</td>
      <td>Envio rapido... Produto 100%</td>
      <td>2017-08-16 00:00:00</td>
      <td>2017-08-17 11:56:55</td>
    </tr>
    <tr>
      <th>18783</th>
      <td>80f25f32c00540d49d57796fb6658535</td>
      <td>ff850ba359507b996e8b2fbb26df8d03</td>
      <td>5</td>
      <td>NaN</td>
      <td>Envio rapido, produto conforme descrito no anu...</td>
      <td>2017-08-22 00:00:00</td>
      <td>2017-08-25 11:40:22</td>
    </tr>
    <tr>
      <th>92230</th>
      <td>870d856a4873d3a67252b0c51d79b950</td>
      <td>ffaabba06c9d293a3c614e0515ddbabc</td>
      <td>3</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-12-20 00:00:00</td>
      <td>2017-12-20 18:50:16</td>
    </tr>
    <tr>
      <th>53962</th>
      <td>5476dd0eaee7c4e2725cafb011aa758c</td>
      <td>ffaabba06c9d293a3c614e0515ddbabc</td>
      <td>3</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-12-20 00:00:00</td>
      <td>2017-12-21 13:24:55</td>
    </tr>
  </tbody>
</table>
<p>1098 rows × 7 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-867f9de0-2bf8-4d79-a11c-56744184341b')"
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
        document.querySelector('#df-867f9de0-2bf8-4d79-a11c-56744184341b button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-867f9de0-2bf8-4d79-a11c-56744184341b');
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


<div id="df-b86fd70a-dc1d-45a1-9ce3-555bb60c2074">
  <button class="colab-df-quickchart" onclick="quickchart('df-b86fd70a-dc1d-45a1-9ce3-555bb60c2074')"
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
        document.querySelector('#df-b86fd70a-dc1d-45a1-9ce3-555bb60c2074 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
df7[df7['order_id'] == 'ff850ba359507b996e8b2fbb26df8d03']
```





  <div id="df-17fdd7b9-7bff-49ab-83b2-11b9d2abeb36" class="colab-df-container">
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
      <th>review_id</th>
      <th>order_id</th>
      <th>review_score</th>
      <th>review_comment_title</th>
      <th>review_comment_message</th>
      <th>review_creation_date</th>
      <th>review_answer_timestamp</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>18783</th>
      <td>80f25f32c00540d49d57796fb6658535</td>
      <td>ff850ba359507b996e8b2fbb26df8d03</td>
      <td>5</td>
      <td>NaN</td>
      <td>Envio rapido, produto conforme descrito no anu...</td>
      <td>2017-08-22 00:00:00</td>
      <td>2017-08-25 11:40:22</td>
    </tr>
    <tr>
      <th>41355</th>
      <td>39de8ad3a1a494fc68cc2d5382f052f4</td>
      <td>ff850ba359507b996e8b2fbb26df8d03</td>
      <td>5</td>
      <td>NaN</td>
      <td>Envio rapido... Produto 100%</td>
      <td>2017-08-16 00:00:00</td>
      <td>2017-08-17 11:56:55</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-17fdd7b9-7bff-49ab-83b2-11b9d2abeb36')"
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
        document.querySelector('#df-17fdd7b9-7bff-49ab-83b2-11b9d2abeb36 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-17fdd7b9-7bff-49ab-83b2-11b9d2abeb36');
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


<div id="df-f79638de-e5d1-4421-b8fe-2e1151fb29ad">
  <button class="colab-df-quickchart" onclick="quickchart('df-f79638de-e5d1-4421-b8fe-2e1151fb29ad')"
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
        document.querySelector('#df-f79638de-e5d1-4421-b8fe-2e1151fb29ad button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
df3[df3['order_id'] == 'ff850ba359507b996e8b2fbb26df8d03']
```





  <div id="df-35333472-6581-4d16-bfb4-3f91f3997c48" class="colab-df-container">
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
      <th>order_id</th>
      <th>order_item_id</th>
      <th>product_id</th>
      <th>seller_id</th>
      <th>shipping_limit_date</th>
      <th>price</th>
      <th>freight_value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>112446</th>
      <td>ff850ba359507b996e8b2fbb26df8d03</td>
      <td>1</td>
      <td>d2bea3c01e172037caa99b2d138f39d0</td>
      <td>9674754b5a0cb32b638cec001178f799</td>
      <td>2017-08-10 20:20:07</td>
      <td>16.9</td>
      <td>16.11</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-35333472-6581-4d16-bfb4-3f91f3997c48')"
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
        document.querySelector('#df-35333472-6581-4d16-bfb4-3f91f3997c48 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-35333472-6581-4d16-bfb4-3f91f3997c48');
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


    </div>
  </div>





```python
df6[df6['order_id'] == 'ff850ba359507b996e8b2fbb26df8d03']
```





  <div id="df-900d63b9-fc0a-49f9-9acc-bc7e30564958" class="colab-df-container">
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
      <th>order_id</th>
      <th>payment_sequential</th>
      <th>payment_type</th>
      <th>payment_installments</th>
      <th>payment_value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>8576</th>
      <td>ff850ba359507b996e8b2fbb26df8d03</td>
      <td>1</td>
      <td>credit_card</td>
      <td>3</td>
      <td>33.01</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-900d63b9-fc0a-49f9-9acc-bc7e30564958')"
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
        document.querySelector('#df-900d63b9-fc0a-49f9-9acc-bc7e30564958 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-900d63b9-fc0a-49f9-9acc-bc7e30564958');
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


    </div>
  </div>





```python
df2[df2['order_id'] == 'ff850ba359507b996e8b2fbb26df8d03']
```





  <div id="df-3e38d682-4d3f-4ea2-adba-f0b1c2ed6984" class="colab-df-container">
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
      <th>order_id</th>
      <th>customer_id</th>
      <th>order_status</th>
      <th>order_purchase_timestamp</th>
      <th>order_approved_at</th>
      <th>order_delivered_carrier_date</th>
      <th>order_delivered_customer_date</th>
      <th>order_estimated_delivery_date</th>
      <th>delivery_time</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>68231</th>
      <td>ff850ba359507b996e8b2fbb26df8d03</td>
      <td>219399e5496f8ca1dc6f68753131c084</td>
      <td>delivered</td>
      <td>2017-08-06 19:38:00</td>
      <td>2017-08-06 20:20:07</td>
      <td>2017-08-08 12:23:16</td>
      <td>2017-08-21 22:15:41</td>
      <td>2017-08-31 00:00:00</td>
      <td>15.0</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-3e38d682-4d3f-4ea2-adba-f0b1c2ed6984')"
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
        document.querySelector('#df-3e38d682-4d3f-4ea2-adba-f0b1c2ed6984 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-3e38d682-4d3f-4ea2-adba-f0b1c2ed6984');
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


    </div>
  </div>




- 해당주문번호로 리뷰를 2번썼는데, 첫번째는 도착하기도전에 리뷰가 적혔다


```python
df7.groupby('order_id').filter(lambda x: len(x) >= 3)
```





  <div id="df-d4200479-4c07-41db-b36e-1e975b2af08a" class="colab-df-container">
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
      <th>review_id</th>
      <th>order_id</th>
      <th>review_score</th>
      <th>review_comment_title</th>
      <th>review_comment_message</th>
      <th>review_creation_date</th>
      <th>review_answer_timestamp</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1985</th>
      <td>ffb8cff872a625632ac983eb1f88843c</td>
      <td>c88b1d1b157a9999ce368f218a407141</td>
      <td>3</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-07-22 00:00:00</td>
      <td>2017-07-26 13:41:07</td>
    </tr>
    <tr>
      <th>2952</th>
      <td>c444278834184f72b1484dfe47de7f97</td>
      <td>df56136b8031ecd28e200bb18e6ddb2e</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-02-08 00:00:00</td>
      <td>2017-02-14 13:58:48</td>
    </tr>
    <tr>
      <th>8273</th>
      <td>b04ed893318da5b863e878cd3d0511df</td>
      <td>03c939fd7fd3b38f8485a0f95798f1f6</td>
      <td>3</td>
      <td>NaN</td>
      <td>Um ponto negativo que achei foi a cobrança de ...</td>
      <td>2018-03-20 00:00:00</td>
      <td>2018-03-21 02:28:23</td>
    </tr>
    <tr>
      <th>13982</th>
      <td>72a1098d5b410ae50fbc0509d26daeb9</td>
      <td>df56136b8031ecd28e200bb18e6ddb2e</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-02-07 00:00:00</td>
      <td>2017-02-10 10:46:09</td>
    </tr>
    <tr>
      <th>44694</th>
      <td>67c2557eb0bd72e3ece1e03477c9dff5</td>
      <td>8e17072ec97ce29f0e1f111e598b0c85</td>
      <td>1</td>
      <td>NaN</td>
      <td>Entregou o produto errado.</td>
      <td>2018-04-07 00:00:00</td>
      <td>2018-04-08 22:48:27</td>
    </tr>
    <tr>
      <th>51527</th>
      <td>f4bb9d6dd4fb6dcc2298f0e7b17b8e1e</td>
      <td>03c939fd7fd3b38f8485a0f95798f1f6</td>
      <td>4</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-03-29 00:00:00</td>
      <td>2018-03-30 00:29:09</td>
    </tr>
    <tr>
      <th>62728</th>
      <td>44f3e54834d23c5570c1d010824d4d59</td>
      <td>df56136b8031ecd28e200bb18e6ddb2e</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-02-09 00:00:00</td>
      <td>2017-02-09 09:07:28</td>
    </tr>
    <tr>
      <th>64510</th>
      <td>2d6ac45f859465b5c185274a1c929637</td>
      <td>8e17072ec97ce29f0e1f111e598b0c85</td>
      <td>1</td>
      <td>NaN</td>
      <td>Comprei 3 unidades do produto vieram 2 unidade...</td>
      <td>2018-04-07 00:00:00</td>
      <td>2018-04-07 21:13:05</td>
    </tr>
    <tr>
      <th>69438</th>
      <td>405eb2ea45e1dbe2662541ae5b47e2aa</td>
      <td>03c939fd7fd3b38f8485a0f95798f1f6</td>
      <td>3</td>
      <td>NaN</td>
      <td>Seria ótimo se tivesem entregue os 3 (três) pe...</td>
      <td>2018-03-06 00:00:00</td>
      <td>2018-03-06 19:50:32</td>
    </tr>
    <tr>
      <th>82525</th>
      <td>202b5f44d09cd3cfc0d6bd12f01b044c</td>
      <td>c88b1d1b157a9999ce368f218a407141</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-07-22 00:00:00</td>
      <td>2017-07-26 13:40:22</td>
    </tr>
    <tr>
      <th>89360</th>
      <td>fb96ea2ef8cce1c888f4d45c8e22b793</td>
      <td>c88b1d1b157a9999ce368f218a407141</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-07-21 00:00:00</td>
      <td>2017-07-26 13:45:15</td>
    </tr>
    <tr>
      <th>92300</th>
      <td>6e4c4086d9611ae4cc0cc65a262751fe</td>
      <td>8e17072ec97ce29f0e1f111e598b0c85</td>
      <td>1</td>
      <td>NaN</td>
      <td>Embora tenha entregue dentro do prazo, não env...</td>
      <td>2018-04-14 00:00:00</td>
      <td>2018-04-16 11:37:31</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-d4200479-4c07-41db-b36e-1e975b2af08a')"
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
        document.querySelector('#df-d4200479-4c07-41db-b36e-1e975b2af08a button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-d4200479-4c07-41db-b36e-1e975b2af08a');
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


<div id="df-8fb5a4f8-0e3c-40e9-8c6d-d715784353b8">
  <button class="colab-df-quickchart" onclick="quickchart('df-8fb5a4f8-0e3c-40e9-8c6d-d715784353b8')"
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
        document.querySelector('#df-8fb5a4f8-0e3c-40e9-8c6d-d715784353b8 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
df7[df7['order_id'] == 'c88b1d1b157a9999ce368f218a407141']
```





  <div id="df-9f05fa4e-13fd-4a27-85d0-b2fa645c7261" class="colab-df-container">
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
      <th>review_id</th>
      <th>order_id</th>
      <th>review_score</th>
      <th>review_comment_title</th>
      <th>review_comment_message</th>
      <th>review_creation_date</th>
      <th>review_answer_timestamp</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1985</th>
      <td>ffb8cff872a625632ac983eb1f88843c</td>
      <td>c88b1d1b157a9999ce368f218a407141</td>
      <td>3</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-07-22 00:00:00</td>
      <td>2017-07-26 13:41:07</td>
    </tr>
    <tr>
      <th>82525</th>
      <td>202b5f44d09cd3cfc0d6bd12f01b044c</td>
      <td>c88b1d1b157a9999ce368f218a407141</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-07-22 00:00:00</td>
      <td>2017-07-26 13:40:22</td>
    </tr>
    <tr>
      <th>89360</th>
      <td>fb96ea2ef8cce1c888f4d45c8e22b793</td>
      <td>c88b1d1b157a9999ce368f218a407141</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-07-21 00:00:00</td>
      <td>2017-07-26 13:45:15</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-9f05fa4e-13fd-4a27-85d0-b2fa645c7261')"
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
        document.querySelector('#df-9f05fa4e-13fd-4a27-85d0-b2fa645c7261 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-9f05fa4e-13fd-4a27-85d0-b2fa645c7261');
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


<div id="df-9b332ec7-3af7-41e5-9fc7-1a20e36c3ad1">
  <button class="colab-df-quickchart" onclick="quickchart('df-9b332ec7-3af7-41e5-9fc7-1a20e36c3ad1')"
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
        document.querySelector('#df-9b332ec7-3af7-41e5-9fc7-1a20e36c3ad1 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
df3[df3['order_id'] == 'c88b1d1b157a9999ce368f218a407141']
```





  <div id="df-960cde13-9c01-4f3c-bd6d-29da7033876f" class="colab-df-container">
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
      <th>order_id</th>
      <th>order_item_id</th>
      <th>product_id</th>
      <th>seller_id</th>
      <th>shipping_limit_date</th>
      <th>price</th>
      <th>freight_value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>88316</th>
      <td>c88b1d1b157a9999ce368f218a407141</td>
      <td>1</td>
      <td>b1acb7e8152c90c9619897753a75c973</td>
      <td>cc419e0650a3c5ba77189a1882b7556a</td>
      <td>2017-07-26 22:50:12</td>
      <td>34.99</td>
      <td>7.78</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-960cde13-9c01-4f3c-bd6d-29da7033876f')"
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
        document.querySelector('#df-960cde13-9c01-4f3c-bd6d-29da7033876f button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-960cde13-9c01-4f3c-bd6d-29da7033876f');
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


    </div>
  </div>





```python
df6[df6['order_id'] == 'c88b1d1b157a9999ce368f218a407141']
```





  <div id="df-21efcd84-68a8-4882-b2ff-264d90097d7d" class="colab-df-container">
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
      <th>order_id</th>
      <th>payment_sequential</th>
      <th>payment_type</th>
      <th>payment_installments</th>
      <th>payment_value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>103471</th>
      <td>c88b1d1b157a9999ce368f218a407141</td>
      <td>1</td>
      <td>credit_card</td>
      <td>4</td>
      <td>42.77</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-21efcd84-68a8-4882-b2ff-264d90097d7d')"
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
        document.querySelector('#df-21efcd84-68a8-4882-b2ff-264d90097d7d button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-21efcd84-68a8-4882-b2ff-264d90097d7d');
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


    </div>
  </div>





```python
df7[df7['review_id'].duplicated(keep=False)].sort_values(by=['review_id']).head(30)
```





  <div id="df-2eb1239e-f106-4c65-b8a4-22aac835bd50" class="colab-df-container">
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
      <th>review_id</th>
      <th>order_id</th>
      <th>review_score</th>
      <th>review_comment_title</th>
      <th>review_comment_message</th>
      <th>review_creation_date</th>
      <th>review_answer_timestamp</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>46678</th>
      <td>00130cbe1f9d422698c812ed8ded1919</td>
      <td>dfcdfc43867d1c1381bfaf62d6b9c195</td>
      <td>1</td>
      <td>NaN</td>
      <td>O cartucho "original HP" 60XL não é reconhecid...</td>
      <td>2018-03-07 00:00:00</td>
      <td>2018-03-20 18:08:23</td>
    </tr>
    <tr>
      <th>29841</th>
      <td>00130cbe1f9d422698c812ed8ded1919</td>
      <td>04a28263e085d399c97ae49e0b477efa</td>
      <td>1</td>
      <td>NaN</td>
      <td>O cartucho "original HP" 60XL não é reconhecid...</td>
      <td>2018-03-07 00:00:00</td>
      <td>2018-03-20 18:08:23</td>
    </tr>
    <tr>
      <th>90677</th>
      <td>0115633a9c298b6a98bcbe4eee75345f</td>
      <td>78a4201f58af3463bdab842eea4bc801</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-09-21 00:00:00</td>
      <td>2017-09-26 03:27:47</td>
    </tr>
    <tr>
      <th>63193</th>
      <td>0115633a9c298b6a98bcbe4eee75345f</td>
      <td>0c9850b2c179c1ef60d2855e2751d1fa</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-09-21 00:00:00</td>
      <td>2017-09-26 03:27:47</td>
    </tr>
    <tr>
      <th>92876</th>
      <td>0174caf0ee5964646040cd94e15ac95e</td>
      <td>f93a732712407c02dce5dd5088d0f47b</td>
      <td>1</td>
      <td>NaN</td>
      <td>Produto entregue dentro de embalagem do fornec...</td>
      <td>2018-03-07 00:00:00</td>
      <td>2018-03-08 03:00:53</td>
    </tr>
    <tr>
      <th>57280</th>
      <td>0174caf0ee5964646040cd94e15ac95e</td>
      <td>74db91e33b4e1fd865356c89a61abf1f</td>
      <td>1</td>
      <td>NaN</td>
      <td>Produto entregue dentro de embalagem do fornec...</td>
      <td>2018-03-07 00:00:00</td>
      <td>2018-03-08 03:00:53</td>
    </tr>
    <tr>
      <th>54832</th>
      <td>017808d29fd1f942d97e50184dfb4c13</td>
      <td>8daaa9e99d60fbba579cc1c3e3bfae01</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-03-02 00:00:00</td>
      <td>2018-03-05 01:43:30</td>
    </tr>
    <tr>
      <th>99167</th>
      <td>017808d29fd1f942d97e50184dfb4c13</td>
      <td>b1461c8882153b5fe68307c46a506e39</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-03-02 00:00:00</td>
      <td>2018-03-05 01:43:30</td>
    </tr>
    <tr>
      <th>20621</th>
      <td>0254bd905dc677a6078990aad3331a36</td>
      <td>5bf226cf882c5bf4247f89a97c86f273</td>
      <td>1</td>
      <td>NaN</td>
      <td>O pedido consta de 2 produtos e até agora rece...</td>
      <td>2017-09-09 00:00:00</td>
      <td>2017-09-13 09:52:44</td>
    </tr>
    <tr>
      <th>96080</th>
      <td>0254bd905dc677a6078990aad3331a36</td>
      <td>331b367bdd766f3d1cf518777317b5d9</td>
      <td>1</td>
      <td>NaN</td>
      <td>O pedido consta de 2 produtos e até agora rece...</td>
      <td>2017-09-09 00:00:00</td>
      <td>2017-09-13 09:52:44</td>
    </tr>
    <tr>
      <th>89712</th>
      <td>0288d42bef3dfe36930740c9588a570f</td>
      <td>33d8795f04dd631f3480d7aaf90da3dc</td>
      <td>3</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-07-29 00:00:00</td>
      <td>2017-07-31 17:11:04</td>
    </tr>
    <tr>
      <th>94851</th>
      <td>0288d42bef3dfe36930740c9588a570f</td>
      <td>f889a5a0b44adc29c5465b99395ac3c1</td>
      <td>3</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-07-29 00:00:00</td>
      <td>2017-07-31 17:11:04</td>
    </tr>
    <tr>
      <th>47495</th>
      <td>02aa7f5f75e964e3c7efa59a1f515281</td>
      <td>d8e17d5f7dacf0970d316e7c03e741e8</td>
      <td>3</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-07-27 00:00:00</td>
      <td>2017-07-29 15:09:50</td>
    </tr>
    <tr>
      <th>95860</th>
      <td>02aa7f5f75e964e3c7efa59a1f515281</td>
      <td>db92613c074f00e53066388d48ad7512</td>
      <td>3</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-07-27 00:00:00</td>
      <td>2017-07-29 15:09:50</td>
    </tr>
    <tr>
      <th>71165</th>
      <td>034528cb00b6bc981847acafbdf2ae0b</td>
      <td>e1e8e3bca903de27e9a1c72b5a5795e0</td>
      <td>1</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-05-14 00:00:00</td>
      <td>2017-05-15 02:17:38</td>
    </tr>
    <tr>
      <th>81094</th>
      <td>034528cb00b6bc981847acafbdf2ae0b</td>
      <td>3d3742a96f24a8fe4e2e57628807e476</td>
      <td>1</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-05-14 00:00:00</td>
      <td>2017-05-15 02:17:38</td>
    </tr>
    <tr>
      <th>1988</th>
      <td>03a6a25db577d0689440933055111897</td>
      <td>2acfdc5131ff2cf4433e668454c9784c</td>
      <td>5</td>
      <td>NaN</td>
      <td>Muito Bom! Gostei Bastante! Tecido Ótimo! Aten...</td>
      <td>2017-12-15 00:00:00</td>
      <td>2017-12-16 01:32:18</td>
    </tr>
    <tr>
      <th>9013</th>
      <td>03a6a25db577d0689440933055111897</td>
      <td>3fde8b7313af6b37b84b5c7594d7add0</td>
      <td>5</td>
      <td>NaN</td>
      <td>Muito Bom! Gostei Bastante! Tecido Ótimo! Aten...</td>
      <td>2017-12-15 00:00:00</td>
      <td>2017-12-16 01:32:18</td>
    </tr>
    <tr>
      <th>21587</th>
      <td>0467560f511c516ddaa54a60edb0c291</td>
      <td>0c995611a99f81268d859184a416f1db</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-02-09 00:00:00</td>
      <td>2017-02-14 15:58:44</td>
    </tr>
    <tr>
      <th>24901</th>
      <td>0467560f511c516ddaa54a60edb0c291</td>
      <td>55b2e390d5d80ada31ad1b795ebeb087</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-02-09 00:00:00</td>
      <td>2017-02-14 15:58:44</td>
    </tr>
    <tr>
      <th>52021</th>
      <td>047fd109ced39e02296f6aeb74f6a6f1</td>
      <td>236e6ec6171c1870d4bcf4ccfad87f49</td>
      <td>4</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-07-31 00:00:00</td>
      <td>2018-08-02 15:11:49</td>
    </tr>
    <tr>
      <th>13872</th>
      <td>047fd109ced39e02296f6aeb74f6a6f1</td>
      <td>a89abace0dcc01eeb267a9660b5ac126</td>
      <td>4</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-07-31 00:00:00</td>
      <td>2018-08-02 15:11:49</td>
    </tr>
    <tr>
      <th>96681</th>
      <td>0498e9722f8757426c3c3ee0b91e666d</td>
      <td>f318811b0fd898d1edf78d6841470be2</td>
      <td>4</td>
      <td>NaN</td>
      <td>Chego certo adoro comprar na lannister.com.br\...</td>
      <td>2018-03-03 00:00:00</td>
      <td>2018-03-06 01:00:33</td>
    </tr>
    <tr>
      <th>77444</th>
      <td>0498e9722f8757426c3c3ee0b91e666d</td>
      <td>041aa5c38550649d5b51f38ba03a29a4</td>
      <td>4</td>
      <td>NaN</td>
      <td>Chego certo adoro comprar na lannister.com.br\...</td>
      <td>2018-03-03 00:00:00</td>
      <td>2018-03-06 01:00:33</td>
    </tr>
    <tr>
      <th>7629</th>
      <td>0501aab2f381486c36bf0f071442c0c2</td>
      <td>0068c109948b9a1dfb8530d1978acef3</td>
      <td>1</td>
      <td>NaN</td>
      <td>Espero obter uma resposta para minha encomenda...</td>
      <td>2018-02-09 00:00:00</td>
      <td>2018-02-10 23:55:18</td>
    </tr>
    <tr>
      <th>66952</th>
      <td>0501aab2f381486c36bf0f071442c0c2</td>
      <td>d75cb3755738c4ae466303358f97bc55</td>
      <td>1</td>
      <td>NaN</td>
      <td>Espero obter uma resposta para minha encomenda...</td>
      <td>2018-02-09 00:00:00</td>
      <td>2018-02-10 23:55:18</td>
    </tr>
    <tr>
      <th>58621</th>
      <td>0546d398a833d4c33dec480bedeecfbd</td>
      <td>e72a8568c8622825a95439791f668e85</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-10-05 00:00:00</td>
      <td>2017-10-24 16:16:33</td>
    </tr>
    <tr>
      <th>92842</th>
      <td>0546d398a833d4c33dec480bedeecfbd</td>
      <td>879d57dc015759bf30e71a20b5ae0652</td>
      <td>5</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-10-05 00:00:00</td>
      <td>2017-10-24 16:16:33</td>
    </tr>
    <tr>
      <th>50517</th>
      <td>0655af56f10bc3ef8e3810610828f294</td>
      <td>d9e44c3fd2ce16086619f299e92e12d8</td>
      <td>5</td>
      <td>NaN</td>
      <td>Muito rápido a entrega</td>
      <td>2017-05-18 00:00:00</td>
      <td>2017-05-19 19:15:22</td>
    </tr>
    <tr>
      <th>23987</th>
      <td>0655af56f10bc3ef8e3810610828f294</td>
      <td>84f5e6c0a0e3155e38c00f434ba90ce8</td>
      <td>5</td>
      <td>NaN</td>
      <td>Muito rápido a entrega</td>
      <td>2017-05-18 00:00:00</td>
      <td>2017-05-19 19:15:22</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-2eb1239e-f106-4c65-b8a4-22aac835bd50')"
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
        document.querySelector('#df-2eb1239e-f106-4c65-b8a4-22aac835bd50 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-2eb1239e-f106-4c65-b8a4-22aac835bd50');
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


<div id="df-b55ba3f5-14f1-4713-aa41-9b735bde43db">
  <button class="colab-df-quickchart" onclick="quickchart('df-b55ba3f5-14f1-4713-aa41-9b735bde43db')"
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
        document.querySelector('#df-b55ba3f5-14f1-4713-aa41-9b735bde43db button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
df2[df2['order_id'] == 'dfcdfc43867d1c1381bfaf62d6b9c195']
```





  <div id="df-8f389900-c1ce-4b89-a420-b203051d1924" class="colab-df-container">
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
      <th>order_id</th>
      <th>customer_id</th>
      <th>order_status</th>
      <th>order_purchase_timestamp</th>
      <th>order_approved_at</th>
      <th>order_delivered_carrier_date</th>
      <th>order_delivered_customer_date</th>
      <th>order_estimated_delivery_date</th>
      <th>delivery_time</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>74048</th>
      <td>dfcdfc43867d1c1381bfaf62d6b9c195</td>
      <td>a7026133ddbd2e86c83ecd4dfa4dbe01</td>
      <td>delivered</td>
      <td>2018-02-02 18:01:08</td>
      <td>2018-02-02 18:31:17</td>
      <td>2018-02-05 23:46:29</td>
      <td>2018-02-26 18:18:45</td>
      <td>2018-03-09 00:00:00</td>
      <td>24.0</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-8f389900-c1ce-4b89-a420-b203051d1924')"
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
        document.querySelector('#df-8f389900-c1ce-4b89-a420-b203051d1924 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-8f389900-c1ce-4b89-a420-b203051d1924');
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


    </div>
  </div>





```python
df[df['customer_id'] == 'a7026133ddbd2e86c83ecd4dfa4dbe01']
```





  <div id="df-9f9624ca-77ba-413a-b7c9-6f3125ef894b" class="colab-df-container">
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
      <th>customer_id</th>
      <th>customer_unique_id</th>
      <th>customer_zip_code_prefix</th>
      <th>customer_city</th>
      <th>customer_state</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>60938</th>
      <td>a7026133ddbd2e86c83ecd4dfa4dbe01</td>
      <td>f30856ad31d3e74253a3f4ccef670648</td>
      <td>71955</td>
      <td>brasilia</td>
      <td>DF</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-9f9624ca-77ba-413a-b7c9-6f3125ef894b')"
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
        document.querySelector('#df-9f9624ca-77ba-413a-b7c9-6f3125ef894b button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-9f9624ca-77ba-413a-b7c9-6f3125ef894b');
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


    </div>
  </div>





```python
df2[df2['order_id'] == '04a28263e085d399c97ae49e0b477efa']
```





  <div id="df-f1bb3cdc-86ec-4778-9046-405989074de4" class="colab-df-container">
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
      <th>order_id</th>
      <th>customer_id</th>
      <th>order_status</th>
      <th>order_purchase_timestamp</th>
      <th>order_approved_at</th>
      <th>order_delivered_carrier_date</th>
      <th>order_delivered_customer_date</th>
      <th>order_estimated_delivery_date</th>
      <th>delivery_time</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>28241</th>
      <td>04a28263e085d399c97ae49e0b477efa</td>
      <td>fef2e5e63da9f3e1dd89e8e319468657</td>
      <td>delivered</td>
      <td>2018-02-02 18:01:10</td>
      <td>2018-02-02 18:31:27</td>
      <td>2018-02-21 02:38:29</td>
      <td>2018-03-11 11:32:24</td>
      <td>2018-03-05 00:00:00</td>
      <td>36.0</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-f1bb3cdc-86ec-4778-9046-405989074de4')"
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
        document.querySelector('#df-f1bb3cdc-86ec-4778-9046-405989074de4 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-f1bb3cdc-86ec-4778-9046-405989074de4');
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


    </div>
  </div>





```python
df[df['customer_id'] == 'fef2e5e63da9f3e1dd89e8e319468657']
```





  <div id="df-0d6b4787-a705-4ccb-9257-5c6659f6c263" class="colab-df-container">
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
      <th>customer_id</th>
      <th>customer_unique_id</th>
      <th>customer_zip_code_prefix</th>
      <th>customer_city</th>
      <th>customer_state</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>62395</th>
      <td>fef2e5e63da9f3e1dd89e8e319468657</td>
      <td>f30856ad31d3e74253a3f4ccef670648</td>
      <td>71955</td>
      <td>brasilia</td>
      <td>DF</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-0d6b4787-a705-4ccb-9257-5c6659f6c263')"
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
        document.querySelector('#df-0d6b4787-a705-4ccb-9257-5c6659f6c263 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-0d6b4787-a705-4ccb-9257-5c6659f6c263');
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


    </div>
  </div>




- 주문번호 중복 : 오류거나, 배송이 변경(교환 등)되거나, 추가되거나 등 여러상황이있고 상품이 도착하기도전에 리뷰가있는 수상한 부분도있지만 같은주문번호에 각각 다른 리뷰메세지가 존재해 데이터를 제거하지않음
- 리뷰아이디 중복 : 사용자가 구매한 주문들을 한번에 같이 리뷰했을때 발생함


```python
df7['review_score'].value_counts()
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
      <th>review_score</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>5</th>
      <td>57328</td>
    </tr>
    <tr>
      <th>4</th>
      <td>19142</td>
    </tr>
    <tr>
      <th>1</th>
      <td>11424</td>
    </tr>
    <tr>
      <th>3</th>
      <td>8179</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3151</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
df3_new = df3_new.merge(df7, on='order_id', how='left')
```


```python
df3_new
```





  <div id="df-9af60739-f51c-45a5-986d-8122636329f8" class="colab-df-container">
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
      <th>order_id</th>
      <th>order_item_id</th>
      <th>product_id</th>
      <th>seller_id</th>
      <th>shipping_limit_date</th>
      <th>price</th>
      <th>freight_value</th>
      <th>customer_id</th>
      <th>order_status</th>
      <th>order_purchase_timestamp</th>
      <th>...</th>
      <th>customer_state</th>
      <th>seller_zip_code_prefix</th>
      <th>seller_city</th>
      <th>seller_state</th>
      <th>review_id</th>
      <th>review_score</th>
      <th>review_comment_title</th>
      <th>review_comment_message</th>
      <th>review_creation_date</th>
      <th>review_answer_timestamp</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>00010242fe8c5a6d1ba2dd792cb16214</td>
      <td>1</td>
      <td>4244733e06e7ecb4970a6e2683c13e61</td>
      <td>48436dade18ac8b2bce089ec2a041202</td>
      <td>2017-09-19 09:45:35</td>
      <td>58.90</td>
      <td>13.29</td>
      <td>3ce436f183e68e07877b285a838db11a</td>
      <td>delivered</td>
      <td>2017-09-13 08:59:02</td>
      <td>...</td>
      <td>RJ</td>
      <td>27277</td>
      <td>volta redonda</td>
      <td>SP</td>
      <td>97ca439bc427b48bc1cd7177abe71365</td>
      <td>5.0</td>
      <td>NaN</td>
      <td>Perfeito, produto entregue antes do combinado.</td>
      <td>2017-09-21 00:00:00</td>
      <td>2017-09-22 10:57:03</td>
    </tr>
    <tr>
      <th>1</th>
      <td>00018f77f2f0320c557190d7a144bdd3</td>
      <td>1</td>
      <td>e5f2d52b802189ee658865ca93d83a8f</td>
      <td>dd7ddc04e1b6c2c614352b383efe2d36</td>
      <td>2017-05-03 11:05:13</td>
      <td>239.90</td>
      <td>19.93</td>
      <td>f6dd3ec061db4e3987629fe6b26e5cce</td>
      <td>delivered</td>
      <td>2017-04-26 10:53:06</td>
      <td>...</td>
      <td>SP</td>
      <td>3471</td>
      <td>sao paulo</td>
      <td>SP</td>
      <td>7b07bacd811c4117b742569b04ce3580</td>
      <td>4.0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-05-13 00:00:00</td>
      <td>2017-05-15 11:34:13</td>
    </tr>
    <tr>
      <th>2</th>
      <td>000229ec398224ef6ca0657da4fc703e</td>
      <td>1</td>
      <td>c777355d18b72b67abbeef9df44fd0fd</td>
      <td>5b51032eddd242adc84c38acab88f23d</td>
      <td>2018-01-18 14:48:30</td>
      <td>199.00</td>
      <td>17.87</td>
      <td>6489ae5e4333f3693df5ad4372dab6d3</td>
      <td>delivered</td>
      <td>2018-01-14 14:33:31</td>
      <td>...</td>
      <td>MG</td>
      <td>37564</td>
      <td>borda da mata</td>
      <td>MG</td>
      <td>0c5b33dea94867d1ac402749e5438e8b</td>
      <td>5.0</td>
      <td>NaN</td>
      <td>Chegou antes do prazo previsto e o produto sur...</td>
      <td>2018-01-23 00:00:00</td>
      <td>2018-01-23 16:06:31</td>
    </tr>
    <tr>
      <th>3</th>
      <td>00024acbcdf0a6daa1e931b038114c75</td>
      <td>1</td>
      <td>7634da152a4610f1595efa32f14722fc</td>
      <td>9d7a1d34a5052409006425275ba1c2b4</td>
      <td>2018-08-15 10:10:18</td>
      <td>12.99</td>
      <td>12.79</td>
      <td>d4eb9395c8c0431ee92fce09860c5a06</td>
      <td>delivered</td>
      <td>2018-08-08 10:00:35</td>
      <td>...</td>
      <td>SP</td>
      <td>14403</td>
      <td>franca</td>
      <td>SP</td>
      <td>f4028d019cb58564807486a6aaf33817</td>
      <td>4.0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-08-15 00:00:00</td>
      <td>2018-08-15 16:39:01</td>
    </tr>
    <tr>
      <th>4</th>
      <td>00042b26cf59d7ce69dfabb4e55b4fd9</td>
      <td>1</td>
      <td>ac6c3623068f30de03045865e4e10089</td>
      <td>df560393f3a51e74553ab94004ba5c87</td>
      <td>2017-02-13 13:57:51</td>
      <td>199.90</td>
      <td>18.14</td>
      <td>58dbd0b2d70206bf40e62cd34e84d795</td>
      <td>delivered</td>
      <td>2017-02-04 13:57:51</td>
      <td>...</td>
      <td>SP</td>
      <td>87900</td>
      <td>loanda</td>
      <td>PR</td>
      <td>940144190dcba6351888cafa43f3a3a5</td>
      <td>5.0</td>
      <td>NaN</td>
      <td>Gostei pois veio no prazo determinado .</td>
      <td>2017-03-02 00:00:00</td>
      <td>2017-03-03 10:54:59</td>
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
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>113309</th>
      <td>fffc94f6ce00a00581880bf54a75a037</td>
      <td>1</td>
      <td>4aa6014eceb682077f9dc4bffebc05b0</td>
      <td>b8bc237ba3788b23da09c0f1f3a3288c</td>
      <td>2018-05-02 04:11:01</td>
      <td>299.99</td>
      <td>43.41</td>
      <td>b51593916b4b8e0d6f66f2ae24f2673d</td>
      <td>delivered</td>
      <td>2018-04-23 13:57:06</td>
      <td>...</td>
      <td>MA</td>
      <td>88303</td>
      <td>itajai</td>
      <td>SC</td>
      <td>9185f849f32d82e216a4e025e0c50f5c</td>
      <td>5.0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-05-11 00:00:00</td>
      <td>2018-05-14 12:53:47</td>
    </tr>
    <tr>
      <th>113310</th>
      <td>fffcd46ef2263f404302a634eb57f7eb</td>
      <td>1</td>
      <td>32e07fd915822b0765e448c4dd74c828</td>
      <td>f3c38ab652836d21de61fb8314b69182</td>
      <td>2018-07-20 04:31:48</td>
      <td>350.00</td>
      <td>36.53</td>
      <td>84c5d4fbaf120aae381fad077416eaa0</td>
      <td>delivered</td>
      <td>2018-07-14 10:26:46</td>
      <td>...</td>
      <td>PR</td>
      <td>1206</td>
      <td>sao paulo</td>
      <td>SP</td>
      <td>be803f6a93d64719fd685c1cc610918a</td>
      <td>5.0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-07-24 00:00:00</td>
      <td>2018-07-25 09:25:29</td>
    </tr>
    <tr>
      <th>113311</th>
      <td>fffce4705a9662cd70adb13d4a31832d</td>
      <td>1</td>
      <td>72a30483855e2eafc67aee5dc2560482</td>
      <td>c3cfdc648177fdbbbb35635a37472c53</td>
      <td>2017-10-30 17:14:25</td>
      <td>99.90</td>
      <td>16.95</td>
      <td>29309aa813182aaddc9b259e31b870e6</td>
      <td>delivered</td>
      <td>2017-10-23 17:07:56</td>
      <td>...</td>
      <td>SP</td>
      <td>80610</td>
      <td>curitiba</td>
      <td>PR</td>
      <td>dbdd81cd59a1a9f94a10a990b4d48dce</td>
      <td>5.0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2017-10-29 00:00:00</td>
      <td>2017-10-29 21:33:52</td>
    </tr>
    <tr>
      <th>113312</th>
      <td>fffe18544ffabc95dfada21779c9644f</td>
      <td>1</td>
      <td>9c422a519119dcad7575db5af1ba540e</td>
      <td>2b3e4a2a3ea8e01938cabda2a3e5cc79</td>
      <td>2017-08-21 00:04:32</td>
      <td>55.99</td>
      <td>8.72</td>
      <td>b5e6afd5a41800fdf401e0272ca74655</td>
      <td>delivered</td>
      <td>2017-08-14 23:02:59</td>
      <td>...</td>
      <td>SP</td>
      <td>4733</td>
      <td>sao paulo</td>
      <td>SP</td>
      <td>fba117c9ac40d41ca7be54741f471303</td>
      <td>5.0</td>
      <td>NaN</td>
      <td>Recebi o produto antes do prazo e corretamente.</td>
      <td>2017-08-17 00:00:00</td>
      <td>2017-08-18 12:24:05</td>
    </tr>
    <tr>
      <th>113313</th>
      <td>fffe41c64501cc87c801fd61db3f6244</td>
      <td>1</td>
      <td>350688d9dc1e75ff97be326363655e01</td>
      <td>f7ccf836d21b2fb1de37564105216cc1</td>
      <td>2018-06-12 17:10:13</td>
      <td>43.00</td>
      <td>12.79</td>
      <td>96d649da0cc4ff33bb408b199d4c7dcf</td>
      <td>delivered</td>
      <td>2018-06-09 17:00:18</td>
      <td>...</td>
      <td>SP</td>
      <td>14940</td>
      <td>ibitinga</td>
      <td>SP</td>
      <td>b2700869a37f1aafc9dda829dc2f9027</td>
      <td>5.0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2018-06-15 00:00:00</td>
      <td>2018-06-17 21:27:09</td>
    </tr>
  </tbody>
</table>
<p>113314 rows × 28 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-9af60739-f51c-45a5-986d-8122636329f8')"
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
        document.querySelector('#df-9af60739-f51c-45a5-986d-8122636329f8 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-9af60739-f51c-45a5-986d-8122636329f8');
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


<div id="df-4a959013-3142-461f-9242-8c39b794cddf">
  <button class="colab-df-quickchart" onclick="quickchart('df-4a959013-3142-461f-9242-8c39b794cddf')"
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
        document.querySelector('#df-4a959013-3142-461f-9242-8c39b794cddf button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_77c7bffc-fa48-4894-bdce-6d6fe306109a">
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
    <button class="colab-df-generate" onclick="generateWithVariable('df3_new')"
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
        document.querySelector('#id_77c7bffc-fa48-4894-bdce-6d6fe306109a button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('df3_new');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 1. 상위 10개 고객 주(state) 빈도수 계산
customer_state_counts = df3_new['customer_state'].value_counts().head(10)

top_states = customer_state_counts.index
average_review_scores = df3_new[df3_new['customer_state'].isin(top_states)].groupby('customer_state')['review_score'].mean()

# 2. 평균 평점이 가장 낮은 10개 고객 주(state) 선택
average_review_scores_all = df3_new.groupby('customer_state')['review_score'].mean()
bottom_states = average_review_scores_all.nsmallest(10)

# 3. 하위 10개 고객 주의 빈도수 계산
bottom_states_counts = df3_new['customer_state'].value_counts().loc[bottom_states.index]

# 4. subplot 생성
fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(12, 12))

# 5. 첫 번째 차트: 상위 10개 고객 주(state) 빈도수
sorted_counts = customer_state_counts.sort_values(ascending=True)  # 빈도수를 오름차순 정렬
bars1 = ax1.barh(sorted_counts.index, sorted_counts.values, color='skyblue')
ax1.set_title('상위 10개 고객 주(State) 빈도수')
ax1.set_xlabel('빈도수')
ax1.grid(axis='x')

# 6. 숫자 표기
for bar in bars1:
    ax1.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
             f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=10)

# 7. 두 번째 차트: 상위 10개 고객 주(state) 평균 평점
bars2 = ax2.barh(sorted_counts.index, average_review_scores[sorted_counts.index], color='lightgreen')
ax2.set_title('상위 10개 고객 주(State) 평균 평점')
ax2.set_xlabel('평균 평점')
ax2.grid(axis='x')

# 8. 숫자 표기
for bar in bars2:
    ax2.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
             f'{bar.get_width():.2f}', va='center', ha='left', fontsize=10)

# 9. 네 번째 차트: 하위 10개 고객 주(state) 빈도수
bars4 = ax4.barh(bottom_states_counts.index, bottom_states_counts.values, color='salmon')
ax4.set_title('하위 10개 고객 주(State) 빈도수')
ax4.set_xlabel('빈도수')
ax4.grid(axis='x')

# 10. 숫자 표기
for bar in bars4:
    ax4.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
             f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=10)

# 11. 세 번째 차트: 하위 10개 고객 주(state) 평균 평점
bars3 = ax3.barh(bottom_states.index, bottom_states.values, color='lightcoral')
ax3.set_title('하위 10개 고객 주(State) 평균 평점')
ax3.set_xlabel('평균 평점')
ax3.grid(axis='x')

for bar in bars3:
    ax3.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
             f'{bar.get_width():.2f}', va='center', ha='left', fontsize=10)

for ax in [ax1, ax2, ax3, ax4]:
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_125_0.png)
    


- 고객의 거주 주 별 평균 평점은 3.5 이상으로 나타나며, RJ주는 고객 비중이 높은 주이면서도 평균 평점이 낮은편에 속함


```python
low_score_counts = df3_new[df3_new['review_score'].isin([1, 2])].groupby('customer_state')['review_score'].count()

top_low_score_states = low_score_counts.nlargest(10).sort_values(ascending=True)

plt.figure(figsize=(10, 6))
bars = plt.barh(top_low_score_states.index, top_low_score_states.values, color='lightcoral')
plt.title('리뷰점수가 1점 또는 2점이 많은 상위 10개 고객 주(State)')
plt.xlabel('빈도수')
plt.grid(axis='x')

for bar in bars:
    plt.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
             f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=10)

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_127_0.png)
    


- 거래가 많이되는 곳에 낮은 점수도 많이 분포되고 있음을 알수있다


```python
df3_new = df3_new.merge(df4, on='product_id', how='left')
```


```python
# 1. 1점과 2점인 경우의 수를 계산
low_score_counts = df3_new[df3_new['review_score'].isin([1, 2])].groupby('product_category_name')['review_score'].count()

# 2. 상위 10개 품목 선택
top_low_score_categories = low_score_counts.nlargest(10).sort_values(ascending=True)

# 3. 5점인 경우의 수를 계산
high_score_counts = df3_new[df3_new['review_score'] == 5].groupby('product_category_name')['review_score'].count()

# 4. 상위 10개 품목 선택
top_high_score_categories = high_score_counts.nlargest(10).sort_values(ascending=True)

# 5. subplot 생성
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 6))

# 6. 첫 번째 차트: 1점 및 2점이 많은 상위 10개 품목
bars1 = ax1.barh(top_low_score_categories.index, top_low_score_categories.values, color='lightcoral')
ax1.set_title('1점 및 2점이 많은 상위 10개 품목')
ax1.set_xlabel('빈도수')
ax1.grid(axis='x')

# 7. 숫자 표기
for bar in bars1:
    ax1.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
             f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=10)

# 8. 두 번째 차트: 5점이 많은 상위 10개 품목
bars2 = ax2.barh(top_high_score_categories.index, top_high_score_categories.values, color='lightgreen')
ax2.set_title('5점이 많은 상위 10개 품목')
ax2.set_xlabel('빈도수')
ax2.grid(axis='x')

for bar in bars2:
    ax2.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
             f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=10)

for ax in [ax1, ax2]:
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_130_0.png)
    


- 평점이 높은 카테고리는 낮은 평점도 공존하고있음

## 현재 주어진 데이터 셋으로 어떤 비즈니스 지표들을 만들 수 있는지 제시하고, 해당 지표들로 AARRR 프레임워크를 구성할 수 있는지 판단하기

### Acquisition (획득): 사용자를 획득하는 단계

- 신규 고객 수 : `customer_unique_id` 활용 신규 고객 수 계산
- 지역별 신규 고객 분포 : `customer_city`와 `customer_state` 활용 지역별 신규 고객 수 계산


```python
new_customers = df3_new['customer_unique_id'].nunique()
print("신규 고객 수:", new_customers)
```

    신규 고객 수: 95420
    


```python
# 1. 도시별 신규 고객 수 계산
city_new_customers = df3_new.groupby('customer_city')['customer_unique_id'].nunique()

# 2. 주별 신규 고객 수 계산
state_new_customers = df3_new.groupby('customer_state')['customer_unique_id'].nunique()

# 3. 상위 10개 및 하위 10개 고객 수 선택
top_cities = city_new_customers.nlargest(10).sort_values(ascending=True)
bottom_cities = city_new_customers.nsmallest(10).sort_values(ascending=True)

top_states = state_new_customers.nlargest(10).sort_values(ascending=True)
bottom_states = state_new_customers.nsmallest(10).sort_values(ascending=True)

# 4. subplot 생성
fig, axs = plt.subplots(2, 2, figsize=(14, 12))

# 5. 첫 번째 차트: 상위 10개 도시
bars1 = axs[0, 0].barh(top_cities.index, top_cities.values, color='skyblue')
axs[0, 0].set_title('상위 10개 도시 신규 고객 분포')
axs[0, 0].set_xlabel('신규 고객 수')
axs[0, 0].grid(axis='x')

# 6. 오른쪽과 위쪽 테두리 제거
axs[0, 0].spines['top'].set_visible(False)
axs[0, 0].spines['right'].set_visible(False)

# 7. 숫자 표기
for bar in bars1:
    axs[0, 0].text(bar.get_width(), bar.get_y() + bar.get_height()/2,
                   f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=10)

# 8. 두 번째 차트: 하위 10개 도시
bars2 = axs[0, 1].barh(bottom_cities.index, bottom_cities.values, color='lightcoral')
axs[0, 1].set_title('하위 10개 도시 신규 고객 분포')
axs[0, 1].set_xlabel('신규 고객 수')
axs[0, 1].grid(axis='x')

# 9. 오른쪽과 위쪽 테두리 제거
axs[0, 1].spines['top'].set_visible(False)
axs[0, 1].spines['right'].set_visible(False)

# 10. 숫자 표기
for bar in bars2:
    axs[0, 1].text(bar.get_width(), bar.get_y() + bar.get_height()/2,
                   f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=10)

# 11. 세 번째 차트: 상위 10개 주
bars3 = axs[1, 0].barh(top_states.index, top_states.values, color='lightgreen')
axs[1, 0].set_title('상위 10개 주 신규 고객 분포')
axs[1, 0].set_xlabel('신규 고객 수')
axs[1, 0].grid(axis='x')

# 12. 오른쪽과 위쪽 테두리 제거
axs[1, 0].spines['top'].set_visible(False)
axs[1, 0].spines['right'].set_visible(False)

# 13. 숫자 표기
for bar in bars3:
    axs[1, 0].text(bar.get_width(), bar.get_y() + bar.get_height()/2,
                   f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=10)

# 14. 네 번째 차트: 하위 10개 주
bars4 = axs[1, 1].barh(bottom_states.index, bottom_states.values, color='lightblue')
axs[1, 1].set_title('하위 10개 주 신규 고객 분포')
axs[1, 1].set_xlabel('신규 고객 수')
axs[1, 1].grid(axis='x')

# 15. 오른쪽과 위쪽 테두리 제거
axs[1, 1].spines['top'].set_visible(False)
axs[1, 1].spines['right'].set_visible(False)

# 16. 숫자 표기
for bar in bars4:
    axs[1, 1].text(bar.get_width(), bar.get_y() + bar.get_height()/2,
                   f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=10)

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_136_0.png)
    



```python
state_new_customers.nlargest(3).sum() / new_customers * 100
```




    66.50806958708866




```python
state_new_customers.nlargest(5).sum() / new_customers * 100
```




    77.08132466988053




```python
state_new_customers.nlargest(7).sum() / new_customers * 100
```




    84.1762733179627




```python
# 1. customer_state와 seller_state의 빈도수 계산
customer_state_counts = df3_new['customer_state'].value_counts().head(10).sort_values(ascending=True)
seller_state_counts = df3_new['seller_state'].value_counts().head(10).sort_values(ascending=True)

# 2. subplot 생성 (1x2)
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

# 3. 첫 번째 차트: customer_state 빈도수
bars1 = ax1.barh(customer_state_counts.index, customer_state_counts.values, color='skyblue')
ax1.set_title('상위 10개 고객 주(State) 빈도수')
ax1.set_xlabel('빈도수')
ax1.grid(axis='x')

# 4. 숫자 표기
for bar in bars1:
    ax1.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
             f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=9)

# 5. 두 번째 차트: seller_state 빈도수
bars2 = ax2.barh(seller_state_counts.index, seller_state_counts.values, color='lightgreen')
ax2.set_title('상위 10개 판매자 주(State) 빈도수')
ax2.set_xlabel('빈도수')
ax2.grid(axis='x')

for bar in bars2:
    ax2.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
             f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=9)

ax1.spines['top'].set_visible(False)
ax1.spines['right'].set_visible(False)
ax2.spines['top'].set_visible(False)
ax2.spines['right'].set_visible(False)

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_140_0.png)
    


- 전체 고객 중 약 84%가 7개 주(SP, RJ, MG, RS, PR, SC, BA)에서 서비스를 이용하고있다. 판매자도 대부분 7개 주에서 판매를 하고있는것으로 관찰된다.
- 배송비와 타지역 신규유입에 들어가는 시간과 비용을 고려했을때, 전국단위보다는 고객이 모여있는 주를 중심으로 시장을 운영하는것이 효과적으로 보인다

### Activation (활성화): 사용자가 제품/서비스를 처음 사용하는 단계

- 첫 구매 완료율 : `order_status`가 delivered인 주문 건수를 전체 주문 건수로 나눠서 계산
- 리드 타임 : `order_purchase_timestamp`와 `order_delivered_customer_date` 컬럼을 이용하여 첫 주문까지의 리드 타임 계산


```python
# 활성화 단계(Activation)
first_purchase_completion_rate = df3_new[df3_new['order_status'] == 'delivered'].shape[0] / df3_new.shape[0]
lead_time = df3_new['delivery_time'].mean()

print("\n첫 구매 완료율:", round(first_purchase_completion_rate * 100, 2))
print("\n리드 타임:", round(lead_time,2))
```

    
    첫 구매 완료율: 97.82
    
    리드 타임: 12.01
    

- 데이터 수집기간동안 98% 고객이 구매를 완료하였고, 리드 타임은 평균 12일로 준수함


```python
# 1. 주별 신규 고객 수 계산
state_new_customers = df3_new.groupby('customer_state')['customer_unique_id'].nunique()

# 2. 상위 10개 고객 주 선택
top_states = state_new_customers.nlargest(10).sort_values(ascending=True).index

# 3. 해당 주들의 평균 배송 시간 계산
average_delivery_time = df3_new[df3_new['customer_state'].isin(top_states)].groupby('customer_state')['delivery_time'].mean()

# 4. 평균 배송 시간을 빈도수 기준으로 정렬
average_delivery_time = average_delivery_time.reindex(top_states)

plt.figure(figsize=(10, 6))
bars = plt.barh(average_delivery_time.index, average_delivery_time.values, color='lightblue')
plt.title('상위 10개 고객 주의 평균 배송 시간')
plt.xlabel('평균 배송 시간')
plt.grid(axis='x')

for bar in bars:
    plt.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
             f'{bar.get_width():.2f}', va='center', ha='left', fontsize=10)

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_146_0.png)
    


- 국가 특성을 자세히는 모르지만, 상위 10개 고객 주의 리드타임은 대체로 14일 이내로 짧은편이다


```python
# 1. 'review_score'가 1점 또는 2점인 데이터 필터링
filtered_data = df3_new[df3_new['review_score'].isin([1, 2])]

# 2. 주별 신규 고객 수 계산
state_new_customers = filtered_data.groupby('customer_state')['customer_unique_id'].nunique()

# 3. 상위 10개 고객 주 선택
top_states = state_new_customers.nlargest(10).sort_values(ascending=True).index

# 4. 해당 주들의 평균 배송 시간 계산
average_delivery_time = filtered_data[filtered_data['customer_state'].isin(top_states)].groupby('customer_state')['delivery_time'].mean()

# 5. 평균 배송 시간을 빈도수 기준으로 정렬
average_delivery_time = average_delivery_time.reindex(top_states)

plt.figure(figsize=(10, 6))
bars = plt.barh(average_delivery_time.index, average_delivery_time.values, color='lightblue')
plt.title('상위 10개 고객 주의 평균 배송 시간 (리뷰 점수 1점 및 2점)')
plt.xlabel('평균 배송 시간')
plt.grid(axis='x')

for bar in bars:
    plt.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
             f'{bar.get_width():.2f}', va='center', ha='left', fontsize=10)

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_148_0.png)
    


- 평점이 낮은 상품들은 리드 타임이 길어진 경향을 보이고있다. 물리적으로 가능하다면 리드타임을 줄이는 방안을 고민해보고, 구매자와 판매자의 거리상 리드타임이 길어질수밖에 없다면 시스템으로 명확하게 배송기간이 길어질수 있음을 사전에 명시하는 이벤트를 추가하여 고객이 인지하도록 한다. 이를통해 구매를 취소하는 빈도와 평점 등을 종합적으로 고려하여 시스템을 개선해본다

### Retention (유지): 사용자가 제품/서비스를 반복적으로 사용하는 단계


- 고객별 주문 횟수 : `customer_unique_id`를 이용하여 고객별 주문 횟수 계산
- 코호트별 재구매 분석 : `order_purchase_timestamp`를 이용하여 코호트를 구분하고, 각 코호트의 재구매율을 계산
- 이탈 고객 비율 : 특정 기간 동안 구매하지 않은 고객 비율을 계산


```python
customer_order_count = df3_new.groupby('customer_unique_id')['order_id'].nunique()
print("\n고객별 주문 횟수:")
customer_order_count.value_counts()
```

    
    고객별 주문 횟수:
    




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
      <th>order_id</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>92507</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2673</td>
    </tr>
    <tr>
      <th>3</th>
      <td>192</td>
    </tr>
    <tr>
      <th>4</th>
      <td>29</td>
    </tr>
    <tr>
      <th>5</th>
      <td>9</td>
    </tr>
    <tr>
      <th>6</th>
      <td>5</td>
    </tr>
    <tr>
      <th>7</th>
      <td>3</td>
    </tr>
    <tr>
      <th>9</th>
      <td>1</td>
    </tr>
    <tr>
      <th>16</th>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
round(((customer_order_count == 2).sum() / customer_order_count.shape[0])*100,2)
```




    2.8



- 대부분 1회성 구매 고객이며, 주문을 2번한 고객은 약 3% 수준으로 관찰됐다. 고객이 재구매를 할수있도록 어떤것들이 문제가있고 개선할 필요가있는지 확인할 필요가 있다


```python
df4_new = df3_new.copy()
df4_new['order_purchase_month'] = df4_new['order_purchase_timestamp'].dt.to_period('M')
first_order_month = df4_new.groupby('customer_unique_id')['order_purchase_month'].min()
orders = pd.merge(df4_new, first_order_month.rename('cohort'), on='customer_unique_id')

# 코호트별 재구매율
cohort_repurchase = orders.groupby(['cohort', 'order_purchase_month'])['customer_unique_id'].nunique().reset_index()
cohort_repurchase['period_number'] = (cohort_repurchase['order_purchase_month'] - cohort_repurchase['cohort']).apply(lambda x: x.n)
cohort_pivot = cohort_repurchase.pivot_table(index='cohort', columns='period_number', values='customer_unique_id')
cohort_size = cohort_pivot.iloc[:, 0]
retention_matrix = cohort_pivot.divide(cohort_size, axis=0)

# 시각화: 히트맵 생성
plt.figure(figsize=(12, 8))
sns.heatmap(retention_matrix, annot=True, fmt='.0%', cmap='Blues', cbar_kws={'label': '재구매율'})
plt.title('코호트별 재구매율')
plt.xlabel('기간 번호 (개월)')
plt.ylabel('코호트 (첫 주문 월)')
plt.xticks(rotation=45)
plt.yticks(rotation=0)
plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_155_0.png)
    



```python
# 이탈 고객 비율 계산
churn_rate = 1 - retention_matrix.mean(axis=1)

# 시각화: 이탈 고객 비율 바 차트 생성
plt.figure(figsize=(12, 6))
sns.barplot(x=churn_rate.index.astype(str), y=churn_rate.values, palette='Reds')
plt.title('코호트별 이탈 고객 비율')
plt.xlabel('코호트 (첫 주문 월)')
plt.ylabel('이탈 고객 비율')
plt.xticks(rotation=45)
plt.ylim(0, 1)  # 비율이 0%에서 100%까지이므로 y축 범위를 설정
plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_156_0.png)
    



```python
churn_rate
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
    <tr>
      <th>cohort</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2016-09</th>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>2016-10</th>
      <td>0.885246</td>
    </tr>
    <tr>
      <th>2016-12</th>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>2017-01</th>
      <td>0.941866</td>
    </tr>
    <tr>
      <th>2017-02</th>
      <td>0.942750</td>
    </tr>
    <tr>
      <th>2017-03</th>
      <td>0.942175</td>
    </tr>
    <tr>
      <th>2017-04</th>
      <td>0.939114</td>
    </tr>
    <tr>
      <th>2017-05</th>
      <td>0.934744</td>
    </tr>
    <tr>
      <th>2017-06</th>
      <td>0.930679</td>
    </tr>
    <tr>
      <th>2017-07</th>
      <td>0.926174</td>
    </tr>
    <tr>
      <th>2017-08</th>
      <td>0.920352</td>
    </tr>
    <tr>
      <th>2017-09</th>
      <td>0.913794</td>
    </tr>
    <tr>
      <th>2017-10</th>
      <td>0.906598</td>
    </tr>
    <tr>
      <th>2017-11</th>
      <td>0.898005</td>
    </tr>
    <tr>
      <th>2017-12</th>
      <td>0.886990</td>
    </tr>
    <tr>
      <th>2018-01</th>
      <td>0.872691</td>
    </tr>
    <tr>
      <th>2018-02</th>
      <td>0.854629</td>
    </tr>
    <tr>
      <th>2018-03</th>
      <td>0.831174</td>
    </tr>
    <tr>
      <th>2018-04</th>
      <td>0.797466</td>
    </tr>
    <tr>
      <th>2018-05</th>
      <td>0.747464</td>
    </tr>
    <tr>
      <th>2018-06</th>
      <td>0.664364</td>
    </tr>
    <tr>
      <th>2018-07</th>
      <td>0.497440</td>
    </tr>
    <tr>
      <th>2018-08</th>
      <td>0.499920</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> float64</label>



- 월별 코호트 분석을 수행해도 앞서 고객별 주문 횟수를 확인한 결과와 동일하게 대부분의 고객(90% 이상)이 1회 구매후 이탈하고있다. (2018년도 데이터는 거래가 작아서 이탈율이 전월대비 낮아보인다)
- 앞서 EDA진행시 제품 평점은 5점 비율이 높았으며, 평균 평점도 제일 낮은지역도 3.5이상으로 나타났다. 그럼에도 이탈률이 높다는 것은 마케팅 전략이나 서비스 품질이 문제가 있다고 판단할 수 있다.
- 고객 유지 전략을 강화하기위해 고객 경험을 개선할 필요가 있다. 예를들어, 고객의 피드백을 수용하는 시스템을 만들거나 프로모션이나 서비스 개선을 검토해볼 수 있다

### Revenue (수익): 사용자가 제품/서비스를 통해 수익을 창출하는 단계


- 총 매출 : `price` 컬럼의 합 계산
- 평균 주문 금액 : `price`컬럼과 `order_purchase_timestamp` 이용하여 평균 주문 금액 계산
- 카테고리별 매출 분석 : `price`와 `product_category_name`을 이용하여 카테고리별 매출 계산


```python
print("\n총 매출:", df3_new['price'].sum())
```

    
    총 매출: 13651923.47
    


```python
# 연도와 월별로 그룹화하여 주문 수 계산
monthly_orders = df2.groupby(df2['order_purchase_timestamp'].dt.to_period('M')).size()

# 1. 'shipping_limit_date'를 datetime 형식으로 변환
df3['shipping_limit_date'] = pd.to_datetime(df3['shipping_limit_date'])

# 2. 월별 매출액 집계
monthly_sales = df3.resample('M', on='shipping_limit_date')['price'].sum()

# 3. 2018년 8월까지의 데이터만 필터링
monthly_sales = monthly_sales[monthly_sales.index <= '2018-08-31']

# 4. subplot 생성
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 12))

# 첫 번째 차트: 월별 주문 수
bars = ax1.bar(monthly_orders.index.astype(str), monthly_orders.values, color='skyblue')

# 주문 수 표시
for bar in bars:
    yval = bar.get_height()
    ax1.text(bar.get_x() + bar.get_width()/2, yval, str(yval), ha='center', va='bottom')

ax1.set_title('월별 주문 수')
ax1.set_xlabel('연도-월')
ax1.set_ylabel('주문 수')
ax1.set_xticks(range(len(monthly_orders.index)))  # x축 위치 설정
ax1.set_xticklabels(monthly_orders.index.astype(str), rotation=45)  # 레이블과 회전 설정
ax1.grid(axis='y')

# 두 번째 차트: 월별 매출액 추이
ax2.plot(monthly_sales.index, monthly_sales.values, marker='o')

# 매출액 숫자 표기
for x, y in zip(monthly_sales.index, monthly_sales.values):
    ax2.text(x, y, f'{y:,.0f}', fontsize=9, ha='center', va='bottom')

# x축을 3개월 단위로 설정
ax2.set_xticks(monthly_sales.index[::3])
ax2.set_title('월별 매출액 추이')
ax2.set_xlabel('월')
ax2.set_ylabel('매출액')
ax2.set_xlim(pd.Timestamp('2016-09-01'), pd.Timestamp('2018-08-31'))  # x축 범위 설정
ax2.grid()

# 레이아웃 조정 및 그래프 표시
plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_162_0.png)
    


- 제품 판매수와 매출은 상승곡선을 그리고있다. 리텐션을 개선한다면 수익을 극대화 할 수 있다. 획득부분에서 얻은 고객이 거주하는 상위 3개 주를 우선적으로 마케팅 전략을 세우고, 상위 7개 주까지 확대방안을 검토해본다.


```python
# 코호트 분석을 위한 평균 주문 금액 계산
cohort_order_value = orders.groupby(['cohort', 'order_purchase_month'])['price'].mean().reset_index()
cohort_order_value['period_number'] = (cohort_order_value['order_purchase_month'] - cohort_order_value['cohort']).apply(lambda x: x.n)
cohort_order_value_pivot = cohort_order_value.pivot_table(index='cohort', columns='period_number', values='price')

plt.figure(figsize=(12, 8))
sns.heatmap(cohort_order_value_pivot, annot=True, fmt='.0f', cmap='YlGnBu', cbar_kws={'label': '평균 주문 금액'})
plt.title('코호트별 평균 주문 금액')
plt.xlabel('기간 번호 (개월)')
plt.ylabel('코호트 (첫 주문 월)')
plt.xticks(rotation=45)
plt.yticks(rotation=0)
plt.tight_layout()
plt.show()

```


    
![png](/assets/img/py9_files/py9_164_0.png)
    


- 대부분의 코호트는 평균주문금액이 초기의 높게 형성됐으며, 시간이 지남에 따라 감소하는 경향을 보이고있다. 다만, 앞서 살펴본 재구매율이 3%수준이기 때문에 근본적으로 고객이 재구매할 수 있는 환경을 조성해야한다


```python
# 1. 'product_category_name'에 대한 빈도수 계산
category_counts = merged_df_product['product_category_name'].value_counts()
category_revenue = merged_df_product.groupby('product_category_name')['price'].sum()

# 2. 전체 매출액 및 전체 빈도수 계산
total_revenue = category_revenue.sum()
total_count = category_counts.sum()

# 3. 첫 번째 줄을 위한 상위 10개 카테고리 선택 및 정렬
top_categories_counts = category_counts.head(10).sort_values(ascending=True)
top_categories_revenue = category_revenue[top_categories_counts.index]

# 4. 상위 10개 카테고리의 매출 비중 및 빈도 비중 계산
top_revenue_percentage = (top_categories_revenue / total_revenue) * 100
top_count_percentage = (top_categories_counts / total_count) * 100

# 5. subplot 생성 (2x2)
fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(14, 10))

# 6. 차트 생성 함수
def create_bar_chart(ax, x_data, y_data, title, xlabel, color):
    bars = ax.barh(x_data, y_data, color=color)
    ax.set_title(title)
    ax.set_xlabel(xlabel)
    ax.grid(axis='x')
    for bar in bars:
        ax.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
                f'{bar.get_width():,.1f}%', va='center', ha='left', fontsize=9)

# 7. 첫 번째 차트: 'product_category_name' 빈도수 비중 (상위 10개)
create_bar_chart(ax1, top_categories_counts.index, top_count_percentage,
                 '상품 카테고리별 빈도수 비중 (%) (상위 10개)', '빈도수 비중 (%)', 'skyblue')

# 8. 두 번째 차트: 상위 10개 카테고리의 매출 비중
create_bar_chart(ax2, top_categories_counts.index, top_revenue_percentage,
                 '상품 카테고리별 매출 비중 (%) (상위 10개)', '매출 비중 (%)', 'lightgreen')

# 9. 세 번째 차트: 전체 매출액 상위 10개의 상품 카테고리 비중
top_revenue_categories = category_revenue.nlargest(10).sort_values(ascending=True)
top_revenue_categories_percentage = (top_revenue_categories / total_revenue) * 100
create_bar_chart(ax3, top_revenue_categories.index, top_revenue_categories_percentage,
                 '총 매출액 상위 10개 상품 카테고리 비중 (%)', '매출 비중 (%)', 'orange')

# 10. 네 번째 차트: 빈도수 (상위 10개 카테고리, 비중)
top_revenue_categories_counts = category_counts[top_revenue_categories.index]
top_revenue_categories_counts_percentage = (top_revenue_categories_counts / total_count) * 100
create_bar_chart(ax4, top_revenue_categories.index, top_revenue_categories_counts_percentage,
                 '상품 카테고리별 빈도수 비중 (%) (상위 10개)', '빈도수 비중 (%)', 'skyblue')

ax2.yaxis.set_visible(False)
ax4.yaxis.set_visible(False)

for ax in [ax1, ax2, ax3, ax4]:
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_166_0.png)
    


- 판매량과 매출액이 반드시 비례하는것은 아닌것으로 관찰됨
- 특정 카테고리 매출비중이 높지않고 고르게 매출이 발생하고있으며, 건강과 미용 상품과 선물용 시계 상품이 각각 전체매출에 약 9% 비중을 차지하는 상위품목으로 관찰됨


```python
total_sales_by_state = df3_new.groupby('customer_state')['price'].sum().reset_index()

# 전체 매출액 계산
total_sales = total_sales_by_state['price'].sum()

# 퍼센트 계산
total_sales_by_state['percentage'] = (total_sales_by_state['price'] / total_sales) * 100

# 매출액 기준으로 상위 10개 주 선택
top_10_states = total_sales_by_state.nlargest(10, 'price')

# 시각화: 상위 10개 주의 총 매출액 차트
plt.figure(figsize=(10, 6))
bars = sns.barplot(y='customer_state', x='price', data=top_10_states.sort_values(by='price', ascending=False), palette='Blues')
plt.title('고객 주별 총 매출액 상위 10개 (퍼센트 포함)')
plt.xlabel('총 매출액')
plt.ylabel('고객 주')

# 퍼센트 표시
for index, bar in enumerate(bars.patches):
    plt.text(bar.get_x() + bar.get_width() + 10000, bar.get_y() + bar.get_height() / 2,
             f'{top_10_states["percentage"].iloc[index]:.1f}%', color='black', va='center')

plt.tight_layout()
plt.show()

```


    
![png](/assets/img/py9_files/py9_168_0.png)
    


- 매출 비중은 SP에서 약 40%로 대부분의 매출이 발생하고있으며, 상위 5개 주를 포함하면 74%에 해당되고있다.


```python
top_states = df3_new['customer_state'].value_counts().nlargest(5).index

# 상위 5개 주에서의 총 매출액 계산
top_states_data = df3_new[df3_new['customer_state'].isin(top_states)]
total_sales_by_category = top_states_data.groupby('product_category_name')['price'].sum().reset_index()

# 매출액 기준으로 상위 10개 상품 카테고리 선택
top_10_categories = total_sales_by_category.nlargest(10, 'price')

# 전체 매출액 계산
total_sales = top_states_data['price'].sum()

# 퍼센트 계산
top_10_categories['percentage'] = (top_10_categories['price'] / total_sales) * 100

# 상품 카테고리 상위 10개 계산
category_counts = top_states_data['product_category_name'].value_counts().nlargest(10).reset_index()
category_counts.columns = ['product_category_name', 'count']

# 시각화: 서브플롯 생성
fig, axes = plt.subplots(1, 2, figsize=(15, 6))

# 첫 번째 차트: 상위 10개 상품 카테고리 총 매출액
bars1 = sns.barplot(y='product_category_name', x='price', data=top_10_categories, palette='Blues', ax=axes[0])
axes[0].set_title('고객 상위 5개 주(state)의 상위 10개 상품 카테고리 총 매출액')
axes[0].set_xlabel('총 매출액')
axes[0].set_ylabel('상품 카테고리')

# 퍼센트 표시
for index, bar in enumerate(bars1.patches):
    axes[0].text(bar.get_x() + bar.get_width() + 10000, bar.get_y() + bar.get_height() / 2,
                  f'{top_10_categories["percentage"].iloc[index]:.1f}%', color='black', va='center')

# 두 번째 차트: 상품 카테고리 상위 10개
bars2 = sns.barplot(y='product_category_name', x='count', data=category_counts, palette='Greens', ax=axes[1])
axes[1].set_title('고객 상위 5개 주(state)의 상품 카테고리 상위 10개')
axes[1].set_xlabel('주문 수')
axes[1].set_ylabel('상품 카테고리')

# 퍼센트 표시
total_count = category_counts['count'].sum()
for index, row in category_counts.iterrows():
    axes[1].text(row['count'] + 0.5, index, f'{(row["count"] / total_count) * 100:.1f}%', color='black', va='center')

for ax in axes:
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_170_0.png)
    


- olist 이용 고객 77%가 속한 상위 5개 주(state)기준 상위 10개 상품 카테고리가 약 63% 매출 비중을 차지한다. 즉, 전체 매출 74% 중 63%의 매출이 상위 10개 상품 카테고리에서 발생하고 있다
- 수익을 우선적으로 극대화하기 위해 상위 5개 주에서 매출비중이 높은 상품을 확장시키는 방안을 검토해본다.
- 다양한 상품은 전지역에 파는 방향보다는 잘팔리는 상품을 구매자와 판매자가 밀집된 지역에 우선적으로 마케팅 전략을 세우는 방향을 도입해볼 필요가 있다

### Referral (추천): 사용자가 제품/서비스를 다른 사람에게 추천하는 단계


- 제품별/카테고리별 평점 비교 : `product_id`, `product_category_name`과 `review_score`컬럼을 이용하여 제품별 평점 비교
- 순 추천지수 : 리뷰 점수를 추천그룹(5점)과 비추천그룹(1점,2점)의 비율을 계산



```python
product_ratings = round(df3_new.groupby('product_category_name')['review_score'].mean(),2).sort_values(ascending=False).reset_index()
print("\n카테고리별 평점 비교:")
product_ratings
```

    
    카테고리별 평점 비교:
    





  <div id="df-3cabc4a0-0338-4a86-a8fe-f5c7df186ae7" class="colab-df-container">
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
      <th>product_category_name</th>
      <th>review_score</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>cds_dvds_musicals</td>
      <td>4.64</td>
    </tr>
    <tr>
      <th>1</th>
      <td>fashion_childrens_clothes</td>
      <td>4.50</td>
    </tr>
    <tr>
      <th>2</th>
      <td>books_general_interest</td>
      <td>4.45</td>
    </tr>
    <tr>
      <th>3</th>
      <td>costruction_tools_tools</td>
      <td>4.44</td>
    </tr>
    <tr>
      <th>4</th>
      <td>flowers</td>
      <td>4.42</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>68</th>
      <td>office_furniture</td>
      <td>3.49</td>
    </tr>
    <tr>
      <th>69</th>
      <td>pc_gamer</td>
      <td>3.33</td>
    </tr>
    <tr>
      <th>70</th>
      <td>portateis_cozinha_e_preparadores_de_alimentos</td>
      <td>3.27</td>
    </tr>
    <tr>
      <th>71</th>
      <td>diapers_and_hygiene</td>
      <td>3.26</td>
    </tr>
    <tr>
      <th>72</th>
      <td>security_and_services</td>
      <td>2.50</td>
    </tr>
  </tbody>
</table>
<p>73 rows × 2 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-3cabc4a0-0338-4a86-a8fe-f5c7df186ae7')"
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
        document.querySelector('#df-3cabc4a0-0338-4a86-a8fe-f5c7df186ae7 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-3cabc4a0-0338-4a86-a8fe-f5c7df186ae7');
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


<div id="df-8699efba-d462-4283-9694-bd0da3bd21c5">
  <button class="colab-df-quickchart" onclick="quickchart('df-8699efba-d462-4283-9694-bd0da3bd21c5')"
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
        document.querySelector('#df-8699efba-d462-4283-9694-bd0da3bd21c5 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_6f8a958f-066d-4cb2-ae9b-3ad3332c8470">
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
    <button class="colab-df-generate" onclick="generateWithVariable('product_ratings')"
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
        document.querySelector('#id_6f8a958f-066d-4cb2-ae9b-3ad3332c8470 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('product_ratings');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
product_ratings.nlargest(10, 'review_score')
```





  <div id="df-2546e65e-be66-4d4e-9f56-34a08f53dbe1" class="colab-df-container">
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
      <th>product_category_name</th>
      <th>review_score</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>11</th>
      <td>cds_dvds_musicals</td>
      <td>4.64</td>
    </tr>
    <tr>
      <th>29</th>
      <td>fashion_childrens_clothes</td>
      <td>4.50</td>
    </tr>
    <tr>
      <th>8</th>
      <td>books_general_interest</td>
      <td>4.45</td>
    </tr>
    <tr>
      <th>22</th>
      <td>costruction_tools_tools</td>
      <td>4.44</td>
    </tr>
    <tr>
      <th>35</th>
      <td>flowers</td>
      <td>4.42</td>
    </tr>
    <tr>
      <th>9</th>
      <td>books_imported</td>
      <td>4.40</td>
    </tr>
    <tr>
      <th>10</th>
      <td>books_technical</td>
      <td>4.37</td>
    </tr>
    <tr>
      <th>37</th>
      <td>food_drink</td>
      <td>4.32</td>
    </tr>
    <tr>
      <th>53</th>
      <td>luggage_accessories</td>
      <td>4.32</td>
    </tr>
    <tr>
      <th>66</th>
      <td>small_appliances_home_oven_and_coffee</td>
      <td>4.30</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-2546e65e-be66-4d4e-9f56-34a08f53dbe1')"
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
        document.querySelector('#df-2546e65e-be66-4d4e-9f56-34a08f53dbe1 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-2546e65e-be66-4d4e-9f56-34a08f53dbe1');
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


<div id="df-917cf758-63b5-4cca-8e86-f0354d5f530b">
  <button class="colab-df-quickchart" onclick="quickchart('df-917cf758-63b5-4cca-8e86-f0354d5f530b')"
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
        document.querySelector('#df-917cf758-63b5-4cca-8e86-f0354d5f530b button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
product_ratings.nsmallest(10, 'review_score')
```





  <div id="df-688a3488-3f47-4ee6-93b1-e886e983aa2f" class="colab-df-container">
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
      <th>product_category_name</th>
      <th>review_score</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>63</th>
      <td>security_and_services</td>
      <td>2.50</td>
    </tr>
    <tr>
      <th>23</th>
      <td>diapers_and_hygiene</td>
      <td>3.26</td>
    </tr>
    <tr>
      <th>62</th>
      <td>portateis_cozinha_e_preparadores_de_alimentos</td>
      <td>3.27</td>
    </tr>
    <tr>
      <th>59</th>
      <td>pc_gamer</td>
      <td>3.33</td>
    </tr>
    <tr>
      <th>57</th>
      <td>office_furniture</td>
      <td>3.49</td>
    </tr>
    <tr>
      <th>46</th>
      <td>home_comfort_2</td>
      <td>3.63</td>
    </tr>
    <tr>
      <th>30</th>
      <td>fashion_male_clothing</td>
      <td>3.64</td>
    </tr>
    <tr>
      <th>34</th>
      <td>fixed_telephony</td>
      <td>3.68</td>
    </tr>
    <tr>
      <th>58</th>
      <td>party_supplies</td>
      <td>3.77</td>
    </tr>
    <tr>
      <th>27</th>
      <td>fashio_female_clothing</td>
      <td>3.78</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-688a3488-3f47-4ee6-93b1-e886e983aa2f')"
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
        document.querySelector('#df-688a3488-3f47-4ee6-93b1-e886e983aa2f button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-688a3488-3f47-4ee6-93b1-e886e983aa2f');
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


<div id="df-b26e5344-68cc-44ed-ab2f-927770fb5506">
  <button class="colab-df-quickchart" onclick="quickchart('df-b26e5344-68cc-44ed-ab2f-927770fb5506')"
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
        document.querySelector('#df-b26e5344-68cc-44ed-ab2f-927770fb5506 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
product_ratings = round(df3_new.groupby('product_category_name')['review_score'].mean(), 2).reset_index()

# 상위 10개와 하위 10개 상품 카테고리 선택
top_10_categories = product_ratings.nlargest(10, 'review_score')
bottom_10_categories = product_ratings.nsmallest(10, 'review_score')

# 상위 10개와 하위 10개를 하나의 데이터프레임으로 결합
top_10_categories['category_type'] = '상위'
bottom_10_categories['category_type'] = '하위'
combined_categories = pd.concat([top_10_categories, bottom_10_categories])

# 시각화: 평균 평점 차트
plt.figure(figsize=(10, 6))
bars = sns.barplot(y='product_category_name', x='review_score', data=combined_categories.sort_values(by='review_score', ascending=False), palette='coolwarm', hue='category_type')
plt.title('상품 카테고리 평균 평점 (상위 10개 및 하위 10개)')
plt.xlabel('평균 평점')
plt.ylabel('상품 카테고리')

# 평균 평점 표시
for index, bar in enumerate(bars.patches):
    plt.text(bar.get_x() + bar.get_width() + 0.01, bar.get_y() + bar.get_height() / 2,
             f'{bar.get_width():.2f}', color='black', va='center')

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_177_0.png)
    



```python
# 1. 1점과 2점인 경우의 수를 계산
low_score_counts = df3_new[df3_new['review_score'].isin([1, 2])].groupby('product_category_name')['review_score'].count()

# 2. 상위 10개 품목 선택
top_low_score_categories = low_score_counts.nlargest(10).sort_values(ascending=True)

# 3. 5점인 경우의 수를 계산
high_score_counts = df3_new[df3_new['review_score'] == 5].groupby('product_category_name')['review_score'].count()

# 4. 상위 10개 품목 선택
top_high_score_categories = high_score_counts.nlargest(10).sort_values(ascending=True)

# 5. subplot 생성
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 6))

# 6. 첫 번째 차트: 1점 및 2점이 많은 상위 10개 품목
bars1 = ax1.barh(top_low_score_categories.index, top_low_score_categories.values, color='lightcoral')
ax1.set_title('1점 및 2점이 많은 상위 10개 품목')
ax1.set_xlabel('빈도수')
ax1.grid(axis='x')

# 7. 숫자 표기
for bar in bars1:
    ax1.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
             f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=10)

# 8. 두 번째 차트: 5점이 많은 상위 10개 품목
bars2 = ax2.barh(top_high_score_categories.index, top_high_score_categories.values, color='lightgreen')
ax2.set_title('5점이 많은 상위 10개 품목')
ax2.set_xlabel('빈도수')
ax2.grid(axis='x')

for bar in bars2:
    ax2.text(bar.get_width(), bar.get_y() + bar.get_height()/2,
             f'{bar.get_width():,.0f}', va='center', ha='left', fontsize=10)

for ax in [ax1, ax2]:
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_178_0.png)
    


- 잘팔리는 상품들은 하위 평점은 아니지만 낮은평점과 높은평점이 공존하고있다
- aarrr 관점에서 우리는 고객이 밀집한 주(state)에서 잘팔리는 상품들을 확대하기로 설정했다.
- 따라서 잘팔리는 상품들의 평점이 1점이나 2점을 받은 낮은 사례들의 리뷰를 확인해서 고객의 피드백을 반영하도록 노력한다
- 추가적으로 리드타임이 길어지면 평점이 낮아지는 경향을 활성화 단계에서 발견했다. 이부분도 리드타임을 개선할 수 있는 방안이나 고객이 인지할수있는 방안을 강구해본다


```python
df3_new['review_answer_timestamp'] = pd.to_datetime(df3_new['review_answer_timestamp'])

# 추천 및 비추천 그룹 분류
df3_new['group'] = df3_new['review_score'].apply(lambda x: '추천' if x == 5 else ('비추천' if x in [1, 2] else '중립'))

# 월별 집계
df3_new['month'] = df3_new['review_answer_timestamp'].dt.to_period('M')
monthly_counts = df3_new.groupby(['month', 'group']).size().unstack(fill_value=0)

# NPS 계산
monthly_counts['NPS'] = (monthly_counts['추천'] - monthly_counts['비추천']) / (monthly_counts['추천'] + monthly_counts['비추천']) * 100

# 시각화
plt.figure(figsize=(12, 6))
sns.lineplot(data=monthly_counts, x=monthly_counts.index.astype(str), y='NPS', marker='o')
plt.title('월별 NPS (추천 비율 - 비추천 비율)')
plt.xlabel('월')
plt.ylabel('NPS (%)')
plt.xticks(rotation=45)
plt.axhline(0, color='red', linestyle='--', linewidth=1)

# NPS 값 표시
for i, nps_value in enumerate(monthly_counts['NPS']):
    plt.text(i, nps_value, f'{nps_value:.1f}', color='black', ha='center', va='bottom')

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/py9_files/py9_180_0.png)
    


- 월별 순 추천지수(NPS)는 대부분 40점 이상으로 굉장히 높게 나타났는데, 실제 재구매율은 3%로 굉장히 낮은 수치를 보이고있다. 리뷰를 5점을 주는것이 과장된 부분이 없는지(리뷰이벤트나 평점을 조작하지 않았는지 등) 감안할 필요가 있다.
- 재구매율을 감안했을때 리뷰점수가 낮은 1점과 2점을 진실된 리뷰로 해석할 수도 있다. 따라서 평점이 낮은 부분을 적극적으로 확인하고, 추가적으로 리뷰 외에도 설문조사 등으로 고객의 의견을 받을 수 있도록 다양한 채널을 만들어 확인할 필요가 있다.
