-- NOTE: this is outdated. see overleaf/ask Robert on discord


-- NOTE: Every "create table" or "create view" is in the migration folder.

/*
Get the relative change in close price for a stock symbol.

We will use the second formula (it's more convenient because the lag syntax is long):

relative change = (today's price - yesterday's price) / yesterday's price
                = today's price / yesterday's price - 1
*/
create view stock_changes as (
    select timestamp, close, symbol,
    coalesce(close / (lag(close, 1) over (partition by symbol order by timestamp)) - 1, 0) as diff
from history
);
-- Need this update because we sorted by (symbol, created at), since otherwise
-- the most recent entry for stock AAP will be treated as the "previous day" for the oldest entry for stock AAPL, for example.
update stock_changes
set diff = 0.0
where "timestamp" < timestamp with time zone '2013-02-09'; -- oldest timestamp occurs on 2013-02-08, others are after.


/*
Compute the average relative change in the market for each day.
This is useful for computing the coefficient of variation and the beta of each stock.

       "timestamp"       |            avg             
------------------------+----------------------------
 2013-02-08 00:00:00-05 |     0.00000000000000000000
 2013-02-11 00:00:00-05 |    -0.00113625747033921996
 2013-02-12 00:00:00-05 |     0.00290388132691383575
 2013-02-13 00:00:00-05 |     0.00161624249110822593
 2013-02-14 00:00:00-05 |     0.00033726937779521996
*/
create view market_changes as
select "timestamp", avg(diff) as market_diff
from stock_changes
group by "timestamp";

/*
Compute the correlation matrix for the entire history of the stocks ('AAPL', 'A', 'AAL').
We can also add a specified time range in the where clause.

I don't think we need to provide both, but if we want the covariance matrix instead,
we can replace `corr(x.diff, y.diff)` with `covar_samp(x.diff, y.diff)`.

Example output:

 symbol | symbol |        corr         
--------+--------+---------------------
 A      | A      |                   1
 A      | AAL    |  0.2921986769074428
 A      | AAPL   | 0.27568383490126025
 AAL    | A      | 0.29219867690744283
 AAL    | AAL    |                   1
 AAL    | AAPL   |  0.2100058140928988
 AAPL   | A      |  0.2756838349012604
 AAPL   | AAL    | 0.21000581409289892
 AAPL   | AAPL   |                   1

The matrix is symmetric (other than some floating point error), so we could populate half with the condition `x.symbol <= y.symbol`.
I didn't do that because it might be inconvenient for querying.
*/
select x.symbol, y.symbol, corr(x.diff, y.diff)
from stock_changes as x join stock_changes as y
    on x."timestamp" = y."timestamp"
where x.symbol in ('AAPL', 'A', 'AAL')
  and y.symbol in ('AAPL', 'A', 'AAL')
group by x.symbol, y.symbol
order by x.symbol, y.symbol;



/*
coefficient of variation for each stock symbol
*/
create view coef_var as
select symbol, stddev_samp(diff) / avg(diff) as cvar
from stock_changes
group by symbol;

/*
beta for each stock symbol
*/
create view beta_coef as
select symbol, covar_samp(diff, market_diff) / (select var_samp(market_diff) from market_changes) as beta
from stock_changes natural join market_changes      -- this joins on "timestamp" only
group by symbol;


/*
Most recent price for the stock 'AAPL'.
*/
select close
from history
where symbol = 'AAPL'
order by timestamp desc
limit 1;

/*
Predict the price of `AAPL` for the date `date '2024-08-01'`.

Idea:
Take the most recent close price and market change, and use it to create a line (price vs time).
Then, using this line, calculate the price at time 't'.
*/
select last_price + diff * ((date '2024-08-01') - last_time) as predicted_price
from (
    select close as last_price, timestamp as last_time
    from history
    where symbol = 'AAPL'
    order by timestamp desc
    limit 1
) last_price_select,
(
    select diff
    from stock_changes
    where symbol = 'AAPL'
    order by timestamp desc
    limit 1
) diff_select;


-- Format: https://www.dpriver.com/pp/sqlformat.htm

/* Get total value (stocks + cash) from a portfolio. */

SELECT total_stock_value + cash
FROM
(SELECT SUM(amount * last_price) AS total_stock_value
FROM portfolio_holds
NATURAL JOIN -- only keep symbols which are in the portfolio
(
    -- get last price of every stock
    SELECT symbol, close AS last_price FROM history
    NATURAL JOIN -- only keep pairs (symbol, timestamp) where the timestamp is maximal.
    (
        SELECT symbol, MAX(timestamp) AS timestamp
        FROM history
        GROUP BY  symbol
    ) last_price
) a
WHERE portfolio_id = 'ef20d74f-9556-4d57-aa44-df8bd1ad7665'
) stock_value,
(
    SELECT cash FROM portfolios
    WHERE id = 'ef20d74f-9556-4d57-aa44-df8bd1ad7665'
) cash;