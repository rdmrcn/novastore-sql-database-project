-- =========================================
-- RehaDemircan_NovaStore_Proje.sql
-- NovaStore E-Ticaret Veri Yönetim Sistemi
-- =========================================

-- Veri Tabaný Oluþturma
CREATE DATABASE NovaStoreDB;
GO

USE NovaStoreDB;
GO

-- =========================================
-- TABLOLAR
-- =========================================

CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(50),
    City VARCHAR(20),
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2),
    Stock INT DEFAULT 0,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- =========================================
-- VERÝ EKLEME (INSERT)
-- =========================================

INSERT INTO Categories (CategoryName) VALUES
('Elektronik'),
('Giyim'),
('Kitap'),
('Kozmetik'),
('Ev ve Yaþam');

INSERT INTO Products (ProductName, Price, Stock, CategoryID) VALUES
('Laptop', 25000.00, 15, 1),
('Telefon', 18000.00, 25, 1),
('Kulaklýk', 1500.00, 10, 1),
('Tiþört', 350.00, 40, 2),
('Mont', 2200.00, 8, 2),
('Roman Kitabý', 180.00, 30, 3),
('SQL Eðitim Kitabý', 450.00, 12, 3),
('Parfüm', 1200.00, 18, 4),
('Þampuan', 160.00, 50, 4),
('Masa Lambasý', 750.00, 14, 5),
('Kahve Makinesi', 3200.00, 6, 5),
('Nevresim Takýmý', 900.00, 20, 5);

INSERT INTO Customers (FullName, City, Email) VALUES
('Ahmet Yýlmaz', 'Ýstanbul', 'ahmet@example.com'),
('Ayþe Demir', 'Ankara', 'ayse@example.com'),
('Mehmet Kaya', 'Ýzmir', 'mehmet@example.com'),
('Zeynep Çelik', 'Bursa', 'zeynep@example.com'),
('Emre Þahin', 'Antalya', 'emre@example.com'),
('Elif Arslan', 'Ýstanbul', 'elif@example.com');

INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2026-06-01', 26500.00),
(2, '2026-06-02', 2550.00),
(3, '2026-06-03', 630.00),
(4, '2026-06-04', 1360.00),
(5, '2026-06-05', 3950.00),
(6, '2026-06-06', 18000.00),
(1, '2026-06-07', 1200.00),
(2, '2026-06-08', 900.00),
(3, '2026-06-09', 750.00),
(4, '2026-06-10', 3200.00);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1,1,1),
(1,3,1),
(2,5,1),
(2,4,1),
(3,6,1),
(3,7,1),
(4,8,1),
(4,9,1),
(5,10,1),
(5,11,1),
(6,2,1),
(7,8,1),
(8,12,1),
(9,10,1),
(10,11,1);

-- =========================================
-- SORGULAR
-- =========================================

-- 1. Stok miktarý 20'den az ürünler
SELECT ProductName, Stock
FROM Products
WHERE Stock < 20
ORDER BY Stock DESC;

-- 2. Hangi müþteri hangi tarihte sipariþ vermiþ?
SELECT
    Customers.FullName,
    Customers.City,
    Orders.OrderDate,
    Orders.TotalAmount
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;

-- 3. Ahmet Yýlmaz'ýn aldýðý ürünler
SELECT
    Customers.FullName,
    Products.ProductName,
    Products.Price,
    Categories.CategoryName
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE Customers.FullName = 'Ahmet Yýlmaz';

-- 4. Kategorilere göre ürün sayýsý
SELECT
    Categories.CategoryName,
    COUNT(Products.ProductID) AS UrunSayisi
FROM Categories
LEFT JOIN Products
ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName;

-- 5. Müþterilerin toplam cirosu
SELECT
    Customers.FullName,
    SUM(Orders.TotalAmount) AS ToplamCiro
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.FullName
ORDER BY ToplamCiro DESC;

-- 6. Sipariþlerin üzerinden kaç gün geçti?
SELECT
    OrderID,
    OrderDate,
    DATEDIFF(DAY, OrderDate, GETDATE()) AS GecenGun
FROM Orders;

-- =========================================
-- VIEW
-- =========================================

CREATE VIEW vw_SiparisOzet AS
SELECT
    Customers.FullName AS MusteriAdi,
    Orders.OrderDate AS SiparisTarihi,
    Products.ProductName AS UrunAdi,
    OrderDetails.Quantity AS Adet
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID;

-- =========================================
-- BACKUP
-- =========================================

BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Users\pc\Desktop\Yedek\NovaStoreDB.bak'
WITH INIT;
GO