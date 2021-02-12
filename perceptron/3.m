fileID = fopen('testLinearlyNonSeparable.txt','r');

%for training data
% tline = fgets(fileID);
% A = sscanf(tline,'%f');
% feature_size=A(1);
% class_size=A(2);
% sample_size=A(3);
% formatSpec='%f %f %f %f %d';

%for test data
feature_size=4;
class_size=2;
sample_size=500;
%fprintf('%d %d %d\n',feature_size,class_size,sample_size);
formatSpec = '%f %f %f %f %d';


sizeA = [feature_size+1 sample_size];
A=fscanf(fileID,formatSpec,sizeA);  % r=feature_size+1,c=sample_size 
%fprintf('%f %f %f %f %d\n',A);
fclose(fileID);

data=A(1:feature_size,:);   % r=feature_size,c=sample_size 
class=A(feature_size+1,:);  % r=1,c=sample_size 
%fprintf('%d\n',class);
%fprintf('%f %f\n',data);

%X1=data(1,:);
%X2=data(2,:);
%gscatter(X1,X2,class,'br','xo');hold on;


rho = 0.7; 
maxIters = 1000;

% Append +1 to all data: 
data=[data',ones(size(data,2),1)]; % 400 5
data=data'; % 5 400
%fprintf('%d %d\n',size(data));
l_extended = size(data,1);
%fprintf('%d\n',l_extended);
w_i = randn(size(data,1),1); % initial weight vector 


[l,N]=size(data);
w=w_i;

w_s=w;  %save in the pocket
h_s=0;  %history count=number of correctly classified sample

iter=0;
mis_class=N;

y=class;
for i=1:N
    if(class(i)==1)
        y(i)=1;
    else
        y(i)=-1;
    end
end

%fprintf('%d\n',y);
while (mis_class>0)&&(iter<maxIters)
    iter=iter+1;
    mis_class=0;
    gradi=zeros(l,1);
    
    for i=1:N
        if((data(:,i)'*w)*y(i)<0)
            mis_class=mis_class+1;
            gradi=gradi+rho*(-y(i)*data(:,i));
        end
    end
    w1=w-rho*gradi;
    h=N-mis_class;  %correctly classified
    
    if(h>h_s)
        w_s=w1;
        h_s=h;
    end
    w=w1;
end

predicted_class=zeros(1,sample_size);
for i=1:N
    if(data(:,i)'*w>0)
        predicted_class(i)=1;
    else
        predicted_class(i)=2;
    end     
end
true_positive =0;
false_positive =0;
true_negative =0;
false_negative =0;
for i=1:N
    if (class(i)==1 && predicted_class(i)==1)
        true_positive=true_positive+1;
    elseif (class(i)==2 && predicted_class(i)==1)
            false_positive=false_positive+1;
    elseif (class(i)==1 && predicted_class(i)==2)
            false_negative=false_negative+1;
    elseif (class(i)==2 && predicted_class(i)==2)
            true_negative=true_negative+1;
    end
        
end


g=sprintf('%d ', w);
fprintf('Weight Vector: %s\n', g)

condition_positive = true_positive + false_negative;
condition_negative = false_positive + true_negative;
test_outcome_positive = true_positive + false_positive;
test_outcome_negative = false_negative + true_negative;
total_population = condition_positive + condition_negative;

accuracy = (true_positive + true_negative)/double(total_population);
PPV = true_positive/double(test_outcome_positive); %precision
TPR = true_positive/double(condition_positive);  %recall  
fprintf('Accuracy: %f\n',accuracy*100);
fprintf('Precision: %f\n',PPV*100);
fprintf('Recall: %f\n',TPR*100);


x1_grid = linspace( min(data(1,:)), max(data(1,:)),50);
x2_db   = ( -w(3) - w(1) * x1_grid ) / w(2);
plot( x1_grid, x2_db, '-g' );
title('perceptron computed decision line');