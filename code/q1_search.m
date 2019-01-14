% ����(ĳ�������
cnc_pos = [1 1 2 2 3 3 4 4]; % ÿ��CNC��Ӧ�Ĺ��λ��
tmove = [18 32 46]; % RGV�ƶ�ʱ��*
tprocess = 545; % CNC�ӹ�һ������ʱ��*
tud = repmat([27 32],1,4); % ��CNC����������ʱ��*
tclean = 25; % ��ϴʱ��*
TARGET = 400; % Ŀ��ӹ�����

order = perms(1:8); %���������������

for j = 1:length(order)

% ����
queue = []; % �ȴ�ָ�����
current_pos = 1; % RGVС����λ�� 1/2/3/4
cnc_now = [0 0 0 0 0 0 0 0]; % CNC��ǰ�ӹ������Ϻţ���ʼ��0
cnc_endtime = [0 0 0 0 0 0 0 0]; % CNC��ǰ�ӹ����ϵĽ���ʱ�䣬��ʼ��0
cnt = 0; % ��ǰ�ӹ�����
cnt_finish = 0; % ��ȫ�ӹ�������
time = 0; % ��ǰ����ʱ��
result = zeros(TARGET,4);  % ��Ž�������Ϻ�/CNC��/���Ͽ�ʼʱ��/���Ͽ�ʼʱ��


% ���������һ�ֵ�ʱ��(�룩
for i = 1:8
    pos = cnc_pos(order(j,i));
    % ���ƶ���+ ����
    if pos == current_pos % �����ƶ���ֱ������
        result(i,1) = i;
        result(i,2) = order(j,i);
        result(i,3) = time;
        time = time + tud(order(j,i)); % ����ʱ������
        cnc_endtime(order(j,i)) = time + tprocess; % ��¼��cnc�����ӹ���ʱ��
        cnc_now(order(j,i)) = i; % ��¼��cnc��ǰ�ӹ������Ϻ�
        
    else % ���ƶ���������
        distance = abs(pos - current_pos);
        time = time + tmove(distance); % �ƶ�ʱ������
        result(i,1) = i;
        result(i,2) = order(j,i);
        result(i,3) = time;
        time = time + tud(order(j,i)); 
        cnc_endtime(order(j,i)) = time + tprocess;
        cnc_now(order(j,i)) = i;
    end
    current_pos = pos; % ���µ�ǰλ��
end

cnt = 8;

while cnt_finish < TARGET
    if time <  min(cnc_endtime)
        time = min(cnc_endtime); % �������CNC�����ڼӹ�״̬,ʱ�䡰�����
        continue;
    else
        queue = checkStatus( time,cnc_endtime );
        assert(isempty(queue)==0, '����Ϊ�գ�')
        % ��������ȷ���
        [idx, dis] = getClosest( current_pos, queue ); % ����RGV����һ��CNCĿ��idx ������
        if dis > 0
            time = time + tmove(dis); % �����Ҫ�ƶ��������ƶ���ʱ��
            current_pos = cnc_pos(idx); % �ƶ�
        end
        % ��/����
        temp = cnc_now(idx); % ��ȡ�������
        result(temp,4) = time; % ��¼���Ͽ�ʼʱ��
        cnt = cnt + 1; % �µ��������ϼӹ�
        result(cnt,1) = cnt;
        result(cnt,2) = idx;
        result(cnt,3) = time; % ��¼���������Ͽ�ʼʱ��
        time = time + tud(idx); % ����ʱ������
        cnc_now(idx) = cnt; %���¼ӹ��������
        cnc_endtime(idx) = time + tprocess; % ���¼ӹ����ʱ��
        time = time + tclean; % ��ϴʱ������
        cnt_finish = cnt_finish + 1;
    end
end
order(j,9) = result(TARGET,4);
if mod(j,4000)==0
    fprintf('%d\n',j);
end
end
[row,column]=find(order==min(order(:,9))); % Ѱ�����ŵ��ǣ�Щ�������
% order(row,:) 
