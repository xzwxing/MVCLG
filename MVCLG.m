function [Z,F_views] = MVCLG(X,num_views,numCluster,nSmp,lambda_1,K)

sigma=0.1;
eps=1e-7;

D=cell(1,num_views);
Z = zeros(nSmp,nSmp);
F_views = cell(1,num_views);
Z_views = cell(1,num_views);
U = cell(1,num_views);

alpha = ones(1,num_views)*(1/num_views);
options = [2.5;100;1e-5;0]; %FCM control parameters
dim = zeros(num_views,1);
%% Initialization
for v = 1:num_views
    if size(X{v},2)~=nSmp %One column is a sample
         X{v} = X{v}';
    end
    dim(v)= size(X{v},1); %Feature dimension dv 
    X{v}=normalize(X{v},'range');%Data normalization
    [~,Fv,~] =fcm(X{v}',numCluster,options);
    F_views{v} = Fv';
    U{v}=rand(dim(v),numCluster);
    Z_views{v} = constructW_PKN(X{v},K,1);
end
for v = 1:num_views
   Z = Z + Z_views{v}./num_views; 
end

MaxIter = 50; 
for i = 1:MaxIter
%%  Update U{v}, F{v}, Z, alpha(v) 
    for v = 1:num_views
        %% Update U{v}
        for j=1:size(X{v},1)
            row=X{v}(j,:)-U{v}(j,:)*F_views{v}';
            norm_row = norm(row,2);
            D{v}(j,j)=(1+sigma).*((2.*(norm_row+sigma).^2)\(norm_row+2.*sigma));
        end
        Utop=D{v}*X{v}*F_views{v};
        Udown=D{v}*U{v}*F_views{v}'*F_views{v}+eps;
        UFrac=Utop./Udown;
        U{v}=U{v}.*UFrac;
               
        %% Update F{v}
        Ftop=X{v}'*D{v}*U{v}+2*alpha(v).*Z*F_views{v};
        Fdown=F_views{v}*U{v}'*D{v}*U{v}+2*alpha(v).*F_views{v}*F_views{v}'*F_views{v};
        FFrac=Ftop./Fdown;
        F_views{v}=F_views{v}.*FFrac; 

    end

    %% Update Z

    G = zeros(nSmp,nSmp);
    T = zeros(nSmp,nSmp);
    Aalpha=0;
    for v = 1:num_views
        G=G+X{v}'*X{v};
        T=T+alpha(v).*F_views{v}*F_views{v}';
        Aalpha=Aalpha+alpha(v);
    end
    Ztop =2*lambda_1*G+2*T;
    Zdown =2*lambda_1*G*Z+2*Aalpha*Z;
    ZFrac=Ztop./Zdown;
    Z=Z.*ZFrac;
    Z=Z-diag(diag(Z));
    
    %% Update alpha(v)
    for v = 1:num_views
        alpha(v) = 1/(2*sqrt(norm(Z-F_views{v}*F_views{v}',"fro").^2+eps)); 
    end
   
end















