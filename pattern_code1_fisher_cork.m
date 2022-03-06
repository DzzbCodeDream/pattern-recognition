clear;
clc;
%��ȡ���ݼ�
data = xlsread('CORK_STOPPERS.xls',2);
x=data(:,3:12);

%����ѡ��ȥ���ڶ��͵�ʮ������
x(:,10)=[];
x(:,2)=[];

[m,n]=size(x);

acc=0;%ƽ����ȷ��
fprintf('The accuracy of Fisher classifier for cork dataset:\n');
for k=1:100 %�ظ�ʵ��100�Σ���ÿ��ʵ�����ȷ�ʺʹ�����
    
%���ݼ��б��1~50��51~100��101~150�����������ڵ�������ͬһ��
%����ʱ�ڷֱ�������1~50��51~100��101~150�����ȡ����8��2�ı����������ݼ�


%��ʼ������������Ϊѵ�����Ͳ��Լ�
train=zeros(120,n);
test=zeros(30,n+1);%��һ��������¼Ԥ��ķ�����

%��һ���г�40����ѵ������10�������Լ�
t=randperm(50);
t1=t(1:40); %ѵ�������
t2=t(41:50); %���Լ����

%���ݱ��ѡ����
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

%�ڶ����г�40����ѵ������10�������Լ�
b=51:100;
r=randperm(50);
t=b(r);
t1=t(1:40); %ѵ�������
t2=t(41:50); %���Լ����

%���ݱ��ѡ����
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

%�������г�40����ѵ������10�������Լ�
c=101:150;
r1=randperm(50);
t=c(r1);
t1=t(1:40); %ѵ�������
t2=t(41:50); %���Լ����

%���ݱ��ѡ����
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

%���������ľ�ֵ����
m1=mean(train(1:40,:));
m2=mean(train(41:80,:));
m3=mean(train(81:120,:));

%������������������ɢ�Ⱦ���
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

%����������ɢ�Ⱦ���
sw12=s1+s2;
sw13=s1+s3;
sw23=s2+s3;

%�����ͶӰ����
w12=((sw12^-1)*(m1-m2)')';
w13=((sw13^-1)*(m1-m3)')';
w23=((sw23^-1)*(m2-m3)')';

%�����б����ķ�ֵT
T12=-0.5*(m1+m2)*inv(sw12)*(m1-m2)';
T13=-0.5*(m1+m3)*inv(sw13)*(m1-m3)';
T23=-0.5*(m2+m3)*inv(sw23)*(m2-m3)';

%����������¼�ڵ�11��
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

%��9�д���ԭ�����
for i=1:30
    if i<=10
        test(i,9)=1; %���Լ�ǰ10��ԭ��Ϊ��һ��
    elseif i<=20
        test(i,9)=2; %���Լ��м�10��ԭ��Ϊ�ڶ���
    else
        test(i,9)=3; %%���Լ���10��ԭ��Ϊ������
    end
end

%��������ԭ�����Ƚ�
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
 
 fprintf('��%d��ʵ��\t��ȷ��%f\t������%f\n',k,accuracy,1-accuracy);
 acc=acc+accuracy;
end
fprintf('fisher�������100���ظ�ʵ�飬ƽ����ȷ�ʣ�%f\n',acc/100);











