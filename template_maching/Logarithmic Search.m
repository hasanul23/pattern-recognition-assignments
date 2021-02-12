template1 = double(imread('reference.jpg'));

input = VideoReader('test.MOV');

template = template1(:,:,1);

[M, N]=size(template);


p=7;
k = ceil(log10(p)/log10(2)); 


%out = VideoWriter('output2.MOV');
out = VideoWriter('testOutput2.MOV');
open(out);

minCost=1000000.0;
m1 = 0;
n1 = 0;


testImage1 = double(read(input,1));

testImage= testImage1(:,:,1);
[I,J]=size(testImage);

for m = 1: I-M
   for n = 1 : J-N
       cost = 0.0;
       for i=m : m+M-1
           for j =n : n+N-1

                cost = cost + abs(template(i-m+1,j-n+1)-testImage(i,j));
           end
       end

       if minCost > cost
           minCost = cost;
           m1 = m;
           n1 = n;
       end

    end
end
image1= insertShape(mat2gray(testImage1),'Rectangle',[n1 m1 M N]);
writeVideo(out,image1);
fprintf('1st frame %f %d %d\n',minCost,m1,n1);
% dx = [0 , 0 , p , p , -p , -p, p , -p];
% dy= [ p , - p , p, -p, p, -p, 0, 0];
for frame = 2: 2: input.NumberOfFrames
    testImage1 = double(read(input,frame));
    testImage= testImage1(:,:,1);
    [I,J]=size(testImage);
    
    centerX = m1;
    centerY = n1;
    minCost1= 10000000;
    
    stepSize = 2^(k-1);
    
    while(stepSize >=1)
        for x = -stepSize : stepSize : stepSize        
           for y = -stepSize : stepSize : stepSize 
                 m = x + centerX;
                 n = y + centerY;
                 if(m<1 || m>I || n<1 || n>J)
                     continue;
                 end
                 
                  cost = 0.0;
                  for k = m : m+M-1
                      for l = n: n+N-1
                          if (k<1 || k>I || l<1 || l>J)
                              cost = 1000000;
                              continue
                          end
                          cost = cost + abs(template(k-m+1,l-n+1)-testImage(k,l));
                          %fprintf('cost: %f\n', cost);
                      end
                  end
                  %fprintf('%f %d %d\n',cost,m,n);
                  if(minCost1>cost)
                       minCost1=cost;
                       m1= m;
                       n1= n;    
                  end     
           end
        end
        
        stepSize = stepSize/2;
        centerX =  m1;
        centerY =  n1;
        
    end
    disp(frame)
    image= insertShape(mat2gray(testImage1),'Rectangle',[n1 m1 N M]);
    writeVideo(out,image);
    %fprintf('Frame = %d %f %d %d\n',frame,minCost1,m1,n1);
end
close(out);


       
        

