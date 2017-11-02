class Empleado{
		var estamina
		var rol
		var tareas=[]
		method rol()=rol
		method asignarTarea(tarea){tareas.add(tarea)}
		method cambiarRol(_rol){
			rol.reiniciar()
			rol=_rol
		}
		method ejecutar(tarea){
			if(tarea.puedeSerRealizada(self))
			tarea.realizar(self)
			else
			throw new Exception("La tarea no puede ser realizada")
		}
		method perderEstamina(valor){(estamina-=valor).max(0)}
		method fuerza()=self.fuerzaBase()+rol.fuerza()
		method fuerzaBase()=estamina+2
		method estamina()=estamina
		method comer(fruta){estamina+=fruta.estamina()}
		method dificultad(tarea)=tarea.dificultad(self)
		method esCiclope()=false
		method experiencia()=tareas.size()*tareas.map({tarea=>tarea.dificultad()}).sum()
		
		
}

class Biclope inherits Empleado{
	override method comer(fruta){super(fruta).min(10)}
}

class Ciclope inherits Empleado{
	override method fuerza()=super()/2
	override method esCiclope()=true

}

class Rol{
	method reiniciar(){}
	method esMucama()=false
	method fuerza()=0
	method esSoldado()=false
	method herramientas()=[]
}

class Soldado inherits Rol{
	var danio
	var danioAcumulado=danio
	constructor(_danio){danio=_danio}
	method practicar(){
		danioAcumulado+=2
	}
	override method reiniciar(){danioAcumulado=danio}
	override method fuerza()=danioAcumulado-danio
	override method esSoldado()=true
}

class Obrero inherits Rol{
	var herramientas=[]
	constructor(_herramientas){herramientas=_herramientas}
	override method herramientas()=herramientas
}

class Mucama inherits Rol{
	override method esMucama()=true
	
}

class Capataz inherits Rol{
	var empleadosACargo=[]
	
}

class Maquina{
	var complejidad
	var herramientas=[]
	constructor(comp,herr){complejidad=comp
		herramientas=herr
	}
	method maquina()=self
	method herramientas()=herramientas
	method complejidad()=complejidad
}


class ArreglarMaquina{
	var maquina
	constructor(maq){maquina=maq}
	method realizar(empleado){
		empleado.perderEstamina(maquina.complejidad())
		}
		
	method puedeSerRealizada(empleado){
		return empleado.estamina()>=maquina.complejidad() and  (maquina.herramientas().all({herram=>empleado.rol().herramientas().contains(herram)}) or maquina.herramientas().size()==0)
	}
	method dificultad(empleado)=2*maquina.complejidad()
}

class DefenderSector{
	var sector
	constructor(sec){sector=sec}
	method puedeSerRealizada(empleado){
		return empleado.rol().esMucama().negate() and empleado.fuerza()>=sector.gradoDeAmenaza()
		}
	method realizar(empleado){
			if(empleado.rol().esSoldado().negate())
			empleado.perderEstamina(0.5*empleado.estamina())
	}	
	method dificultad(empleado)=sector.gradoDeAmenaza()*if(empleado.esCiclope())2 else 1
		
}

class LimpiarSector{
	var dificultad=10
	var sector
	constructor(sec){sector=sec}
	method setDificultad(valor){dificultad=valor}
	method puedeSerRealizada(empleado)=empleado.estamina()>=self.estaminaRequerida()
	method estaminaRequerida()=if(sector.esGrande())4 else 1
	method realizar(empleado){
		if(empleado.rol().esMucama().negate())
		empleado.perderEstamina(self.estaminaRequerida())
	}
	method dificultad(empleado)=dificultad
	
}

class Sector{
	var esGrande
	var gradoDeAmenaza
	constructor(_esGrande,grado){
		esGrande=_esGrande
		gradoDeAmenaza=grado
	}
	method gradoDeAmenaza()=gradoDeAmenaza
	method esGrande()=esGrande
}


object banana{
	method estamina()=10
}

object  manzana{
	method estamina()=5
}

object uva{
	method estamina()=1
}

