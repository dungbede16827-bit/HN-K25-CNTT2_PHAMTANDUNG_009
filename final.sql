Create database management_system;
use management_system;

create table Employees (
employee_id int primary key,
full_name varchar(50) not null ,
email varchar(100) unique not null ,
phone_number varchar(10) not null,
hire_date date default (CURRENT_DATE) not null,
salary int check(salary > 0)
);

create table Employee_Details (
detail_id int primary key,
employee_id int not null ,
citizen_id varchar(20) not null unique ,
address varchar(100 ) not null,
working_status enum('Active' , 'Inactive') not null check(working_status = 'Active' or working_status = 'Inactive'),

foreign key (employee_id) references Employees(employee_id) 



);

create table Departments (
department_id int primary key ,
department_name varchar(100) not null,
description varchar(250) not null

);
create table Projects (
project_id int primary key ,
project_name varchar(200) not null,
department_id int not null ,
budget decimal(12,0) check (budget > 0),
project_status varchar(50) not null check (project_status = 'Pending'or project_status = 'Doing'or project_status = 'Done'),

foreign key (department_id) references Departments(department_id)


);

create table Work_Assignments  (
assignment_id varchar(5) primary key ,
employee_id int not null,
project_id int not null ,
start_date date default (current_date()) not null,
deadline date not null,
completed_date date ,


foreign key (employee_id) references Employees(employee_id),
foreign key (project_id) references Projects(project_id)
);


insert into Employees(employee_id,full_name,email,phone_number,hire_date,salary) 
value (1,'Nguyen Van A','anv@gmail.com','0901234567','2022-01-15','12000000'),
(2,'Tran Thi B','btt@gmail.com','0912345678','2021-05-20','18000000') ,
(3,
'Le Van C',
'cle@yahoo.com',
'0922334455',
'2023-02-10',
'9500000'

),
(4,
'Pham Minh D',
'dpham@hotmail.com',
'0933445566',
'2020-11-05',
'22000000'

),
(5,
'Hoang Anh E',
'ehoang@gmail.com',
'0944556677',
'2023-01-12',
'15000000'

);

insert into Employee_Details(detail_id,
employee_id,
citizen_id,
address,
working_status
)
value (1,
1,
'123456789',
'Ha Noi',
'Active'

),
(2,
2,
'234567890',
'Hai Phong',
'Active'

),
(3,
3,
'345678901',
'Da Nang',
'Inactive'

),
(4,
4,
'456789012',
'Ho Chi Minh',
'Active'

),
(5,
5,
'567890123',
'Can Tho',
'Active'
);

insert into Departments(department_id,
department_name,
description
)
value(1,
'IT',
'Phòng công nghệ thông tin'
),
(2,
'HR',
'Phòng nhân sự'

),
(3,
'Marketing',
'Phòng marketing'

),
(4,
'Finance',
'Phòng tài chính'
),
(5,
'Sales',
'Phòng kinh doanh'
);

insert into Projects(project_id,
project_name,
department_id,
budget,
project_status
)
value  (1,
'Website Company',
1,
50000000,
'Doing'

),
(2,
'Recruitment 2025',
2,
20000000,
'Pending'

),
(3,
'Ads Campaign',
3,
30000000,
'Doing'

),
(4,
'Accounting System',
4,
45000000,
'Done'

),
(5,
'Customer Expansion',
5,
25000000,
'Pending'
);

insert into Work_Assignments(assignment_id,
employee_id,
project_id,
start_date,
deadline,
completed_date
)
value('101',
1,
1,
'2024-01-10',
'2024-02-10',
NULL

),
('102',
2,
2,
'2024-02-01',
'2024-03-01',
'2024-02-25'

),
('103',
3,
3,
'2024-03-05',
'2024-04-05',
NULL

),
('104',
4,
4,
'2023-10-10',
'2023-12-10',
'2023-12-05'

),
('105',
5,
5,
'2024-04-01',
'2024-05-01',
NULL

);

-- câu 2 Viết câu lệnh tăng thêm 5.000.000 VNĐ ngân sách cho các dự án thỏa mãn đồng thời:
-- Thuộc phòng ban 'IT'.

update Projects 
set budget = budget + 5000000 
where department_id = 1;

delete 
from Work_Assignments 
where completed_date < '2024-01-01' and completed_date IS NOT NULL ;


-- PHẦN 3: TRUY VẤN CƠ BẢN 
-- câu 1 
select p.project_id, p.project_name, p.budget 
from Projects p 
join Departments d on p.department_id = d.department_id
where d.department_name = 'IT' and p.budget  > 30000000;
-- Câu 2 nhân viên có ngày vào làm trong năm 2022 và email thuộc tên miền '@gmail.com'.

select employee_id, full_name, email 
from Employees
where hire_date between '2022-01-01' and '2022-12-31' and
email like '%@gmail.com';

-- Câu 3 danh sách được sắp xếp theo lương giảm dần và chỉ hiển thị 3 nhân viên bắt đầu từ người thứ 2 (bỏ qua người lương cao nhất).

select employee_id ,full_name,salary 
from Employees 
order by salary desc 
limit 3 offset 1;

-- Phần 4 Truy Vấn Nâng cao 

-- câu 1 mã phân công, tên nhân viên, tên dự án, ngày bắt đầu, hạn hoàn thành, 
-- với dữ liệu được lấy từ các bảng liên quan 
-- và chỉ hiển thị các công việc chưa hoàn thành (completed_date IS NULL).

select assignment_id , full_name , project_name,start_date,deadline
from Work_Assignments wa 
left join Employees e on wa.employee_id = e.employee_id
left join  Projects p on wa.project_id = p.project_id
where wa.completed_date is null ;

-- câu 2  chỉ hiển thị những phòng ban có tổng ngân sách lớn hơn 40.000.000.

select d.department_name , sum(p.budget) as total_budget
from Departments d 
join Projects p on p.department_id = d.department_id
group by d.department_name
having  total_budget > 40000000; 

-- câu 3 working_status của những nhân viên có trạng thái làm việc là 'Active'
-- nhưng chưa từng tham gia dự án nào có ngân sách lớn hơn 40.000.000.

select e.employee_id,e.full_name,ed.working_status 
from Employees e
join Employee_Details ed on  e.employee_id = ed.employee_id
join Work_Assignments wa on e.employee_id = wa.employee_id
join Projects p on wa.project_id = p.project_id
where ed.working_status = 'Active' and p.budget < 4000000;

-- PHẦN 5: INDEX & VIEW
-- câu 1 Tạo một chỉ mục (index) tên idx_assignment_dates trên bảng Work_Assignments dựa trên hai cột start_date và completed_date nhằm tối ưu truy vấn.

create index idx_assignment_dates  on Work_Assignments(start_date ,completed_date );

-- câu 2 hiển thị mã phân công, tên nhân viên, tên dự án,
-- ngày bắt đầu và hạn hoàn thành, trong đó chỉ chứa các công việc 
-- chưa hoàn thành và đã quá hạn so với ngày hiện tại (CURDATE()).

create view vw_overdue_assignments as
select wa.assignment_id , e.full_name , p.project_name , wa.start_date , wa.completed_date
from Work_Assignments wa
join Employees  e on wa.employee_id = e.employee_id
join Projects  p on wa.project_id = p.project_id
where completed_date is null and completed_date > (CURDATE()) ;

-- PHẦN 6: TRIGGER 
DELIMITER //

-- Câu 1 (5đ): Viết một trigger tên trg_after_assignment_insert sao cho khi thêm mới một 
-- phân công vào bảng Work_Assignments, 
-- hệ thống tự động cập nhật trạng thái dự án tương ứng thành 'Doing'.



-- Câu 2 (5đ): Viết một trigger tên trg_prevent_delete_employee 
-- ngăn chặn việc xóa nhân viên nếu nhân viên đó vẫn còn công việc chưa hoàn thành 

DELIMITER //
create trigger trg_prevent_delete_employee
before delete on Work_Assignments
for each row
begin 
if completed_date is null then 
 SIGNAL SQLSTATE '45000'
set message_text = 'Công việc chưa hoàn thành không thể xóa ';
end if ;
end //
DELIMITER ;


-- PHẦN 7: STORED PROCEDURE 
-- câu 1 :Viết một stored procedure tên sp_check_project_budget nhận vào p_project_id và trả về p_message, trong đó:
-- Nếu ngân sách < 20.000.000 → 'Ngân sách thấp'
-- Nếu ngân sách từ 20.000.000 – 40.000.000 → 'Ngân sách trung bình'
-- Nếu ngân sách > 40.000.000 → 'Ngân sách cao' 

DELIMITER //
create Procedure sp_check_project_budget(in p_project_id int , out p_message varchar(100)  )
begin 
declare d_budget decimal(12,0);
select budget into d_budget
from Projects
where project_id = p_project_id ;

if d_budget > 40000000 then set p_message = 'Ngân sách cao' ;
elseif d_budget between 40000000 and 20000000 then set p_message = 'Ngân sách trung bình';
elseif d_budget < 20000000 then set p_message = 'Ngân sách thấp';
end if ;
 

end //

DELIMITER ;

call sp_check_project_budget(1,@checkk);

 -- Câu 2 (5đ): Viết một stored procedure tên sp_complete_assignment_transaction để xử lý hoàn thành công việc bằng Transaction, nhận vào p_assignment_id, gồm các bước:
-- Bước 1: Bắt đầu giao dịch (START TRANSACTION)
-- Bước 2: Kiểm tra công việc đã hoàn thành chưa — nếu completed_date IS NOT NULL → ROLLBACK + báo lỗi 'Công việc đã hoàn thành rồi'
-- Bước 3: Cập nhật completed_date = CURDATE()
-- Bước 4: Nếu tất cả công việc của dự án đã hoàn thành → cập nhật project_status = 'Done'
-- Bước 5: COMMIT nếu thành công, ROLLBACK nếu có lỗi

DELIMITER //
create procedure sp_complete_assignment_transaction (in p_assignment_id varchar(5) , out message varchar(150))
begin
declare d_completed_date date ;
start transaction ;
select completed_date into d_completed_date
from Work_Assignments
where assignment_id = p_assignment_id;

if d_completed_date is not null then 
set message = 'Công việc đã hoàn thành rồi';
rollback;
end if ;

  set d_completed_date =  CURDATE() ;
  
  



end //

DELIMITER ;









