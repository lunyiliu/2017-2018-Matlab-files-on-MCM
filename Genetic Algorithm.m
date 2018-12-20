
%1、确定初始种群
N=100;
c=1.7;
popsize=100;
iter=60;
x_group=zeros(popsize,N);
x_BGC_group=zeros(popsize,4*N);
time_group_=zeros(1,popsize);
time_group=zeros(1,popsize);
eva_group=zeros(1,popsize);
%种群数量100
%{
for i=1:popsize
    %1、生成x(保证初始解在一个比较好的范围内
    x=[];
    for j=1:12
    x=[x,randperm(8)];
    end
    x=[x,randperm(4)];
    x_group(i,:)=x;
end
%}
%种群数量250

for i=1:popsize
    %1、生成x(保证初始解在一个比较好的范围内
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
%2、编码
x_BGC=num2BGC(x_group(i,:));
x_BGC_group(i,:)=x_BGC;
%3、计算适应度（线性调整适应度）
    time_group_(i)=eva_no_con(x_group(i,:));%该适应度是没有约束的一道工序目标函数
    time_group(i)=- time_group_(i);
end
eva_group=time_group;
        %线性调整
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
    
%4、选择（采用基于种群的按个体适应度大小排序的选择算法）
        [~,I]=sort(eva_group,'descend');
        %展示
         plot(q,eva_group(I(1)),'+')
         hold on 
        %优良个体复制两份，一般个体一份，劣质个体不复制
       mate_pool= [x_BGC_group(I(1:30),:);x_BGC_group(I(1:30),:);x_BGC_group(I(31:70),:)];
       %随机选择两个个体(选择10次）
       good_son=zeros(20,4*N);
       for j=1:10
       choose=ceil(rand(1,2)*size(mate_pool,1));
%5、交叉(选择的两个个体多次交叉）（共有20个新个体产生）
            %三点交叉(不能破坏编码）（交叉多次）(兄弟竞争）(兄弟间择优）
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
%6、变异(从优秀的父代个体中产生变异补充进新个体）（变异10个,每个个体变异率百分之5）
        for i=1:10
            rand_=randperm(N);
            val=new_group(i,rand_(1:5))+1;
            val(val==2)=0;
            new_group(i+90,rand_(1:5))=val;
        end
%7、展示(在计算适应度那里展示）
for i=1:popsize
x_group(i,:)=BGC2num(new_group(i,:));
end
end
%8、结束
for i=1:popsize
     time_group_(i)=eva_no_con(x_group(i,:));%该适应度是没有约束的一道工序目标函数
   
end
[~,I_final]=sort(time_group_,'ascend');
x=x_group(I_final(1),:);
