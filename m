From: Daniel Axtens <dja@axtens.net>
Subject: ext4_file_open: Inconsistent encryption contexts (commit ff978b09f973) breaking Docker
Date: Fri, 11 Mar 2016 11:44:54 +1100
Message-ID: <87io0t3ks9.fsf@gamma.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34218 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909AbcCKAo7 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 10 Mar 2016 19:44:59 -0500
Received: by mail-pa0-f41.google.com with SMTP id fe3so63290649pab.1
        for <linux-unionfs@vger.kernel.org>; Thu, 10 Mar 2016 16:44:59 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk, miklos@szeredi.hu, linux-unionfs@vger.kernel.org

Hi,

Trying to run a Docker container on a mainline kernel is failing
intermittently, in interesting and exciting ways, such as:

$ docker run -it --rm --env PACKAGE=sinatra npmtest
operation not permitted
docker: Error response from daemon: Cannot start container 4fc0120a6389f25241f84527a0d31854806f6fe4fd98d019f790cea0ae7e230b: [10] System error: operation not permitted.

$ docker run -it --rm --env PACKAGE=sinatra npmtest
Unable to find user tester
docker: Error response from daemon: Cannot start container a28d6256cfcde750e8e4ff60fc72217b19b58160df68f55d798ea2f3000c4564: [10] System error: Unable to find user tester.

$ docker run ...
...
Error: EPERM, operation not permitted '/usr/share/npm/node_modules/npmconf/node_modules/config-chain/index.js'

$ docker run ...
...
Error: EPERM, operation not permitted '/usr/lib/nodejs/form-data/form_data.js'

$ docker run ...
...
/bin/bash: /usr/bin/npm: Operation not permitted

Each of these failures is accompanied by lines in dmesg like these:

EXT4-fs warning (device sda2): ext4_file_open:402: Inconsistent encryption contexts: 27842/3691208

EXT4-fs warning (device sda2): ext4_file_open:402: Inconsistent encryption contexts: 41086/3128060

(With different context numbers each time)

Grepping for the error message took me to ff978b09f973:
"ext4 crypto: move context consistency check to ext4_file_open()"
which went in to mainline in rc5.

A build with the source rolled back to the commit immediately before
that doesn't exhibit the issue.

Docker is using Overlay filesystems backing onto an ext4 filesystem, so
some interaction between Overlay FS and ext4 may be the cause. I'm not
much of a file system developer so I don't really know where to go from
here, but I'm happy to help however I can.

The machine is a ppc64le VM running Ubuntu, docker 1.11.0-dev, build
dd32445. I've turned on most of the kernel debugging options I can think
of and nothing interesting is showing up. fsck reports the root ext4
filesystem is clean. If I've missed any helpful info please let me know.

Regards,
Daniel Axtens
