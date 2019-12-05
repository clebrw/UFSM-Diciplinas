%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%XXXX QPSK Modulation and Demodulation - Cleber Werlang, Lucas Siqueira XXXX
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

clc;clear all;close all;

n_bits =2000;
br=10.^6;       % Let us transmission bit rate 1000000
f=br;           % Frequencia da onda portadora
T=1/br;         % bit duration
t=T/50:T/50:T;  % Time vector for one bit information  
        
data = round(rand(1,n_bits));  % Gera um vetor de dados 0s e 1s

data_NRZ=2*data-1; % Data Represented at NRZ form for QPSK modulation

s_p_data = reshape(data_NRZ,2,length(data)/2);  % S/P convertion of data

% XXXXXXXXXXXXXXXXXXXXXXX QPSK modulation  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

BE = [];
EbNo_dB = 1:16;
%EbNo_lin = 10.^(EbNo_dB/10);
%EbNo = 4;
for n=1:length(EbNo_dB)  
    y=[];
    y_in=[];
    y_qd=[];

    for(i=1:length(data)/2)

        y1=s_p_data(1,i)*cos(2*pi*f*t); % inphase component
        y2=s_p_data(2,i)*sin(2*pi*f*t);% Quadrature component
        y_in=[y_in y1]; % inphase signal vector   
        y_qd=[y_qd y2]; %quadrature signal vector 
        
        ruido= sqrt(1/(2*10^((n-20)/10)))*((randn(1,length(y1))-0.5)); % Generate AWGN noise
        
        y=[y y1+y2+ruido]; % modulated signal vector     
    end

    Tx_sig= y;
    tt=T/50:T/50:(T*length(data))/2;

    % XXXXXXXXXXXXXXXXXXXXXXXXXXXX QPSK demodulation XXXXXXXXXXXXXXXXXXXXXXXXXX
    Rx_data=[];
    Rx_sig=Tx_sig; % Received signal
    for(i=1:1:length(data)/2)

        %%XXXXXX inphase coherent dector XXXXXXX
        Z_in=Rx_sig((i-1)*length(t)+1:i*length(t)).*cos(2*pi*f*t); 
        % above line indicat multiplication of received & inphase carred signal
        
        Z_in_intg=(trapz(t,Z_in))*(2/T);% integration using trapizodial rull
        if(Z_in_intg>0) % Decession Maker
            Rx_in_data=1;
        else
           Rx_in_data=0; 
        end
        
        %%XXXXXX Quadrature coherent dector XXXXXX
        Z_qd=Rx_sig((i-1)*length(t)+1:i*length(t)).*sin(2*pi*f*t);
        %above line indicat multiplication ofreceived & Quadphase carred signal
        
        Z_qd_intg=(trapz(t,Z_qd))*(2/T);%integration using trapizodial rull
            if (Z_qd_intg>0)% Decession Maker
            Rx_qd_data=1;
            else
           Rx_qd_data=0; 
            end
               
        Rx_data=[Rx_data  Rx_in_data  Rx_qd_data]; % Received Data vector
         
    end

    BE = [BE sum(xor(data,Rx_data))];
    n  % printa na janela de comandos as iterações
end

BER = BE/length(data);

figure;
semilogy(EbNo_dB,BER);
xlabel('Eb/No in dB');
ylabel('BER');
title('Bit Error Probability, Pb vs Eb/No');
grid on;

    