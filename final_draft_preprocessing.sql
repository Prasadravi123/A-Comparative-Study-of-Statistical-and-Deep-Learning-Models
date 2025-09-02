
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES ;



select * from tesla_stock_2020_2025;


SELECT 
    Ticker  AS [date],
    TSLA  AS [close]
INTO df
FROM tesla_stock_2020_2025;

select * from df;

ALTER TABLE df
ALTER COLUMN [date] DATE;

ALTER TABLE df
ALTER COLUMN [close] FLOAT;

SELECT 
    CAST(DATEFROMPARTS(YEAR([date]), MONTH([date]), 1) AS DATE) AS month,
    AVG([close]) AS monthly_close
INTO df_monthly
FROM df
WHERE [close] IS NOT NULL
GROUP BY YEAR([date]), MONTH([date])
ORDER BY month;

select * from df_monthly;

SELECT * 
FROM df_monthly
ORDER BY month ASC;


SELECT * from mercedes_stock_2020_2025;

select 
ticker AS [date],
MBG_DE as [m_close]
into mb_close
from mercedes_stock_2020_2025;

select * from mb_close;

SELECT 
    CAST(DATEFROMPARTS(YEAR([date]), MONTH([date]), 1) AS DATE) AS month,
    AVG([m_close]) AS monthly_close
INTO df_monthly_mercedes
FROM mb_close
WHERE [m_close] IS NOT NULL
GROUP BY YEAR([date]), MONTH([date])
ORDER BY month;

select* from df_monthly_mercedes;

select table_name
from information_schema.TABLES;


select * from sentinment_mercedes_1_final;

select * from sentinment_mercedes_1_final
where afinn is null;

delete from sentinment_mercedes_1_final
where textblob is null;

select date ,finbert_sentiment ,textblob ,vader,afinn,bing into cleaned_sentinment from
sentinment_mercedes_1_final;

select * from cleaned_sentinment;

SELECT *
FROM cleaned_sentinment
WHERE finbert_sentiment IS NULL;

delete from cleaned_sentinment
where vader is null;

ALTER TABLE  cleaned_sentinment
ALTER COLUMN bing FLOAT;

ALTER TABLE  cleaned_sentinment
ALTER COLUMN textblob FLOAT;

ALTER TABLE  cleaned_sentinment
ALTER COLUMN finbert_sentiment FLOAT;

ALTER TABLE  cleaned_sentinment
ALTER COLUMN vader FLOAT;

ALTER TABLE  cleaned_sentinment
ALTER COLUMN afinn FLOAT;

SELECT
    [date],
    AVG(finbert_sentiment) AS finbert,
    AVG(textblob) AS textblob,
    AVG(vader) AS vader,
    AVG(afinn) AS afinn,
    AVG(bing) AS bing
	into mercedes_sentinment
FROM cleaned_sentinment
GROUP BY [date]
ORDER BY [date];

select * from mercedes_sentinment;

select * from mb_close;

select coalesce(mb_close.date ,mercedes_sentinment.date)as date,
mb_close.m_close,
bing,
finbert,
afinn,
textblob,
vader into mercedes_full 
from mb_close
full outer join mercedes_lable
on mb_close.date=mercedes_sentinment.date
order by [date];


select * from mercedes_full
order by [date];



tesla


select table_name
from information_schema.tables;

select * from sentinment_3;



select date,finbert_sentiment,textblob,vader,afinn,bing into cleaned_tesla
from sentinment_3;

select * from cleaned_tesla
where bing is null;

delete from cleaned_tesla
where date is null;

ALTER TABLE cleaned_tesla
ALTER COLUMN bing FLOAT;

ALTER TABLE cleaned_tesla
ALTER COLUMN textblob FLOAT;

ALTER TABLE cleaned_tesla
ALTER COLUMN finbert_sentiment FLOAT;

ALTER TABLE cleaned_tesla
ALTER COLUMN vader FLOAT;

ALTER TABLE cleaned_tesla
ALTER COLUMN afinn FLOAT;


select date,
avg(bing) as bing,
avg(textblob) as textblob,
avg(finbert_sentiment) as finbert,
avg(vader) as vader,
avg(afinn) as afinn
into tesla_sentinment from cleaned_tesla
group by [date]
order by [date];

select * from tesla_sentinment;
select * from mercedes_sentinment;

select table_name
from INFORMATION_SCHEMA.tables;

select * from df;

SELECT * 
FROM df
FULL OUTER JOIN tesla_sentinment
ON df.date = tesla_sentinment.date;

SELECT
    COALESCE(df.date, tesla_sentinment.date) AS date,
    df.[close],
    bing,
    textblob,
    finbert,
    vader,
    afinn
	into tesla_full
FROM df
FULL OUTER JOIN tesla_sentinment
ON df.date = tesla_sentinment.date
ORDER BY [date];

select table_name from 
INFORMATION_SCHEMA.tables;

select * from tesla_full;





select * from tesla_full
order by [date];


select * from tesla_full
where textblob is null
order by [date];


select * from tesla_full
where [close] is not null
order by [date];

select table_name
from information_schema.tables;

select * from sentinment_tesla_transfered;

delete from sentinment_tesla_transfered
where [close] is null;

select * from sentinment_tesla_transfered
where [close]is null;

update sentinment_tesla_transfered
set finbert_edited = 0
where finbert_edited is null;

update sentinment_tesla_transfered
set bing_edited = 0
where bing_edited is null;


update sentinment_tesla_transfered
set afinn_edited = 0
where afinn_edited is null;

update sentinment_tesla_transfered
set textblob_edited = 0
where textblob_edited is null;

update sentinment_tesla_transfered
set vader_edited = 0
where vader_edited is null;

select * from sentinment_tesla_transfered;

select
[date] as [date],
[close] as price,
finbert_edited as finbert,
afinn_edited as afinn,
bing_edited as bing,
textblob_edited as textblob,
vader_edited as vader
into final_sentinment_tesla
from sentinment_tesla_transfered;


select * from final_sentinment_tesla;

select * from sentinment_mercedes_transfered_dates;

delete from sentinment_mercedes_transfered_dates
where m_close is null;

update sentinment_mercedes_transfered_dates
set finbert_edited = 0
where finbert_edited is null;

update sentinment_mercedes_transfered_dates
set bing_edited = 0
where bing_edited is null;

update sentinment_mercedes_transfered_dates
set textblob_edited = 0
where textblob_edited is null;

update sentinment_mercedes_transfered_dates
set afinn_edited = 0
where afinn_edited is null;

update sentinment_mercedes_transfered_dates
set vader_edited = 0
where vader_edited is null;

select [date] as [date], 
m_close as price,
vader_edited as vader,
afinn_edited as afinn,
textblob_edited as textblob,
finbert_edited as finbert,
bing_edited as bing
into final_mercedes_sentinment
from sentinment_mercedes_transfered_dates;

select * from final_mercedes_sentinment;

select table_name
from information_schema.tables;

select * from sentinment_mercedes_after_steming_final;


select * from mercedes_lable;

SELECT 
    date,
    AVG(bing) AS bing,
    AVG(textblob) AS textblob,
    AVG(finbert_sentiment) AS finbert,
    AVG(vader) AS vader,
    AVG(afinn) AS afinn,
    STRING_AGG(text, ' ') AS text,
    STRING_AGG(title, ' ') AS title,
    STRING_AGG(cleaned_trunc, ' ') AS cleaned_trunc
INTO mercedes_lable
FROM sentinment_mercedes_after_steming_final
GROUP BY date
ORDER BY date;

select * from sentinment_tesla_final_steming;

alter table sentinment_tesla_final_steming
alter column textblob float;


SELECT 
    date,
    AVG(bing) AS bing,
    AVG(textblob) AS textblob,
    AVG(finbert_sentiment) AS finbert,
    AVG(vader) AS vader,
    AVG(afinn) AS afinn,
    STRING_AGG(text, ' ') AS text,
    STRING_AGG(title, ' ') AS title,
    STRING_AGG(cleaned_trunc, ' ') AS cleaned_trunc
INTO tesla_lable
FROM sentinment_tesla_final_steming
GROUP BY date
ORDER BY date;

select * from tesla_lable;

select * from tesla_lable;

select * from mercedes_lable;

SELECT
    COALESCE(df.date, tesla_lable.date) AS date,
    df.[close],
    finbert,
    into tesla_final
FROM df
FULL OUTER JOIN tesla_lable
ON df.date = tesla_lable.date
ORDER BY [date];

SELECT
    COALESCE(df.date, tesla_lable.date) AS date,
    df.[close],
    finbert,
	textblob,
	vader,
	bing,
	afinn
    into tesla_final1
FROM df
FULL OUTER JOIN tesla_lable
ON df.date = tesla_lable.date
ORDER BY [date];

select * from tesla_final;
select * from tesla_final1;


select coalesce(mb_close.date ,mercedes_lable.date)as date,
mb_close.m_close,
finbert, afinn, bing,vader, textblob
 into mercedes_final1 
from mb_close
full outer join mercedes_lable
on mb_close.date=mercedes_lable.date
order by [date];

select * from mercedes_final;

select * from tesla_final;

select * from tesla_final1;
select * from mercedes_final1;


select * from mercedes_python_preprocessing;

update mercedes_python_preprocessing
set finbert_edited = 0
where finbert_edited is null;

delete from mercedes_python_preprocessing
where m_close is null;

select * from tesla_python;

update  tesla_python
set finbert_edited = 0
where finbert_edited is null;

delete from tesla_python 
where [close] is null;


select * from microsoft_reddit_sentiment;

SELECT
    [date],
    AVG(finbert_sentiment) AS finbert,
    AVG(textblob_polarity) AS textblob,
    AVG(vader_compound) AS vader,
    AVG(afinn_score) AS afinn,
    AVG(bing_score) AS bing
	into microsoft_sentinment
FROM microsoft_reddit_sentiment
GROUP BY [date]
ORDER BY [date];

select * from microsoft_stock;

select coalesce(microsoft_stock.date ,microsoft_sentinment.date)as date,
microsoft_stock.[close],
bing,
finbert,
afinn,
textblob,
vader into microsoft_combine 
from microsoft_stock
full outer join microsoft_sentinment
on microsoft_stock.date=microsoft_sentinment.date
order by [date];

select * from microsoft_combine;

select * from apple_reddit_df;

SELECT
    [date],
    AVG(finbert_sentiment) AS finbert,
    AVG(textblob_polarity) AS textblob,
    AVG(vader_compound) AS vader,
    AVG(afinn_score) AS afinn,
    AVG(bing_score) AS bing
	into apple_sentinment
FROM apple_reddit_df
GROUP BY [date]
ORDER BY [date];




select coalesce(apple_stock.date ,apple_sentinment.date)as date,
apple_stock.[close],
bing,
finbert,
afinn,
textblob,
vader into apple_combine 
from apple_stock
full outer join apple_sentinment
on apple_stock.date=apple_sentinment.date
order by [date];

select * from apple_combine;

select * from sample;

SELECT 
    date,
	AVG(finbert_sentiment) AS finbert,
    AVG(textblob_polarity) AS textblob,
    AVG(vader_compound) AS vader,
    AVG(afinn_score) AS afinn,
    AVG(bing_score) AS bing,
    STRING_AGG(text, ' ') AS text,
    STRING_AGG(title, ' ') AS title
INTO apple_lab
FROM sample
GROUP BY date
ORDER BY date;

select* from apple_lab;

select * from sample_micro;

SELECT 
    date,
	AVG(finbert_sentiment) AS finbert,
    AVG(textblob_polarity) AS textblob,
    AVG(vader_compound) AS vader,
    AVG(afinn_score) AS afinn,
    AVG(bing_score) AS bing,
    STRING_AGG(text, ' ') AS text,
    STRING_AGG(title, ' ') AS title
INTO micro_lable
FROM sample_micro
GROUP BY date
ORDER BY date;