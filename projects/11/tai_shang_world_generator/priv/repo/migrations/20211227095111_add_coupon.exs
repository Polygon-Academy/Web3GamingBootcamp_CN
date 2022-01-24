defmodule TaiShangWorldGenerator.Repo.Migrations.AddCoupon do
  use Ecto.Migration

  def change do
    create table :coupon do
      add :coupon_id, :string, default: false
      add :is_used, :boolean
      timestamps()

    end
    create unique_index(:coupon, [:coupon_id])
  end
end
