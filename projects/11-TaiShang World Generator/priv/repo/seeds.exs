# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TaiShangWorldGenerator.Repo.insert!(%TaiShangWorldGenerator.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# +---------------------------------------------+
# | Generate 100 rand Coupon and save it to csv |
# +---------------------------------------------+

alias TaiShangWorldGenerator.Coupon

coupond_list =
Enum.map(0..100, fn _whatever ->
  {:ok, %{coupon_id: coupon_id}} =
    Coupon.generate()
  [coupon_id]
end)

file = File.open!("coupon.csv", [:write, :utf8])
coupond_list
|> CSV.encode
|> Enum.each(&IO.write(file, &1))
