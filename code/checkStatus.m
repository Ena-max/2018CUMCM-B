function [ queue ] = checkStatus( time,endtime )
%checkStatus ����������¼����ЩCNC�Ѿ�����˼ӹ����񣬴��ڵȴ�״̬
queue = [];
for i = 1:8
    if endtime(i) <= time
        queue = [queue,i];
    end
end
end

