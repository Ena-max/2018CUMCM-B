% ģ�����״̬�����ѡ��һ̨CNC�������ϣ�����ʱ�����������ʱ���ڷ�Χ�������
breakdown_idx = unidrnd(8);
breakdown_start = unidrnd(8*60*60);
breakdown_end = breakdown_start + 10*60 + unidrnd(10*60);
fprintf('���ϵ���%d��,%d -- %d\n',breakdown_idx,breakdown_start,breakdown_end);
% ����
cnc_pos = [1 1 2 2 3 3 4 4]; % ÿ��CNC��Ӧ�Ĺ��λ��
tmove = [23 41 59]; % RGV�ƶ�ʱ��*
tprocess = 560; % CNC�ӹ�һ������ʱ��*
tud = repmat([28 31],1,4); % ��CNC����������ʱ��*
tclean = 25; % ��ϴʱ��*
TARGET = 400; % Ŀ��ӹ�����

order = [1 3 5 7 8 6 4 2];
% ����
queue = []; % �ȴ�ָ�����
current_pos = 1; % RGVС����λ�� 1/2/3/4
cnc_now = [0 0 0 0 0 0 0 0]; % CNC��ǰ�ӹ������Ϻţ���ʼ��0
cnc_endtime = [0 0 0 0 0 0 0 0]; % CNC��ǰ�ӹ����ϵĽ���ʱ�䣬��ʼ��0
cnt = 0; % ��ǰ�ӹ�����
cnt_finish = 0; % ��ȫ�ӹ�������
time = 0; % ��ǰ����ʱ��
% ��������󣨶�Ӧexcle���
result = zeros(TARGET,4);  % ���Ϻ�/CNC��/���Ͽ�ʼʱ��/���Ͽ�ʼʱ��


% ���������һ�ֵ�ʱ��(�룩
for i = 1:8
    pos = cnc_pos(order(i));
    % ���ƶ���+ ����
    if pos == current_pos % �����ƶ���ֱ������
        result(i,1) = i;
        result(i,2) = order(i);
        result(i,3) = time;
        time = time + tud(order(i)); % ����ʱ������
        cnc_endtime(order(i)) = time + tprocess; % ��¼��cnc�����ӹ���ʱ��
        cnc_now(order(i)) = i; % ��¼��cnc��ǰ�ӹ������Ϻ�

    else % ���ƶ���������
        distance = abs(pos - current_pos);
        time = time + tmove(distance); % �ƶ�ʱ������
        result(i,1) = i;
        result(i,2) = order(i);
        result(i,3) = time;
        time = time + tud(order(i)); 
        cnc_endtime(order(i)) = time + tprocess;
        cnc_now(order(i)) = i;
        
    end
    current_pos = pos; % ���µ�ǰλ��
end

cnt = 8;
breakdown_flag = 1; % �ڱ����� ���ƻָ�����ʱ��Ĳ��� ִֻ��һ��
complete_flag = 1; % �ڱ����� ���ơ�����ʱ�Ƿ��ڼӹ�״̬���ļ��ֻ����һ��
is_compelete = 0;

while cnt_finish < TARGET
    if time >= breakdown_start && time <= breakdown_end
        if cnc_endtime(breakdown_idx) <= breakdown_start && complete_flag == 1% �ж��Ƿ����
            is_compelete = 1;
            complete_flag = 0;
        end
        if is_compelete == 0
            cnc_now(breakdown_idx) = 0; % ������
        end 
            cnc_endtime(breakdown_idx) = 99999; %�����ڼ������ʱ����һ���޴��ֵ�����Ͻ����ָ�
    elseif time >= breakdown_end % �ָ�����ʱ�� �ò���ִֻ��һ��
        if breakdown_flag == 1
            cnc_endtime(breakdown_idx) = time;
            breakdown_flag = 0;
        end
    end
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
        if temp == 0 % ֮ǰ�ӹ���һ����ϵģ�ֻ��Ҫ���ϣ�������ϴ�ͼ�¼����
            cnt = cnt + 1; % �µ��������ϼӹ�
            result(cnt,1) = cnt;
            result(cnt,2) = idx;
            result(cnt,3) = time; % ��¼���������Ͽ�ʼʱ��
            time = time + tud(idx); % ����ʱ������
            cnc_now(idx) = cnt; %���¼ӹ��������
            cnc_endtime(idx) = time + tprocess; % ���¼ӹ����ʱ��
        else
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
end
