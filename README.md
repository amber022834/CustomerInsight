# CustomerInsight
CRM Customer Segmentation &amp; Analysis using SQL
# CustomerInsight

## CRM Customer Segmentation & Analysis

CustomerInsight 是一個以 **SQL 與 CRM 分群概念**為核心的客戶分析專案，透過客戶基本資料、交易紀錄與行為資料建立標籤與客群，找出不同客群的特徵與交易差異，作為 CRM 客戶經營與行銷規劃的參考。

---

# Project Goal

透過客戶與交易資料進行分析，建立一致的 **CRM Tag 與 Customer Segment**，協助行銷企劃快速找到目標客群，並從數據中了解不同客群的交易特徵。

---

# Tools

- **MySQL**｜資料整理、SQL 查詢、客群分析


---

# Data Analysis

本專案使用模擬客戶、交易、商品與行為資料，分析不同通路、商品與客群的交易差異，作為 CRM 標籤與客群設計的依據。

## SQL Data Analysis

使用 SQL 整合客戶、交易與商品資料，分析不同客群的交易情況。

- **客戶分析**｜分析不同年齡、地區的客戶交易情況
- **通路分析**｜比較 App、Web、Branch 的客戶數與交易金額
- **商品分析**｜比較不同商品類別的交易表現
- **客群分析**｜找出不同客群的交易特徵

## Key Findings

- Investment 為主要交易商品類別，各通路皆有較高的交易金額。
- **進階理財方案**的交易總金額與平均單筆交易金額較高。
- 北部 **40–49 歲**、中部與南部 **30–39 歲**客群的進階理財方案交易金額較高。
- 分析結果可進一步作為 **CRM Tag 與 Customer Segment** 的設計依據。

---

# CRM Tag Design

將客戶基本資料與交易行為整理成標籤，建立一致的客戶分類方式。

| Tag Category | Tag Example |
|---|---|
| 年齡 | 20–29、30–39、40–49、50+ |
| 地區 | 北部、中部、南部、東部 |
| 使用通路 | App、Web、Branch |
| 商品偏好 | 基礎理財、投資方案、進階理財 |
| 客戶價值 | 高價值、中價值、一般 |

## Customer Value Rule

依據**交易頻率與平均單筆交易金額**建立客戶價值分類。

| Value Tag | Rule |
|---|---|
| 高價值 | 交易 ≥ 2 次＋平均單筆金額 ≥ 1,800 元 |
| 中價值 | 交易頻率或平均單筆金額其中一項較高 |
| 低價值 | 交易 < 2 次＋平均單筆金額 < 1,800 元 |

---

# Customer Segment Design

透過不同 CRM Tags 組合建立客群，協助行銷企劃快速找到目標客戶。

| Segment | 分群條件 | 用途 |
|---|---|---|
| App 高價值客群 | App＋高價值 | 找出 App 高價值客戶 |
| 進階理財高價值客群 | 進階理財＋高價值 | 找出高價值理財客戶 |
| 進階理財潛力客群 | 進階理財＋中價值 | 找出具潛力的理財客戶 |

---

# Customer Segment｜App 高價值客群

## Segment Overview

| 指標 | 結果 |
|---|---|
| 客群定義 | App 使用者＋高價值客戶 |
| 客戶數 | 44 人 |
| 主要年齡層 | 20–29、30–39 歲 |
| 主要地區 | 北部、南部 |
| 主要商品類別 | Investment |
| Investment 交易筆數 | 49 筆 |
| Investment 交易金額 | 419,700 元 |
| Investment 金額占比 | 約 84% |

## Data Insight

App 高價值客群共 44 人，主要集中於 20–29 歲及 30–39 歲，地區則以北部及南部為主。

從交易資料來看，**Investment 為主要商品類別，共 49 筆交易，交易金額 419,700 元，約占此客群交易總金額的 84%**，顯示此客群的交易金額主要集中於 Investment 商品。

---

# Product Application

根據客群分析結果，可進一步思考不同客群的產品經營方式。

### App 高價值客群

**Target**

App 使用者＋高價值客戶

**Insight**

Investment 商品交易金額占比高。

**Possible Action**

針對高價值 App 使用者推薦相關 Investment 商品與進階理財服務。

---

# Project Outcome

透過 SQL 與 Power BI 完成：

**Customer Data**

↓

**Data Analysis**

↓

**CRM Tag**

↓

**Customer Segmentation**

↓

**Customer Insight**

↓

**Product / Marketing Action**

將原始客戶資料轉換為可供 CRM 與行銷企劃使用的客群資訊，建立從**資料分析 → 客群分群 → Insight → Action**的分析流程。
