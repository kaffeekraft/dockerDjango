VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # setup vagrant VM with port forwarding and folder sharing
  config.vm.box = "ubuntu/trusty64"
  config.vm.network :forwarded_port, guest: 8000, host: 8000
  config.vm.network :forwarded_port, guest: 2022, host: 2022
  config.vm.network :forwarded_port, guest: 3306, host: 3306
  config.vm.synced_folder ".", "/vagrant"

  # VM needs 1024 memory with less mysql container would not start properly
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end

  # provision the docker container using the Dockerfile
  config.vm.provision "docker" do |d|
    # build image from ubuntu base
    d.pull_images "ubuntu:trusty"
    d.pull_images "mysql:5.6.20"
    d.build_image "/vagrant", args: "-t django/project"

    # start the mysql box first
    d.run "mysql:5.6.20",
        args: "--name mysqlDB -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=db -d -p 3306:3306"

    # start the backend box and link it with the mysql
    d.run "django/project",
        args: "--name django_project -d -i -v '/vagrant:/django' -p 8000:8000 -p 2022:22 --link mysqlDB:mysql"

  end
end
