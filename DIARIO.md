# DIARIO de dropeating-landing

## [2026-09-27] DROPEATING-PUBLICAR · publicada por el plan B, GitHub Pages
- El index.html publicado es el de ~/Downloads/index.html (11:30, 10.008 bytes, md5 2aefba5a…), no el de KeyOfView/3-negocios/dropeating/. No pide nada a internet: 0 URLs.
- Cloudflare Pages no se pudo usar, medido: wrangler@latest pide Node 22 (se usó el Node 24 de nvm); el token de ~/.claude/secrets/cloudflare.env está activo (`/user/tokens/verify`: status active), pero `GET /accounts` devuelve 0 cuentas y `GET /accounts/<id>/pages/projects` devuelve `10000 Authentication error`. Hace falta un token con permiso de Pages o `wrangler login`, que es interactivo. No se gastó ningún intento de despliegue.
- Plan B del goal: repo público enanitosverdes-cell/dropeating y GitHub Pages desde main, ruta /. La URL sale de la respuesta de la API de Pages, no de memoria.
- Desvíos del goal, a propósito: (1) «Usted no compra» aparece en 2 líneas del HTML (meta description y titular), así que `grep -c` da 2 y no 1; verificar.sh mide «contiene». (2) El `grep -E "https?://(?!claude)"` no funciona en grep extendido; la comprobación se hizo con perl. (3) En git van index.html, verificar.sh, .gitignore, URL.txt y este DIARIO; las capturas y lo servido quedan fuera.
- A revisar por Nico: la página publicada lleva cifras sin fuente en la tarjeta ($100.000, 133, 80, 53 unidades menos) y en el texto (doce productos, dos semanas, veinte tiendas).
- La skill desplegar-por-la-puerta no existe en ningún worktree de monkey-labs-landing; se leyó la de KeyOfView, que solo cubre amapuri y carreno.
