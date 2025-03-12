import streamlit as st
import pandas as pd
import plotly.express as px
from db_connection import create_connection

# Кэширование данных
@st.cache_data
def load_data(query, _conn):
    return pd.read_sql_query(query, _conn)

# Подключение к базе данных
conn = create_connection()

# Заголовок дашборда
st.title("Chinook Sales Dashboard")

# Фильтры
st.sidebar.header("Фильтры")
start_date = st.sidebar.date_input("Стартовая дата")
end_date = st.sidebar.date_input("Конечная дата")

# Данные для линейного графика
invoice_query = f"""
SELECT invoice_date, SUM(total) AS total_sales
FROM invoice
WHERE invoice_date BETWEEN '{start_date}' AND '{end_date}'
GROUP BY invoice_date
ORDER BY invoice_date;
"""
invoice_data = load_data(invoice_query, conn)

# Линейный график
fig1 = px.line(invoice_data, x="invoice_date", y="total_sales",
               title="Продажи по датам",
               labels={"invoice_date": "Дата", "total_sales": "Сумма продаж"})
st.plotly_chart(fig1)

# Данные для столбчатой диаграммы
genre_query = f"""
SELECT g.name AS genre, SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice i
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE i.invoice_date BETWEEN '{start_date}' AND '{end_date}'
GROUP BY g.name
ORDER BY total_sales DESC;
"""
genre_data = load_data(genre_query, conn)

# Столбчатая диаграмма
fig2 = px.bar(genre_data, x="genre", y="total_sales",
              title="Продажи по жанрам",
              labels={"genre": "Жанр", "total_sales": "Сумма продаж"})
st.plotly_chart(fig2)

# Отображение таблиц
st.dataframe(invoice_data)
st.dataframe(genre_data)
