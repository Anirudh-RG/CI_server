const express = require('express')
const PORT = 3000;
const app = express();

app.get('/',(req,res)=>{
    res.send("Hellow rold")
    res.status(200);
})

app.get('/health',(req,res)=>{
    res.status(200);
    res.send("OK");
})

app.listen(PORT,()=>{
    console.log(`listens on ${PORT}`)
})