defmodule DemoRocksdb do

  @db_path 'data'

  def setup do
    {:ok, db} = open_db()
    put_data(db, random_data())
    {:ok, db}
  end

  def open_db do
    :rocksdb.open(@db_path, create_if_missing: true)
  end

  def random_data do
    1..10
    |> Enum.map(&Integer.to_string/1)
    |> Enum.map(fn x -> {x, x} end)
    |> Enum.shuffle()
  end

  def put_data(db, data) do
    Enum.each(data, fn {k,v} -> :rocksdb.put(db, t2b(k), t2b(v), []) end)
  end

  # API
  def tab2list(db) do
    db
    |> take(:infinity)
    |> elem(0)
  end

  # API
  def take(db, n) when n > 0 do
    {:ok, it} = :rocksdb.iterator(db, [])
    do_iter_take(it, n)
  end

  # API
  def take(db, n, first_key) do
    {:ok, it} = :rocksdb.iterator(db, iterate_lower_bound: t2b(first_key))
    do_iter_take(it, n)
  end

  # move iter to first element
  defp do_iter_take(it, n) do
    case :rocksdb.iterator_move(it, :first) do
      {:ok, key, value} ->
        do_iter_take(it, 1, n, [{b2t(key), b2t(value)}])
      {:error, :invalid_iterator} ->
        {[], nil}
    end
  end

  # take the next
  defp do_iter_take(it, count, n, acc) when count < n do
    case :rocksdb.iterator_move(it, :next) do
      {:ok, key, value} ->
        do_iter_take(it, count+1, n, [{b2t(key), b2t(value)} | acc])
      {:error, :invalid_iterator} ->
        {Enum.reverse(acc), nil}
    end
  end

  # done
  defp do_iter_take(it, n, n, acc) do
    next_key =
      case :rocksdb.iterator_move(it, :next) do
        {:ok, key, _} ->
          b2t(key)
        {:error, :invalid_iterator} ->
          nil
      end
    {Enum.reverse(acc), next_key}
  end

  defp t2b(t), do: :sext.encode(t)

  defp b2t(b), do: :sext.decode(b)

end
