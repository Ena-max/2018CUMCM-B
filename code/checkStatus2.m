function [ queue1,queue2 ] = checkStatus2( time,endtime,assign )
%checkStatus2 ģ��˫�����龳�¼����ЩCNC�Ѿ�����˼ӹ����񣬴��ڵȴ�״̬
%   queue1��ʾ����1CNC�ȴ����У�queue2��ʾ����2CNC�ȴ�����
queue1 = [];
queue2 = [];
for i = 1:8
    if endtime(i) <= time
        if assign(i)==1
            queue1 = [queue1,i];
        else
            queue2 = [queue2,i];
        end
    end
end
end