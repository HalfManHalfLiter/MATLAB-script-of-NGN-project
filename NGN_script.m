%Projekt NGN

% Autor projektu:  
% Szymon Plata 
clear
clc
digits(100);

%Dane wejściowe
A = [750 585 550]; 
LAMBDA_RT = [12000 14500 11000]; 
LAMBDA_NRT = [21000 22100 28500]; 

B = 0.002; % docelowe prawdopodobieństwo straty


N_DSP = 4;

WZ_RT = [   0 0.2 0.33 0.35 0.2 0.1;
            0.15 0 0.35 0.2 0.2 0.1;
            0.25 0.25 0 0.1 0.2 0.2;
            0.05 0.25 0.2 0 0.3 0.2;
            0.15 0.25 0.2 0.2 0 0.2;
            0.15 0.35 0.2 0.25 0.05 0;]
        
WZ_NRT = [  0 0 0 0 0 0; 
            0 0 0 0 0 0; 
            0 0 0 0 0 0; 
            0 0 0 0 0.6 0.4; 
            0 0 0 0.5 0 0.5; 
            0 0 0 0.45 0.55 0; ]
N_DSP = 4;

T_PAK_G729 = 0.01;     
T_PAK_G711 = 0.02;
C = 599.04;
V = 200000;
L_NRT = 1500;
K1 = 6;
K2 = 10;

%Obliczenia

LAMBDA_G729 = 1/T_PAK_G729
LAMBDA_G711 = 1/T_PAK_G711

BIT_CAL_NRT = 8 * (L_NRT + 40);
E_T_NRT = BIT_CAL_NRT / (C * 10^6);

%1.1

Nin1 = policzN(A(1), B)
Nin2 = policzN(A(2), B)
Nin3 = policzN(A(3), B) 

%1.2

NPCM30_1 = ceil(Nin1 / 30)
NPCM30_2 = ceil(Nin2 / 30)
NPCM30_3 = ceil(Nin3 / 30)

%1.3

NR_IN1 = NPCM30_1 * 30
NR_IN2 = NPCM30_2 * 30
NR_IN3 = NPCM30_3 * 30
NR_IN = [NR_IN1 NR_IN2 NR_IN3];

%1.4

NDSP_IN1 = ceil(NR_IN1 / N_DSP)
NDSP_IN2 = ceil(NR_IN2 / N_DSP)
NDSP_IN3 = ceil(NR_IN3 / N_DSP)

%Obliczenia NOUTi oraz NDSP_OUTi

%1.1

A_OUT_PSTN_1 = 0;
A_OUT_PSTN_2 = 0;
A_OUT_PSTN_3 = 0;

for k = 1:6
    A_IN_K = [ A LAMBDA_RT/LAMBDA_G729 ];  
    
    A_OUT_PSTN_1 = A_OUT_PSTN_1 + (WZ_RT(k, 1) * A_IN_K(k));
    A_OUT_PSTN_2 = A_OUT_PSTN_2 + (WZ_RT(k, 2) * A_IN_K(k));
    A_OUT_PSTN_3 = A_OUT_PSTN_3 + (WZ_RT(k, 3) * A_IN_K(k));
end

A_OUT_PSTN_1
A_OUT_PSTN_2
A_OUT_PSTN_3

%1.2: Wyznaczenie liczby PCM30

N_OUT_1 = policzN(A_OUT_PSTN_1, B)
N_OUT_2 = policzN(A_OUT_PSTN_2, B)
N_OUT_3 = policzN(A_OUT_PSTN_3, B)

%1.3: Obliczenie liczby kanałów NR_IN

N_PCM3032_OUT1 = ceil(N_OUT_1 / 30)
N_PCM3032_OUT2 = ceil(N_OUT_2 / 30)
N_PCM3032_OUT3 = ceil(N_OUT_3 / 30)

%1.4: Obliczenie zapotrzebowania na DSP

N_R_OUT1 = N_PCM3032_OUT1 * 30
N_R_OUT2 = N_PCM3032_OUT2 * 30
N_R_OUT3 = N_PCM3032_OUT3 * 30

%1.5

N_DSP_OUT1 = ceil(N_R_OUT1 / N_DSP)
N_DSP_OUT2 = ceil(N_R_OUT2 / N_DSP)
N_DSP_OUT3 = ceil(N_R_OUT3 / N_DSP)

%1. C RT PSTN_Z, PSTN_D

LAMBDA_G711
lb_pakiet = T_PAK_G711 / (125 * 10^-6) 
b_cal_G711 = 8 * (lb_pakiet + 40)  

C_RT = [ 0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0; ];

for i = 1:3
    for j = 1:3
        C_RT(i, j) = round((WZ_RT(i, j) * NR_IN(i) * LAMBDA_G711 * b_cal_G711) / 10^6, 3);
        fprintf("C_RT(%i, %i) %f Mb/s \n", i, j, C_RT(i,j));
    end
end

%C_RT_PSTN

%2. 
LAMBDA_G729
lb_pakiet = 1000 / LAMBDA_G729
b_cal_G729 = 8 * (lb_pakiet + 40)

for i = 1:3
    for j = 4:6
        C_RT(i, j) = round((WZ_RT(i, j) * NR_IN(i) * LAMBDA_G729 * b_cal_G729) / 10^6, 3);
        fprintf("C_RT(%i, %i) %f Mb/s \n", i, j, C_RT(i,j));
    end
end

%4.
fprintf("\n");

for i = 4:6
    for j = 1:6
        C_RT(i, j) = round((WZ_RT(i, j) * LAMBDA_RT(i - 3) * b_cal_G729) / 10^6, 3);
        fprintf("C_RT(%i, %i) %f Mb/s \n", i, j, C_RT(i,j));
    end
end
 
transpose(C_RT) 

%tabela 1.11
fprintf("\n\ntabela 1.11 i 1.12: \n \n");
fprintf("Brama     Kierunek A Ab. – B Ab      Kierunek B Ab. – A Ab      C_RT_IP_i \n");

for i = 1:3
    fprintf("  %i", i);
    
    kier_a = 0;

    for j = 1:6
        kier_a = kier_a + C_RT(i, j);
    end
    
    kier_b = 0;
    for j = 1:6
        kier_b = kier_b + C_RT(j, i);
    end
    
    fprintf("              %f", round(kier_a, 2));
    fprintf("               %f", round(kier_b, 2));
    fprintf("           %f", round(kier_a + kier_b, 2));
    fprintf("\n");
end

%Drogi RT:

RB1_RR1 = C_RT(1, 2) + C_RT(1, 3) + C_RT(1, 4) + C_RT(1, 5) + C_RT(1, 6) + C_RT(2, 1) + C_RT(3, 1) + C_RT(4, 1) + C_RT(5, 1) + C_RT(6, 1);
RR1_RR2 = C_RT(1, 2) + C_RT(1, 3) + C_RT(1, 6) + C_RT(2, 1) + C_RT(3, 1) + C_RT(6,1);
RR2_RR3 = C_RT(1, 2) + C_RT(1, 6) + C_RT(4, 6) + C_RT(5, 6) + C_RT(6, 5) + C_RT(6, 4) + C_RT(6, 1) + C_RT(2, 1);
RR3_RB6 = C_RT(1,6) + C_RT(2, 6) + C_RT(3, 6) + C_RT(4, 6) + C_RT(5, 6) + C_RT(6, 1) + C_RT(6, 2) + C_RT(6, 3) + C_RT(6, 4) + C_RT(6, 5);

PRZEPLYWNOSCI_RT = [ RB1_RR1 RR1_RR2 RR2_RR3 RR3_RB6 ]
ODLEGLOSCI_RT = [ 30 70 70 60 ]

fprintf("\nprzepływności 2.2: \n \n");
fprintf("Łącze         Przepływnosć stru. Mb/s               A_RT \n");  

for i = 1:size(PRZEPLYWNOSCI_RT, 2)
    fprintf("                    %f                     %f \n", PRZEPLYWNOSCI_RT(i), PRZEPLYWNOSCI_RT(i) / C);
end

A_RT = PRZEPLYWNOSCI_RT / C;

IPLR_RT = [];

for i = 1:size(A_RT, 2)
    IPLR_RT(i) = ((1 - A_RT(i)) / (1 - (A_RT(i)^(K1+2)))) * (A_RT(i)^(K1+1));
end

E_T_NAD = b_cal_G711 / (C * 10^6);

E_T_OCZ = [];

for i = 1:size(A_RT, 2)
    E_T_OCZ(i) = (A_RT(i)/(1/E_T_NAD))*(1+(A_RT(i)^K1)*(K1*A_RT(i)-(K1+1)))/((1-A_RT(i))*(1-(A_RT(i)^(K1+2))));
end

E_T_PROP = ODLEGLOSCI_RT / V;

IPDT = E_T_NAD + E_T_OCZ + E_T_PROP;

fprintf("\ntabela 2.3 (parametery jakościowe RT): \n \n");
fprintf("Łącze         IPLR                 E(T_ocz)            E(T_nad)          E(T_prop)              IPDT \n");

for i = 1:size(IPDT, 2)
    fprintf("           %d         %d        %d        %d        %d       %d  ", IPLR_RT(i), E_T_OCZ(i), E_T_NAD, E_T_PROP(i), IPDT(i));
    fprintf("\n")
end

fprintf("\ntabela 2.4: \n \n");
IPDT_MAX = (K1 + 1) * E_T_NAD + E_T_NRT
IPDT_MIN = E_T_NAD
IPDV_MAX = IPDT_MAX - IPDT_MIN

fprintf("\n");
fprintf("IPLR: %d \n", sum(IPLR_RT));
fprintf("IPDT: %d \n", sum(IPDT));
fprintf("IPDV_MAX: %d \n", IPDV_MAX * size(IPDT, 2));

fprintf("\n NRT: \n\n");
C_NRT = zeros(6, 6);

for i = 4:6
    for j = 4:6
        C_NRT(i, j) = (WZ_NRT(i, j) * LAMBDA_NRT(i - 3) * BIT_CAL_NRT) / 10^6;   
        fprintf("C_NRT(%i, %i) %f Mb/s \n", i, j, C_NRT(i,j));
    end
end

transpose(C_NRT)

RB5_RR1 = C_NRT(1, 5) + C_NRT(4, 5) + C_NRT(5, 1) + C_NRT(5, 4);
RR1_RB4 = C_NRT(1, 4) + C_NRT(4, 1) + C_NRT(4, 5) + C_NRT(5, 4);

fprintf("tabela 2.5 (łącza NRT): \n \n");

PRZEPLYWNOSCI_RT_FOR_NRT = [ RB5_RR1 RR1_RB4 ]
PRZEPLYWNOSCI_NRT = [ C_NRT(4, 5) C_NRT(4, 5)]
ODLEGLOSCI_NRT = [ 70 40 ]

A_RT = PRZEPLYWNOSCI_RT_FOR_NRT / C;
A_NRT = zeros(2);

fprintf("\ntabela 2.6 (przepływności): \n \n");
fprintf("Łącze         A_RT               A_NRT \n"); 

for i = 1:size(PRZEPLYWNOSCI_RT_FOR_NRT, 2)
    A_NRT(i) = PRZEPLYWNOSCI_NRT(i) / (C - PRZEPLYWNOSCI_RT_FOR_NRT(i));
    fprintf("            %f            %f \n", A_RT(i), A_NRT(i));
end
 
IPLR_NRT = [];

for i = 1:size(A_NRT, 2)
    IPLR_NRT(i) = ((1 - A_NRT(i)) / (1 - (A_NRT(i)^(K2+2)))) * (A_NRT(i)^(K2+1));
end

E_T_NAD_NRT = BIT_CAL_NRT / (C * 10^6);

E_T_OCZ_NRT = [];

for i = 1:size(A_NRT, 2)
    E_T_OCZ_NRT(i) = (A_NRT(i)/(1/E_T_NAD_NRT))*(1+(A_NRT(i)^K2)*(K2*A_NRT(i)-(K2+1)))/((1-A_NRT(i))*(1-(A_NRT(i)^(K2+2))));
     
end 

E_T_PROP_NRT = ODLEGLOSCI_NRT / V;

IPDT_NRT = E_T_NAD_NRT + E_T_OCZ_NRT + E_T_PROP_NRT;

fprintf("\ntabela 2.7 (parametery jakościowe NRT): \n \n");
fprintf("Łącze         IPLR                 E(T_ocz)            E(T_nad)          E(T_prop)              IPDT \n");

for i = 1:size(IPDT_NRT, 2)
    fprintf("           %d         %d        %d        %d        %d       %d  ", IPLR_NRT(i), E_T_OCZ_NRT(i), E_T_NAD_NRT, E_T_PROP_NRT(i), IPDT_NRT(i));
    fprintf("\n")
end

fprintf("\ntabela 2.8: \n");
IPDT_MIN_NRT = E_T_NAD_NRT;
IPDT_MAX_NRT = [];

for i = 1:size(A_RT, 2)
    IPDT_MAX_NRT(i) = ((K2 + 1) * E_T_NAD_NRT) / (1 - A_RT(i));
end
IPDV_MAX_NRT = IPDT_MAX_NRT - IPDT_MIN_NRT;

IPDT_MAX_NRT
IPDT_MIN_NRT
IPDV_MAX_NRT

fprintf("\nparametry jakościowe: \n \n");
fprintf("IPLR: %d \n", sum(IPLR_NRT));
fprintf("IPDT: %d \n", sum(IPDT_NRT));
fprintf("IPDV_MAX: %d \n", sum(IPDV_MAX_NRT));

function N = policzN(A, B)
    e = 1;
    e_poprz = 1;
    N = 0;

    while e > B
        N = N + 1;
        e = (A * e_poprz) / (N + A * e_poprz);
        e_poprz = e;
    end
end