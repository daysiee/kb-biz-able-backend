const oracledb = require('oracledb')
const express = require('express')
const app = express()
var path = require('path')
var request = require('request')
var bodyParser = require('body-parser')
var dbConfig = require('./dbconfig.js')
var jwt = require('jsonwebtoken')
var auth = require('./lib/auth')
// var userlib = require('./lib/userlib')

oracledb.autoCommit = true;

// 디자인 파일 경로 지정
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// 디자인 자원 및 json 데이터 사용
// to use static asset
app.use(express.static(path.join(__dirname, 'public')));

// json 허용
app.use(express.json())
app.use(express.urlencoded({extended:false}))
app.use(bodyParser.urlencoded({extended: true}))

//-----------------데이터 전송 라우터 추가----------------------
app.post('/',auth, function(req,res){
    res.send("Hello Tigers!")
})

app.get('/getTime',function(req,res){
    var nowTime = new Date()
    res.json(nowTime)
})

//-------------------오라클예제---------------------------------
oracledb.getConnection(
    {
        user          : dbConfig.user,
        password      : dbConfig.password,
        connectString : dbConfig.connectString
    },
    function(err, connection)
    {
        if (err) {
            console.error(err.message);
            return;
        }
        connection.execute(
            "SELECT * FROM DEF_JOB WHERE ROWNUM <= 3",{},
            {outFormat:oracledb.OBJECT},
            function(err, result)
            {
                if (err) {
                    console.error(err.message);
                    doRelease(connection);
                    return;
                }
                console.log(result.metaData); // 테이블 스키마
                console.log(result.rows); // 데이터
                console.log(result.rows.length);
                doRelease(connection);
            });
    });

function doRelease(connection)
{
    connection.release(
        function(err) {
            if (err) {
                console.error(err.message);
            }
        });
}

//-----------------부서명으로 배치내역 조회하기------------------------------
app.post('/getHistoryBy_deptNM', auth,  function(req,res){
    oracledb.getConnection(
        {
            user          : dbConfig.user,
            password      : dbConfig.password,
            connectString : dbConfig.connectString
        },
        function(err, connection)
        {
            if (err) {
                console.error(err.message);
                return;
            }
            var deptNM = req.body.DEPT_NM;
            //console.log("==> oracle select example is running...")
            var sql="WITH J_T AS ( SELECT JOB_NAME, ORDER_ID, ORDER_TIME, ODATE, DESCRIPTION FROM EZ_HISTORY WHERE JOB_NAME in ( SELECT JOB_NAME FROM EZ_JOB_MAPPER WHERE USER_CD_1 in ( SELECT USER_CD FROM EZ_USER WHERE DEPT_CD = ( SELECT DEPT_CD FROM EZ_DEPT WHERE DEPT_NM IN (:v1))))), MAPPER_T AS(SELECT JOB_NAME, USER_NM FROM EZ_JOB_MAPPER JOIN EZ_USER ON EZ_JOB_MAPPER.USER_CD_1 = EZ_USER.USER_CD), ERROR_CHK_T AS(SELECT EZ_HISTORY.ORDER_ID, ALARM.MESSAGE FROM EZ_HISTORY, ALARM WHERE EZ_HISTORY.ORDER_ID = ALARM.ORDER_ID(+)) SELECT J_T.JOB_NAME, J_T.ORDER_ID, J_T.ODATE, J_T.ORDER_TIME, J_T.DESCRIPTION, MAPPER_T.USER_NM, /*DECODE(ERROR_CHK_T.MESSAGE, NULL, 'SUCCESS', 'FAIL') as SUCCESS,*/ ERROR_CHK_T.MESSAGE FROM J_T , MAPPER_T, ERROR_CHK_T WHERE J_T.JOB_NAME = MAPPER_T.JOB_NAME AND J_T.ORDER_ID = ERROR_CHK_T.ORDER_ID";
            //var sql = "SELECT USER_HP FROM EZ_USER WHERE USER_NM IN (:v1, :v2)";
            //var binds = ["이정가", "신혜가"]
            var binds = [deptNM];

            connection.execute(sql,binds,{outFormat:oracledb.OBJECT},
                    function(err, result){
                    if (err) {
                        console.error(err.message);
                        doRelease(connection);
                        return;
                    }
                    //console.log(result.metaData); // 테이블 스키마
                    console.log(result.rows); // 데이터
                    doRelease(connection, result.rows);
                });
        });
    function doRelease(connection, data)
    {
        connection.release(
            function(err) {
                if (err) {
                    console.error(err.message);
                }
                console.log("==> selecting success")
                res.send(data);

            });
    }
})

// select example
app.get('/selectData', auth,function(req,res){
    oracledb.getConnection(
        {
            user          : dbConfig.user,
            password      : dbConfig.password,
            connectString : dbConfig.connectString
        },
        function(err, connection)
        {
            if (err) {
                console.error(err.message);
                return;
            }
            console.log("==> oracle select example is running...")
            var sql = "SELECT * FROM DEF_JOB WHERE ROWNUM <= 10";
            // 상위 10개 레코드만 조회
            connection.execute(sql,{},{outFormat:oracledb.OBJECT},
                    function(err, result){
                    if (err) {
                        console.error(err.message);
                        doRelease(connection);
                        return;
                    }
                    //console.log(result.metaData); // 테이블 스키마
                    console.log(result.rows); // 데이터
                    doRelease(connection, result.rows);
                });
        });

    function doRelease(connection, data)
    {
        connection.release(
            function(err) {
                if (err) {
                    console.error(err.message);
                }
                console.log("==> selecting success")
                res.send(data);

            });
    }
})




//-------------------------------jwt 로그인------------------------------------
app.post('/loginEZ', function(req,res){
    oracledb.getConnection(
        {
            user          : dbConfig.user,
            password      : dbConfig.password,
            connectString : dbConfig.connectString
        },
        function(err, connection)
        {
            if (err) {
                console.error(err.message);
                return;
            }
            var uid = req.body.uid;
            var upw = req.body.password;
            console.log("==> oracle select example is running...")
            var sql = "SELECT USER_PW FROM EZ_LOGIN WHERE USER_ID IN (:v1)";
            var binds = [uid];
            connection.execute(sql,binds,{outFormat:oracledb.OBJECT},
                    function(err, result){
                    if (err) {
                        console.error(err.message);
                        doRelease(connection);
                        return;
                    }
                    //console.log(result.metaData); // 테이블 스키마
                    console.log(result.rows[0].USER_PW); // 데이터
                    var dbpw = result.rows[0].USER_PW;
                    if(dbpw == upw){
                        // login 성공
                        var tokenKey = "P~airJu@i!!!ce$%#IsD*in&^nerBot"
                        jwt.sign({
                            UID : uid
                        },
                        tokenKey,
                        {
                            expiresIn : '30m',
                            issuer : 'daysiee',
                            subject : 'user.login.info'
                        },

                        function(err, token){
                            console.log('로그인 성공', token)
                            var data = { "token" : token}
                            res.json(data) // jwt 리턴
                        })
                    }
                    else{
                        var data = {"errmsg" : "invalid pw"}
                        res.json(data);
                    }
                    doRelease(connection, result.rows);
                });
        });
        function doRelease(connection, data)
        {
            connection.release(
                function(err) {
                    if (err) {
                        console.error(err.message);
                    }
                    console.log("==> selecting success")
                    //res.send(data);
                });
        }
})




//------------------------------------api 추가---------------------------------------


// 메인 My탭 대시보드 데이터 조회
app.post('/getMainChartData_My', auth,function(req,res){
    oracledb.getConnection(
        {
            user          : dbConfig.user,
            password      : dbConfig.password,
            connectString : dbConfig.connectString
        },
        function(err, connection)
        {
            if (err) {
                console.error(err.message);
                return;
            }
            var uid = req.body.USER_ID;
            console.log("==> oracle select example is running...")
            var sql="WITH OPERATION AS (SELECT ODATE, STATUS, USER_CD, count(*) AS CNT_OPER FROM EZ_HISTORY, EZ_JOB_MAPPER, EZ_USER WHERE EZ_HISTORY.JOB_NAME = EZ_JOB_MAPPER.JOB_NAME(+) AND EZ_JOB_MAPPER.USER_CD_1 = EZ_USER.USER_CD(+) AND APPLICATION LIKE '01%' AND ODATE = '200812' GROUP BY STATUS, ODATE, USER_CD), INFORMATION AS (SELECT ODATE, STATUS, USER_CD, count(*) AS CNT_INFO FROM EZ_HISTORY, EZ_JOB_MAPPER, EZ_USER WHERE EZ_HISTORY.JOB_NAME = EZ_JOB_MAPPER.JOB_NAME(+) AND EZ_JOB_MAPPER.USER_CD_1 = EZ_USER.USER_CD(+) AND APPLICATION LIKE '02%'AND ODATE = '200812' GROUP BY STATUS, ODATE, USER_CD), EDW AS (SELECT ODATE, STATUS, USER_CD, count(*) AS CNT_EDW FROM EZ_HISTORY, EZ_JOB_MAPPER, EZ_USER WHERE EZ_HISTORY.JOB_NAME = EZ_JOB_MAPPER.JOB_NAME(+) AND EZ_JOB_MAPPER.USER_CD_1 = EZ_USER.USER_CD(+) AND APPLICATION LIKE '03%' AND ODATE = '200812' GROUP BY STATUS, ODATE, USER_CD), ETC AS (SELECT ODATE, STATUS, USER_CD, count(*) AS CNT_ETC FROM EZ_HISTORY, EZ_JOB_MAPPER, EZ_USER WHERE EZ_HISTORY.JOB_NAME = EZ_JOB_MAPPER.JOB_NAME(+) AND EZ_JOB_MAPPER.USER_CD_1 = EZ_USER.USER_CD(+) AND REGEXP_LIKE(APPLICATION, '99|10|11|BMC|16|15|12') AND ODATE = '200812' GROUP BY STATUS, ODATE, USER_CD), USERINFO AS (select USER_CD, USER_ID, STATUS from( SELECT USER_CD, USER_ID, 'SUCCESS' AS SUCCESS, 'FAIL' AS FAIL FROM EZ_USER) UNPIVOT (VALUE FOR STATUS IN (SUCCESS, FAIL))) SELECT USERINFO.USER_CD, USERINFO.USER_ID, USERINFO.STATUS, DECODE(CNT_OPER, NULL, 0, CNT_OPER) AS CNT_OPER, DECODE(CNT_INFO, NULL, 0, CNT_INFO) AS CNT_INFO, DECODE(CNT_EDW,NULL, 0, CNT_EDW) AS CNT_EDW, DECODE(CNT_ETC,NULL, 0, CNT_ETC) AS CNT_ETC FROM OPERATION, INFORMATION, EDW, ETC, USERINFO WHERE USERINFO.USER_CD = OPERATION.USER_CD(+) AND  USERINFO.USER_CD = INFORMATION.USER_CD(+) AND USERINFO.USER_CD = EDW.USER_CD(+) AND USERINFO.USER_CD = ETC.USER_CD(+) AND USERINFO.STATUS = OPERATION.STATUS(+) AND USERINFO.STATUS = INFORMATION.STATUS(+) AND USERINFO.STATUS = EDW.STATUS(+) AND USERINFO.STATUS = ETC.STATUS(+) AND USERINFO.USER_ID = (:v1)"
            connection.execute(sql,[uid],{outFormat:oracledb.OBJECT},
                    function(err, result){
                    if (err) {
                        console.error(err.message);
                        doRelease(connection);
                        return;
                    }
                    doRelease(connection, result.rows);
                });
        });
    function doRelease(connection, data)
    {
        connection.release(
            function(err) {
                if (err) {
                    console.error(err.message);
                }
                console.log("==> selecting success")
                res.send(data);
            });
    }
})


// 메인 All탭 대시보드 데이터 조회
app.post('/getMainChartData_All', auth,function(req,res){
    oracledb.getConnection(
        {
            user          : dbConfig.user,
            password      : dbConfig.password,
            connectString : dbConfig.connectString
        },
        function(err, connection)
        {
            if (err) {
                console.error(err.message);
                return;
            }
            console.log("==> oracle select example is running...")
            var sql="WITH OPERATION AS (SELECT ODATE, STATUS, count(*) CNT_OPERATION FROM EZ_HISTORY WHERE APPLICATION LIKE '01%' GROUP BY STATUS, ODATE), INFORMATION AS (SELECT ODATE, STATUS, count(*) CNT_INFORMATION FROM EZ_HISTORY WHERE APPLICATION LIKE '02%' GROUP BY STATUS, ODATE), EDW AS (SELECT ODATE, STATUS, count(*) CNT_EDW FROM EZ_HISTORY WHERE APPLICATION LIKE '03%' GROUP BY STATUS, ODATE), ETC AS (SELECT ODATE, STATUS, count(*) CNT_ETC FROM EZ_HISTORY WHERE REGEXP_LIKE(APPLICATION, '99|10|11|BMC|16|15|12') GROUP BY STATUS, ODATE) SELECT OPERATION.ODATE ODATE, OPERATION.STATUS OPERATION_STATUS, CNT_OPERATION, DECODE(INFORMATION.STATUS, NULL, 'FAIL', INFORMATION.STATUS) INFORMATION_STATUS, DECODE(CNT_INFORMATION, NULL, 0, CNT_INFORMATION) CNT_INFORMATION, DECODE (EDW.STATUS, NULL, 'FAIL', EDW.STATUS) AS EDW_STATUS, DECODE(CNT_EDW, NULL, 0, CNT_EDW) AS CNT_EDW, DECODE(ETC.STATUS, NULL, 'FAIL', ETC.STATUS) ETC_STATUS, DECODE(CNT_ETC, NULL, 0, CNT_ETC) CNT_ETC FROM OPERATION, INFORMATION, EDW, ETC WHERE OPERATION.STATUS = INFORMATION.STATUS(+) AND OPERATION.STATUS = EDW.STATUS(+) AND OPERATION.STATUS = ETC.STATUS(+) AND OPERATION.ODATE = INFORMATION.ODATE(+) AND OPERATION.ODATE = EDW.ODATE(+) AND OPERATION.ODATE = ETC.ODATE(+) AND OPERATION.ODATE = '200812' ORDER BY OPERATION.ODATE, OPERATION.STATUS"
            connection.execute(sql,[],{outFormat:oracledb.OBJECT},
                    function(err, result){
                    if (err) {
                        console.error(err.message);
                        doRelease(connection);
                        return;
                    }
                    doRelease(connection, result.rows);
                });
        });
    function doRelease(connection, data)
    {
        connection.release(
            function(err) {
                if (err) {
                    console.error(err.message);
                }
                console.log("==> selecting success")
                res.send(data);
            });
    }
})


// 사번(USER_ID) 입력 시 배치 에러 내역 조회(에러배치명, 에러메시지, 실행시간)
app.post('/getErrorHistory_byUID', auth,function(req,res){
    oracledb.getConnection(
        {
            user          : dbConfig.user,
            password      : dbConfig.password,
            connectString : dbConfig.connectString
        },
        function(err, connection)
        {
            if (err) {
                console.error(err.message);
                return;
            }
            console.log("==> oracle select example is running...")
            var uid = req.body.USER_ID;
            var binds = [uid];
            var sql = "WITH DOINGJOB_T AS (SELECT EZ_JOB_MAPPER.JOB_NAME FROM EZ_JOB_MAPPER,EZ_USER WHERE EZ_JOB_MAPPER.USER_CD_1 = EZ_USER.USER_CD AND EZ_USER.USER_ID = (:v1))SELECT JOB_NAME, MESSAGE, HOST_TIME, ORDER_ID FROM (SELECT ROW_NUMBER() over (ORDER BY HOST_TIME) rnum, JOB_NAME, MESSAGE, HOST_TIME, ORDER_ID FROM (SELECT ALARM.JOB_NAME, ALARM.MESSAGE, ALARM.HOST_TIME, ALARM.ORDER_ID FROM ALARM, DOINGJOB_T WHERE ALARM.JOB_NAME in DOINGJOB_T.JOB_NAME) ORDER BY HOST_TIME DESC)"
            connection.execute(sql,binds,{outFormat:oracledb.OBJECT},
                    function(err, result){
                    if (err) {
                        console.error(err.message);
                        doRelease(connection);
                        return;
                    }
                    var page_num = req.body.PAGE_NUM;
                    console.log("PAGE_NUM: "+page_num);
                    var totalCount = result.rows.length; // 총 레코드 수
                    //console.log(totalCount);
                    var listCount = 10; // 한 번에 보여줄 레코드 수
                    var totalPage = parseInt(totalCount / listCount);
                    //console.log(totalPage);
                    if(totalCount % listCount > 0){
                        totalPage++;
                    }
                    if(totalPage < page_num){
                        page_num = totalPage;
                    }
                    var start_num  = (page_num * 10)+1;
                    var end_num = start_num + (listCount-1);
                    console.log("Start Record Num is "+start_num);
                    console.log("End Record Num is "+end_num);
                    var sql2 = sql + " WHERE rnum BETWEEN (:v1) AND (:v2)";
                    connection.execute(sql2,[uid, start_num, end_num],{outFormat:oracledb.OBJECT},
                        function(err, result){
                        if (err) {
                            console.error(err.message);
                            doRelease(connection);
                            return;
                        }
                        var obj1 ={"totalPage" : totalPage};
                        var resData = new Object();
                        resData.contents = result.rows;
                        resData.pageable = obj1;
                        console.log(resData);
                        doRelease(connection, resData);
                    });
                });
        });
    function doRelease(connection, data)
    {
        connection.release(
            function(err) {
                if (err) {
                    console.error(err.message);
                }
                console.log("==> selecting success")
                res.send(data);
            });
    }
})



// 일련번호(OrderID) 입력시 배치 상세(담당자명, 소속, 배치명, 상태, ODATE, 앱코드, 결과, 오류조치방안)
app.post('/getBatchDetail_byOID', auth,function(req,res){
    oracledb.getConnection(
        {
            user          : dbConfig.user,
            password      : dbConfig.password,
            connectString : dbConfig.connectString
        },
        function(err, connection)
        {
            if (err) {
                console.error(err.message);
                return;
            }
            console.log("==> oracle select example is running...")
            var oid = req.body.ORDER_ID;
            var binds = [oid, oid];
            var sql ="WITH NAMEFILTER_T AS (SELECT EZ_JOB_MAPPER.JOB_NAME, DEPT_NM, USER_NM, USER_HP FROM EZ_JOB_MAPPER,(SELECT EZ_USER.USER_CD, EZ_USER.USER_NM, EZ_DEPT.DEPT_NM, EZ_USER.USER_HP FROM EZ_USER, EZ_DEPT WHERE EZ_USER.DEPT_CD = EZ_DEPT.DEPT_CD(+))WHERE EZ_JOB_MAPPER.USER_CD_1 = USER_CD(+)),NAMEFILTER_2T AS (SELECT EZ_JOB_MAPPER.JOB_NAME, DEPT_NM, USER_NM, USER_HP FROM EZ_JOB_MAPPER,(SELECT EZ_USER.USER_CD, EZ_USER.USER_NM, EZ_DEPT.DEPT_NM, EZ_USER.USER_HP FROM EZ_USER, EZ_DEPT WHERE EZ_USER.DEPT_CD = EZ_DEPT.DEPT_CD(+))WHERE EZ_JOB_MAPPER.USER_CD_2 = USER_CD(+)),NAMEFILTER_3T AS (SELECT EZ_JOB_MAPPER.JOB_NAME, DEPT_NM, USER_NM, USER_HP FROM EZ_JOB_MAPPER,(SELECT EZ_USER.USER_CD, EZ_USER.USER_NM, EZ_DEPT.DEPT_NM, EZ_USER.USER_HP FROM EZ_USER, EZ_DEPT WHERE EZ_USER.DEPT_CD = EZ_DEPT.DEPT_CD(+)) WHERE EZ_JOB_MAPPER.USER_CD_3 = USER_CD(+)), NAMEFILTER_4T AS (SELECT EZ_JOB_MAPPER.JOB_NAME, DEPT_NM, USER_NM, USER_HP FROM EZ_JOB_MAPPER,(SELECT EZ_USER.USER_CD, EZ_USER.USER_NM, EZ_DEPT.DEPT_NM, EZ_USER.USER_HP FROM EZ_USER, EZ_DEPT WHERE EZ_USER.DEPT_CD = EZ_DEPT.DEPT_CD(+)) WHERE EZ_JOB_MAPPER.USER_CD_4 = USER_CD(+)), ERROR_ORDER_T AS (SELECT EZ_HISTORY.ORDER_TIME, EZ_HISTORY.APPLICATION, EZ_HISTORY.GROUP_NAME, EZ_HISTORY.DESCRIPTION, EZ_HISTORY.ORDER_ID, EZ_JOB_MAPPER.ERROR_DESCRIPTION, EZ_HISTORY.JOB_NAME, EZ_HISTORY.STATUS FROM EZ_HISTORY, EZ_JOB_MAPPER WHERE EZ_HISTORY.JOB_NAME = EZ_JOB_MAPPER.JOB_NAME(+)),DEFJOB_T AS (SELECT EZ_HISTORY.JOB_NAME, DEF_JOB.NODE_ID, DEF_JOB.CMD_LINE, EZ_HISTORY.ORDER_ID FROM EZ_HISTORY,DEF_JOB WHERE EZ_HISTORY.JOB_NAME = DEF_JOB.JOB_NAME(+)) SELECT ERROR_ORDER_T.JOB_NAME,NAMEFILTER_T.DEPT_NM AS USER1DEPT, NAMEFILTER_T.USER_NM AS USER1NAME, NAMEFILTER_T.USER_HP AS USER1HP, NAMEFILTER_2T.DEPT_NM AS USER2DEPT, NAMEFILTER_2T.USER_NM AS USER2NAME, NAMEFILTER_2T.USER_HP AS USER2HP, NAMEFILTER_3T.DEPT_NM AS USER3DEPT, NAMEFILTER_3T.USER_NM AS USER3NAME, NAMEFILTER_3T.USER_HP AS USER3HP, NAMEFILTER_4T.DEPT_NM AS USER4DEPT, NAMEFILTER_3T.USER_NM AS USER4NAME, NAMEFILTER_3T.USER_HP AS USER4HP, ORDER_TIME, APPLICATION, GROUP_NAME, DESCRIPTION, NODE_ID, CMD_LINE, STATUS, ERROR_DESCRIPTION FROM NAMEFILTER_T, NAMEFILTER_2T, NAMEFILTER_3T, NAMEFILTER_4T, ERROR_ORDER_T, DEFJOB_T WHERE ERROR_ORDER_T.JOB_NAME = NAMEFILTER_T.JOB_NAME AND ERROR_ORDER_T.JOB_NAME = NAMEFILTER_2T.JOB_NAME AND ERROR_ORDER_T.JOB_NAME = NAMEFILTER_3T.JOB_NAME AND ERROR_ORDER_T.JOB_NAME = NAMEFILTER_4T.JOB_NAME AND ERROR_ORDER_T.ORDER_ID = (:v1) AND DEFJOB_T.ORDER_ID = (:v2)"
            connection.execute(sql,binds,{outFormat:oracledb.OBJECT},
                    function(err, result){
                    if (err) {
                        console.error(err.message);
                        doRelease(connection);
                        return;
                    }
                    doRelease(connection, result.rows);
                });
        });
    function doRelease(connection, data)
    {
        connection.release(
            function(err) {
                if (err) {
                    console.error(err.message);
                }
                console.log("==> selecting success")
                res.send(data);
            });
    }
})


//다중 필터로 배치내역 조회
app.post('/getHistroy_byFilter', auth,function(req,res){
    oracledb.getConnection(
        {
            user          : dbConfig.user,
            password      : dbConfig.password,
            connectString : dbConfig.connectString
        },
        function(err, connection)
        {
            if (err) {
                console.error(err.message);
                return;
            }
            console.log("==> oracle select example is running...")

            // 필터 시작
            var deptNm = "%%";
            if(req.body.DEPT_NM != null){
                deptNm = '%'+req.body.DEPT_NM+'%';
            }
            console.log(deptNm);
            var userNm = "%%";
            if(req.body.USER_NM != null){
                userNm = '%'+req.body.USER_NM+'%';
            }
            var jobNm = "%%";
            if(req.body.JOB_NAME != null){
                jobNm = '%'+req.body.JOB_NAME+'%';
            }
            var status = "%%";
            if(req.body.STATUS != null){
                status = '%'+req.body.STATUS+'%';
            }
            var application = "%%";
            if(req.body.APPLICATION != null){
                application = '%'+req.body.APPLICATION+'%';
            }
            var groupNm = "%%";
            if(req.body.GROUP_NAME != null){
                groupNm = '%'+req.body.GROUP_NAME+'%';
            }
            var startOd = 200812;
            if(req.body.START_DATE != ""){
                startOd = parseInt(req.body.START_DATE);
            }
            var endOd = 200814;
            if(req.body.END_DATE != ""){
                endOd = parseInt(req.body.END_DATE);
            }
            var sql = "WITH NAMEFILTER_T AS (SELECT EZ_JOB_MAPPER.JOB_NAME, DEPT_NM, USER_NM FROM EZ_JOB_MAPPER,(SELECT EZ_USER.USER_CD, EZ_USER.USER_NM, EZ_DEPT.DEPT_NM FROM EZ_USER, EZ_DEPT WHERE EZ_USER.DEPT_CD = EZ_DEPT.DEPT_CD(+)) WHERE EZ_JOB_MAPPER.USER_CD_1 = USER_CD(+) AND DEPT_NM LIKE (:v1) AND USER_NM LIKE (:v2) AND JOB_NAME LIKE (:v3)), JOBFILTER_T AS (SELECT JOB_NAME, STATUS, ORDER_TIME,ORDER_ID FROM EZ_HISTORY WHERE STATUS LIKE (:v4) AND APPLICATION LIKE (:v5) AND GROUP_NAME LIKE (:v6) AND ODATE BETWEEN (:v7) AND (:v8)) SELECT JOB_NAME, DEPT_NM, USER_NM, STATUS, ORDER_TIME,ORDER_ID FROM (SELECT ROW_NUMBER() over (ORDER BY DEPT_NM) rnum, JOBFILTER_T.JOB_NAME, DEPT_NM, USER_NM, STATUS, ORDER_TIME,ORDER_ID FROM NAMEFILTER_T, JOBFILTER_T WHERE JOBFILTER_T.JOB_NAME = NAMEFILTER_T.JOB_NAME)"

            var binds = {
        v1: { val: deptNm, dir: oracledb.BIND_IN, type: oracledb.STRING },
        v2: { val: userNm, dir: oracledb.BIND_IN, type: oracledb.STRING },
        v3: { val: jobNm, dir: oracledb.BIND_IN, type: oracledb.STRING },
        v4: { val: status, dir: oracledb.BIND_IN, type: oracledb.STRING },
        v5: { val: application, dir: oracledb.BIND_IN, type: oracledb.STRING },
        v6: { val: groupNm, dir: oracledb.BIND_IN, type: oracledb.STRING },
        v7: { val: startOd},
        v8: { val: endOd}
        };

       console.log(binds);

            connection.execute(sql, binds, {outFormat:oracledb.OBJECT},
                    function(err, result){
                    if (err) {
                        console.error(err.message);
                        doRelease(connection);
                        return;
                    }
                    var page_num = req.body.PAGE_NUM;
                    console.log("PAGE_NUM: "+page_num);
                    var totalCount = result.rows.length; // 총 레코드 수
                    //console.log(totalCount);
                    var listCount = 10; // 한 번에 보여줄 레코드 수
                    var totalPage = parseInt(totalCount / listCount);
                    //console.log(totalPage);
                    if(totalCount % listCount > 0){
                        totalPage++;
                    }
                    if(totalPage < page_num){
                        page_num = totalPage;
                    }
                    var start_num  = (page_num * 10)+1;
                    var end_num = start_num + (listCount-1);
                    console.log("Start Record Num is "+start_num);
                    console.log("End Record Num is "+end_num);
                    var sql2 = sql + "WHERE rnum BETWEEN (:v9) AND (:v10)";
                    var binds2 =  {
                        v1: { val: deptNm, dir: oracledb.BIND_IN, type: oracledb.STRING },
                        v2: { val: userNm, dir: oracledb.BIND_IN, type: oracledb.STRING },
                        v3: { val: jobNm, dir: oracledb.BIND_IN, type: oracledb.STRING },
                        v4: { val: status, dir: oracledb.BIND_IN, type: oracledb.STRING },
                        v5: { val: application, dir: oracledb.BIND_IN, type: oracledb.STRING },
                        v6: { val: groupNm, dir: oracledb.BIND_IN, type: oracledb.STRING },
                        v7: { val: startOd},
                        v8: { val: endOd},
                        v9: { val: start_num},
                        v10: { val: end_num}
                        };

                        connection.execute(sql2, binds2, {outFormat:oracledb.OBJECT},
                            function(err, result){
                                if (err) {
                                    console.error(err.message);
                                    doRelease(connection);
                                    return;
                                }
                                console.log("페이징 시작");
                                var obj1 ={"totalPage" : totalPage};
                                var resData = new Object();
                                resData.contents = result.rows;
                                resData.pageable = obj1;
                                console.log(resData); 
                                //console.log(result.rows); // 데이터
                                doRelease(connection,resData);
                            });
                });
        });
    function doRelease(connection, data)
    {
        connection.release(
            function(err) {
                if (err) {
                    console.error(err.message);
                }
                console.log("==> selecting success")
            
                res.send(data);

            });
    }
})


//업무명으로 비상연락망 조회
app.post('/getPersonInfo_byJob', auth, function(req,res){
    oracledb.getConnection(
        {
            user          : dbConfig.user,
            password      : dbConfig.password,
            connectString : dbConfig.connectString
        },
        function(err, connection)
        {
            if (err) {
                console.error(err.message);
                return;
            }
            console.log("==> oracle select example is running...")
            var job_str="%%"; // 검색 대상 문자열 (업무명)
            if(req.body.USER_JOB != null){
                job_str = '%'+req.body.USER_JOB+'%'; 
            } 
            var sql = "SELECT DEPT_NM, USER_NM, USER_HP, USER_JOB,USER_CD FROM (SELECT ROW_NUMBER() over (ORDER BY USER_NM) rnum, DEPT_NM, USER_NM,USER_HP, USER_JOB,USER_CD FROM (SELECT DEPT_NM, USER_NM, USER_HP, USER_JOB,USER_CD FROM EZ_USER, EZ_DEPT WHERE EZ_USER.DEPT_CD = EZ_DEPT.DEPT_CD(+) AND USER_JOB LIKE (:v1)) ORDER BY USER_NM)";
            connection.execute(sql,[job_str],{outFormat:oracledb.OBJECT},
                    function(err, result){
                    if (err) {
                        console.error(err.message);
                        doRelease(connection);
                        return;
                    }
                    var page_num = req.body.PAGE_NUM;
                    console.log("PAGE_NUM: "+page_num);
                    var totalCount = result.rows.length; // 총 레코드 수
                    //console.log(totalCount);
                    var listCount = 10; // 한 번에 보여줄 레코드 수
                    var totalPage = parseInt(totalCount / listCount);
                    //console.log(totalPage);
                    if(totalCount % listCount > 0){
                        totalPage++;
                    }
                    if(totalPage < page_num){
                        page_num = totalPage;
                    }
                    var start_num  = (page_num * 10)+1;
                    var end_num = start_num + (listCount-1);
                    console.log("Start Record Num is "+start_num);
                    console.log("End Record Num is "+end_num);
                    var sql2 = sql + " WHERE rnum BETWEEN (:v1) AND (:v2)";
                    connection.execute(sql2,[job_str,start_num,end_num],{outFormat:oracledb.OBJECT}, function(err, result){
                        if (err) {
                            console.error(err.message);
                            doRelease(connection);
                            return;
                        }
                        var obj1 ={"totalPage" : totalPage};
                        var resData = new Object();
                        resData.contents = result.rows;
                        resData.pageable = obj1;
                        console.log(resData);
                        doRelease(connection, resData);
                    });
                });
        });
    function doRelease(connection, data)
    {
        connection.release(
            function(err) {
                if (err) {
                    console.error(err.message);
                }
                console.log("==> selecting success")
                res.send(data);

            });
    }
})


//담당자명으로 비상연락망 조회
app.post('/getPersonInfo_byName', auth,function(req,res){
    oracledb.getConnection(
        {
            user          : dbConfig.user,
            password      : dbConfig.password,
            connectString : dbConfig.connectString
        },
        function(err, connection)
        {
            if (err) {
                console.error(err.message);
                return;
            }
            console.log("==> oracle select example is running...")
            var name_str="%%"; // 검색 대상 문자열 (담당자명)
            if(req.body.USER_NM != null){
                name_str = '%'+req.body.USER_NM+'%'; 
            } 
            var sql = "SELECT DEPT_NM, USER_NM, USER_HP, USER_JOB,USER_CD FROM (SELECT ROW_NUMBER() over (ORDER BY USER_NM) rnum, DEPT_NM, USER_NM, USER_HP, USER_JOB, USER_CD FROM (SELECT DEPT_NM, USER_NM, USER_HP, USER_JOB, EZ_USER.USER_CD FROM EZ_USER, EZ_DEPT WHERE EZ_USER.DEPT_CD = EZ_DEPT.DEPT_CD(+) AND USER_NM LIKE(:v1)) ORDER BY USER_NM)";
            connection.execute(sql,[name_str],{outFormat:oracledb.OBJECT},
                    function(err, result){
                    if (err) {
                        console.error(err.message);
                        doRelease(connection);
                        return;
                    }
                    var page_num = req.body.PAGE_NUM;
                    console.log("PAGE_NUM: "+page_num);
                    var totalCount = result.rows.length; // 총 레코드 수
                    //console.log(totalCount);
                    var listCount = 10; // 한 번에 보여줄 레코드 수
                    var totalPage = parseInt(totalCount / listCount);
                    //console.log(totalPage);
                    if(totalCount % listCount > 0){
                        totalPage++;
                    }
                    if(totalPage < page_num){
                        page_num = totalPage;
                    }
                    var start_num  = (page_num * 10)+1;
                    var end_num = start_num + (listCount-1);
                    console.log("Start Record Num is "+start_num);
                    console.log("End Record Num is "+end_num);
                    var sql2 = sql + " WHERE rnum BETWEEN (:v1) AND (:v2)";
                    connection.execute(sql2,[name_str,start_num,end_num],{outFormat:oracledb.OBJECT}, function(err, result){
                        if (err) {
                            console.error(err.message);
                            doRelease(connection);
                            return;
                        }
                        var obj1 ={"totalPage" : totalPage};
                        var resData = new Object();
                        resData.contents = result.rows;
                        resData.pageable = obj1;
                        console.log(resData);
                        doRelease(connection, resData);
                    });
                });
        });
    function doRelease(connection, data)
    {
        connection.release(
            function(err) {
                if (err) {
                    console.error(err.message);
                }
                console.log("==> selecting success")
                res.send(data);

            });
    }
})


app.listen(3000)
