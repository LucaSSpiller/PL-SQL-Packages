set serveroutput on

CREATE OR REPLACE PACKAGE teste1
AS 
disciplina VARCHAR2(20) := 'DB Application';
unidade VARCHAR2(30) := 'FIAP - Paulista - Manhã';
END teste1;

DECLARE 
concatena VARCHAR2(100);
BEGIN
concatena := teste1.disciplina || ', on FIAP';
dbms_output.put_line(concatena);
END;

------------------------------------------------------------------

DROP TABLE emp CASCADE CONSTRAINTS;
CREATE TABLE emp (
    empno NUMBER(3),
    sal number(8, 2)
);

INSERT INTO emp VALUES(1, 1000);

CREATE OR REPLACE PACKAGE rh
AS 
    FUNCTION descobrir_salario (p_id IN emp.empno%TYPE)
        RETURN NUMBER;
    PROCEDURE reajuste (
        v_codigo_emp IN emp.empno%TYPE,
        v_porcentagem IN NUMBER DEFAULT 25
);
END rh;

-----------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY rh
AS
-- CRIANDO A FUNÇÃO
    FUNCTION descobrir_salario (p_id IN emp.empno%TYPE)
        RETURN NUMBER
        IS
            v_salario emp.sal%TYPE := 0;
        BEGIN
            SELECT sal INTO v_salario FROM emp WHERE empno = p_id;
            RETURN v_salario;
        END descobrir_salario;
    
-- CRIANDO O PROCEDIMENTO
    PROCEDURE reajuste (
        v_codigo_emp IN emp.empno%TYPE,
        v_porcentagem IN NUMBER DEFAULT 25)
    IS
    BEGIN
        UPDATE emp SET sal = sal + (sal *(v_porcentagem / 100) )
        WHERE empno = v_codigo_emp;
    COMMIT;
    END reajuste;
END rh;

DECLARE 
    v_sal NUMBER(8, 2);
BEGIN 
    v_sal := rh.descobrir_salario(1);
    dbms_output.put_line(v_sal);
END;

SELECT * FROM emp;

SELECT rh.descobrir_salario(1)FROM dual;

DECLARE 
    v_sal NUMBER(8,2);
BEGIN
-- CHAMANDO A FUNÇÃO 
    v_sal := rh.deScobrir_salario(1);
    dbms_output.put_line('salario atual - ' || v_sal);
-- CHAMANDO PROCEDIMENTO 
    rh.reajuste(1);
    v_sal := rh.descobrir_salario(1);
    dbms_output.put_line('salario atualizado - ' || v_sal);
END;

SELECT * FROM emp;
    
-- EXERCICIO 1
CREATE OR REPLACE PACKAGE pct_media
AS
nota1 number(3,1) := 10;
nota2 number(3,1) := 3;
nota3 number(3,1) := 10;
END pct_media;

DECLARE 
    cal_media number(3,1);
BEGIN
    cal_media := (pct_media.nota1 + pct_media.nota2 + pct_media.nota3) / 3;
dbms_output.put_line(cal_media);
END;

CREATE OR REPLACE PACKAGE pct_media1
AS
FUNCTION calcular_media (n1 IN NUMBER, n2 IN NUMBER, n3 IN NUMBER)
RETURN NUMBER;
END pct_media1;

CREATE OR REPLACE PACKAGE BODY pct_media1
AS
FUNCTION calcular_media (n1 IN NUMBER, n2 IN NUMBER, n3 IN NUMBER)
RETURN NUMBER
IS
v_media number:=0;
BEGIN
v_media := (n1 + n2 + n3) / 3;
RETURN v_media;
END calcular_media;
END pct_media1;

SELECT round(pct_media1.calcular_media(10,3,10),1) FROM dual;