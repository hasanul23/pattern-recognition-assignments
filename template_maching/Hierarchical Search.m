template1 = double(imread('reference.jpg'));

input = VideoReader('test.MOV');


%out = VideoWriter('output3.MOV');
out = VideoWriter('testOutput3.MOV');
open(out);

p=7;

l0_template = template1(:,:,1);
l1_template = imresize(l0_template,0.5);
l2_template = imresize(l1_template,0.5);


for frame = 1: 2 : input.NumberOfFrames
      testImage1 = double(read(input,frame));
      
      l0_testImage = testImage1(:,:,1);
      l1_testImage = imresize(l0_testImage,0.5);
      l2_testImage = imresize(l1_testImage,0.5);
      
      %Level 2 image start---------------
      
      [M2,N2]=size(l2_template);
      [I2,J2] = size(l2_testImage);
      C=1000000.0;
        x1 = 0;
        y1 = 0;
        for m = 1: I2-M2
           for n = 1 : J2-N2
               cost = 0.0;
               for i=m : m+M2-1
                   for j =n : n+N2-1

                        cost = cost + abs(l2_template(i-m+1,j-n+1)-l2_testImage(i,j));
                   end
               end

               if C > cost
                   C = cost;
                   x1 = m;
                   y1 = n;
               end

            end
        end
        
        % Level 2 image end-------------------
        
        %Level 1 image start-----------------
        
        p=4;
        k = ceil(log10(p)/log10(2));


        [M1,N1]=size(l1_template);
        [I1,J1] = size(l1_testImage);
        minCost1 = 1000000.0;
        x2 = 0;
        y2 = 0;
        centerX = 2*x1;
        centerY = 2*y1;
        stepSize = 2^(k-1);
        while(stepSize >=1)
            for x = -stepSize : stepSize : stepSize        
               for y = -stepSize : stepSize : stepSize 
                     m = x + centerX;
                     n = y + centerY;
                     if(m<1 || m>I1 || n<1 || n>J1)
                         continue;
                     end

                      cost = 0.0;
                      for k = m : m+M1-1
                          for l = n: n+N1-1
                              if (k<1 || k>I1 || l<1 || l>J1)
                                  cost = 1000000;
                                  continue
                              end
                              cost = cost + abs(l1_template(k-m+1,l-n+1)-l1_testImage(k,l));
                              %fprintf('cost: %f\n', cost);
                          end
                      end
                      %fprintf('%f %d %d\n',cost,m,n);
                      if(minCost1>cost)
                           minCost1=cost;
                           x2= m;
                           y2= n;    
                      end     
               end
            end

            stepSize = stepSize/2;
            centerX =  x2;
            centerY =  y2;
        end

         %Level 1 image ends------------------
         
         %Level 0 image start-------------
        
        [M,N]=size(l0_template);
        [I,J] = size(l0_testImage);
        minCost2 = 1000000.0;
        x3 = 0;
        y3 = 0;
        centerX = 2*x2;
        centerY = 2*y2;
        stepSize1 = 2^(k-1); 
        
        
         while(stepSize1 >=1)
            for x = -stepSize1 : stepSize1 : stepSize1        
               for y = -stepSize1 : stepSize1 : stepSize1 
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
                              cost = cost + abs(l0_template(k-m+1,l-n+1)-l0_testImage(k,l));
                              %fprintf('cost: %f\n', cost);
                          end
                      end
                      %fprintf('%f %d %d\n',cost,m,n);
                      if(minCost2>cost)
                           minCost2=cost;
                           x3= m;
                           y3= n;    
                      end     
               end
            end

            stepSize1 = stepSize1/2;
            centerX =  x3;
            centerY =  y3;
         end
         
        disp(frame);
        image3= insertShape(mat2gray(l0_testImage),'Rectangle',[y3 x3 N M]);
        writeVideo(out,image3);
        %Level 0 image end-------------------------------------------------
        
        

end

close(out);
%l1_testImage = imfilter(imresize(l0_testImage,0.5),h);
%l2_testImage = imfilter(imresize(l1_testImage,0.5),h);

%fprintf('%d %d %d %d\n',M,N,I,J);

%image1= insertShape(mat2gray(l2_testImage),'Rectangle',[y1 x1 M2 N2]);
%imshow(image1);
%fprintf('%f %d %d\n',C,x1,y1);


 


%fprintf('%f %d %d\n',minCost1,x2,y2);
%image2= insertShape(mat2gray(l1_testImage),'Rectangle',[y2 x2 M1 N1]);
%imshow(image2);






%fprintf('%f %d %d\n',minCost2,x3,y3);

%imshow(image3);

