%Hybrid code

LBPmatrixM=load('LBP matrix of mugs.mat').LBPmatrixM;
LBPmatrixB=load('LBP matrix of bolws.mat').LBPmatrixB;
LBPmatrixC=[LBPmatrixM;LBPmatrixB]; %attach two matrix
HOGmatrixM=load('HOG matrix of mugs.mat').HOGmatrixM;
HOGmatrixB=load('HOG matrix of bowls.mat').HOGmatrixB;
HOGmatrixC=[HOGmatrixM;HOGmatrixB]; %attach two matrix

knn=5;
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
    [THOG]=extractHOGFeatures(I, 'CellSize', round(s/4), 'BlockSize', [1 1], 'NumBins', hs);
    for j=1:164
        HOGed(j)= sqrt(sum(THOG()-HOGmatrixC(j,:)).^2);
        LBPed(j)= sqrt(sum(TLBP()-LBPmatrixC(j,:)).^2);
    end
    [HOGtemp,HOGtempIndex]=mink(HOGed, knn);
    [LBPtemp,LBPtempIndex]=mink(LBPed, knn);
    LHOGflag=0;
    LLBPflag=0;
    KHOGflag=0;
    KLBPflag=0;
    for j=1:knn
        if HOGtempIndex(j)<83
            LHOGflag=LHOGflag+1;
        else
            KHOGflag=KHOGflag+1;
        end
        if LBPtempIndex(j)<83
            LLBPflag=LLBPflag+1;
        else
            KLBPflag=KLBPflag+1;
        end
    end
    if (LHOGflag+LLBPflag)>(KHOGflag+KLBPflag)
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