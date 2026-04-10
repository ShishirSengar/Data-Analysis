### Advanced SQL Operations

/*Task 12: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's name, book title, issue date, and days overdue.
*/
-- issued_status + members + books + return_status
select ist.issued_member_id, 
m.member_name, 
b.book_title, 
ist.issued_date, 
-- rs.return_date,
current_date() - ist.issued_date as days_overdue
from issued_status ist
join members m
on m.member_id =  ist.issued_member_id  
join books b
on  b.isbn = ist.issued_book_isbn
left join return_status rs
on  rs.issued_id = ist.issued_id
where rs.return_date is null
and (current_date() - ist.issued_date) > 30
order by ist.issued_member_id;



/*
Task 13: Update Book Status on Return
Write a query to update the status of books in the books table to "available" when they are returned (based on entries in the return_status table).
*/
DELIMITER $$

create procedure update_book_status_on_return(
	in p_return_id varchar(10),
    in p_issued_id varchar(10),
    in p_book_quality varchar(10)
)
begin
	
    declare v_isbn varchar(50);
    declare v_book_name varchar(80);
    
	-- Insert return record
    insert into return_status(return_id, issued_id, return_date, book_quality)
    values
    (p_return_id,p_issued_id,curdate(),p_book_quality);
    
    -- Get book details from issued_status
    select issued_book_isbn, issued_book_name
    into v_isbn, v_book_name
    from issued_status
    where issued_id = p_issued_id;
    
    -- Update book status to available
     update books
	 set status = 'Yes'
	 where isbn = v_isbn;
    
     -- Message to user
    select concat('Thank you for returning the book: ', v_book_name) AS message;
end $$
delimiter ;

CALL update_book_status_on_return('RS138', 'IS135', 'Good');

select * from books where isbn = '978-0-307-58837-1';


/*
Task 14: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, 
the number of books returned, and the total revenue generated from book rentals.
*/
create table branch_performance_report as 
select b.branch_id, b.manager_id, sum(bk.rental_price) as total_revenue, 
count(ist.issued_id) as num_of_book_issued, count(rs.return_id) as nu_of_books_returned
from issued_status ist
join employees e  
on ist.issued_emp_id = e.emp_id
join branch b
on e.branch_id = b.branch_id
left join return_status rs
on ist.issued_id = rs.issued_id
join books bk
on ist.issued_book_isbn = bk.isbn
group by b.branch_id, b.manager_id;



/*
Task 15: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members 
who have issued at least one book in the last 2 months.
*/
create table active_members 
as 
select * from members 
where member_id in(
					select distinct issued_member_id from issued_status
					where issued_date >= current_date() - interval 2 month
				   );


/*
Task 16: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
*/




/*
Task 17: Identify Members Issuing High-Risk Books
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.    
*/

/*
Task 18: Stored Procedure
Objective: Create a stored procedure to manage the status of books in a library system.
    Description: Write a stored procedure that updates the status of a book based on its issuance or return. Specifically:
    If a book is issued, the status should change to 'no'.
    If a book is returned, the status should change to 'yes'.
*/



/*
Task 19: Create Table As Select (CTAS)
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines
*/