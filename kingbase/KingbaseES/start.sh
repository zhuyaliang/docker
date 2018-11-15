#!/bin/bash

chown -R kingbase /home/kingbase/*
chgrp kingbase /home/kingbase/*

su - kingbase -c "/home/kingbase/KingbaseES/run.sh $USERNAME $PASSWORD"
