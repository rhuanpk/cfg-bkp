docker_remove_dangling_images() {
	docker image rm -f $(docker images -af 'dangling=true' | grep -F '<none>' | awk '{print $3}')
}
go_package_start() {
	pathway=/tmp/tmp/golang
	[ -d $pathway ] && rm -rfv ${pathway:?pathway no set!}/ && {
		mkdir -pv $pathway
		cd $pathway
		echo "pwd: `pwd`"
		touch ./main.go
		go mod init golang
		go mod tidy
	}
}
