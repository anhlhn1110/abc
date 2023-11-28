/*
    DROP TABLE THAMGIADT;
    DROP TABLE KHOA;
    DROP TABLE BOMON;
    DROP TABLE CONGVIEC;
    DROP TABLE DETAI;
    DROP TABLE CHUDE;
    DROP TABLE GIAOVIEN;
    DROP TABLE NGUOITHAN;
    DROP TABLE GV_DT;
*/
select * from BOMON;
select * from GIAOVIEN;
/*
Sử dụng Database đầu bài để thao tác các bài tập sau:
1. Truy xuất thông tin của Table Tham gia đề tài;
--2. Lấy ra Mã gv và  khoa tương ứng
3. Lấy ra Mã GV, tên GV và họ tên người thân tương ứng
4. Lấy ra Mã GV, tên GV và tên khoa tương ứng mà giáo viên đó làm việc. (Gợi ý:
Bộ môn nằm trong khoa)
*/


select * from thamgiadt;
SELECT * FROM giaovien a;
--where magv = '001';
select * from KHOA;
--select * from thamgiadt
--where magv = '001';
--
--select thamgiadt.madt, giaovien.hoten 
--from thamgiadt, giaovien
--where thamgiadt.magv = giaovien.magv
--;
--select x.magv, x.ho_ten, b.tenkhoa --from(
----select * 
--from giaovien x, Khoa b --alias
--where x.magv = b.truongkhoa
----)

--select * from BOMON;
--select * from KHOA;
select a.makhoa, a.tenbm, b.tenkhoa
from bomon a, khoa b
where a.makhoa = b.makhoa
order by b.tenkhoa 
;
select a.makhoa, a.tenbm, b.tenkhoa
from bomon a
    left join KHOA b
     on a.makhoa = b.makhoa
;
--Lấy ra Mã GV, tên GV và họ tên người thân tương ứng
select * from giaovien;
select * from nguoithan;
select a.magv, a.hoten, b.ten
from giaovien a, nguoithan b
where a.magv = b.magv;

select  a.magv, a.hoten, b.ten
from giaovien a
 join nguoithan b
--on a.magv = b.magv;
--Xuất ra các giáo viên là nữ và có lương hơn 2000
select hoten, luong
from giaovien
where luong > '2000' and phai = 'Nữ'
;
--Xuất ra tổng lương giáo viên là nữ và có lương hơn 2000

select sum(luong) tongluong
from giaovien
where luong > '2000' and phai = 'Nữ';

--lấy ra hoten gv bắt đầu = 'T'
select hoten
from giaovien
where hoten like 'T%'
;
--lấy ra hoten gv CÓ KÝ TỰ 'N' VÀ KẾT THÚC = 'U'
select hoten
from giaovien
where upper(hoten) like 'TR__N%U' --AND upper(HOTEN) LIKE '%U'
;

--Lấy ra Giáo viên Nam lương < 2000 và Nữ Lương > 2000
select *
from giaovien
where (phai = 'Nam' and luong < '2000') OR (phai = 'Nữ' and luong > '2000');

AND
OR
--=======
TRUE AND TRUE = TRUE
falSE AND FALSE = FALSE
TRUE AND FLASE = FALSE
FALSE AND TRUE = FALSE

1 AND 1 = 1
1 AND 0 = 0
0 AND 1 = 0
0 AND 0 = 0

1 or 1 = 1
1 OR 0 = 1
0 OR 1 = 1
0 OR 0 = 0

1+1 - (1-1) = 2
-- Lấy ra danh sách các mã giáo viên QLCM
-- Kiểm tra mã GV tồn tại trong danh sách đó

SELECT hoten,
CASE WHEN luong > '2000' then luong
--    ELSE null
    END phanloai
FROM giaoVIEN;
-- 2. Xuất ra thông tin của khoa mà có nhiều hơn 2 giáo viên
-- Lấy được danh sách bộ môn nằm trong khoa hiện tại

select * from giaovien;
select * from khoa;
select * from bomon;

with ab as (
select * 
from khoa a
join bomon b
on a.makhoa=b.makhoa
)
, abc as (select *
from ab
join giaovien c
on ab.mabm = c.mabm
)
select tenkhoa
, count (hoten) soluong
from abc
--where tenkhoa like '%H%'
group by tenkhoa
having  count (hoten) > 2;

select k.tenkhoa, count(g.hoten)
from khoa k
join bomon b
on k.makhoa = b.makhoa
join giaovien g
on g.mabm = b.mabm
group by k.tenkhoa
having count(g.hoten)>2