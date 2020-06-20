const path = require('path')
const express = require('express')
const hbs = require('hbs')
const app = express()
const PORT = 3000

const PublicDirPath = path.join(__dirname, '/public')
const viewsPath = path.join(__dirname, '/templates/views')
const PartialsPath = path.join(__dirname, '/templates/partials')

app.set('view engine', 'hbs')
app.set('views', viewsPath)
hbs.registerPartials(PartialsPath)

app.use(express.static(PublicDirPath))

app.use(express.static('public'))


app.get('/', (req, res) => {

    res.render('home', {
        title: 'Donate India'
    })


})

app.get('/camp', (req, res) => {
    res.render('createCampaign', {
        title: 'Donate India'
    });
})

app.get('/viewCamps', (req, res) => {
    res.render('viewCampaigns', {
        title: 'Donate India'
    })
});

app.get('/approve', (req, res) => {
    res.render('approve', {
        title: 'Donate India'
    })
});

app.get('/donate/:id', (req, res) => {
    res.render('donate', {
        id: req.params.id,
        title: 'Donate India'
    })
});

app.get('/about', (req, res) => {
    res.render('about', {

    })
})







app.listen(PORT, () => {
    console.log('Listening...')
})