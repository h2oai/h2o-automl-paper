# H2O AutoML Paper

👋 This repository contains the code for the H2O AutoML paper, [_"H2O AutoML: Scalable Automatic Machine Learning"_](https://www.automl.org/wp-content/uploads/2020/07/AutoML_2020_paper_61.pdf), an accepted paper at the [ICML 2020 AutoML Workshop](https://sites.google.com/view/automl2020/accepted-papers_1).

The Experiments section contains the H2O AutoML specific experiments and the OpenML AutoML Benchmark contains benchmarks against other AutoML systems.


## Experiments

- **Hardware & Software:** The "Baseline" and "Blending vs CV Stacking" experiments can be replicated using [H2O 3.30.0.3](http://h2o-release.s3.amazonaws.com/h2o/rel-zahradnik/3/index.html) R package on a *c5.metal* Amazon EC2 instance (96 vCPUs, 192G RAM). An AMI called "h2oautoml_gpu" is available in us-east-1 for convenience. The experiments require R and a few other R package dependencies which can be installed using  `./utils/install.sh`.  
- **Data:** To run the experiments, first navigate to the `./data/airlines` subfolder and download the Airlines data files by running `get-data.sh`.  
- **Experiments:** Navigate to the experiment code subfolder (e.g. `blending_stacking/code`) and then run the `run-airlines-binary.sh` scripts to launch the experiments.

### Baseline

*Baseline H2O AutoML (default settings).* 


Using various subsets of the Airlines Dataset (~150M rows):

- 10k, 100k, 1M, 10M, 100M row training sets
- 100k test set 


### Blending vs CV Stacking

*Compare the baseline (5-fold CV) Stacked Ensemble with 10% blending frame Stacked Ensemble.*

Using various subsets of the Airlines Dataset (~150M rows):

- 10k, 100k, 1M, 10M, 100M row training sets
- 100k test set 


## OpenML AutoML Benchmark

An overview of the OpenML AutoML Benchmark as well as instructions for how to reproduce the benchmark are available in a separate [README.md](https://github.com/h2oai/h2o-automl-paper/blob/master/openml_automlbenchmark/README.md).  Also included in the `./openml_automlbenchmark` subfolder is the results files for each framework that was included (TPOT, auto-sklearn, H2O AutoML, AutoGluon-Tabular) and the H2O AutoML leaderboards generated during the benchmark.
