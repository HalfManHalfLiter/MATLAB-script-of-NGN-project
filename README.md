NGN Analysis Script
This MATLAB script performs an analysis of Next Generation Network (NGN) performance for real-time (RT) and non-real-time (NRT) traffic. The script calculates key network parameters such as the number of channels, PCM30 systems, DSP requirements, traffic intensities, and quality metrics (e.g., IPLR, IPDT, IPDV) based on input data for traffic loads and routing probabilities.
Project Structure

src/ - Source code:
NGN_script.m: Main MATLAB script containing the NGN analysis logic.


.gitignore: Excludes unnecessary files (e.g., temporary MATLAB files).
README.md: This file.

Features

Input Data Processing: Handles traffic intensities (A), packet rates (LAMBDA_RT, LAMBDA_NRT), and routing matrices (WZ_RT, WZ_NRT) for three network nodes.
Channel Calculations: Determines the number of channels (N), PCM30 systems, and DSP units required for input and output traffic.
Traffic Flow Analysis: Computes RT and NRT traffic flows (C_RT, C_NRT) in Mb/s across network links.
Quality Metrics: Calculates quality parameters such as packet loss ratio (IPLR), packet delay (IPDT), and packet delay variation (IPDV) for RT and NRT traffic.
Custom Function: Includes a policzN function to compute the number of channels based on the Erlang B formula.

Requirements

MATLAB (tested with versions R2016a and later)
MATLAB Symbolic Math Toolbox (for high-precision calculations with digits(100))
No external libraries required

How to Run

Clone the repository:git clone https://github.com/your-username/ngn-analysis.git


Navigate to the source directory:cd ngn-analysis/src


Open MATLAB:
Launch MATLAB and set the working directory to the src/ folder.


Run the script:
In the MATLAB Command Window, type:NGN_script


Press Enter to execute the script.


View results:
The script outputs results to the MATLAB Command Window, including:
Number of channels (Nin, N_OUT)
PCM30 systems (NPCM30, N_PCM3032_OUT)
DSP requirements (NDSP_IN, N_DSP_OUT)
Traffic flows (C_RT, C_NRT) in Mb/s
Quality metrics (IPLR, IPDT, IPDV) for RT and NRT traffic





Input Data
The script uses the following input parameters (defined in NGN_script.m):

A: Traffic intensities for three nodes (Erlangs)
LAMBDA_RT, LAMBDA_NRT: Packet rates for RT and NRT traffic (packets/s)
WZ_RT, WZ_NRT: Routing probability matrices for RT and NRT traffic
B: Target loss probability (e.g., 0.002)
N_DSP: Number of channels per DSP (4)
Codec parameters: T_PAK_G729 (0.01 s), T_PAK_G711 (0.02 s)
Link capacity: C (599.04 Mb/s)
Propagation speed: V (200,000 km/s)
NRT packet size: L_NRT (1500 bytes)
Queue lengths: K1 (6 for RT), K2 (10 for NRT)

To modify the analysis, edit these parameters directly in the script.
Example Output
C_RT(1, 1) 0.000 Mb/s
C_RT(1, 2) 9.720 Mb/s
...
tabela 1.11 i 1.12:
Brama     Kierunek A Ab. – B Ab      Kierunek B Ab. – A Ab      C_RT_IP_i
  1              32.40               22.68           55.08
...

tabela 2.3 (parametery jakościowe RT):
Łącze         IPLR                 E(T_ocz)            E(T_nad)          E(T_prop)              IPDT
           0.000001    0.000021    0.000011    0.000150    0.000182
...

tabela 2.7 (parametery jakościowe NRT):
Łącze         IPLR                 E(T_ocz)            E(T_nad)          E(T_prop)              IPDT
           0.000003    0.000042    0.000020    0.000200    0.000262
...

Limitations

The script assumes fixed input parameters and does not support dynamic input (e.g., via user prompts or files).
Calculations are based on specific codecs (G.729, G.711) and may need adjustments for other protocols.
High-precision arithmetic (digits(100)) may slow down execution for large datasets.
The policzN function implements a simplified Erlang B model, which may not account for all real-world scenarios.

License
MIT License
