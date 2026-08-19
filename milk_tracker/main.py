from fastapi import FastAPI
from pydantic import BaseModel
import sqlite3

app = FastAPI()

# =========================
# MODELS
# =========================

class Customer(BaseModel):
    name: str
    phone: str
    milk_qty: float
    rate: float


class Delivery(BaseModel):
    customer_id: int
    delivery_date: str
    delivered: int  # 1 = Taken, 0 = Skipped


class Payment(BaseModel):
    customer_id: int
    amount: float
    payment_date: str


# =========================
# DATABASE SETUP
# =========================

conn = sqlite3.connect("milk.db")
cursor = conn.cursor()

# Customers Table
cursor.execute("""
CREATE TABLE IF NOT EXISTS customers(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    phone TEXT,
    milk_qty REAL,
    rate REAL
)
""")

# Deliveries Table
cursor.execute("""
CREATE TABLE IF NOT EXISTS deliveries(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER,
    delivery_date TEXT,
    delivered INTEGER
)
""")

# Payments Table
cursor.execute("""
CREATE TABLE IF NOT EXISTS payments(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER,
    amount REAL,
    payment_date TEXT
)
""")

conn.commit()
conn.close()

# =========================
# HOME
# =========================

@app.get("/")
def home():
    return {"message": "Milk Tracker API Running Successfully"}

# =========================
# CUSTOMER APIs
# =========================

@app.post("/customer")
def create_customer(customer: Customer):

    conn = sqlite3.connect("milk.db")
    cursor = conn.cursor()

    cursor.execute(
        """
        INSERT INTO customers
        (name, phone, milk_qty, rate)
        VALUES (?, ?, ?, ?)
        """,
        (
            customer.name,
            customer.phone,
            customer.milk_qty,
            customer.rate
        )
    )

    conn.commit()
    conn.close()

    return {"status": "Customer Saved Successfully"}


@app.get("/customers")
def get_customers():

    conn = sqlite3.connect("milk.db")
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM customers")
    data = cursor.fetchall()

    conn.close()

    return {"customers": data}

# =========================
# DELIVERY APIs
# =========================

@app.post("/delivery")
def add_delivery(delivery: Delivery):

    conn = sqlite3.connect("milk.db")
    cursor = conn.cursor()

    cursor.execute(
        """
        INSERT INTO deliveries
        (customer_id, delivery_date, delivered)
        VALUES (?, ?, ?)
        """,
        (
            delivery.customer_id,
            delivery.delivery_date,
            delivery.delivered
        )
    )

    conn.commit()
    conn.close()

    return {"status": "Delivery Saved Successfully"}


@app.get("/deliveries")
def get_deliveries():

    conn = sqlite3.connect("milk.db")
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM deliveries")
    data = cursor.fetchall()

    conn.close()

    return {"deliveries": data}

# =========================
# PAYMENT APIs
# =========================

@app.post("/payment")
def add_payment(payment: Payment):

    conn = sqlite3.connect("milk.db")
    cursor = conn.cursor()

    cursor.execute(
        """
        INSERT INTO payments
        (customer_id, amount, payment_date)
        VALUES (?, ?, ?)
        """,
        (
            payment.customer_id,
            payment.amount,
            payment.payment_date
        )
    )

    conn.commit()
    conn.close()

    return {"status": "Payment Saved Successfully"}


@app.get("/payments")
def get_payments():

    conn = sqlite3.connect("milk.db")
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM payments")
    data = cursor.fetchall()

    conn.close()

    return {"payments": data}

# =========================
# BILL CALCULATION
# =========================

@app.get("/bill/{customer_id}")
def calculate_bill(customer_id: int):

    conn = sqlite3.connect("milk.db")
    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT name, milk_qty, rate
        FROM customers
        WHERE id = ?
        """,
        (customer_id,)
    )

    customer = cursor.fetchone()

    if not customer:
        conn.close()
        return {"error": "Customer not found"}

    name, milk_qty, rate = customer

    cursor.execute(
        """
        SELECT COUNT(*)
        FROM deliveries
        WHERE customer_id = ?
        AND delivered = 1
        """,
        (customer_id,)
    )

    days = cursor.fetchone()[0]

    total_bill = days * milk_qty * rate

    conn.close()

    return {
        "customer_name": name,
        "days_taken": days,
        "milk_per_day": milk_qty,
        "rate": rate,
        "total_bill": total_bill
    }

# =========================
# BALANCE CALCULATION
# =========================

@app.get("/balance/{customer_id}")
def customer_balance(customer_id: int):

    conn = sqlite3.connect("milk.db")
    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT name, milk_qty, rate
        FROM customers
        WHERE id = ?
        """,
        (customer_id,)
    )

    customer = cursor.fetchone()

    if not customer:
        conn.close()
        return {"error": "Customer not found"}

    name, milk_qty, rate = customer

    # Delivered Days
    cursor.execute(
        """
        SELECT COUNT(*)
        FROM deliveries
        WHERE customer_id = ?
        AND delivered = 1
        """,
        (customer_id,)
    )

    days = cursor.fetchone()[0]

    total_bill = days * milk_qty * rate

    # Total Paid
    cursor.execute(
        """
        SELECT COALESCE(SUM(amount),0)
        FROM payments
        WHERE customer_id = ?
        """,
        (customer_id,)
    )

    paid = cursor.fetchone()[0]

    balance = total_bill - paid

    conn.close()

    return {
        "customer_name": name,
        "total_bill": total_bill,
        "paid_amount": paid,
        "balance_amount": balance
    }