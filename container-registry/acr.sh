#!/bin/bash

source acr.cfg

kubectl create secret docker-registry regcred \
                      --docker-server="${yourregistryserver}" \
                      --docker-username="${yourname}" \
                      --docker-password="${yourpword}" \
                      --docker-email="${youremail}"
