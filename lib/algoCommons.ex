defmodule AlgoCommons do
  def initiate_process(numNodes, msg) do
    convergence_task = Task.async(fn -> listenConvergence(numNodes) end)
    :global.register_name(:convergence_task_pid, convergence_task.pid)
    start_process_on_random_node(numNodes, msg)
    Task.await(convergence_task, :infinity)
  end

  def listenConvergence(numNodes) do
    if(numNodes > 0) do
      receive do
        {:converged, pid} ->
          IO.puts("#{inspect(pid)} Converged, remaining: #{numNodes}")
          listenConvergence(numNodes - 1)
      after
        1000 ->
          IO.puts("Convergence failed for a node, remaining #{numNodes}")
          listenConvergence(numNodes - 1)
      end
    end
  end

  def start_process_on_random_node(numNodes, msg) do
    node_pid = numNodes |> :rand.uniform() |> ActorCommons.getPid()

    if node_pid != nil do
      send(node_pid, msg)
    else
      start_process_on_random_node(numNodes, msg)
    end
  end
end
