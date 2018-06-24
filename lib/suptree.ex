defmodule Suptree do
  @moduledoc """
  Documentation for Suptree.

  Suptree can be used by children who know their parent to find their siblings by a known ID.
  """

  @doc """
    Get all child PIDs and IDs as `{id, pid}`.
  """
  def all_child_ids(pid) do
    for {cid, child, typ, _} <- Supervisor.which_children(pid) do
      case typ do
        :supervisor -> [{cid, child}, all_child_ids(child)]
        _ -> {cid, child}
      end
    end
  end

  @doc """
    Get all child PIDs.
  """
  def all_children(pid) do
    for {_cid, child, typ, _} <- Supervisor.which_children(pid) do
      case typ do
        :supervisor -> [child, all_children(child)]
        _ -> child
      end
    end
  end

  @doc """
    Find a child by `id` within the supervision tree of `pid`.

    Uses a breadth first search.
  """
  def find_child_by_id(pid, id) do
    all_child_ids(pid) |> FlattenBreadthFirst.flatten_breadth_first |> List.keyfind(id, 0, {nil, nil}) |> elem(1)
  end
end
