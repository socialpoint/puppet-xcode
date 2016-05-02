# xcode

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with xcode](#setup)
    * [What xcode affects](#what-xcode-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with xcode](#beginning-with-xcode)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module helps you manage your installed versions of Xcode on your Mac OS X system.

## Module Description

If applicable, this section should have a brief description of the technology
the module integrates with and what that integration enables. This section
should answer the questions: "What does this module *do*?" and "Why would I use
it?"

If your module has a range of functionality (installation, configuration,
management, etc.) this is the time to mention it.

## Setup

### What xcode affects

This module will help install Xcode by source (dmg) into your Mac OS X Applications directory

### Setup Requirements

No special configuration needed

### Beginning with xcode

## Usage

To use the module simply the Xcode module, the invoke the 'xcode::instance' define with the versions of Xcode you'd like to have installed.

```
include xcode

xcode::instance {
    'Xcode v7.1.1':
        ensure      => present,
        source_url  => 'http://cache.mydomain.com/xcode/Xcode_7.1.1.dmg';
}
```

By default, this module will *not* accept the EULA for Xcode. However, if you pass in the parameter 'eula' as 'accept', we will accept the EULA for Xcode requiring no manual intervention.

If the value of 'eula' is not 'accept', then the EULA will be left as is.

## Reference

A new facter 'xcode_versions' will list an array of hash that contain the installed Xcode versions. The hash is in the form of: `{build: <number>, version: <string>}`

For example:
```
[
    {
        version: '7.1.1',
        build: '7B1005'
    },
    ...
]
```

## Limitations

This module *doesn't* enforce Xocde to OS X version compatibility. If you install an Xcode version, the onus is on you to ensure that version of Xcode works with the version of Mac OS X you've installed it on.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes

## Version 0.0.1

This is the initial release
