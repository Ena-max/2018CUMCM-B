function [ num, order] = getAssign( time1,time2 )
%getAssign ���ݹ���1������2��ʱ�䣬������ʵķ����������������һCNC���е��������
num = 4;
loss = 99999;
order = [];
for i = 1:7
    if abs(i/time1 - (8-i)/time2) < loss
        loss = abs(i/time1 - (8-i)/time2);
        num = i;
    end
end
% ��������
temp = nchoosek(1:8, num);
for i = 1:length(temp)
    order = [order; perms(temp(i,:))];
end
end

