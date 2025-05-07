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

app.get('/user',(req,res)=>{
    res.send("User page");
    res.status(200);
})

app.get('/user/:id',(req,res)=>{
    const id = req.params.id;
    res.send(`User page with id ${id}`);
    res.status(200);
})

app.listen(PORT,()=>{
    console.log(`listens on ${PORT}`)
})