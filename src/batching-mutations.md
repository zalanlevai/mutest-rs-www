# Batching Mutations

Mutation batching is a novel, experimental technique for increasing the parallelism of mutation analysis. By ensuring that mutations appear in *"distinct"* parts of the program, mutest-rs is able to combine them into one, while ensuring that

* mutations do not influence each other's behavior, and
* mutation detections can still be distinguished from test case outputs.

By combining mutations into bigger batches, mutest-rs is able to evaluate more test cases in each iteration, making better use of the parallel processors available, and ultimately speeding up mutation evalaution.

Mutation batching is based on, and described in detail in the following research paper:

> **Batching Non-Conflicting Mutations for Efficient, Safe, Parallel Mutation Analysis in Rust**<br>
> *Zalán Lévai, Phil McMinn*
>
> [![DOI 10.1109/ICST57152.2023.00014](https://img.shields.io/badge/10.1109%2FICST57152.2023.00014-black?logo=DOI)](https://doi.org/10.1109/ICST57152.2023.00014)

## Using Mutation Batching in mutest-rs { #usage }

To enable mutation batching, first change the batch size limit (default: 1) to a higher value using the `--mutant-batch-size` argument. Otherwise, no mutation batching method will be able to create batches.

```sh
cargo mutest --mutant-batch-size 100 run
```

Mutation batching is performed by various algorithms before the mutations are compiled and evaluated. To pick a mutation batching algorithm, pass its name with the `--mutant-batch-algorithm` argument (default: none). Note, that various mutation batching algorithms may take their own, additional set of optional arguments, with the `--mutant-batch-<ALGORITHM>-` prefix. See `--help` for more details.

```sh
cargo mutest --mutant-batch-algorithm greedy --mutant-batch-size 100 run
```

If you experience crashes with mutation batching during evaluation, then it is most likely due to a conflict not accounted for with the current settings. The conflict relationships used in mutation batching are based on static call graph construction, which has a depth limit for practical reasons. To increase the depth limit of the call graph construction, and thus increase mutest-rs's ability to find all conflict relationships, pass a higher value to the `--call-graph-depth` argument (default: 3).

```sh
cargo mutest --call-graph-depth 10 --mutant-batch-algorithm greedy --mutant-batch-size 100 run
```
