patterns = [];
population = 0;

options = [
	{ name: "Number", chars: ["0","1","2","3","4","5","6","7","8","9"] },
	{ name: "Letter", chars: ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"] } ];

function findLicensePlates(){
	//Sets Population
	population = document.getElementById('populationField').value;	
	//Check Population for nonNumbers or empty space.
	if(population == ""){
		alert("Population field is empty.");
		return;
	}else if(isNaN(population)){
		alert(document.getElementById('populationField').value+" is not a number.");
		return;
	}  
	patterns = [];
  
	//This is where the pattern is found.  
	findPattern("",1,0,0,0);	
	patterns.sort(function(a, b) {return a.num-b.num;} ); 	
	//End Find Pattern
	
	//Builds output alert box
	output = "Population: "+population+"\nPattern: "+patterns[0].numbers+" numbers, "+patterns[0].letters+" letters\n";
	output += "Total Plates: "+patterns[0].num+"\nExcess Plates: "+(patterns[0].num-population)+"\nExample:\n";	
	for(j=0; j<5; j++){	output += createExample();}	
	alert(output);
}

function findPattern(pattern, num, numbers, letters, j){
	for (i = 0; i < options.length; i++) {
		if (options[i].chars.length * num >= population) {
			if(options[i].name == "Number") patterns.push( { pattern: pattern + options[i].name, num: options[i].chars.length * num, letters:letters, numbers:numbers +1});
			else patterns.push( { pattern: pattern + options[i].name, num: options[i].chars.length * num, letters:letters+1, numbers:numbers });
		}else {
			if(options[i].name == "Number") findPattern(pattern+options[i].name+", ", options[i].chars.length * num, numbers+1, letters, i )
			else findPattern( pattern+options[i].name+", ", options[i].chars.length * num, numbers, letters+1, i )
		}
	}
	i = j;
}

function createExample(){
	arr = [];
	str = "";
	for(i=0; i<patterns[0].numbers;i++){ arr.push(options[0].chars[Math.floor(Math.random()*options[0].chars.length)])};
	for(i=0; i<patterns[0].letters;i++){ arr.push(options[1].chars[Math.floor(Math.random()*options[1].chars.length)])};
	arr.sort(  
		function(a, b) {  
			return 0.5 - Math.random();  
		}  
	);  
	for(i=0; i<arr.length;i++){ str+=arr[i]};
	return "   "+str+"  ";
}