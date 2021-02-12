template1 = double(imread('reference.jpg'));

template = template1(:,:,1); %only red component


out = VideoWriter('testOutput1.MOV');
open(out);

%template=[4 2; 3 5];
%testImage=[3 4 4 2; 3 5 4 2; 8 7 3 5; 3 5 4 2];
[M,N]=size(template);


input = VideoReader('test.MOV');
for frame = 1: 3 : 6
    testImage1 = double(read(input,frame));
    testImage= testImage1(:,:,1);
    [I,J]=size(testImage);
    
    disp(frame);
    C=1000000.0;
    m1 = 0;
    n1 = 0;
    for m = 1: I-M
       for n = 1 : J-N
           cost = 0.0;
           for i=m : m+M-1
               for j =n : n+N-1
                   
                    cost = cost + abs(template(i-m+1,j-n+1)-testImage(i,j));
               end
           end
          
           if C > cost
               C = cost;
               m1 = m;
               n1 = n;
           end
        
        end
    end
    
    image= insertShape(mat2gray(testImage1),'Rectangle',[n1 m1 M N]);
    writeVideo(out,image);
    
end
close(out);

    
    
     
     
  
   