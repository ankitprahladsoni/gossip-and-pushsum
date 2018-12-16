defmodule ActorCommons do
  def via_tuple(node_id), do: {:via, Registry, {:registry, node_id}}

  def getPid(node_id) do
    case Registry.lookup(:registry, node_id) do
      [{pid, _}] -> pid
      [] -> nil
    end
  end

  def shutdown(pid) do
    send(:global.whereis_name(:convergence_task_pid), {:converged, self()})
    Task.shutdown(pid, :kill)
  end
end
