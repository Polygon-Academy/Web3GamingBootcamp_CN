defmodule TaiShangWorldGenerator.NftInteractor do

  @moduledoc """
    example contract:
    "https://mumbai.polygonscan.com/address/0x545EDf91e91b96cFA314485F5d2A1757Be11d384"
  """
  alias Utils.Ethereum.Transaction
  alias Ethereumex.HttpClient
  alias Utils.{TypeTranslator, URIHandler}

  @func %{
    token_uri: "tokenURI(uint256)", # token_id
    claim: "claim(uint256, string)", # block_height & token_info
    owner_of: "ownerOf(uint256)", # token_id
    get_block_height_for_token: "getBlockHeightForToken(uint256)"
  }

  # +-------------+
  # | Write Funcs |
  # +-------------+

  # TODO
  def claim(chain, priv, from, contract_addr, receiver_addr, uri) do
    {:ok, addr_bytes} = TypeTranslator.hex_to_bytes(receiver_addr)

    str_data =
      get_data(
        @func.claim,
        [addr_bytes, uri]
      )


    send_raw_tx(chain, priv, from, contract_addr, str_data)
  end

  # +------------+
  # | Read Funcs |
  # +------------+

  @doc """
    return a map that is decoded
  """
  def token_uri(contract_addr, token_id) do
    data =
      get_data(
        @func.token_uri,
        [token_id]
      )

    {:ok, uri} =
      Ethereumex.HttpClient.eth_call(%{
        data: data,
        to: contract_addr
      })
    uri
    |> TypeTranslator.data_to_str()
    |> parse_nft()
  end

  @spec get_block_height_for_token(String.t(), integer()) :: integer()
  def get_block_height_for_token(contract_addr, token_id) do
    data = get_data(@func.get_block_height_for_token, [token_id])

    {:ok, block_height_hex} =
      Ethereumex.HttpClient.eth_call(%{
        data: data,
        to: contract_addr
      })

    TypeTranslator.data_to_int(block_height_hex)
  end


  # +-------------+
  # | Basic Funcs |
  # +-------------+

  def parse_nft(payload_raw) do
    %{image: img_raw} =
      payload =
        URIHandler.decode_uri(payload_raw)
    img_parsed =
      URIHandler.decode_uri(img_raw)
    %{payload: payload, img_parsed: img_parsed}
  end

  def send_raw_tx(%{config: %{"chain_id" => chain_id}}, priv, from, contract_addr, str_data) do
    {:ok, data_bin} = TypeTranslator.hex_to_bytes(str_data)
    signed_tx =
      from
      |> Transaction.build_tx(contract_addr, data_bin) # get unsigned tx
      |> Transaction.sign(priv, chain_id)
    raw_tx = Transaction.signed_tx_to_raw_tx(signed_tx)
    HttpClient.eth_send_raw_transaction(raw_tx)
  end

  @spec get_data(String.t(), List.t()) :: String.t()
  def get_data(func_str, params) do
    payload =
      func_str
      |> ABI.encode(params)
      |> Base.encode16(case: :lower)

    "0x" <> payload
  end

end
