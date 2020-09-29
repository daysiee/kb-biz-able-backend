module.exports = {
    user          : process.env.NODE_ORACLEDB_USER || 'root',

    // Instead of hard coding the password, consider prompting for it,
    // passing it in an environment variable via process.env, or using
    // External Authentication.
    password      : process.env.NODE_ORACLEDB_PASSWORD || 'kbsec01!',

    // For information on connection strings see:
    // https://github.com/oracle/node-oracledb/blob/master/doc/api.md#connectionstrings
    connectString : process.env.NODE_ORACLEDB_CONNECTIONSTRING || 'intern-bjmsdb.cxjqmpzmd7mn.us-east-2.rds.amazonaws.com/BJMS',


    // Setting externalAuth is optional.  It defaults to false.  See:
    // https://github.com/oracle/node-oracledb/blob/master/doc/api.md#extauth
    externalAuth  : process.env.NODE_ORACLEDB_EXTERNALAUTH ? true : false
};
