defmodule NeighborFactory do
  def getNeighbor(i, numNodes, topology, random2dGrid) do
    range = 1..numNodes

    case topology do
      "full" -> Enum.reject(range, fn x -> x == i end)
      "line" -> Enum.filter(range, fn x -> x == i + 1 || x == i - 1 end)
      "3D" -> get3DNeighbor(i, numNodes)
      "torus" -> getTorusNeighbor(i, numNodes)
      "impLine" -> impLineNeighbor(i, numNodes)
      "rand2D" -> rand2DNeighbor(i, numNodes, random2dGrid)
    end
  end

  defp get3DNeighbor(i, numNodes) do
    cubeLength = numNodes |> :math.pow(1 / 3)
    numNodes = :math.pow(cubeLength, 3)

    [
      i - 1,
      i + 1,
      i - cubeLength,
      i + cubeLength,
      i - cubeLength * cubeLength,
      i + cubeLength * cubeLength
    ]
    |> Enum.filter(fn x -> x > 0 && x <= numNodes end) |> Enum.map(fn x-> trunc(x) end)
  end

  defp getTorusNeighbor(i, numNodes) do
    gridWidth = :math.sqrt(numNodes) |> trunc()
    # numNodes = :math.sqrt(numNodes) |>:math.ceil |> :math.pow(2) |> trunc()
    r = rem(numNodes, gridWidth)
    numNodes = if r == 0, do: numNodes, else: numNodes + gridWidth - r

    top = if i - gridWidth <= 0, do: numNodes + i - gridWidth, else: i - gridWidth
    bottom = if i + gridWidth > numNodes, do: i + gridWidth - numNodes, else: i + gridWidth
    right = if rem(i, gridWidth) == 0, do: i - gridWidth + 1 , else: i + 1
    left = if rem(i - 1, gridWidth) == 0, do: i + gridWidth - 1, else: i - 1

    [
      top,
      bottom,
      right,
      left
    ]
  end

  def impLineNeighbor(i, numNodes) do
    near = Enum.filter(1..numNodes, fn x -> x == i + 1 || x == i - 1 end)
    remaining = Enum.to_list(1..numNodes) -- [i | near]
    [Enum.random(remaining) | near]
  end

  def rand2DNeighbor(i, numNodes, random2dGrid) do
    gridLen = numNodes |> :math.sqrt() |> trunc()
    k = (gridLen / 10) |> :math.ceil() |> trunc()

    top = Enum.map(1..k, fn x -> i - x * gridLen end) |> Enum.filter(fn x -> x > 0 end)
    bottom = Enum.map(1..k, fn x -> i + x * gridLen end) |> Enum.filter(fn x -> x <= numNodes end)

    right =
      if rem(i, gridLen) == 0,
        do: [],
        else: Enum.take_while((i + 1)..(i + k), fn x -> rem(x, gridLen) != 1 end)

    left =
      if rem(i, gridLen) == 1,
        do: [],
        else: Enum.take_while((i - 1)..(i - k), fn x -> rem(x, gridLen) != 0 end)

    neighborIndex = top ++ bottom ++ right ++ left |> Enum.map(fn x -> trunc(x) end)

    Enum.filter(random2dGrid, fn x -> Enum.member?(neighborIndex, elem(x, 1)) end)
    |> Enum.map(fn x -> elem(x, 0) end)
  end

  def correctNumNodesForGrids(numNodes, topology) do
    case topology do
      "3D" -> :math.pow(numNodes, 1 / 3) |> :math.ceil() |> :math.pow(3) |> trunc()
      "rand2D" -> :math.sqrt(numNodes) |> :math.ceil() |> :math.pow(2) |> trunc()
      _ -> numNodes
    end
  end
end
