const jwt = require('jsonwebtoken')
var tokenKey = "P~airJu@i!!!ce$%#IsD*in&^nerBot"
const authMiddleware = (req, res, next) => {
   const auth = req.headers['authorization'];
   const strArray = auth.split(' ')
   const token = strArray[1];
   console.log(token);

   console.log("--------------------------인증 시작---------------------------")
   // 토큰이 없으면
   if(!token) {
       return res.status(403).json({
           success: false,
           message: 'not logged in'
       })
   }
   // 토큰 인증 성공 시
   const p = new Promise(
       (resolve, reject) => {
           jwt.verify(token, tokenKey, (err, decoded) => {
               if(err) reject(err)
               resolve(decoded)
           })
       }
   )
   const onError = (error) => {
       console.log(error);
       res.status(403).json({
           success: false,
           message: error.message
       })
   }
   p.then((decoded)=>{
       req.decoded = decoded
       console.log(decoded) // 사용자 정보 출력(log)
       console.log("--------------------------인증 성공---------------------------")
       next()
   }).catch(onError)
}

module.exports = authMiddleware;
