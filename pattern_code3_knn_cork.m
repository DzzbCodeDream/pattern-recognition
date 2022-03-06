clear;
clc;
%��ȡ���ݼ�
data = xlsread('CORK_STOPPERS.xls',2);
x = data(:,3:12);

%����ѡ��ȥ���ڶ��͵�ʮ������
x(:,10)=[];
x(:,2)=[];

%��¼��ʱ���ݼ��Ĵ�С
[m,n]=size(x);

%��¼���ݼ�ԭʼ�ķ���
x_labels=data(:,2);

sum=0; %100��ʵ��ƽ����ȷ��
count=0; %100��ʵ������ȷ�ʴ���85%%�Ĵ���
for k=1:100   %����һ�ٴ��ظ�ʵ����׼ȷ��

    %����8��2�ı�������ѵ�����Ͳ��Լ�
    train=zeros(120,n);
    train_labels=zeros(120,1);%��¼ѵ�����ı�ǩ
    test=zeros(30,n);
    test_labels=zeros(30,1);%��¼���Լ��ı�ǩ
    
    %����150���������Ϊ��ţ������ѡ������
    t=randperm(150);
    t1=t(1:120); %ѵ�������
    t2=t(121:150); %���Լ����
    
    %����ѵ�����Ͳ��Լ��������Եı�ǩ
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
    
    
    %��¼ѵ�����Ͳ��Լ��Ĵ�С
    [mtrain,ntrain]=size(train);
    [mtest,ntest]=size(test);
    dataset = [train;test];
    
    %���ݵĹ�һ������ʹ����matlab�Դ��Ĺ�һ������mapminmax
    [dataset_scale,ps] = mapminmax(dataset',0,1);
    dataset_scale = dataset_scale';
    train = dataset_scale(1:mtrain,:);
    test = dataset_scale( (mtrain+1):(mtrain+mtest),: );
    
    %����knn����ģ�ͣ�������׼ȷ��
    %matlab���Դ��з���ѧϰ����
    mdl = ClassificationKNN.fit(train,train_labels,'NumNeighbors',5); %kȡ5ʱ������
    predict_label   =   predict(mdl, test);
    accuracy    =  length(find(predict_label == test_labels))/length(test_labels)*100;
    if accuracy >=85
        count=count+1;
    end
   fprintf('��%d��ʵ��\t׼ȷ�ʣ�%f \n',k,accuracy);
   sum=sum+accuracy;

end
fprintf('100��ʵ������ȷ�ʴ���85%%�Ĵ�����%d\n',count);
fprintf('100��ʵ��ƽ����ȷ�ʣ�%f\n',sum/100);




