# Danny-s-8-week-Challenge
## Introduction
This repository contains SQL scripts for analyzing customer sales data from a restaurant. The data is structured into three main tables: sales_data, menu, and members. The analysis focuses on customer spending, purchasing behavior, and loyalty program points accumulation.

### Tables Description
1. **sales_data**
customer_id: Identifier for the customer (VARCHAR(1))
order_date: Date of the order (DATE)
product_id: Identifier for the product (INTEGER)
2. **menu**
product_id: Identifier for the product (INTEGER)
product_name: Name of the product (VARCHAR(5))
price: Price of the product (INTEGER)
3. **members**
customer_id: Identifier for the customer (VARCHAR(1))
join_date: Date the customer became a member (DATE)

### Data Analysis
The analysis covers the following points:

- Total Amount Spent by Each Customer:
The total amount spent by each customer is calculated by summing up the prices of all items purchased by the customer.
**Visualization:** A bar plot showing the total amount spent by each customer.
![total amount spent by each customer](https://github.com/user-attachments/assets/235d7b2a-c38d-467a-94b5-e0579b874f30)

- Number of Visits by Each Customer:
The number of visits is determined by counting the unique dates on which a customer placed an order.
**Visualization:** A bar plot showing the number of visits by each customer.
![number of visits by each customer](https://github.com/user-attachments/assets/1cec6cdd-c248-4e57-ba34-8d3d06b9f4ff)

- First Item Purchased by Each Customer:
The first item purchased by each customer is identified by ordering their purchases by date and selecting the first entry.
**Visualization:** A count plot showing the first item purchased by each customer.
![first item purchased by each customer](https://github.com/user-attachments/assets/287634b4-56df-4eae-854c-5265b820213a)

And further more analysis are performed.

### What I learned
This analysis provides valuable insights into customer behavior and menu item popularity, which can help the restaurant optimize its offerings and improve customer satisfaction. The visualizations make it easy to understand the data and identify key trends.

