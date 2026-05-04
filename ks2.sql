create database ks2;

use ks2;

-- bảng Books
create table Books  (
book_id varchar(5) primary key not null,
title varchar(150) not null unique,
author varchar(100) not null,
category varchar(50) not null,
price decimal (10,2) not null,
status varchar(20) not null
);



-- bảng Members  
 create table Members (
member_id varchar(5) primary key not null,
full_name varchar(150) not null,
email varchar(100) not null unique,
phone  varchar(50) not null,
membership_type varchar(20) not null
);



-- bảng Loans
create table Loans(
loan_id int primary key not null auto_increment,
book_id varchar(5)  not null,
member_id varchar(5)  not null,
loan_date date  not null,
return_date date ,
foreign key (book_id) references Books (book_id),
foreign key (member_id) references Members (member_id)
);



-- bảng Fines
create table Fines (
fine_id int primary key not null auto_increment,
loan_id int not null ,
fine_amount decimal(10,2) not null,
fine_reason varchar(255) not null,
foreign key (loan_id) references Loans (loan_id)
);




-- Yêu cầu bổ sung: 


-- Thêm ràng buộc cho cột price: giá sách phải lớn hơn 0.
alter table Books 
add constraint price check (price > 0);


-- Thiết lập giá trị mặc định cho cột status trong bảng Books là 'Available'.
alter table Books 
alter column status set default 'Available'; 


-- Thêm cột published_year (INT) vào bảng Books.
alter table Books 
add published_year int;


-- PHẦN 2: Chèn dữ liệu và Thao tác (10 điểm)


insert into Books 
values ('B01', 'Đất rừng phương Nam', 'Đoàn Giỏi', 'Tiểu thuyết', 120000.00, 'Available', 2020),
('B02', 'Lập trình Python', 'Nguyễn Anh', 'Công nghệ', 250000.00, 'Borrowed', 2022),
('B03', 'Kỹ thuật lập trình C', 'Lê Nam', 'Công nghệ', 180000.00, 'Available', 2021),
('B04', 'Số đỏ', 'Vũ Trọng Phụng', 'Tiểu thuyết', 85000.00, 'Borrowed', 2019),
('B05', 'Tư duy logic', 'Phạm Minh', 'Kỹ năng', 150000.00, 'Available', 2023);


insert into Members
values ('M01', 'Trần Văn An', 'an.tv@gmail.com', '0912345678', 'Student'),
('M02', 'Nguyễn Thị Bình', 'binh.nt@gmail.com', '0987654321', 'Teacher'),
('M03', 'Nguyễn Minh Hiếu', 'hieu.nm@gmail.com', '0911223344', 'Student'),
('M04', 'Phạm Bảo Ngọc', 'ngoc.pb@gmail.com', '0922334455', 'Guest'),
('M05', 'Lê Hồng Anh', 'anh.lh@gmail.com', '0933445566', 'Student');


insert into Loans 
values (1, 'B02', 'M01', '2025-11-10', '2025-11-20'),
(2, 'B04', 'M03', '2025-11-12', NULL),
(3, 'B01', 'M02', '2025-11-15', '2025-11-25'),
(4, 'B02', 'M05', '2025-12-01', NULL),
(5, 'B03', 'M01', '2025-12-05', '2025-12-15'),
(6, 'B05', 'M03', '2025-12-10', NULL);


insert into Fines 
value (1, 1, 15000.00, 'Quá hạn 5 ngày'),
(2, 3, 5000.00, 'Làm rách trang sách'),
(3, 5, 20000.00, 'Quá hạn 7 ngày');


-- Yêu cầu cập nhật/xóa: 

set sql_safe_updates = 0;



-- Cập nhật membership_type của độc giả 'M01' thành 'Teacher'.
update Members
set membership_type  = 'teacher'
where member_id = 'M01';



-- Tăng giá sách (price) thêm 5% cho các sách thuộc thể loại 'Công nghệ'.
update Books 
set price = price * 1.05
where category like 'Công nghệ';


-- Xóa các khoản phạt (Fines) có số tiền (fine_amount) nhỏ hơn 10,000.
delete from Fines 
where fine_amount = fine_amount < 10000;



-- Cập nhật status của tất cả các cuốn sách có năm xuất bản (published_year) trước năm 2020 thành 'Lost'. 
update Books 
set status = 'Lost'
where published_year < 2020;


-- Cập nhật return_date thành ngày hiện tại cho tất cả các đơn mượn (Loans)  
-- của độc giả có mã 'M01' mà chưa trả sách (đang có return_date là NULL)
update Loans 
set return_date = current_date()
where member_id = 'M01';



-- PHẦN 3: Truy vấn dữ liệu (55 điểm)
-- Cơ bản (25 điểm):


-- Liệt kê tất cả sách có giá từ 100,000 đến 500,000.
select *
from Books 
where price between 100000 and 500000;



-- Lấy thông tin full_name, email của độc giả có họ 'Nguyễn'.
select  full_name, email
from Members 
where full_name like 'Nguyễn%';


-- Hiển thị danh sách sách gồm title, author, sắp xếp theo price giảm dần.
select  title, author
from Books 
order by price desc;




-- Lấy ra 3 cuốn sách mới nhất (dựa trên published_year).
select * 
from Books 
order by published_year desc
limit 3;



-- Hiển thị thông tin mượn sách (Loans) diễn ra trong tháng 11/2025.
select *
from Loans 
where loan_date like '2025-11%';



-- Hiển thị danh sách các cuốn sách có tên (title) bắt đầu bằng chữ 'L' hoặc kết thúc bằng chữ 'n' 
select * 
from Books 
where title like 'L%n';



-- Lấy thông tin các đơn mượn sách có ngày mượn (loan_date) nằm trong khoảng từ '2025-11-01' đến '2025-12-15' .
select *
from Loans 
where loan_date between '2025-11-01' and '2025-12-15';


-- Hiển thị danh sách độc giả gồm member_id, full_name, phone và sắp xếp theo tên độc giả (full_name) theo bảng chữ cái (A-Z) 
select  member_id, full_name, phone 
from Members
order by full_name;


-- Nâng cao (30 điểm):

select  l.loan_id,m.full_name,b.title,l.loan_date
from Loans.l 
inner join Members.m on  l.member_id = m.member_id
inner join Books.b on l.book_id = b.book_id
where m.membership_type = 'Student';




















 

