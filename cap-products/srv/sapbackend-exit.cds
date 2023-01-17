using {sapbackend as external} from './external/sapbackend.csn';

define service SAPBackendExit {

  @cds.persistence : { // La permite la peticion de Incidencia
    table,
    skip : false
  }
  @cds.autoexpose
  //entity Incidents as select from external.IncidentsSet; // es como una copia el servicio pero si colocamo las llaves exponemos las propiedades que queramos

  entity Incidents as projection on external.IncidentsSet;

// entity Incidents as select from external.IncidentsSet {
//     IncidenceId,
//     EmployeeId,
//     '' as Newproperty // creando una propiedad nueva
// };

}
// Exponer los servicio en forma de REST
@protocol: 'rest'
service RestService {
  entity Incidents as projection on SAPBackendExit.Incidents;
}