class CreateUsuarios < ActiveRecord::Migration
  def change
    execute <<-SQL
      CREATE TABLE usuarios(
        correo text NOT NULL references logins(correo),
        idusuario int NOT NULL,
        nombres text NOT NULL,
        apellidoPaterno text NOT NULL,
        apellidoMaterno text NOT NULL,
        nacionalidad text NOT NULL,
        genero varchar(1) NOT NULL check (genero in ('H', 'M')),
        fechaNacimiento date NOT NULL,
        url_imagen text
      );
      ALTER TABLE usuarios
      ADD CONSTRAINT usuariosc
      PRIMARY KEY (idusuario);

      create or replace function fusuarios() returns trigger as $tusuarios$
      begin 
        if new.idusuario is null then new.idusuario = (select max(idusuario) from usuarios) + 1;
        end if;
        return new;
      end;
      $tusuarios$ language plpgsql;

      create trigger tusuarios
      before insert on usuarios
      for each row
      execute procedure fusuarios()
    SQL
  end
end
