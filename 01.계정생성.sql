/*������ �ּ��� ���*/
-- ���� �ּ��� ���

/*���������� ���� ��ɾ�� ������ ������.*/
-- C##EMPLOYEE��� ����ڸ� �߰��ϰ� ��й�ȣ�� EMPLOYEE�� �ϰڴ�.
-- ���� �տ� ����Ŭ����  C##�� �ٿ��ش�. ������Ʈ�� �Ⱥ��δ�
-- ������ �Ҵ� ������ �Ⱥ��δ�. ??
-- IDENTIFIED ��й�ȣ
--CREATE USER C##EMPLOYEE IDENTIFIED BY EMPLOYEE;
-- �ѹ��� �߰� ���� ��Ʈ�� ����


-- ����: ������ �̶�� �Ѵ�
-- RESOUTRCE(��������� �� ����), (CONNECT ���ӱ��� ���۹�8���� ����) ����
-- GRANT RESOURCE, CONNECT TO C##EMPLOYEE;
--ALTER (����) �����Ѵ�. 
-- ���� QUOTA�뷮 ���� UNLIMITED �ý��ۿ� ���� �뷮 ��������
--ALTER USER C##EMPLOYEE QUOTA UNLIMITED ON SYSTEM
-- ���� UNLIMITED 
--ALTER USER C##EMPLOYEE QUOTA UNLIMITED ON USERS;
