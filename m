From: Andrew Vagin <avagin@odin.com>
Subject: procfs reports unexpected mnt_id and path for overlayfs files
Date: Wed, 15 Apr 2015 11:50:14 +0300
Message-ID: <20150415085013.GA8907@odin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:46799 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbbDOIuV (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 15 Apr 2015 04:50:21 -0400
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: criu@openvz.org, linux-unionfs@vger.kernel.org, saied@google.com

Hello Miklos and Everyone else,

We have a report that a container with overlayfs can't be checkpointed.

To dump file descriptors we get information from /proc/pid/fd/ and /proc/pid/fdinfo.

But in case of overlayfs we see unexpected values there.

/proc/PID/fdinfo/FD contains mnt_id which isn't presented in /proc/pid/mountinfo.
/proc/PID/fd/FD does not contain an absolute path to the opened file.

Can someone help to fix these issues?

Here is a sequance of commands to reproduce the problem:

[root@ ]# mount -t overlay overlay -olowerdir=a,upperdir=b,workdir=c z
[root@ ]# cat /proc/self/mountinfo | grep over
163 77 0:42 / /home/avagin/tmp/z rw,relatime shared:109 - overlay overlay rw,lowerdir=a,upperdir=b,workdir=c
[root@ ]# ls -l /home/avagin/tmp/z/a
-rw-r--r-- 1 root root 0 Apr 14 09:43 /home/avagin/tmp/z/a
[root@ ]# ipython
In [1]: fd = open("/home/avagin/tmp/z/a")

In [2]: 
[1]+  Stopped                 ipython
[root@ ]# ps -C ipython
  PID TTY          TIME CMD
 8868 pts/6    00:00:00 ipython
[root@ ]# cat /proc/8868/fdinfo/5 
pos:	0
flags:	0100000
mnt_id:	164

# we expect to see mnt_id: 163

[root@ ]# ls -l /proc/8868/fd/5
lr-x------ 1 root root 64 Apr 15 11:21 /proc/8868/fd/5 -> /a

# we expect to see /proc/8868/fd/5 -> /home/avagin/tmp/z/a

Thanks,
Andrew
