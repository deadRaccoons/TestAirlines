class CreatePromocions < ActiveRecord::Migration
  def change
    execute <<-SQL
      CREATE TABLE promocions(
        idPromocion integer not null,
        codigoPromocion varchar(10) not null,
        porcentaje double precision not null check(porcentaje > 0 and porcentaje < 1),
        fechaEntrada date not null,
        vigencia date not null
      );
      
      alter table promocions
      add constraint proomocionsc
      primary key (idPromocion);

      create or replace function fpromocions() returns trigger as $tpromocions$
        begin 
          if new.idpromocion is null then new.idpromocion = (select max(idpromocion) from promocions) + 1;
          end if;
        return new;
      end;
    $tpromocions$ language plpgsql;

    create trigger tpromocions
    before insert on promocions
    for each row
    execute procedure fpromocions()

    SQL
  end
end
