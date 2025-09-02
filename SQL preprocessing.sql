
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