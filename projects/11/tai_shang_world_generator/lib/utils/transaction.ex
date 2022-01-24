defmodule Utils.Ethereum.Transaction do
  @moduledoc """
    Tx about Ethereum.
  """

  alias Utils.{Crypto, TypeTranslator}
  alias Ethereumex.HttpClient
  alias Utils.Ethereum.Transaction

  @gas %{price: 20_000_000_000, limit: 300_000}
  defstruct nonce: 0,
            gas_price: 0,
            gas_limit: 0,
            to: <<>>,
            value: 0,
            v: nil,
            r: nil,
            s: nil,
            init: <<>>,
            data: <<>>

  @type t :: %__MODULE__{
          nonce: integer(),
          gas_price: integer(),
          gas_limit: integer(),
          to: <<_::160>> | <<_::0>>,
          value: integer(),
          v: integer(),
          r: integer(),
          s: integer(),
          # contract machine code
          init: binary(),
          data: binary()
        }

  def build_tx(from, to_str, data) do
    nonce = get_nonce(from)

    to_bin =
      TypeTranslator.addr_to_bin(to_str)

    %Transaction{
      nonce: nonce,
      gas_price: @gas.price,
      gas_limit: @gas.limit,
      to: to_bin,
      value: 0,
      init: <<>>,
      data: data
    }
  end

  @spec get_nonce(String.t()) :: integer
  def get_nonce(addr) do
    {:ok, hex} = HttpClient.eth_get_transaction_count(addr)
    TypeTranslator.hex_to_int(hex)
  end

  @spec signed_tx_to_raw_tx(TaiShang.Ethereum.Transaction.t()) :: <<_::16, _::_*8>>
  def signed_tx_to_raw_tx(signed_tx) do
    raw_tx =
      signed_tx
      |> serialize()
      |> ExRLP.encode(encoding: :hex)

    "0x" <> raw_tx
  end

  @doc """
    generate signature
  """
  @spec sign(t, Binary.t(), integer() | nil) :: t
  def sign(tx, private_key, chain_id \\ nil) do
    {v, r, s} =
      tx
      |> hash_for_signing(chain_id)
      |> Crypto.sign_hash(private_key, chain_id)

    %{tx | v: v, r: r, s: s}
  end

  @spec hash_for_signing(Transaction.t(), integer() | nil) :: binary()
  def hash_for_signing(tx, chain_id \\ nil) do
    # See EIP-155
    tx
    |> serialize(false)
    |> Kernel.++(if chain_id, do: [:binary.encode_unsigned(chain_id), <<>>, <<>>], else: [])
    |> ExRLP.encode(encoding: :binary)
    |> Crypto.kec()
  end

  @spec serialize(Transaction.t(), boolean()) :: ExRLP.t()
  def serialize(tx, include_vrs \\ true) do
    base = [
      encode_unsigned(tx.nonce),
      encode_unsigned(tx.gas_price),
      encode_unsigned(tx.gas_limit),
      tx.to,
      encode_unsigned(tx.value),
      if(tx.to == <<>>, do: tx.init, else: tx.data)
    ]

    if include_vrs do
      base ++
        [
          encode_unsigned(tx.v),
          encode_unsigned(tx.r),
          encode_unsigned(tx.s)
        ]
    else
      base
    end
  end

  @spec encode_unsigned(number()) :: binary()
  def encode_unsigned(0), do: <<>>
  def encode_unsigned(n), do: :binary.encode_unsigned(n)
end
