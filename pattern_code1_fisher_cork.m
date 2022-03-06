clear;
clc;
%读取数据集
data = xlsread('CORK_STOPPERS.xls',2);
x=data(:,3:12);

%特征选择，去掉第二和第十个特征
x(:,10)=[];
x(:,2)=[];

[m,n]=size(x);

acc=0;%平均正确率
fprintf('The accuracy of Fisher classifier for cork dataset:\n');
for k=1:100 %重复实验100次，看每次实验的正确率和错误率
    
%数据集中编号1~50、51~100、101~150，三个区间内的数据是同一类
%划分时在分别在区间1~50、51~100、101~150随机抽取，按8：2的比例划分数据集


%初始化两个矩阵作为训练集和测试集
train=zeros(120,n);
test=zeros(30,n+1);%多一列用来记录预测的分类结果

%第一类中抽40个做训练集，10个做测试集
t=randperm(50);
t1=t(1:40); %训练集编号
t2=t(41:50); %测试集编号

%根据编号选数据
for i=1:40
    for j=1:n
        train(i,j)=x(t1(i),j); 
    end
end
for i=1:10
    for j=1:n
        test(i,j)=x(t2(i),j);
    end
end

%第二类中抽40个做训练集，10个做测试集
b=51:100;
r=randperm(50);
t=b(r);
t1=t(1:40); %训练集编号
t2=t(41:50); %测试集编号

%根据编号选数据
for i=41:80
    for j=1:n
        train(i,j)=x(t1(i-40),j);
    end
end
for i=11:20
    for j=1:n
        test(i,j)=x(t2(i-10),j);
    end
end

%第三类中抽40个做训练集，10个做测试集
c=101:150;
r1=randperm(50);
t=c(r1);
t1=t(1:40); %训练集编号
t2=t(41:50); %测试集编号

%根据编号选数据
for i=81:120
    for j=1:n
        train(i,j)=x(t1(i-80),j);
    end
end
for i=21:30
    for j=1:n
        test(i,j)=x(t2(i-20),j);
    end
end

%三类样本的均值向量
m1=mean(train(1:40,:));
m2=mean(train(41:80,:));
m3=mean(train(81:120,:));

%求三类样本的类内离散度矩阵
s1=zeros(n);
s2=zeros(n);
s3=zeros(n);

for i=1:40
    s1=s1+(train(i,:)-m1)'*(train(i,:)-m1);
end

for i=41:80
    s2=s2+(train(i,:)-m2)'*(train(i,:)-m2);
end

for i=81:120
    s3=s3+(train(i,:)-m3)'*(train(i,:)-m3);
end

%求总类内离散度矩阵
sw12=s1+s2;
sw13=s1+s3;
sw23=s2+s3;

%各类的投影方向
w12=((sw12^-1)*(m1-m2)')';
w13=((sw13^-1)*(m1-m3)')';
w23=((sw23^-1)*(m2-m3)')';

%各类判别函数的阀值T
T12=-0.5*(m1+m2)*inv(sw12)*(m1-m2)';
T13=-0.5*(m1+m3)*inv(sw13)*(m1-m3)';
T23=-0.5*(m2+m3)*inv(sw23)*(m2-m3)';

%将分类结果记录在第11列
for i=1:30
    temp=test(i,1:n);
    g12=w12*temp'+T12;
    g13=w13*temp'+T13;
    g23=w23*temp'+T23;
    if g12>0 && g13>0
        test(i,10)=1;
    elseif g12<0 && g23>0
        test(i,10)=2;
    elseif g13<0 && g23<0
        test(i,10)=3;
    end       
end

%第9列储存原本类别
for i=1:30
    if i<=10
        test(i,9)=1; %测试集前10个原先为第一类
    elseif i<=20
        test(i,9)=2; %测试集中间10个原先为第二类
    else
        test(i,9)=3; %%测试集后10个原先为第三类
    end
end

%分类结果与原先类别比较
right=0;
wrong=0; 
for i=1:30
    if test(i,9)==test(i,10)
        right=right+1;
    else
        wrong=wrong+1;
    end
end
 accuracy=right/30;
 
 fprintf('第%d次实验\t正确率%f\t错误率%f\n',k,accuracy,1-accuracy);
 acc=acc+accuracy;
end
fprintf('fisher分类进行100次重复实验，平均正确率：%f\n',acc/100);











