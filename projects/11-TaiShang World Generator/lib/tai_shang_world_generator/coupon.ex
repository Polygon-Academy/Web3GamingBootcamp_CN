defmodule TaiShangWorldGenerator.Coupon do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaiShangWorldGenerator.Coupon, as: Ele
  alias TaiShangWorldGenerator.Repo
  alias Utils.RandGen

  schema "coupon" do
    field :coupon_id, :string
    field :is_used, :boolean, default: false

    timestamps()
  end

  @doc """
    generate a new coupon.
  """
  def generate() do
    coupon_id = RandGen.gen_hex(16)
    create(
      %{
        coupon_id: coupon_id
    })
  end

  def get_by_id(id) do
    Repo.get_by(Ele, id: id)
  end

  def get_by_coupon_id(coupon_id) do
    Repo.get_by(Ele, coupon_id: coupon_id)
  end

  def is_used?(coupon) do
    %{is_used: is_used} = coupon
    is_used
  end

  def use_coupon(coupon_id) do
    coupon = get_by_coupon_id(coupon_id)
    with false <- is_nil(coupon),
      false <- is_used?(coupon) do
        do_use_coupon(coupon)
      else
        _else ->
        {:error, "the coupon_id is not valid"}
    end
  end

  def do_use_coupon(coupon) do
    change_coupon(coupon, %{is_used: true})
  end

  def create(attrs \\ %{}) do
    %Ele{}
    |> Ele.changeset(attrs)
    |> Repo.insert()
  end

  def change_coupon(%Ele{} = ele, attrs) do
    ele
    |> changeset(attrs)
    |> Repo.update()
  end

  def changeset(%Ele{} = ele) do
    Ele.changeset(ele, %{})
  end

  @doc false
  def changeset(%Ele{} = ele, attrs) do
    ele
    |> cast(attrs, [:coupon_id, :is_used])
    |> unique_constraint(:coupon_id)
  end
end
