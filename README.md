# OpenProject-Nomad

I have decided to share with anyone that is interesting an HCL for deploying OpenProject using Nomad as orchestrator.
I've tried to find anywhere if there was a hcl for openproject but I was really unlucky, if you want to use this file I want to give you some information about this:
- No PostgreSQL server is inside the HCL as in my use case I prefer to have the database in another cluster
- The tag I'm using for the version is currently 16.2, I will try to make some changes in the future to use the variables.
- I don't use any variables and secrets (I will do in a future version of it) so you have to change the IPs of the hostname.

## How to use

After fixing the IP and path of volumes you need to start the job uploading the hcl inside nomad and wait for it to download all the images.
I'm currently using consul-template to serve the config to nginx as loadbalancer & proxypass.
It has no multiple allocations as I don't need that but if anyone ask me to add that part I will sure do it for you.

## Copyright

I don't own Nomad, Consul, Consul-template, OpenProject. 
This project is only for help people to start OpenProject on Nomad + Consul.
