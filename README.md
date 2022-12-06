# Synthetic axion injection

In this [paper](https://arxiv.org/abs/2212.00732), we established a method based on frequency hopping spread spectrum (FHSS) for synthesizing axion signals in a microwave cavity haloscope experiment. It allows us to generate a narrow and asymmetric shape in frequency space that resembles an axion's spectral distribution, which is derived from a Maxwell-Boltzmann distribution. 

The purpose of this repository is to share the code for implementing synthetic axion injection demonstrated in the paper. The hardware device used in the demonstration is a Keysight PSG signal generator with model number E8257D. Though not tested, the code should also work for the following Keysight models: E4428C, E4438C,N5181A, N5182A, N5183A, N5171B, N5181B, N5172B, N5182B, N5182N, N5173B, N5183B E8241A, E8244A, E8251A, E8254A, E8247C, E8257C, E8267C, E8267D, E8257N, E8663B, E8663D, N5166B, N5183N. In addition to the code provided here, the ability to record the PSG's output over time is necessary to test synthetic signal injection. In the paper, the output signal was recorded over 12 hours, and in the `nocavitydata` example included in this repository, 0.5-1 hours. In both cases, we use a heterodyne scheme for detection.

### Related Work
Yuqi Zhu, M. J. Jewell, Claire Laffan, Xiran Bai, Sumita Ghosh, Eleanor Graham, S. B. Cahn, Reina H. Maruyama, S. K. Lamoreaux, An improved synthetic signal injection routine for HAYSTAC, 2022 [(arxiv)](https://arxiv.org/abs/2212.00732)


## Requirements 

- MATLAB instrument driver for PSG E8257D provided by Keysight 
    - It can be download from https://www.keysight.com/us/en/lib/software-detail/driver/rf-signal-generators-ivi-and-matlab-instrument-drivers-1669133.html.
    - Driver functions' directory must be in MATLAB's search path.
- a PC that remotely controls the PSG
    - See 'Configuring for Remote Control' in the PSG's Installation Guide for instructions.
    - Check the PSG's id. This is needed as an input (`PSGid`) for the synthetic axion injection code.

## How to use

1. Download all the functions and scripts in this repository. 
2. Run individual sections in `simpletests.m` to perform simple tests with fixed frequency sample numbers.
3. Run `main.m` for signal injection over a longer period.

An example of the expected outcome is inlcuded in the `nocavitydata/` folder:
- Data file: `nocavitydata/gage_test_2022_02_02_17_25_30.mat`
    - This dataset can be reproduced by running `%% simple test 2: read a longer list with N samples` in `simpletest.m`. 
- The experimental scheme is shown in `nocavitydata/heterodynescheme.pdf`.
    - This scheme is a minimal heterodyne scheme, similar but simpler than what was used in the paper (see Fig.1).
    - Code for recording time series data and calculating Fourier Transform is not provided.
- `nocavitydata/plotdata_hardwareinjection.m` produces the plot shown by `nocavitydata/syninjectiondataexample.pdf`.
