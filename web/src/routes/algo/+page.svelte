<script lang="ts">
	const directed_graph = {
		1: [2, 3],
		2: [4, 5],
		3: [4],
		4: [5],
	};

	class TopologicalSort {
		directed_graph: Map<number, number[]>;
		visited: boolean[];
		indegree: number[];

		constructor(directed_graph: Map<number, number[]>, len: number) {
			this.directed_graph = directed_graph;
			this.visited = new Array(len).fill(false);

			this.indegree = new Array(len).fill(0);
			for (const [node, neighbors] of directed_graph.entries()) {
				for (const neighbor of neighbors) {
					this.indegree[neighbor]++;
				}
			}
		}

		solve(): number[] {
			let soln: number[] = [];

			return soln;
		}
	}
</script>
