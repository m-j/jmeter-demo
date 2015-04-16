var db = require('../db/db')

function IngredientsController(){
    this.get('/api/ingredients', function(req, res){
        setTimeout(function(){
            res.send(db.ingredients)
        },200)
    })
}

module.exports = IngredientsController