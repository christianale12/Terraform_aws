# terraform-labs

Lab personal para aprender Terraform de verdad, de a poco y sin gastar un peso.

La idea es simple: aprendí redes por consola, y Terraform me costó porque no veía cómo se conectaba con un entorno real. Este repo es mi manera de hacerlo "clic": todo corre local, todo es reproducible y cada práctica se va sumando sola.

## Qué es cada carpeta

- **`0-bootstrap/`** — El "cimientos". Crea el bucket de S3 (`christian-tfstate`) y la tabla de locks (`terraform-locks`) que después usan todos los demás para guardar su state remoto. Se corre una sola vez (y si alguna vez reseteás el entorno, otra vez).
- **`app/`** — Un ejemplo con módulos: usa `modules/s3_bucket` para crear dos buckets (data y logs) y una tabla DynamoDB, con variables por entorno (`dev`, etc.).
- **`modules/`** — Código reutilizable. Hoy solo está `s3_bucket`, pero la idea es que las prácticas vayan delegando acá lo que repiten.
- **`practicas/`** — Mis prácticas, numeradas, de a una. Cada una tiene su propia config y su propio state remoto.
  - `01-ec2/` → VPC + subred + security group + una instancia. Es donde entendí lo del drift (tocás una regla a mano, `terraform plan` la detecta y `apply` la vuelve a poner como es) y lo de los `outputs` como etiqueta pública del state.
  - `02-rutas/` → Internet gateway y tabla de rutas. Acá se ve el encadenado: con `terraform_remote_state` lee los outputs de `01-ec2` y se apoya en la VPC que ya existe sin volver a crearla.

## El stack (todo local, gratis)

| Servicio | Rol | Puerto |
|---|---|---|
| **LocalStack** | Emula AWS (ec2, sts, iam) | `4566` |
| **MinIO** | Emula S3 (el backend del state) | `9000` |
| **DynamoDB-local** | Emula DynamoDB (los locks) | `8000` |

O sea: el flujo es idéntico al de AWS real, pero en tu máquina y con la billetera intacta.

## Cómo arrancar

```bash
# 1. Levantás el stack
docker start minio dynamodb-local
docker start localstack
curl -s http://localhost:4566/_localstack/health   # esperá a ver "available"

# 2. Una vez: el bootstrap
cd ~/terraform-labs/0-bootstrap
terraform plan && terraform apply

# 3. Tu práctica
cd ~/terraform-labs/practicas/01-ec2
terraform plan && terraform apply
```

## Lo que siempre tengo en la cabeza

- **El código es la fuente de verdad.** Si toco algo a mano en la consola, `terraform plan` lo detecta (drift) y `apply` lo vuelve a dejar como yo lo escribí.
- **El state es la memoria.** `terraform state list` / `state show` te dicen qué existe según Terraform. La realidad la ves con el proveedor (`describe-...`). La diferencia entre ambas es el drift.
- **Nada secreto se sube al repo** (state, tfvars, claves). El `.gitignore` se encarga.

## Las trampas del lab (las aprendí a los golpes)

- **DynamoDB-local separa por access key.** Corre con `SharedDb: false`, así que cada par usuario/clave ve una base distinta. Si chequeás con `test/test` vas a ver cero tablas y jurar que hay drift, cuando en realidad estás mirando otra base. Para inspeccionar, usá las mismas credenciales que usa Terraform (las de `~/.aws/credentials`).
- **LocalStack no edita una security group: la reemplaza.** Al cambiarle la descripción, borra la vieja y crea una nueva con otro ID. La instancia que estaba pegada a la vieja queda con un grupo que ya no existe.
- **Y peor: no persiste el cambio de SG en una instancia que ya está corriendo.** Acepta la llamada, te devuelve un OK hermoso, y no guarda nada. El `apply` termina "bien", pero el plan siguiente vuelve a pedir el mismo cambio para siempre. La salida es `terraform apply -replace=aws_instance.maquina`. Regla: en LocalStack configurá todo **antes** de aplicar, nunca después.
- **`terraform_remote_state` solo expone `outputs`.** En Terraform 1.16 no tiene atributo `resources`, así que desde otra carpeta solo podés leer lo que la otra declaró como output. Si falta un output, el error es `object with no attributes`.
- **`dynamodb_table` está deprecado** (tira el warning en cada `init`). Cuando se migre: `use_lockfile`.

## Pendiente

- [x] Terminar `01-ec2` con la EC2 real (el `aws_instance` ya está, corriendo).
- [x] Sumar `outputs.tf` a las prácticas para encadenar infra entre carpetas.
- [ ] `02-rutas`: crear el `aws_internet_gateway` en la VPC que viene de `01-ec2` (vía `terraform_remote_state`).
- [ ] `02-rutas`: crear la `aws_route_table` con la ruta default `0.0.0.0/0` hacia el gateway.
- [ ] `02-rutas`: asociar esa tabla de rutas a la subred de `01-ec2` con `aws_route_table_association`.
- [ ] Mover el patrón VPC+subred a un módulo en vez de copiarlo (`modules/vpc_subnet`), usando `moved` para no romper el lab.
- [ ] Practicas siguientes: varias VPCs, VPC peering, y un par de `data` sources para contrastar state vs. realidad.


