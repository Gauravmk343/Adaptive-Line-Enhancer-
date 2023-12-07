clc;
clear all;
A = 2;
fm = 10000;
Fs = 44000;
t = 0:1/Fs:0.01;
message_signal = A*sin(2*pi*fm*t);
noise = wgn(1, length(t), 0);
input_signal = message_signal + noise;
figure(1)
plot(t, message_signal);
title("Message Signal");
xlabel("Time in seconds");
ylabel("Amplitude");
figure(2)
plot(t, input_signal);
title("Noisy Message Signal");
xlabel("Time in seconds");
ylabel("Amplitude");
figure(3)
plot(t,noise);
p = 5;
N = length(t);
w = ones(1,p).*0.0001;
message_in = [];
for j = 1:N-p+1
    for i = 1:p
        message_in(j, i) = message_signal(j+i-1);
    end
end
j = 2;
y = zeros(p);
epsilon = 10;
while epsilon > 1e-3
    y = filter(w, 1, message_in((j-1), :));
    error_signal = y - message_in(j, :);
    w_ = w + 1e-4*error_signal(p)*message_in(j, :);
    epsilon = (abs(norm(w_ - w)))^2/norm(w)^2;
    w = w_;
    j = j+1;
end
sys_ = filt(w, 1)
[H, om] = freqz(w, 1, 'whole', length(t));
H_ = (abs(H)).^2;
f_scale = (-length(om)/2:1:length(om)/2-1)*Fs/(length(om));
figure
plot(f_scale, abs(fftshift(H_))/abs(max(H_)));
title("Plot of the transfer function");
xlabel("Frequency in Hz");
ylabel("Amplitude");
% H_fft = fftshift(fft(H_));
% figure
% plot(f_scale, abs(H_fft)));