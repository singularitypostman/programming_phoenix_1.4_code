#---
# Excerpted from "Programming Phoenix 1.4",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/phoenix14 for more book information.
#---
defmodule InfoSys.Counter do
  def inc(pid), do: send(pid, :inc)

  def dec(pid), do: send(pid, :dec)

  def val(pid, timeout \\ 5000) do 
    ref = make_ref()
    send(pid, {:val, self(), ref})

    receive do
      {^ref, val} -> val
    after
      timeout -> exit(:timeout)
    end
  end

  def start_link(initial_val) do 
    {:ok, spawn_link(fn -> listen(initial_val) end)}
  end

  defp listen(val) do 
    receive do
      :inc ->
        listen(val + 1)

      :dec ->
        listen(val - 1)

      {:val, sender, ref} ->
        send(sender, {ref, val})
        listen(val)
    end
  end
end
