import sqlite3

def create_connection():
    """Создаёт подключение к базе данных Chinook"""
    return sqlite3.connect("Chinook_Sales.db")
