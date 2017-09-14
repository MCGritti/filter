function NLTest(y)
%NLTest teste de não linearidade
% correl dentro dos bounds = sist. linear; não linear caso contrario

% proposto em
% Billings, S. A.; Voon, W. S. F. (1983). Structure detection and model 
% validity tests in the identification of nonlinear systems. IEE Proceedigs 
% Pt. D, 130(4):193-199.

% descrito em detalhes em 
% Billings S.A. "Nonlinear System Identification: NARMAX Methods in the
% Time, Frequency, and Spatio-Temporal Domains". Wiley, 2013 (p. 121)

N = length(y);
LAG = 20;
y_prime = y-mean(y);
coefs_nl = crosscorr(y_prime,y_prime.^2,LAG);
conf=1.96/sqrt(N);
figure
plot(-LAG:LAG,coefs_nl,'k-'); hold on
plot([-LAG LAG],[conf -conf;conf -conf],'k:');hold off
xlim([-LAG LAG]);
ylim([-1 1]);
% ylabel('$\phi_{y''y''^2}(\tau)$','Interpreter','LaTex')
% xlabel('$\tau$','Interpreter','LaTex')
ylabel('\phi_{y''y''^2}(\tau)','FontSize',16)
xlabel('\tau','FontSize',16)



