## Resize me 

A simple app to understand concept of ActiveJob.

```bash

# compile your assets
RAILS_ENV=production bundle exec rake assets:precompile

# Build
docker build . -t resize-me

# Run
docker run -it -p 3000:3000 --name resize-me-app-x resize-me:latest
 
# Debug 
docker exec -it <container-name> /bin/bash

# Try it
open localhost:3000
```


```bash
# Deploy 
docker tag resize-me:latest artemrubylearn.azurecr.io/resize-me:1
docker push artemrubylearn.azurecr.io/resize-me
```


