class CreateAvions < ActiveRecord::Migration
  def change
    execute <<-SQL
      create table avions(
        idAvion int primary key,
        modelo varchar(6) NOT NULL,
        marca text NOT NULL,
        capacidadPrimera int NOT NULL check(capacidadPrimera > 0),
        capacidadTurista int NOT NULL check(capacidadTurista > 0),
        disponible varchar(1) check(disponible in ('y', 'n'))
      );
      
      insert into avions values(1,'A320','Airbus',50,80,'y');

      create or replace function favion() returns trigger as $tavion$
      begin 
        if new.idavion is null then new.idavion = (select max(idavion) from avions) + 1;
        end if;
      return new;
      end;
      $tavion$ language plpgsql;
  
      create trigger tavion
      before insert on avions
      for each row
      execute procedure favion()
    SQL
  end
end
