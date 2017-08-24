#!/bin/sh

set -e

if [[ ! -e .terraform/vault ]]; then
    case $(uname) in
        Linux)
            DOWNLOAD_URL=https://releases.hashicorp.com/vault/0.8.1/vault_0.8.1_linux_amd64.zip
            ;;
        Darwin)
            DOWNLOAD_URL=https://releases.hashicorp.com/vault/0.8.1/vault_0.8.1_darwin_amd64.zip
            ;;
        *)
            echo "ERROR: Unable to identify OS type."
            exit 1
    esac

    pushd .terraform
    wget -q -O vault.zip $DOWNLOAD_URL
    unzip vault.zip
    rm vault.zip
    popd
fi

if [[ $CA_CERT == "N/A" ]]; then
    CA_CERT_OPTION="-ca-cert=$CA_CERT"
else
    CA_CERT_OPTION=""
fi

VAULT_ADDRESS=$1
CA_CERT=$2
VAULT_POLICY=$3
TOKEN_PERIOD=$4
TOKEN_PATH=$5

TOKEN_SECRET=$(vault read -format=json \
    -address=$VAULT_ADDRESS $CA_CERT_OPTION \
    $TOKEN_PATH)

ACCESSOR=$(echo "$TOKEN_SECRET" | jq -r '.data.accessor')
if [[ -n $ACCESSOR ]]; then
    set +e
    vault token-lookup -format=json -address=$VAULT_ADDRESS $CA_CERT_OPTION -accessor $ACCESSOR >/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo "$TOKEN_SECRET" | jq '.data'
        exit 0
    fi
    set -e
fi

RESP=$(vault token-create -orphan -format=json \
    -address=$VAULT_ADDRESS $CA_CERT_OPTION \
    -policy=$VAULT_POLICY \
    -period=$TOKEN_PERIOD)

echo "{ \"token\": $(echo $RESP | jq '.auth.client_token'), \"accessor\": $(echo $RESP | jq '.auth.accessor') }"

set +e
