var ingredients = [
    {
        name: 'Abomination lymph',
        icon : '/images/mixture-icons/Substances_Abomination_lymph.png',
        quantity: '1000300'
    },
    {
        name: 'Alp fangs',
        icon : '/images/mixture-icons/Substances_Alp_fangs.png',
        quantity: '2003200'
    },
    {
        name: 'Cockatrice eye',
        icon : '/images/mixture-icons/Substances_Cockatrice_eye.png',
        quantity: '1003700'
    },
    {
        name: 'Ectoplasm',
        icon : '/images/mixture-icons/Substances_Ectoplasm.png',
        quantity: '1500000'
    },
    {
        name: 'Kikimore claw',
        icon : '/images/mixture-icons/Substances_Kikimore_claws.png',
        quantity: '3900000'
    },
    {
        name: 'Pituitary gland',
        icon : '/images/mixture-icons/Substances_Pituitary_gland.png',
        quantity: '5000100'
    },
    {
        name: 'Striga heart',
        icon: '/images/mixture-icons/Substances_Striga_heart.png',
        quantity: '1000100'
    },
    {
        name: 'Werewolf fur',
        icon : '/images/mixture-icons/Substances_Werewolf_fur.png',
        quantity: '2000200'
    },
    {
        name: 'Wing membrane',
        icon : '/images/mixture-icons/Substances_Wing_membrane.png',
        quantity: '12000000'
    }
]

function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min)) + min;
}

console.log('id,name,count')

for(var i = 0; i < 1000; i++){
	var arraryIndex = getRandomInt(0,ingredients.length)
	var row = ingredients[arraryIndex]

	var count = getRandomInt(1,4)	
	var csvRow = arraryIndex + ',' + row.name + ',' + count
	console.log(csvRow)
}