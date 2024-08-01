/*
Get the relative change in close price for a stock symbol.

We will use the second formula (it's more convenient because the lag syntax is long):

relative change = (today's price - yesterday's price) / yesterday's price
                = today's price / yesterday's price - 1
*/
with upd as (
    select "timestamp", close, symbol,
    close / (lag(close, 1) over (order by symbol, "timestamp")) - 1 as diff
from history
)
insert into stock_changes
select timestamp, close, symbol, coalesce(diff, 0)
from upd;
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

insert into market_changes
select "timestamp", avg(diff) as market_diff
from stock_changes
group by "timestamp";


/*
coefficient of variation for each stock symbol
*/
insert into coef_var
select symbol, stddev_samp(diff) / avg(diff) as cvar
from stock_changes
group by symbol;

/*
beta for each stock symbol
*/
insert into beta_coef
select symbol, covar_samp(diff, market_diff) / (select var_samp(market_diff) from market_changes) as beta
from stock_changes natural join market_changes      -- this joins on "timestamp" only
group by symbol;