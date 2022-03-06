clear;
clc;
%读取数据集
data = xlsread('CORK_STOPPERS.xls',2);
x = data(:,3:12);

%特征选择，去掉第二和第十个特征
x(:,10)=[];
x(:,2)=[];

%记录此时数据集的大小
[m,n]=size(x);

%记录数据集原始的分类
x_labels=data(:,2);

sum=0; %100次实验平均正确率
count=0; %100次实验中正确率大于85%%的次数
for k=1:100   %进行一百次重复实验求准确率

    %按照8：2的比例划分训练集和测试集
    train=zeros(120,n);
    train_labels=zeros(120,1);%记录训练集的标签
    test=zeros(30,n);
    test_labels=zeros(30,1);%记录测试集的标签
    
    %产生150个随机数作为编号，按编号选择数据
    t=randperm(150);
    t1=t(1:120); %训练集编号
    t2=t(121:150); %测试集编号
    
    %读入训练集和测试集，及各自的标签
    for i=1:120
        for j=1:n
            train(i,j)=x(t1(i),j);
        end
        train_labels(i)=x_labels(t1(i));
    end
    for i=1:30
        for j=1:n
            test(i,j)=x(t2(i),j);
        end
        test_labels(i)=x_labels(t2(i));
    end
    
    
    %记录训练集和测试集的大小
    [mtrain,ntrain]=size(train);
    [mtest,ntest]=size(test);
    dataset = [train;test];
    
    %数据的归一化处理，使用了matlab自带的归一化函数mapminmax
    [dataset_scale,ps] = mapminmax(dataset',0,1);
    dataset_scale = dataset_scale';
    train = dataset_scale(1:mtrain,:);
    test = dataset_scale( (mtrain+1):(mtrain+mtest),: );
    
    %构建knn分类模型，并计算准确率
    %matlab中自带有分类学习工具
    mdl = ClassificationKNN.fit(train,train_labels,'NumNeighbors',5); %k取5时结果最好
    predict_label   =   predict(mdl, test);
    accuracy    =  length(find(predict_label == test_labels))/length(test_labels)*100;
    if accuracy >=85
        count=count+1;
    end
   fprintf('第%d次实验\t准确率：%f \n',k,accuracy);
   sum=sum+accuracy;

end
fprintf('100次实验中正确率大于85%%的次数：%d\n',count);
fprintf('100次实验平均正确率：%f\n',sum/100);




