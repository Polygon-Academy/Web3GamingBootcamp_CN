defmodule TaiShangWorldGenerator.MapTranslator do
  alias Utils.TypeTranslator
  alias TaiShangWorldGenerator.BlockchainFetcher
  @rule_class "Rule"

  def get_map_by_block_num_and_rule_name(block_num, rule_name) do
    {:ok, %{hash: block_hash}} =
      BlockchainFetcher.abstract_block_by_block_number(block_num)
    type =
      block_hash
      |> TypeTranslator.hex_to_bin()
      |> get_type(rule_name)
    map =
      block_num
      |> BlockchainFetcher.get_blocks(block_num, :txs)
      |> BlockchainFetcher.hex_to_bin_batch()
      |> bin_list_to_list_2d()
      |> handle_map_by_rule(rule_name)
    description =
      get_ele_description(rule_name)
    %{
      map: map,
      type: type,
      ele_description: description
    }
  end
  @doc """
    ```elixir
    alias TaiShangWorldGenerator.{BlockchainFetcher, MapTranslator}
    begin_num =
      BlockchainFetcher.get_block_number()
    begin_num
    |> BlockchainFetcher.get_blocks(begin_num, :txs)
    |> BlockchainFetcher.hex_to_bin_batch()
    |> MapTranslator.bin_list_to_list_2d()
    |> MapTranslator.handle_map_by_rule("RuleA")
    ```
  """
  @spec bin_list_to_list_2d(list()) :: list()
  def bin_list_to_list_2d(bin_list) do
    Enum.map(bin_list, fn bin ->
      TypeTranslator.bin_to_list(bin)
    end)
  end

  @doc """
    //TODO: async to optimize
  """
  def handle_map_by_rule(list_2d, rule) do
    rule_mod = TypeTranslator.str_to_module(@rule_class, rule)
    Enum.map(list_2d, fn line ->
      handle_line_by_rule(line, rule_mod)
    end)
  end

  @doc """
    //TODO: async to optimize
  """
  def handle_line_by_rule(line, rule_mod) do
    Enum.map(line, fn ele ->
      apply(rule_mod, :handle_ele, [ele])
    end)
  end

  def get_type(hash, rule) do
    rule_mod = TypeTranslator.str_to_module(@rule_class, rule)
    apply(rule_mod, :get_type, [hash])
  end

  def get_ele_description(rule) do
    rule_mod = TypeTranslator.str_to_module(@rule_class, rule)
    apply(rule_mod, :get_ele_description, [])
  end

  # +-----------+
  # | Behaviour |
  # +-----------+
  defmodule Behaviour do
    @moduledoc """
    the behaviour of MapTranslator.
    """
    @callback handle_ele(
      ele :: integer()
      ) :: integer()

    @callback get_type(
      hash :: binary()
      ) :: String.t()

    @callback get_ele_description() :: map()
  end
end
