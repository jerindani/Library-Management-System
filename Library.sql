CREATE DATABASE library;
USE library;
CREATE TABLE Branch (
    Branch_no INT PRIMARY KEY,
    Manager_Id INT,
    Branch_address VARCHAR(255),
    Contact_no VARCHAR(15)
);

INSERT INTO Branch (Branch_no, Manager_Id, Branch_address, Contact_no) VALUES
(101, 1, '123 Library St, City A', '1234567890'),
(102, 2, '456 Knowledge Rd, City B', '2345678901'),
(103, 3, '789 Learning Ave, City C', '3456789012'),
(104, 4, '101 Reading Blvd, City D', '4567890123'),
(105, 5, '202 Book Ln, City E', '5678901234');

SELECT * FROM Branch;

CREATE TABLE Employee (
    Emp_Id INT PRIMARY KEY,
    Emp_name VARCHAR(100),
    Position VARCHAR(50),
    Salary DECIMAL(10, 2),
    Branch_no INT,
    FOREIGN KEY (Branch_no) REFERENCES Branch(Branch_no)
);

INSERT INTO Employee (Emp_Id, Emp_name, Position, Salary, Branch_no) VALUES
(1, 'John Doe', 'Manager', 60000, 101),
(2, 'Jane Smith', 'Assistant Manager', 55000, 102),
(3, 'Alice Johnson', 'Clerk', 40000, 103),
(4, 'Bob Brown', 'Librarian', 45000, 104),
(5, 'Charlie Davis', 'Technician', 42000, 105);

SELECT * FROM Employee;

CREATE TABLE Books (
    ISBN VARCHAR(20) PRIMARY KEY,
    Book_title VARCHAR(255),
    Category VARCHAR(100),
    Rental_Price DECIMAL(10, 2),
    Status VARCHAR(3),
    Author VARCHAR(100),
    Publisher VARCHAR(100)
);

INSERT INTO Books (ISBN, Book_title, Category, Rental_Price, Status, Author, Publisher) VALUES
('ISBN001', 'Data Science 101', 'Technology', 30.00, 'Yes', 'Dr. A. Author', 'TechBooks Publishing'),
('ISBN002', 'Advanced Mathematics', 'Mathematics', 25.00, 'No', 'Prof. B. Maths', 'EduBooks Press'),
('ISBN003', 'World History', 'History', 28.00, 'Yes', 'C. Historian', 'HistoryPress'),
('ISBN004', 'Modern Physics', 'Science', 35.00, 'Yes', 'Dr. D. Scientist', 'ScienceBooks Ltd.'),
('ISBN005', 'Creative Writing', 'Literature', 22.00, 'No', 'E. Writer', 'LitBooks Inc.');

SELECT * FROM Books;

CREATE TABLE Customer (
    Customer_Id INT PRIMARY KEY,
    Customer_name VARCHAR(100),
    Customer_address VARCHAR(255),
    Reg_date DATE
);

INSERT INTO Customer (Customer_Id, Customer_name, Customer_address, Reg_date) VALUES
(1001, 'David White', '15 Maple St, City A', '2021-12-20'),
(1002, 'Emily Green', '27 Oak Ave, City B', '2022-02-15'),
(1003, 'Frank Black', '89 Pine Rd, City C', '2023-01-10'),
(1004, 'Grace Blue', '34 Elm St, City D', '2023-06-12'),
(1005, 'Helen Yellow', '56 Birch Ln, City E', '2021-11-05');

SELECT * FROM Customer;

CREATE TABLE IssueStatus (
    Issue_Id INT PRIMARY KEY,
    Issued_cust INT,
    Issued_book_name VARCHAR(255),
    Issue_date DATE,
    Isbn_book VARCHAR(20),
    FOREIGN KEY (Issued_cust) REFERENCES Customer(Customer_Id),
    FOREIGN KEY (Isbn_book) REFERENCES Books(ISBN)
);

INSERT INTO IssueStatus (Issue_Id, Issued_cust, Issued_book_name, Issue_date, Isbn_book) VALUES
(2001, 1001, 'Data Science 101', '2023-07-01', 'ISBN001'),
(2002, 1002, 'World History', '2023-06-15', 'ISBN003'),
(2003, 1003, 'Modern Physics', '2023-07-20', 'ISBN004'),
(2004, 1004, 'Advanced Mathematics', '2023-06-05', 'ISBN002'),
(2005, 1005, 'Creative Writing', '2023-07-10', 'ISBN005');

SELECT * FROM IssueStatus;

CREATE TABLE ReturnStatus (
    Return_Id INT PRIMARY KEY,
    Return_cust INT,
    Return_book_name VARCHAR(255),
    Return_date DATE,
    Isbn_book2 VARCHAR(20),
    FOREIGN KEY (Return_cust) REFERENCES Customer(Customer_Id),
    FOREIGN KEY (Isbn_book2) REFERENCES Books(ISBN)
);

INSERT INTO ReturnStatus (Return_Id, Return_cust, Return_book_name, Return_date, Isbn_book2) VALUES
(3001, 1001, 'Data Science 101', '2023-07-15', 'ISBN001'),
(3002, 1002, 'World History', '2023-06-30', 'ISBN003'),
(3003, 1003, 'Modern Physics', '2023-07-25', 'ISBN004'),
(3004, 1004, 'Advanced Mathematics', '2023-06-20', 'ISBN002'),
(3005, 1005, 'Creative Writing', '2023-07-20', 'ISBN005');

SELECT * FROM ReturnStatus;

#1. Retrieve the book title, category, and rental price of all available books. 
SELECT Book_title, Category, Rental_Price 
FROM Books 
WHERE Status = 'Yes';

#2. List the employee names and their respective salaries in descending order of salary. 
SELECT Emp_name, Salary 
FROM Employee 
ORDER BY Salary DESC;

#3. Retrieve the book titles and the corresponding customers who have issued those books. 
SELECT Books.Book_title, Customer.Customer_name 
FROM IssueStatus 
JOIN Books ON IssueStatus.Isbn_book = Books.ISBN 
JOIN Customer ON IssueStatus.Issued_cust = Customer.Customer_Id;

#4. Display the total count of books in each category.
SELECT Category, COUNT(*) AS Total_Books 
FROM Books 
GROUP BY Category;

#5. Retrieve the employee names and their positions for the employees whose salaries are above Rs.50,000. 
SELECT Emp_name, Position 
FROM Employee 
WHERE Salary > 50000;

#6. List the customer names who registered before 2022-01-01 and have not issued any books yet.
SELECT Customer.Customer_name 
FROM Customer 
LEFT JOIN IssueStatus ON Customer.Customer_Id = IssueStatus.Issued_cust 
WHERE Customer.Reg_date < '2022-01-01' AND IssueStatus.Issue_Id IS NULL;

#7. Display the branch numbers and the total count of employees in each branch. 
SELECT Branch_no, COUNT(*) AS Total_Employees 
FROM Employee 
GROUP BY Branch_no;

#8. Display the names of customers who have issued books in the month of June 2023.
SELECT Customer.Customer_name 
FROM IssueStatus 
JOIN Customer ON IssueStatus.Issued_cust = Customer.Customer_Id 
WHERE Issue_date BETWEEN '2023-06-01' AND '2023-06-30';

#9. Retrieve book_title from book table containing history. 
SELECT Book_title 
FROM Books 
WHERE Book_title LIKE '%history%';

#10. Retrieve the branch numbers along with the count of employees for branches having more than 5 employees.
SELECT Branch_no, COUNT(*) AS Total_Employees 
FROM Employee 
GROUP BY Branch_no 
HAVING COUNT(*) > 5;

#11. Retrieve the names of employees who manage branches and their respective branch addresses.
SELECT Employee.Emp_name, Branch.Branch_address 
FROM Employee 
JOIN Branch ON Employee.Emp_Id = Branch.Manager_Id;

#12. Display the names of customers who have issued books with a rental price higher than Rs. 25.
SELECT DISTINCT Customer.Customer_name 
FROM IssueStatus 
JOIN Books ON IssueStatus.Isbn_book = Books.ISBN 
JOIN Customer ON IssueStatus.Issued_cust = Customer.Customer_Id 
WHERE Books.Rental_Price > 25;




















