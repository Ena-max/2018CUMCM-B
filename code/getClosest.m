function [ closeIdx, min ] = getClosest( pos, queue )
%getClosest �ҵ������о��뵱ǰλ���������� ������ź;���
closeIdx = -1;
min = 5;
num = length(queue);
for i = 1:num
    if abs(ceil(queue(i)/2) - pos) < min
        min =  abs(ceil(queue(i)/2) - pos);
        closeIdx = queue(i);
    end
end

end

