#!/bin/bash

###### CHANGE THESE AS NEEDED #######
RG="vue-starter"
APPNAME="$RG-$RANDOM"
#You can get a list of locations by running 
#az account list-locations --query [].name
LOCATION="West US"
RUNTIME="DOTNETCORE:7.0"
#Pricing for Linux Service Plans changes from time to time given the location you choose
#and parameters of your subscription. You can review the pricing for Linux Service Plans here:
#https://azure.microsoft.com/en-us/pricing/details/app-service/linux/

#The sku should be one of:
#F1(Free), D1(Shared), B1(Basic Small), B2(Basic Medium), B3(Basic Large), 
#S1(Standard Small), P1(Premium Small), P1V2(Premium V2 Small), 
#PC2 (Premium Container Small), PC3 (Premium Container Medium), 
#PC4 (Premium Container Large).

#accepted values: B1, B2, B3, D1, F1, FREE, P1, P1V2, P2, P2V2, P3, P3V2, PC2, PC3, PC4, S1, S2, S3, SHARED
SKU=B1

rm scripts/.env
rm scripts/deploy.sh

echo "Creating scripts/.env"

# Adding these to the .env file for convenience
echo "RG=$RG" > scripts/.env
echo "APPNAME=$APPNAME" >> scripts/.env
echo "LOCATION=$LOCATION" >> scripts/.env

echo "Creating a resource group"

#this can be run safely even 
az group create -n $RG -l $LOCATION

echo "Creating AppService Plan"
az appservice plan create --name $APPNAME \
                          --resource-group $RG \
                          --sku $SKU \
                          --is-linux


echo "Creating Web app"
az webapp create --resource-group $RG \
                  --plan $APPNAME \
                  --name $APPNAME \
                  --runtime $RUNTIME

az webapp config appsettings set --resource-group $RG --name $APPNAME --settings WEBSITE_RUN_FROM_PACKAGE="1"

echo "Setting up logging"
#setup logging and monitoring
az webapp log config --application-logging filesystem \
                    --detailed-error-messages true \
                    --web-server-logging filesystem \
                    --level information \
                    --name $APPNAME \
                    --resource-group $RG

# echo "An alias for setting your domain (when you're ready) has been added to your .env"
# echo "To create a domain, you need to set a CNAME pointed to $APPNAME.azurewebsites.net"
# echo "For more information you can have a look here: "
# echo "https://docs.microsoft.com/en-us/azure/app-service/web-sites-traffic-manager-custom-domain-name?WT.mc_id=webapp-azx-robcon"
echo "alias setdomain='az webapp config hostname add --webapp-name $APPNAME --resource-group $RG --hostname [YOUR DOMAIN]'" >> scripts/.env


echo "Adding logs alias to .env. Invoking this will allow you to see the application logs realtime-ish."
#set an alias for convenience - add to .env
echo "alias logs='az webapp log tail -n $APPNAME -g $RG'" >> scripts/.env

echo "rm scripts/app.zip" >> scripts/deploy.sh
echo "dotnet publish" >> scripts/deploy.sh
echo "cd bin/Debug/net7.0/publish/" >> scripts/deploy.sh
echo "zip -r app.zip ." >> scripts/deploy.sh
echo "mv app.zip ../../../../scripts/" >> scripts/deploy.sh
echo "cd ../../../../" >> scripts/deploy.sh

echo "open https://$APPNAME.azurewebsites.net" >> scripts/deploy.sh

echo "echo 'Site's been pushed, watching logs...'" >> scripts/deploy.sh
echo "az webapp log tail -n $APPNAME -g $RG" >> scripts/deploy.sh

source scripts/deploy.sh

echo "If there were no errors you should be able to view your site at https://$APPNAME.azurewebsites.net"