import streamlit as st
import pandas as pd
import plotly.express as px
from db_connection import create_connection

# Подключение к базе данных
conn = create_connection()

# Заголовок
st.title("Chinook Sales Report")

# Запрос SQL
query = """
SELECT 
    billing_country AS country, 
    SUM(total) AS total_sales, 
    COUNT(invoice_id) AS total_invoices, 
    STRFTIME('%Y-%m', invoice_date) AS invoice_month
FROM invoice
GROUP BY country, invoice_month
ORDER BY invoice_month;
"""
df = pd.read_sql_query(query, conn)

# Элементы управления
st.sidebar.header("Фильтры")
selected_countries = st.sidebar.multiselect(
    "Выберите страны", df["country"].unique(), default=df["country"].unique()
)
selected_month = st.sidebar.selectbox(
    "Выберите месяц", df["invoice_month"].unique()
)
min_sales = st.sidebar.slider(
    "Минимальная сумма продаж", 0, int(df["total_sales"].max()), 0
)

# Применение фильтров
filtered_df = df[
    (df["country"].isin(selected_countries)) & 
    (df["invoice_month"] == selected_month) & 
    (df["total_sales"] >= min_sales)
]

# Графики
fig1 = px.bar(
    filtered_df, 
    x="country", 
    y="total_sales", 
    title="Сумма продаж по странам"
)

fig2 = px.line(
    filtered_df, 
    x="invoice_month", 
    y="total_invoices", 
    color="country", 
    title="Динамика инвойсов"
)

# Отображение
st.plotly_chart(fig1)
st.plotly_chart(fig2)
st.dataframe(filtered_df)
