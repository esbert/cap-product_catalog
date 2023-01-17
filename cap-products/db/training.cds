namespace com.training;

using {
    cuid,
    managed,
    Country
} from '@sap/cds/common';

entity Course {
    key ID      : UUID;
        Student : Association to many StudentCourse
                      on Student.Course = $self;

}

entity Student {
    key ID     : UUID;
        Course : Association to many StudentCourse
                     on Course.Student = $self;

}

entity StudentCourse {
    key ID      : UUID;
        Student : Association to Student;
        Course  : Association to Course;

}

entity Orders {

    key ClientEmail  : String(65);
        FirstName    : String(30);
        LastName     : String(30);
        CreatedOn    : Date;
        Reviewed     : Boolean;
        Approved     : Boolean;
        Country      : Country; // se coloca en el archivo Country_code ya que la deficinico de Country de Sap se llama asi
        Status       : String(1);

}
