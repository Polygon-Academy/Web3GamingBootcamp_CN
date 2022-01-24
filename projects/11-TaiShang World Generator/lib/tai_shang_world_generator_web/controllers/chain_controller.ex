defmodule TaiShangWorldGeneratorWeb.ChainController do
  alias Utils.TypeTranslator
  alias TaiShangWorldGenerator.BlockchainFetcher
  alias TaiShangWorldGeneratorWeb.ResponseMod
  use TaiShangWorldGeneratorWeb, :controller

  def get_last_block_num(conn, _params) do
    block_num = BlockchainFetcher.get_block_number()
    json(conn, ResponseMod.get_res(
      %{
        last_block_num: block_num
      }, :ok)
    )
  end

end
