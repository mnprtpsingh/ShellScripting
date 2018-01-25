welcome_message() {
	printf "\n\t1. Add Student Result\n"
	printf "\t2. Delete Student Result\n"
	printf "\t3. View Student Result\n"
	printf "\t4. Show Database\n"
	printf "\t5. Exit\n"
	printf "\n\n\tEnter number from 1 - 5: "
}

add_student() {
	printf "\n\tEnter Roll Number: "; read number
	awk -F "," '{print $1}' data.csv > temp
	grep "$number" temp > tmp
	mv tmp temp
	if [ -s temp ] ; then
		printf "\n\tEither this record already exits or is invalid! "
		rm temp; read -n 1 -s; return;
	fi
	printf "\tEnter Name: "; read name
	printf "\n\tEnter Marks in Computer Organisation: "; read co
	printf "\tEnter Marks in Operating Systems: "; read os
	printf "\tEnter Marks in Data Structures: "; read ds
	printf "\tEnter Marks in System Software: "; read ss
	printf "\tEnter Marks in Theory Of Computation: "; read toc
	printf "\tEnter Marks in Environmental Science: "; read evs
	total=`expr $co + $os + $ds + $ss + $toc + $evs`
	percentage=`bc <<< "scale=2; $total/6"`
	line="$number,$name,$co,$os,$ds,$ss,$toc,$evs,$total,$percentage"
	echo $line >> data.csv
	printf "\n\n\tStudent's result added successfully! "
	read -n 1 -s
}

delete_student() {
	if [ -s data.csv ] ; then
		printf "\n\tEnter Roll Number: "
		read number
	else
		printf "\n Database is empty, add student results first! "
		read -n 1 -s
		return
	fi
	awk -F "," '{print $1}' data.csv > temp
	grep "$number" temp > tmp
	mv tmp temp
	var=`cat temp`
	rm temp
	if [ "$number" == "$var" ] ; then
		sed -i "/$number/d" data.csv
		printf "\n\tRecord successfully deleted! "
		read -n 1 -s
	else
		printf "\n\tNo such record found! "
		read -n 1 -s
	fi
}

view_result() {
	if [ -s data.csv ] ; then
		printf "\n\tEnter Roll Number: "
		read number
	else
		printf "\n Database is empty, add student results first! "
		read -n 1 -s
		return
	fi
	grep "$number" data.csv > temp
	no_of_lines=`wc -l < temp`
	if [[ $no_of_lines < 1 || $no_of_lines > 1 ]] ; then
		printf "\n\tKindly check your input and try again! "
	else
		awk -F "," '{printf "\n\n\tRoll Number : %s", $1}' temp
		awk -F "," '{printf "\n\tName : %s", $2}' temp
		awk -F "," '{printf"\n\n\tComputer Organisation: %d", $3}' temp
		awk -F "," '{printf "\n\tOperating Systems : %d", $4}' temp
		awk -F "," '{printf "\n\tData Structures : %d", $5}' temp
		awk -F "," '{printf "\n\tSystem Software : %d", $6}' temp
		awk -F "," '{printf "\n\tTheory Of Computation : %d", $7}' temp
		awk -F "," '{printf "\n\tEnvironmental Science : %d", $8}' temp
		awk -F "," '{printf "\n\n\tTotal Marks : %d", $9}' temp
		awk -F "," '{printf "\n\tPercentage : %.2f ", $10}' temp
	fi
	rm temp
	read -n 1 -s
}

show_data() {
	if [ -s data.csv ] ; then
		printf "\n\n"
	else
		printf "\n Database is empty, add student results first! "
		read -n 1 -s
		return
	fi
	printf " Roll No    Name                   CO   OS   DS   SS"
	printf "  TOC  EVS  Total    Percent\n"
	awk -F "," '{printf " %-10s %-20s %4s %4s %4s %4s %4s %4s %6s %8s %%\n"\
		,$1, $2, $3, $4, $5, $6, $7, $8, $9, $10}' data.csv
	printf "\n "
	read -n 1 -s
}

#main body of script
while :
do
	clear
	welcome_message
	read choice
	clear
	case $choice in
		1) add_student ;;
		2) delete_student ;;
		3) view_result ;;
		4) show_data ;;
		5) exit ;;
		*) printf "\tTry Again! "; read -n 1 -s ;;
	esac
done
