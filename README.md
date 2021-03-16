# DemoRocksdb

## Run
rm -rf data

mix do deps.get, deps.compile, compile --force

iex -S mix

```elixir
{:ok, db} = DemoRocksdb.setup()
DemoRocksdb.tab2list(db)
DemoRocksdb.take(db, 4)
DemoRocksdb.take(db, 4, "4")
DemoRocksdb.take(db, 4, "8")
```
