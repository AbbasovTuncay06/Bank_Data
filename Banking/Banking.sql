Create database Bank
use Bank

--Primary Key-lerin yaradilmasi;
 select * from bank_data

  ALTER TABLE bank_data
ADD CONSTRAINT PK_Bank PRIMARY KEY (Branch_Id);

 select * from customer_data

 ALTER TABLE customer_data
ADD CONSTRAINT PK_Customers PRIMARY KEY (Customer_ID);


 select * from transaction_data
  
   ALTER TABLE transaction_data
ADD CONSTRAINT PK_transaction PRIMARY KEY (transaction_ID);

--Foreign Key-lerin yaradilmasi
 
 ALTER TABLE customer_data
ADD CONSTRAINT FK_Customer_Branch
FOREIGN KEY (Branch_ID)
REFERENCES bank_data(Branch_ID);

alter table transaction_data
add constraint FK_Trabcation_Custoemer_ID
Foreign Key (Customer_Id) 
references Customer_data(Customer_ID)


--Bank cedvelinde Profit_Margin sutununun deyerlerinin duzedilmesi

update bank_data
set Profit_Margin=Firm_Revenue-Expenses 
where Firm_Revenue is not null

--Profi_Margine esasen Firm_revenue cedvelindeki null deyerlerin duzeldilmesi

update bank_data
set Firm_Revenue=Profit_Margin + Expenses
where Firm_Revenue is null

--Firm_Revenue ve Profit_Margin sutunlarindaki qiymetlerin yuvarlaqlasdirilmasi

update bank_data
set Firm_Revenue=floor(Firm_Revenue)

update bank_data
set Profit_Margin=floor(Profit_Margin)

--Customer  cedvelinde Yasi null olanlarin 0-la,Customer_Type sutunundaki Null deyerlerin ise Unknown olaraq deyisdirilmesi

select * from customer_data

update customer_data
set Age=0
where age is null

update customer_data
set Customer_Type='Unknown'
where Customer_Type is null

--Customer_Data cedvelindeki City sutununun  deyerlerinin Bank_Data cedvelindeki City sutununa esasen duzeldilmesi
select * from customer_data
select * from bank_data

update  c
set c.city=b.city
from customer_data c
inner join bank_data b on b.Branch_ID=c.Branch_ID

--Customer_Data cedvelindeki Region sutununun  deyerlerinin Bank_Data cedvelindeki Region sutununa esasen duzeldilmesi

update c
set c.region=b.region
from customer_data c
inner join bank_data b on b.Branch_ID=c.Branch_ID

--Transaction_Data cedvelinde Transaction_Amount sutununun deyerlerinin duzeldilmesi

select * from transaction_data

select * from customer_data

update transaction_data
set Transaction_Amount=ROUND(Transaction_Amount,0)

--Customer_ID-ye esasen Tranzaksiya cedvelinde her customerin toplam Tranzaksiyasi

select count(*) Transaksiya_Sayi ,sum(Transaction_Amount),Customer_ID from transaction_data  
group by Customer_ID
order by customer_ID asc;


--Regionlara esasen Bank cedvelinde  toplam Frim_Revenue,Expences ve Profit Marginin  tapılması

Select * from bank_data

select region,Sum(firm_revenue) as Toplam_Gelir,
sum(expenses) as Toplam_Gedər,
Sum(profit_margin) as Toplam_Qazanc
from bank_data
group by Region
order by region asc

--Şəhərlərə  esasen Bank cedvelinde  toplam Frim_Revenue,Expences ve Profit Marginin  tapılması

select City,Sum(firm_revenue) as Toplam_Gelir,
sum(expenses) as Toplam_Gedər,
Sum(profit_margin) as Toplam_Qazanc
from bank_data
group by City
order by City asc

--Bank cedvelinde Profin_Margin sutununa esasen mənfi olan deyerlerin region ve şəhərə görə qruplaşdırılması

select * from bank_data

select City,sum(Profit_Margin)
from bank_data
where Profit_Margin<0
group by City
order by City asc

select * from bank_data

select Region,sum(Profit_Margin)
from bank_data
where Profit_Margin<0
group by Region
order by Region asc

--Branch_ID ye uygun toplam Customer_ID grouplasdirmaq

select * from customer_data

select Branch_ID, count(*) Customer_ID
from customer_data
group by Branch_ID
order by Branch_ID asc

--Hər filialda (Branch_ID) neçə müştəri olduğunu tapan  və həmin filialın şəhərini göstərən kod

select * from customer_data

select c.Branch_ID, count(*) Customer_ID,b.city
from customer_data c
inner join bank_data b
on b.Branch_ID=c.Branch_ID
group by c.Branch_ID,b.City
order by c.Branch_ID asc
     --Havingden istifade olunan versiya
select 
    c.Branch_ID, 
    count(*) as Customer_Count,
    b.city
from customer_data c
inner join bank_data b
    on b.Branch_ID = c.Branch_ID
group by 
    c.Branch_ID,
    b.city
having 
    count(*) >= 5
order by 
    c.Branch_ID asc;


--Region ve Şəhərə əsasən customer_type gosteren kod

select * from customer_data

select count(customer_type) Customer_Sayı,region 
from customer_data
group by region
order by region asc

select count(customer_type) Customer_Sayı,city 
from customer_data
group by City
order by city asc

--Customer cedvelinde yaş aralıqlarına uyğun qiymətlərin göstərilməsi

select * from customer_data

select Customer_ID,Age,Customer_Type,
case 
when age !=0 and age<35 then 'kicik yas'
when age>=35 and age<55 then 'Orta yas'
when age>=55 and age <80 then 'Yuksek yas'
else 'Namelum yas'
end as Yas_tipleri
from customer_data

--Account type və İnvestment_Type  uyğun Transaction_Data cədvəlində total_Balance,Transaction_Amount və investment amountun toplam cəmi

Select * from transaction_data

select Account_Type,sum(Total_Balance) Toplam_Balans,sum(Transaction_Amount) Toplam_tranzaksiya_Miqdarı,sum(Investment_Amount) Toplam_İnvestiya
from transaction_data
group by Account_Type

select Investment_Type,sum(Total_Balance) Toplam_Balans,sum(Transaction_Amount) Toplam_tranzaksiya_Miqdarı,sum(Investment_Amount) Toplam_İnvestiya
from transaction_data
group by Investment_Type
--Region və şəhərə  uyğun Transaction_Data cədvəlində total_Balance,Transaction_Amount və investment amountun toplam cəmi
--(Joinden istifade ederek Customer_Datadan melumat getirmek)

select * from transaction_data

select c.region,sum(t.Total_Balance) Toplam_Balans,sum(t.Transaction_Amount) Toplam_tranzaksiya_Miqdarı,
sum(t.Investment_Amount) Toplam_İnvestiya from transaction_data t
inner join customer_data c
on c.Customer_ID=t.Customer_ID
group by c.Region

select c.City,sum(t.Total_Balance) Toplam_Balans,sum(t.Transaction_Amount) Toplam_tranzaksiya_Miqdarı,
sum(t.Investment_Amount) Toplam_İnvestiya from transaction_data t
inner join customer_data c
on c.Customer_ID=t.Customer_ID
group by c.City

--Bank cedvelindeki regionlara uygun evvelki yuxardaki sql sorgusunun qruplasdirilması

select * from bank_data
select * from transaction_data
select * from customer_data

select b.Region,sum(t.Total_Balance) Toplam_Balans,sum(t.Transaction_Amount) Toplam_tranzaksiya_Miqdarı,
sum(t.Investment_Amount) Toplam_İnvestiya from transaction_data t
inner join customer_data c
on c.Customer_ID=t.Customer_ID 
inner join bank_data b 
on b.Branch_ID=c.Branch_ID
group by b.Region

--eyni qayda ile SUM funksiyasının yerine avarage(),Min(),Max() ve diger uyğun funksialari yazaraq  istediyimiz neticeleri əldə edə bilerik



--Index-lerin her cedvelde ID sutununa esasen yaradilmasi

create index Bank_ID_Index
on bank_data(Branch_ID)

create index Customer_ID_Index
on Customer_Data(Branch_ID)

drop index Customer_ID_Index
on Customer_data 

--Clustrel index yaratmaq

create  index Customer_ID_Index
on Customer_data(Customer_ID)

create index Transaction_ID_Index
on transaction_Data(Transaction_ID)

--Viewlarin yaradilmasi

--Filial üzrə ümumi balans və tranzaksiya

select * from customer_data
select * from transaction_data
select * from bank_data

create view Branch_Vezyet
as
select b.Branch_ID as Branch_ID,b.region as region ,sum(t.transaction_amount) Toplam_tranzaksiya_miqdari,count(t.Transaction_amount) Tranzaksiya_sayi,
count(c.Customer_ID) as Musderi_sayi from customer_data c
inner join bank_data b
on b.branch_id=c.Branch_ID
inner join transaction_data t
on t.Customer_ID=c.Customer_ID
group by b.Branch_ID,b.Region

select * from Branch_Vezyet


--                     Triggerlər
--Customer Data cedvelinde melumat silinerken ona aid olan Melumatların Arxhive_Data cedvelone elave olunması

select * from customer_data
select * from transaction_data
select * from Archive_data

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Archive_data](
	[Transaction_ID] [int] NOT NULL,
	[Customer_ID] [int] NOT NULL,
	[Account_Type] [nvarchar](50) NOT NULL,
	[Total_Balance] [int] NOT NULL,
	[Transaction_Amount] [float] NOT NULL,
	[Investment_Amount] [int] NOT NULL,
	[Investment_Type] [nvarchar](50) NOT NULL,
	[Transaction_Date] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Transaction_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE TRIGGER ARCHIVE_TR
ON Customer_data
AFTER DELETE
AS
BEGIN
    -- Transaction-ları Archive_data-ya köçür
    INSERT INTO Archive_data
    (
        Transaction_ID,
        Customer_ID,
        Account_Type,
        Total_Balance,
        Transaction_Amount,
        Investment_Amount,
        Investment_Type,
        Transaction_Date
    )
    SELECT 
        t.Transaction_ID,
        t.Customer_ID,
        t.Account_Type,
        t.Total_Balance,
        t.Transaction_Amount,
        t.Investment_Amount,
        t.Investment_Type,
        t.Transaction_Date
    FROM transaction_data t
    INNER JOIN deleted d ON t.Customer_ID = d.Customer_ID;
END;
 
 begin transaction  

delete from customer_data  where Customer_ID=200000

rollback transaction

--                      Funksialar

--Customerin Yas kategoriyasini qaytaran funksia

CREATE FUNCTION Yas_KTQR (@age INT)
RETURNS VARCHAR(30)
AS
BEGIN
    DECLARE @category VARCHAR(30);

    IF @age < 35
        SET @category = 'Genc';
    ELSE IF @age BETWEEN 35 AND 55
        SET @category = 'Orta';
    ELSE
        SET @category = 'Yasli';

    RETURN @category;
END;

SELECT 
    Customer_ID,
    dbo.Yas_KTQR(Age) AS Age_Category
FROM Customer_data;


--Customer_Id ye esasen butun transaction_Amountu qaytaran funksiya

select * from customer_data
select * from transaction_data

CREATE FUNCTION dbo.C_T_SUM (@ID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Cem INT;

    SELECT @Cem = SUM(t.transaction_amount)
    FROM customer_data c
    INNER JOIN transaction_data t
        ON t.customer_ID = c.customer_ID
    WHERE c.customer_ID = @ID;

    RETURN @Cem;
END;
GO

SELECT dbo.C_T_SUM(200000) AS Total_Transaction;

select sum(transaction_amount) from transaction_data
where Customer_ID=200000



--Regionlar uzre investisya_amount-un toplam cemini qaytaran funksiiya

select * from customer_data
select * from bank_data
select * from transaction_data

Create function dbo.R_B_SUM(@Region varchar(20))
returns int
as begin
declare @Toplam_Cem int

select @Toplam_Cem=Sum(t.Investment_Amount) from transaction_data t
inner join customer_data c
on c.Customer_ID=t.Customer_ID
inner join bank_data b
on b.Branch_ID=c.Branch_ID
where b.Region=@Region
return @Toplam_Cem
end;

select dbo.R_B_SUM('West')

select  Sum(t.Investment_Amount) from transaction_data t
inner join customer_data c
on c.Customer_ID=t.Customer_ID
inner join bank_data b
on b.Branch_ID=c.Branch_ID
where b.Region='west'