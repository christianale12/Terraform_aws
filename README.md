# terraform-labs

Lab personal para aprender Terraform de verdad, de a poco y sin gastar un peso.

La idea es simple: aprendí redes por consola, y Terraform me costó porque no veía cómo se conectaba con un entorno real. Este repo es mi manera de hacerlo "clic": todo corre local, todo es reproducible y cada práctica se va sumando sola.

## Qué es cada carpeta

- **`0-bootstrap/`** — El "cimientos". Crea el bucket de S3 (`christian-tfstate`) y la tabla de locks (`terraform-locks`) que después usan todos los demás para guardar su state remoto. Se corre una sola vez (y si alguna vez reseteás el entorno, otra vez).
- **`app/`** — Un ejemplo con módulos: usa `modules/s3_bucket` para crear dos buckets (data y logs) y una tabla DynamoDB, con variables por entorno (`dev`, etc.).
- **`modules/`** — Código reutilizable. Hoy solo está `s3_bucket`, pero la idea es que las prácticas vayan delegando acá lo que repiten.
- **`practicas/`** — Mis prácticas, numeradas, de a una. Cada una tiene su propia config y su propio state remoto.
  - `01-ec2/` → VPC + subred + security group. Es donde entendí lo del drift (tocás una regla a mano, `terraform plan` la detecta y `apply` la vuelve a poner como es).

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

## Pendiente

- [ ] Terminar `01-ec2` con la EC2 real (falta el `aws_instance`).
- [ ] Sumar `outputs.tf` a las prácticas para encadenar infra entre carpetas.
- [ ] Mover el patrón VPC+subred a un módulo en vez de copiarlo.
- [ ] Seguir con otras prácticas (routers de tablas, múltiples VPCs, etc.).

Si llegaste acá buscando un tutorial "serio", avisame y lo humano lo cambiamos por corporativo. Pero así (en mis palabras) es como realmente aprendí.