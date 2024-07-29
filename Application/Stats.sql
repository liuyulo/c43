--# TODO: delete the table declarations. they should be in Schema.sql.

CREATE TABLE stocks (
    symbol TEXT PRIMARY KEY NOT NULL
);
create table history (
    symbol TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    open NUMERIC(20, 2),
    high NUMERIC(20, 2),
    low NUMERIC(20, 2),
    close NUMERIC(20, 2),
    volume INT NOT NULL,
    PRIMARY KEY(symbol, created_at)
);



-- page 5: "It should be possible to compute these values over any interval of time. "

/*
https://www.postgresql.org/docs/current/plpgsql-declarations.html
A variable's default value is evaluated and assigned to the variable each time the block is entered (not just once per function call).
So, for example, assigning now() to a variable of type timestamp causes the variable to have the time of the current function call,
not the time when the function was precompiled.
*/
start_date CONSTANT timestamp with time zone := now();
end_date CONSTANT timestamp with time zone := now();
target_symbol CONSTANT text := 'AAPL';

-- stats functions: https://www.postgresql.org/docs/9.1/functions-aggregate.html#FUNCTIONS-AGGREGATE-STATISTICS-TABLE


-- NOTE: THIS IS WRONG. WE NEED VAR FOR RELATIVE CHANGE, NOT ABSOLUTE VALUE
/*
Get the variance of a particular stock symbol (`target_symbol`), for dates between `start_date` and `end_date`.
*/
select var_samp(close)
from history
where symbol = target_symbol
    and start_date <= created_at
    and created_at <= end_date;


/*
Get the variance of all stock symbols, for dates between `start_date` and `end_date`.
*/
select symbol, var_samp(close)
from history
where start_date <= created_at
    and created_at <= end_date
group by symbol;


/*
Get the relative change in close price for a stock symbol.

We will use the second formula (it's more convenient because the lag syntax is long):

relative change = (today's price - yesterday's price) / yesterday's price
                = today's price / yesterday's price - 1
*/
create table stock_changes as (
    select created_at, close, symbol,
    close / (lag(close, 1) over (order by symbol, created_at)) - 1 as diff
from history
);
-- Need this update because we sorted by (symbol, created at), since otherwise
-- the most recent entry for stock AAP will be treated as the "previous day" for the oldest entry for stock AAPL, for example.
update stock_changes
set diff = 0.0
where created_at < timestamp with time zone '2013-02-09'; -- oldest timestamp occurs on 2013-02-08, others are after.


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
    on x.created_at = y.created_at
where x.symbol in ('AAPL', 'A', 'AAL')
  and y.symbol in ('AAPL', 'A', 'AAL')
group by x.symbol, y.symbol
order by x.symbol, y.symbol;

/*
Compute the average relative change in the market for each day.
This is useful for computing the coefficient of variation and the beta of each stock.

       created_at       |            avg             
------------------------+----------------------------
 2013-02-08 00:00:00-05 |     0.00000000000000000000
 2013-02-11 00:00:00-05 |    -0.00113625747033921996
 2013-02-12 00:00:00-05 |     0.00290388132691383575
 2013-02-13 00:00:00-05 |     0.00161624249110822593
 2013-02-14 00:00:00-05 |     0.00033726937779521996
*/
create view market_changes as
select created_at, avg(diff) as market_diff
from stock_changes
group by created_at;

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
from stock_changes natural join market_changes      -- this joins on created_at only
group by symbol;

