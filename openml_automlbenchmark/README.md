# OpenML AutoML Benchmark

The results were obtained with the open access [automlbenchmark] application running in AWS mode with prebuilt docker images available at [automlbenchmark docker] repository. 

## Datasets

THe datasets used for the benchmarks are all listed in [datasets.csv] with some basic characteristics, a detailed description can be obtained for each of them by clicking on their [OpenML] identifier.

## Running the benchmarks

Using the [automlbenchmark] application, all the framework comparison results could be theoretically obtained by simply running:
```bash
for c in 1h8c; do
    for b in small medium validation regr_small regr_medium; do
        for f in h2oautoml autogluon autosklearn tpot; do
            python runbenchmark.py $f $b $c -u ~/.config/automlbenchmark/h2opaper -o ./h2opaper/frameworks -m aws -p 100 -Xmax_parallel_jobs=120 -Xseed=1 -Xaws.use_docker=True -Xdelay_between_jobs=10
        done
    dones
done
```
In practice, this was not all executed in a single loop to improve parallelism.

The `1h8c` constraint tells that all the listed frameworks have been tested for 1h on 8 cores: `m5.2xlarge` EC2 instances.

### Configuration

The following `config.yaml` was used in `~/.config/automlbenchmark/h2opaper` to be able to extend the default [automlbenchmark] with the regression datasets, and to be able to run some experiments with [H2OAutoML]. 
```yaml
---
#project_repository: https://github.com/openml/automlbenchmark

frameworks:
  definition_file:
    - '{root}/resources/frameworks.yaml'
    - '{user}/frameworks.yaml'

benchmarks:
  definition_dir:
    - '{user}/benchmarks'
    - '{root}/resources/benchmarks'

aws:
  resource_files:
    - '{user}/config.yaml'
    - '{user}/frameworks.yaml'
```

### Additional benchmark definitions

- regr_small.yaml
```yaml
---
- name: mtp2 
  openml_task_id: 4804

- name: Moneyball
  openml_task_id: 166852

- name: QSAR-TID-11140 
  openml_task_id: 211991

- name: elevators 
  openml_task_id: 2307

- name: ASP-POTASSCO-regression
  openml_task_id: 189936
```
- regr_medium.yaml
```
---
- name: houses 
  openml_task_id: 4862

- name: fried 
  openml_task_id: 4885

- name: aloi 
  openml_task_id: 12732 

- name: BNG_breastTumor 
  openml_task_id: 7324
```

### Custom frameworks definitions
 
Those custom frameworks definitions were used in `{user}/frameworks.yaml` to compare `H2OAutoML` baseline with other configurations:
```yaml
---

H2OAutoML_exploitation1:
  extends: H2OAutoML
  params:
    exploitation_ratio: 0.1

H2OAutoML_exploitation2:
  extends: H2OAutoML
  params:
    exploitation_ratio: 0.2
```

## Results

The [results] for each (framework, task, fold, constraint) combination are available.

We also provide all the [leaderboards] obtained for the `H2OAutoML` runs


[automlbenchmark]: https://github.com/openml/automlbenchmark
[automlbenchmark docker]: https://hub.docker.com/u/automlbenchmark
[datasets.csv]: ./datasets.csv
[leaderboards]: ./leaderboards
[results]: ./results
[H2OAutoML]: https://github.com/h2oai/h2o-3/tree/master/h2o-automl
[OpenML]: http://openml.org

