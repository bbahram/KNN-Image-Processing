%LBP code

ls=59;


LBPmatrixM=load('LBP matrix of mugs.mat').LBPmatrixM;
LBPmatrixB=load('LBP matrix of bowls.mat').LBPmatrixB;
matrixT=[LBPmatrixM;LBPmatrixB]; %attach two matrix

knn=1;
per=0;
TP=0;
FN=0;
TPR=0;
TN=0;
FP=0;
TNR=0;

for n=1:20
    I=imread(sprintf("YOUR DIRECTORY", n));
    I=rgb2gray(I);
    s=size(I);
    [TLBP]=extractLBPFeatures(I);
    for j=1:164
        ED(j)= sqrt(sum(TLBP()-matrixT(j,:)).^2);
    end
    [temp,tempIndex]=mink(ED, knn);
    Lflag=0;
    Kflag=0;
    for j=1:knn
        if tempIndex(j)<83
            Lflag=Lflag+1;
        else
            Kflag=Kflag+1;
        end
    end
    if Lflag>Kflag
        disp(n+". Mug");
        if n>10
            per=per+1;
            TP=TP+1;
        else
            FP=FP+1;
        end
    else
        disp(n+". Bowl");
        if n<11
            per=per+1;
            TN=TN+1;
        else
            FN=FN+1;
        end
    end
end

TPR=TP/(TP+FN);
TNR=TN/(TN+FP);
disp("KNN: "+knn);
disp("True: "+per*100/20+" %");
disp("TPR: "+ TPR);
disp("TNR: "+ TNR);
disp("FPR: "+ (1-TNR));
disp("FNR: "+ (1-TPR));
disp("Precision: "+TP/(TP+FP));