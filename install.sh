mkdir -p binaries/linux-64
wget https://github.com/github/hub/releases/download/v2.7.0/hub-linux-amd64-2.7.0.tgz
mv hub-linux-amd64-2.7.0.tgz binaries/linux-64/
(
  cd binaries/linux-64/
  tar -zxvf hub-linux-amd64-2.7.0.tgz
)