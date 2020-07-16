#!/bin/bash

##  Author = "Nick Bailuc"
##  Copyright = "Copyright (C) 2020 Nick Bailuc, <nick.bailuc@gmail.com>"
##  License = "GNU General Public License, version 3 or later"
##	"Windows 95 Product Key Generator" (Version 0.32)
##
##  There are 41713826857560 valid Product Key's for Windows 95. This program
##  uses Bash's $RANDOM variable in a sequence until it finds appropriate keys.
##  Inspiration: Youtube <<FlyTech Videos>> https://www.youtube.com/watch?v=3DCEeASKNDk
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <https://www.gnu.org/licenses/>.
##
VERSION=0.32

generate()
{
	# 3-digit day of year:
	D=$RANDOM
	while (( D > 365 ))
	do
		D=$(( RANDOM % 366 ))
	done
	D=$(( D + 1))
	if (( D < 10))
	then
		D=00$D
	elif (( D < 100 ))
	then
		D=0$D
	fi

	# 2-digit year:
	Y=$RANDOM
	while (( Y > 3 && Y < 95)) || (( Y > 99 ))
	do
		Y=$(( RANDOM % 100 ))
	done
	if (( Y < 4 ))
	then
		Y=0$Y
	fi

	# 7-digit "divisible by 7" group:
	a=0; b=0; c=0; d=0; e=0; f=1
	while (( (100000*a + 10000*b + 1000*c + 100*d + 10*e + f) % 7 != 0 ))
	do
		a=$(( RANDOM % 10 ))
		b=$(( RANDOM % 10 ))
		c=$(( RANDOM % 10 ))
		d=$(( RANDOM % 10 ))
		e=$(( RANDOM % 10 ))
		f=$(( RANDOM % 10 ))
	done

	# 5-digit "random" group:
	r1=$(( RANDOM % 10 ))
	r2=$(( RANDOM % 10 ))
	r3=$(( RANDOM % 10 ))
	r4=$(( RANDOM % 10 ))
	r5=$(( RANDOM % 10 ))

	# Export Product Key:
	printf "$D$Y-OEM-0$a$b$c$d$e$f-$r1$r2$r3$r4$r5\n"
}

generate_debug()
{
	# Define text format:
	c1=$(tput bold)
	c2=$(tput sgr0)
	printf "${c1}Initialization complete!\n\n"

	# 3-digit day of year:
	printf "Determining 3-digit day of year:${c2}\n"
	D=$RANDOM
	while (( D > 365 ))
	do
		D=$(( RANDOM % 366 ))
		printf "\tTrying $D\n"
	done
	D=$(( D + 1))
	if (( D < 10))
	then
		D=00$D
	elif (( D < 100 ))
	then
		D=0$D
	fi
	printf "${c1}\t3-digit day of year determined to be $D!\n\n"

	# 2-digit year:
	Y=$RANDOM
	printf "Determining 2-digit year:${c2}\n"
	while (( Y > 3 && Y < 95)) || (( Y > 99 ))
	do
		Y=$(( RANDOM % 100 ))
		printf "\tTrying $Y\n"
	done
	if (( Y < 4 ))
	then
		Y=0$Y
	fi
	printf "${c1}\t2-digit year determined to be $Y!\n\n"

	# 7-digit "divisible by 7" group:
	printf "Initiating divisible by 7 group:${c2}\n"
	a=0; b=0; c=0; d=0; e=0; f=1
	while (( (100000*a + 10000*b + 1000*c + 100*d + 10*e + f) % 7 != 0 ))
	do
		a=$(( RANDOM % 10 ))
		b=$(( RANDOM % 10 ))
		c=$(( RANDOM % 10 ))
		d=$(( RANDOM % 10 ))
		e=$(( RANDOM % 10 ))
		f=$(( RANDOM % 10 ))
		printf "\ta = $a\n\tb = $b\n\tc = $c\n\td = $d\n\te = $e\n\tf = $f\n"
		printf "\tLinear combination equals $((100000*a + 10000*b + 1000*c + 100*d + 10*e + f))\n"
	done
	printf "${c1}\t$((100000*a + 10000*b + 1000*c + 100*d + 10*e + f)) is divisible by 7!\n\n"

	# 5-digit "random" group:
	printf "Determining 5-digit group:${c2}\n"
	r1=$(( RANDOM % 10 ))
	r2=$(( RANDOM % 10 ))
	r3=$(( RANDOM % 10 ))
	r4=$(( RANDOM % 10 ))
	r5=$(( RANDOM % 10 ))
	printf "\tr1 = $r1\n\tr2 = $r2\n\tr3 = $r3\n\tr4 = $r4\n\tr5 = $r5\n"
	printf "5-digit group determined to be $r1$r2$r3$r4$r5!\n\n"

	# Export Product Key:
	printf "${c1}Parsing variables and exporting to stdout:${c2}\n"
	printf "\033[4mWindows 95 Product Key #$i:\t$D$Y-OEM-0$a$b$c$d$e$f-$r1$r2$r3$r4$r5\033[0m\n\n"
}

main()
{
	if [[ $ARG1 == "-d" ]] || [[ $ARG1 == "--debug" ]]
	then
		generate_debug
		exit 0
	else
		if [[ $ARG1 -eq "" ]]
		then
			i=1
			if [[ $ARG2 != "-s" ]] && [[ $ARG2 != "--silent" ]]
			then
				printf "Windows 95 Product Key #$i:\t"
			fi
			generate
			exit 0
		elif (( ARG1 < 1 ))
		then
			printf "Invalid input! Please enter an integer between 1 and (2^63)-1 (inclusively)\n" >&2
			exit 1
		else
			i=1
			while (( i <= ARG1 ))
			do
				if [[ $ARG2 != "-s" ]] && [[ $ARG2 != "--silent" ]]
				then
					printf "Windows 95 Product Key #$i:\t"
				fi
				generate
				i=$(( i + 1 ))
			done
			exit 0
		fi
	fi
}

# Initialization:
ARG1=$1
ARG2=$2
main
printf "End of script error!\n" >&2
exit 2

# Exit Codes:
#	0 : Success
#	1 : Invalid argument: number of keys
#	2 : End of script!

#TODO: add validator
