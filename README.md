Скрипты для автоматизации:
  - CA Server: install-ca.sh
  - OpenVPN Server: install-vpnsrv.sh
  - Prometheus Server: install-promsrv.sh
  - Backup Server: backup.sh

Упрощенный вариант разворачивания OpenVPN-сервера:
https://openvpn.net/product-select/
To install Access Server on your Linux server, run this command as root:
```
bash <(curl -fsS https://packages.openvpn.net/as/install.sh) --yes
```

Веб-интерфейс Prometheus - `https://raif.hopto.org/`

Поскольку данные на серверах конфиденциальны, для бэкапирования используется инструмент с поддержкой шифрования из коробки - Restic - https://restic.net/

Схема инфраструктуры - [https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=%D1%81%D1%85%D0%B5%D0%BC%D0%B0_%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D1%8B.drawio&dark=auto#Uhttps%3A%2F%2Fraw.githubusercontent.com%2FRaifSpace%2Fraif-devops%2Fmain%2F%D1%81%D1%85%D0%B5%D0%BC%D0%B0_%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D1%8B.drawio
](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&target=blank&highlight=0000ff&edit=_blank&layers=1&nav=1&title=%D1%81%D1%85%D0%B5%D0%BC%D0%B0_%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D1%8B.drawio&dark=auto#Uhttps%3A%2F%2Fraw.githubusercontent.com%2FRaifSpace%2Fraif-devops%2Fmain%2F%D1%81%D1%85%D0%B5%D0%BC%D0%B0_%D0%B8%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D1%8B.drawio)
