
%1��ȷ����ʼ��Ⱥ
N=100;
c=1.7;
popsize=100;
iter=60;
x_group=zeros(popsize,N);
x_BGC_group=zeros(popsize,4*N);
time_group_=zeros(1,popsize);
time_group=zeros(1,popsize);
eva_group=zeros(1,popsize);
%��Ⱥ����100
%{
for i=1:popsize
    %1������x(��֤��ʼ����һ���ȽϺõķ�Χ��
    x=[];
    for j=1:12
    x=[x,randperm(8)];
    end
    x=[x,randperm(4)];
    x_group(i,:)=x;
end
%}
%��Ⱥ����250

for i=1:popsize
    %1������x(��֤��ʼ����һ���ȽϺõķ�Χ��
    x=[];
    for j=1:12
    x=[x,randperm(8)];
    end
    x=[x,randperm(4)];
    x_group(i,:)=x;
end
for q=1:iter
    q
for i=1:popsize
%2������
x_BGC=num2BGC(x_group(i,:));
x_BGC_group(i,:)=x_BGC;
%3��������Ӧ�ȣ����Ե�����Ӧ�ȣ�
    time_group_(i)=eva_no_con(x_group(i,:));%����Ӧ����û��Լ����һ������Ŀ�꺯��
    time_group(i)=- time_group_(i);
end
eva_group=time_group;
        %���Ե���
        %{
        f_min=min(time_group);
        f_max=max(time_group);
        f_avg=mean(time_group);
        if f_min>(c*f_avg-f_max)/(c-1)
            a=(c-1)*f_avg/(f_max-f_avg);
            b=f_avg*(f_max-c*f_avg)/(f_max-f_avg);
            eva_group=a*time_group+b;
        else
            a=f_avg/(f_avg-f_min);
            b=-f_avg*f_min/(f_avg-f_min);
            eva_group=a*time_group+b;
        end
%}
    
%4��ѡ�񣨲��û�����Ⱥ�İ�������Ӧ�ȴ�С�����ѡ���㷨��
        [~,I]=sort(eva_group,'descend');
        %չʾ
         plot(q,eva_group(I(1)),'+')
         hold on 
        %�������帴�����ݣ�һ�����һ�ݣ����ʸ��岻����
       mate_pool= [x_BGC_group(I(1:30),:);x_BGC_group(I(1:30),:);x_BGC_group(I(31:70),:)];
       %���ѡ����������(ѡ��10�Σ�
       good_son=zeros(20,4*N);
       for j=1:10
       choose=ceil(rand(1,2)*size(mate_pool,1));
%5������(ѡ������������ν��棩������20���¸��������
            %���㽻��(�����ƻ����룩�������Σ�(�ֵܾ�����(�ֵܼ����ţ�
            son_group=zeros(20,4*N);
            son_eva=zeros(20,1);
            for i=1:10
            father=mate_pool(choose(1),:);
            mother=mate_pool(choose(2),:);
            r=1:4:4*N-3;
            r_=randperm(length(r));
         cross_point=sort(r(r_(1:3)),'ascend');
         swap=father(1:cross_point(1));
         father(1:cross_point(1))=mother(1:cross_point(1));
         mother(1:cross_point(1))=swap;
          swap=father(cross_point(2):cross_point(3));
          father(cross_point(2):cross_point(3))=mother(cross_point(2):cross_point(3));   
          mother(cross_point(2):cross_point(3))=swap;
          son_group(i,:)=father;
          son_group(i+10,:)=mother;
           son_eva(i)=-eva_no_con(BGC2num(father));
          son_eva(i+10)=-eva_no_con(BGC2num(mother));
          %{
          son_eva(i)=a*(-eva_no_con(BGC2num(father)))+b;
          son_eva(i+10)=a*(-eva_no_con(BGC2num(mother)))+b;
          %}
            end
           [~,I_son]=sort(son_eva,'descend');
           good_son(j,:)=son_group(I_son(1),:);
           good_son(j+10,:)=son_group(I_son(2),:);
       end
       new_group=[x_BGC_group(I(1:80),:);good_son];
%6������(������ĸ��������в������첹����¸��壩������10��,ÿ����������ʰٷ�֮5��
        for i=1:10
            rand_=randperm(N);
            val=new_group(i,rand_(1:5))+1;
            val(val==2)=0;
            new_group(i+90,rand_(1:5))=val;
        end
%7��չʾ(�ڼ�����Ӧ������չʾ��
for i=1:popsize
x_group(i,:)=BGC2num(new_group(i,:));
end
end
%8������
for i=1:popsize
     time_group_(i)=eva_no_con(x_group(i,:));%����Ӧ����û��Լ����һ������Ŀ�꺯��
   
end
[~,I_final]=sort(time_group_,'ascend');
x=x_group(I_final(1),:);
