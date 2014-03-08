# Puppet Module for managing our KVM Hosts

manage installation and configuration of KVM hosts, as well as the provisioning of new VMs.

In a best case scenario, VMs just need to be placed in hiera.


## Documentation

Installing 

```puppet
     include kvmhost
```

## TODO

* we need to document exactly how to do the setup. i.e.: What values should be put into hiera to be able install a distribution.
* the preseed files [external.cfg](./templates/external.cfg) and [internal.cfg](./templates/internal.cfg) are too specific to Brainsware. There must be an easy way to replace them.
* our upstreams dependencies ([thias/libvirt](https://github.com/thias/puppet-libvirt) [jsosic/cobbler](https://bitbucket.org/jsosic/puppet-cobbler)) and have not yet accepted all of the features that this module depends on
* the code needs a little clean up (i.e.: what's the difference between cobbler::install.. and cobbler::config)

## Release process

The version in Modulefile should be bumped according to [semver](http://semver.org/) *during development*, i.e.: The first commit after the release should already bump the version, as master at this point differs from the latest release.

When cutting a new release, please

* make sure that all tests pass
* make sure that the documentation is up-to-date
* verify that all dependencies are correct, and up-to-date
* create a new, *signed* tag and a package, using `rake release`:

```
    igalic@levix ~/src/bw/puppet-kvmhost (git)-[master] % rake release
    git tag -s 1.3.2 -m 't&r 1.3.2'
    ...
    git checkout 1.3.2
    Note: checking out '1.3.2'.
    ...
    HEAD is now at ff9aaae... Most awesomest feature ever. SHIPIT!
    puppet module build .
    Notice: Building /home/igalic/src/bw/puppet-kvmhost for release
    Module built: /home/igalic/src/bw/puppet-kvmhost/pkg/brainsware-kvmhost-1.3.2.tar.gz
    igalic@levix ~/src/bw/puppet-kvmhost (git)-[1.3.2] %
```

* push the tag,

```
    igalic@levix ~/src/bw/puppet-kvmhost (git)-[1.3.2] % git push --tags origin
```

* and finally [upload the new package](http://forge.puppetlabs.com/brainsware/kvmhost/upload)

License
-------

Apache Software License 2.0


Contact
-------

You can send us questions via mail [puppet@brainsware.org](puppet@brainsware.org), or reach us IRC: [igalic](https://github.com/igalic) hangs out in [#puppet](irc://freenode.org/#puppet)

Support
-------

Please log tickets and issues at our [Project's issue tracker](https://github.com/Brainsware/puppet-kvmhost/issues)

