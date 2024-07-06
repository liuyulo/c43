# C43 Final Project

## Installation

- Haskell: [ghcup](https://www.haskell.org/ghcup/install/)
  - Run `ghcup tui` to manage toolchains.
  - GHC 9.6.6, HLS 2.9.0.1
- PostgreSQL
  - Install `libpqxx-dev libpq-dev libgmp3-dev`.

## Stack

```bash
stack build # compile
stack run # compile and run
```

## Postgres

- Home directory is `/var/lib/postgresql`
- PostgreSQL is initalised at `$HOME/data`

Switch user to postgres
```bash
sudo su - postgres
```

The rest of the commands are to runned as user `postgres`

```bash
pg_ctl status
pg_ctl start
```

### Psql

To start psql, run `psql` as postgres, or `sudo -u postgres psql`

```bash
\l # list databases
\c <dabase> # connect to <database>
\dt # list tables
```

