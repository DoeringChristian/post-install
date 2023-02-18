
#!/bin/sh
docker run -v "$(pwd)":/usr/src/project -w /usr/src/project -it fedora /bin/bash -c "chmod +x /usr/src/project/install.sh && /usr/src/project/install.sh"
