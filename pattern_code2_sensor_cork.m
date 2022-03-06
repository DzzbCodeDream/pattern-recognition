clc;
clear;
%读取数据集
data = xlsread('CORK_STOPPERS.xls',2);

x=data(:,2:end);%去除编号

%去除第十和第二特征
x(:,11)=[];
x(:,3)=[];

%将样本写成增广矩阵
x(:,10)=1;

N=10^4;%迭代次数

acc=0;%平均正确率
for q=1:20 %重复多次实验看每次实验的正确率和错误率

%初始化两个矩阵作为训练集和测试集
train=zeros(120,10);
test=zeros(30,11);

%按照8：2的比例划分训练集和测试集
t=randperm(150);
t1=t(1:120);
t2=t(121:150);
for i=1:120
    for j=1:10
        train(i,j)=x(t1(i),j);
    end
end
for i=1:30
    for j=1:10
        test(i,j)=x(t2(i),j);
    end
end

%初始增广权向量
w1=zeros(1,9);
w2=zeros(1,9);
w3=zeros(1,9);

%训练第一类权向量
for k=1:N 
    ischange=0;%用于判断权向量是否发生变化，0表示不变，非0表示变
    for i=1:120
        temp=train(i,2:10);
        y1=w1*temp';
        if train(i,1)==1 && y1<=0
            w1=w1+temp;
            ischange=1;
        else
            if train(i,1)~=1 && y1>=0
                w1=w1-temp;
                ischange=1;
            end
        end
    end
    if ischange==0 %若不变，则找到权向量
        break;
    end
end

%训练第二类权向量
for k=1:N
    ischange=0; %用于判断权向量是否发生变化，0表示不变，非0表示变
    for i=1:120
        temp=train(i,2:10);
        y2=w2*temp';
        if train(i,1)==2 && y2<=0
            w2=w2+temp;
            ischange=1;
        else
            if train(i,1)~=2 && y2>=0
                w2=w2-temp;
                ischange=1;
            end
        end
    end
    if ischange==0 %若不变，则找到权向量
        break;
    end
end

%训练第三类权向量
for k=1:N 
    ischange=0; %用于判断权向量是否发生变化，0表示不变，非0表示变
    for i=1:120
        temp=train(i,2:10);
        y3=w3*temp';
        if train(i,1)==3 && y3<=0
            w3=w3+temp;
            ischange=1;
        else
            if train(i,1)~=3 && y3>=0
                w3=w3-temp;
                ischange=1;
            end
        end
    end
    if ischange==0  %若不变，则找到权向量
        break;
    end
end

%由得到权向量对测试集进行分类
for i=1:30
    temp=test(i,2:10);
    result1=w1*temp';
    result2=w2*temp';
    result3=w3*temp';
    result =max([result1,result2,result3]);
    if result == result1
        test(i,11)=1;
    else
        if result == result2;
            test(i,11)=2;
        else
            test(i,11)=3;
        end
    end
end

count=0; %记录分类正确次数
for i=1:30
    if test(i,1)==test(i,11)
        count=count+1;
    end
end

accuracy=count/30;

fprintf('第%d次实验的正确率：%f \n',q,accuracy);
acc=acc+accuracy;
end

fprintf('感知器进行%d实验平均正确率：%f\n',q,acc/q);

