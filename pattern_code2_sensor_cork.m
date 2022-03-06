clc;
clear;
%��ȡ���ݼ�
data = xlsread('CORK_STOPPERS.xls',2);

x=data(:,2:end);%ȥ�����

%ȥ����ʮ�͵ڶ�����
x(:,11)=[];
x(:,3)=[];

%������д���������
x(:,10)=1;

N=10^4;%��������

acc=0;%ƽ����ȷ��
for q=1:20 %�ظ����ʵ�鿴ÿ��ʵ�����ȷ�ʺʹ�����

%��ʼ������������Ϊѵ�����Ͳ��Լ�
train=zeros(120,10);
test=zeros(30,11);

%����8��2�ı�������ѵ�����Ͳ��Լ�
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

%��ʼ����Ȩ����
w1=zeros(1,9);
w2=zeros(1,9);
w3=zeros(1,9);

%ѵ����һ��Ȩ����
for k=1:N 
    ischange=0;%�����ж�Ȩ�����Ƿ����仯��0��ʾ���䣬��0��ʾ��
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
    if ischange==0 %�����䣬���ҵ�Ȩ����
        break;
    end
end

%ѵ���ڶ���Ȩ����
for k=1:N
    ischange=0; %�����ж�Ȩ�����Ƿ����仯��0��ʾ���䣬��0��ʾ��
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
    if ischange==0 %�����䣬���ҵ�Ȩ����
        break;
    end
end

%ѵ��������Ȩ����
for k=1:N 
    ischange=0; %�����ж�Ȩ�����Ƿ����仯��0��ʾ���䣬��0��ʾ��
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
    if ischange==0  %�����䣬���ҵ�Ȩ����
        break;
    end
end

%�ɵõ�Ȩ�����Բ��Լ����з���
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

count=0; %��¼������ȷ����
for i=1:30
    if test(i,1)==test(i,11)
        count=count+1;
    end
end

accuracy=count/30;

fprintf('��%d��ʵ�����ȷ�ʣ�%f \n',q,accuracy);
acc=acc+accuracy;
end

fprintf('��֪������%dʵ��ƽ����ȷ�ʣ�%f\n',q,acc/q);

