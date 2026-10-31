# Query results

## Q1. What are the headline business numbers?

| total_orders   | unique_customers   | sellers   | revenue_brl   | avg_order_value_brl   | avg_review_score   |
|:---------------|:-------------------|:----------|:--------------|:----------------------|:-------------------|
| 99,441         | 96,096             | 3,095     | 13,591,644    | 137.75                | 4.09               |

## Q2. How did monthly orders and revenue grow, month over month?

| month   | orders   | revenue_brl   | mom_growth_pct   |
|:--------|:---------|:--------------|:-----------------|
| 2017-01 | 789      | 120,313       |                  |
| 2017-02 | 1,733    | 247,303       | 105.5            |
| 2017-03 | 2,641    | 374,344       | 51.4             |
| 2017-04 | 2,391    | 359,927       | -3.9             |
| 2017-05 | 3,660    | 506,071       | 40.6             |
| 2017-06 | 3,217    | 433,039       | -14.4            |
| 2017-07 | 3,969    | 498,031       | 15               |
| 2017-08 | 4,293    | 573,972       | 15.2             |
| 2017-09 | 4,243    | 624,402       | 8.8              |
| 2017-10 | 4,568    | 664,219       | 6.4              |
| 2017-11 | 7,451    | 1,010,271     | 52.1             |
| 2017-12 | 5,624    | 743,914       | -26.4            |
| 2018-01 | 7,220    | 950,030       | 27.7             |
| 2018-02 | 6,694    | 844,179       | -11.1            |
| 2018-03 | 7,188    | 983,213       | 16.5             |
| 2018-04 | 6,934    | 996,648       | 1.4              |
| 2018-05 | 6,853    | 996,518       | 0                |
| 2018-06 | 6,160    | 865,124       | -13.2            |
| 2018-07 | 6,273    | 895,507       | 3.5              |
| 2018-08 | 6,452    | 854,686       | -4.6             |

## Q3. How much did revenue grow year over year (January–August)?

| revenue_2017_jan_aug   | revenue_2018_jan_aug   | yoy_growth_pct   |
|:-----------------------|:-----------------------|:-----------------|
| 3,113,000              | 7,385,906              | 137.3            |

## Q4. Which product categories drive revenue?

| category              | orders   | revenue_brl   | share_pct   | cumulative_share_pct   |
|:----------------------|:---------|:--------------|:------------|:-----------------------|
| health_beauty         | 8,836    | 1,258,681     | 9.3         | 9.3                    |
| watches_gifts         | 5,624    | 1,205,006     | 8.9         | 18.1                   |
| bed_bath_table        | 9,417    | 1,036,989     | 7.6         | 25.8                   |
| sports_leisure        | 7,720    | 988,049       | 7.3         | 33                     |
| computers_accessories | 6,689    | 911,954       | 6.7         | 39.7                   |
| furniture_decor       | 6,449    | 729,762       | 5.4         | 45.1                   |
| cool_stuff            | 3,632    | 635,291       | 4.7         | 49.8                   |
| housewares            | 5,884    | 632,249       | 4.7         | 54.4                   |
| auto                  | 3,897    | 592,720       | 4.4         | 58.8                   |
| garden_tools          | 3,518    | 485,256       | 3.6         | 62.4                   |

## Q5. How reliable is delivery overall?

| delivered_orders   | on_time_pct   | avg_delivery_days   | avg_promised_days   |
|:-------------------|:--------------|:--------------------|:--------------------|
| 96,476             | 91.9          | 12.6                | 23.7                |

## Q6. Which states are served worst?

| state   | delivered_orders   | on_time_pct   | avg_delivery_days   |
|:--------|:-------------------|:--------------|:--------------------|
| MA      | 717                | 80.3          | 21.6                |
| CE      | 1,279              | 84.7          | 21.3                |
| BA      | 3,256              | 86            | 19.3                |
| RJ      | 12,353             | 86.5          | 15.3                |
| PA      | 946                | 87.6          | 23.8                |

## Q7. How much does a late delivery hurt the review score?

| delivery_group      | reviews   | avg_review   | pct_1_or_2_stars   |
|:--------------------|:----------|:-------------|:-------------------|
| 1. On time or early | 89,949    | 4.29         | 9.3                |
| 2. 1-3 days late    | 1,856     | 3.29         | 32.2               |
| 3. 4-7 days late    | 1,756     | 2.1          | 67.7               |
| 4. 8+ days late     | 2,798     | 1.7          | 79.2               |

## Q8. How many customers come back, and how much revenue do they bring?

| customer_type   | customers   | customer_share_pct   | revenue_share_pct   | revenue_per_customer_brl   |
|:----------------|:------------|:---------------------|:--------------------|:---------------------------|
| One-time        | 93,099      | 96.88                | 94.3                | 138                        |
| Repeat          | 2,997       | 3.12                 | 5.7                 | 260                        |

## Q9. How do customers pay?

| payment_type   | orders   | order_share_pct   | avg_payment_brl   | avg_installments   |
|:---------------|:---------|:------------------|:------------------|:-------------------|
| credit_card    | 76,505   | 76.9              | 163.32            | 3.5                |
| boleto         | 19,784   | 19.9              | 145.03            | 1                  |
| voucher        | 3,866    | 3.9               | 65.7              | 1                  |
| debit_card     | 1,528    | 1.5               | 142.57            | 1                  |

## Q10. Do customers who pay in more installments spend more?

| installments   | payments   | avg_payment_brl   |
|:---------------|:-----------|:------------------|
| 1              | 25,457     | 96                |
| 2-3            | 22,874     | 134               |
| 4-6            | 16,257     | 181               |
| 7+             | 12,207     | 335               |

## Q11. How concentrated is revenue among sellers?

| decile   | sellers   | revenue_share_pct   |
|:---------|:----------|:--------------------|
| 1        | 310       | 67.6                |
| 2        | 310       | 15.2                |
| 3        | 310       | 7.6                 |

## Q12. Where is demand high but seller supply thin?

| state   | orders   | sellers   | orders_per_seller   |
|:--------|:---------|:----------|:--------------------|
| PE      | 1,652    | 9         | 184                 |
| BA      | 3,380    | 19        | 178                 |
| CE      | 1,336    | 13        | 103                 |
| ES      | 2,033    | 23        | 88                  |
| RJ      | 12,852   | 171       | 75                  |
| DF      | 2,140    | 30        | 71                  |

## Q13. When do customers shop?

| weekday   | orders   | share_pct   |
|:----------|:---------|:------------|
| Mon       | 16,196   | 16.3        |
| Tue       | 15,963   | 16.1        |
| Wed       | 15,552   | 15.6        |
| Thu       | 14,761   | 14.8        |
| Fri       | 14,122   | 14.2        |
| Sun       | 11,960   | 12          |
| Sat       | 10,887   | 10.9        |
