From: Raphael Hertzog <raphael@ouaza.com>
Subject: Re: Regression in overlayfs in 4.13: "could not fsync file" error by
 PostgreSQL
Date: Tue, 7 Nov 2017 11:11:25 +0100
Message-ID: <20171107101125.zwcfd4v3h6pfilhm@home.ouaza.com>
References: <20171103140046.h6oabi5tjqqvj6uj@home.ouaza.com>
 <CAOQ4uxhcWYRcGdwE0QXpZ-_4BFX7LGFyFkFrZSvUgf4PSUFBkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.vm.ouaza.com ([212.83.178.2]:46490 "EHLO mail.vm.ouaza.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754514AbdKGKL2 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 05:11:28 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhcWYRcGdwE0QXpZ-_4BFX7LGFyFkFrZSvUgf4PSUFBkg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

Hello Amir,

Le samedi 04 novembre 2017, Amir Goldstein a écrit :
> I tries mounting squashfs+overlayfs to /var/lib/postgresql and create
> db on Ubuntu and it seemed ok.

FWIW, in my failing case, it uses PostgreSQL 10.0 as in Debian
Testing/Unstable. In Ubuntu, it's only available in Bionic Beaver (development
release).

> > This bug report has been filed against Kali Linux in the first place:
> > https://bugs.kali.org/view.php?id=4332
> 
> - strace of the failing postgresql db create
> - dmesg from that time, specifically "overlayfs" messages
> - output of cat /proc/self/mountinfo (or better postgres pid instead of self)

Here's the relevant output, there's nothing appearing in kernel messages
at the time of the error.

root@kali:~# ps aux|grep postgres
postgres 31597  2.7  1.2 294416 25648 ?        S    09:32   0:00 /usr/lib/postgresql/10/bin/postgres -D /var/lib/postgresql/10/main -c config_file=/etc/postgresql/10/main/postgresql.conf
postgres 31599  0.0  0.1 294416  3928 ?        Ss   09:32   0:00 postgres: 10/main: checkpointer process
postgres 31600  0.0  0.1 294416  3928 ?        Ss   09:32   0:00 postgres: 10/main: writer process
postgres 31601  0.0  0.1 294416  3928 ?        Ss   09:32   0:00 postgres: 10/main: wal writer process
postgres 31602  0.0  0.3 294840  6624 ?        Ss   09:32   0:00 postgres: 10/main: autovacuum launcher process
postgres 31603  0.0  0.1 149348  3352 ?        Ss   09:32   0:00 postgres: 10/main: stats collector process
postgres 31604  0.0  0.2 294708  4880 ?        Ss   09:32   0:00 postgres: 10/main: bgworker: logical replication launcher
root     31618  0.0  0.0  12720   964 pts/1    S+   09:32   0:00 grep postgres
root@kali:~# cat /proc/31597/mountinfo
17 26 0:17 / /sys rw,nosuid,nodev,noexec,relatime shared:10 - sysfs sysfs rw
18 26 0:5 / /proc rw,nosuid,nodev,noexec,relatime shared:16 - proc proc rw
19 26 0:6 / /dev rw,nosuid,relatime shared:5 - devtmpfs udev rw,size=1005564k,nr_inodes=251391,mode=755
20 19 0:18 / /dev/pts rw,nosuid,noexec,relatime shared:6 - devpts devpts rw,gid=5,mode=620,ptmxmode=000
21 26 0:19 / /run rw,nosuid,noexec,relatime shared:8 - tmpfs tmpfs rw,size=205196k,mode=755
22 26 11:0 / /lib/live/mount/medium ro,noatime shared:2 - iso9660 /dev/sr0 ro,nojoliet,check=s,map=n,blocksize=2048
23 26 7:0 / /lib/live/mount/rootfs/filesystem.squashfs ro,noatime shared:3 - squashfs /dev/loop0 ro
24 26 0:20 / /lib/live/mount/overlay rw,relatime shared:4 - tmpfs tmpfs rw
26 1 0:22 / / rw,noatime shared:1 - overlay overlay rw,lowerdir=//filesystem.squashfs/,upperdir=/live/overlay//rw,workdir=/live/overlay//work
25 17 0:7 / /sys/kernel/security rw,nosuid,nodev,noexec,relatime shared:11 - securityfs securityfs rw
29 19 0:23 / /dev/shm rw,nosuid,nodev shared:7 - tmpfs tmpfs rw
30 21 0:24 / /run/lock rw,nosuid,nodev,noexec,relatime shared:9 - tmpfs tmpfs rw,size=5120k
31 17 0:25 / /sys/fs/cgroup ro,nosuid,nodev,noexec shared:12 - tmpfs tmpfs ro,mode=755
32 31 0:26 / /sys/fs/cgroup/unified rw,nosuid,nodev,noexec,relatime shared:13 - cgroup2 cgroup rw,nsdelegate
33 31 0:27 / /sys/fs/cgroup/systemd rw,nosuid,nodev,noexec,relatime shared:14 - cgroup cgroup rw,xattr,name=systemd
34 17 0:28 / /sys/fs/pstore rw,nosuid,nodev,noexec,relatime shared:15 - pstore pstore rw
35 31 0:29 / /sys/fs/cgroup/cpu,cpuacct rw,nosuid,nodev,noexec,relatime shared:17 - cgroup cgroup rw,cpu,cpuacct
36 31 0:30 / /sys/fs/cgroup/blkio rw,nosuid,nodev,noexec,relatime shared:18 - cgroup cgroup rw,blkio
37 31 0:31 / /sys/fs/cgroup/devices rw,nosuid,nodev,noexec,relatime shared:19 - cgroup cgroup rw,devices
38 31 0:32 / /sys/fs/cgroup/net_cls,net_prio rw,nosuid,nodev,noexec,relatime shared:20 - cgroup cgroup rw,net_cls,net_prio
39 31 0:33 / /sys/fs/cgroup/pids rw,nosuid,nodev,noexec,relatime shared:21 - cgroup cgroup rw,pids
40 31 0:34 / /sys/fs/cgroup/perf_event rw,nosuid,nodev,noexec,relatime shared:22 - cgroup cgroup rw,perf_event
41 31 0:35 / /sys/fs/cgroup/memory rw,nosuid,nodev,noexec,relatime shared:23 - cgroup cgroup rw,memory
42 31 0:36 / /sys/fs/cgroup/freezer rw,nosuid,nodev,noexec,relatime shared:24 - cgroup cgroup rw,freezer
43 31 0:37 / /sys/fs/cgroup/cpuset rw,nosuid,nodev,noexec,relatime shared:25 - cgroup cgroup rw,cpuset
44 18 0:38 / /proc/sys/fs/binfmt_misc rw,relatime shared:26 - autofs systemd-1 rw,fd=24,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=11412
45 17 0:8 / /sys/kernel/debug rw,relatime shared:27 - debugfs debugfs rw
46 19 0:39 / /dev/hugepages rw,relatime shared:28 - hugetlbfs hugetlbfs rw,pagesize=2M
47 19 0:16 / /dev/mqueue rw,relatime shared:29 - mqueue mqueue rw
80 26 0:42 / /tmp rw,nosuid,nodev,relatime shared:30 - tmpfs tmpfs rw
117 44 0:44 / /proc/sys/fs/binfmt_misc rw,relatime shared:31 - binfmt_misc binfmt_misc rw
259 21 0:46 / /run/user/0 rw,nosuid,nodev,relatime shared:172 - tmpfs tmpfs rw,size=205192k,mode=700
266 259 0:47 / /run/user/0/gvfs rw,nosuid,nodev,relatime shared:177 - fuse.gvfsd-fuse gvfsd-fuse rw,user_id=0,group_id=0
274 17 0:48 / /sys/fs/fuse/connections rw,relatime shared:182 - fusectl fusectl rw

As for strace output, postgresql is split over multiple processes. The one that
generates the error in the log is 31599 (checkpointer process). I also attach
some file listing of the directories that it fails to fsync. strace looks like
this (in loop):

# strace -f -p 31599
select(0, NULL, NULL, NULL, {tv_sec=1, tv_usec=0}) = 0 (Timeout)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
open("pg_xact", O_RDONLY)               = 3
fsync(3)                                = 0
close(3)                                = 0
open("pg_commit_ts", O_RDONLY)          = 3
fsync(3)                                = -1 EINVAL (Invalid argument)
close(3)                                = 0
rt_sigprocmask(SIG_SETMASK, ~[ILL TRAP ABRT BUS FPE KILL SEGV CONT STOP SYS RTMIN RT_1], NULL, 8) = 0
write(2, "2017-11-07 09:47:38.580 UTC [315"..., 98) = 98
select(0, NULL, NULL, NULL, {tv_sec=1, tv_usec=0}) = 0 (Timeout)
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
open("pg_xact", O_RDONLY)               = 3
fsync(3)                                = 0
close(3)                                = 0
open("pg_commit_ts", O_RDONLY)          = 3
fsync(3)                                = -1 EINVAL (Invalid argument)
close(3)                                = 0
rt_sigprocmask(SIG_SETMASK, ~[ILL TRAP ABRT BUS FPE KILL SEGV CONT STOP SYS RTMIN RT_1], NULL, 8) = 0
write(2, "2017-11-07 09:47:39.582 UTC [315"..., 98) = 98
# cat /proc/31599/mountinfo 
17 26 0:17 / /sys rw,nosuid,nodev,noexec,relatime shared:10 - sysfs sysfs rw
18 26 0:5 / /proc rw,nosuid,nodev,noexec,relatime shared:16 - proc proc rw
19 26 0:6 / /dev rw,nosuid,relatime shared:5 - devtmpfs udev rw,size=1005564k,nr_inodes=251391,mode=755
20 19 0:18 / /dev/pts rw,nosuid,noexec,relatime shared:6 - devpts devpts rw,gid=5,mode=620,ptmxmode=000
21 26 0:19 / /run rw,nosuid,noexec,relatime shared:8 - tmpfs tmpfs rw,size=205196k,mode=755
22 26 11:0 / /lib/live/mount/medium ro,noatime shared:2 - iso9660 /dev/sr0 ro,nojoliet,check=s,map=n,blocksize=2048
23 26 7:0 / /lib/live/mount/rootfs/filesystem.squashfs ro,noatime shared:3 - squashfs /dev/loop0 ro
24 26 0:20 / /lib/live/mount/overlay rw,relatime shared:4 - tmpfs tmpfs rw
26 1 0:22 / / rw,noatime shared:1 - overlay overlay rw,lowerdir=//filesystem.squashfs/,upperdir=/live/overlay//rw,workdir=/live/overlay//work
25 17 0:7 / /sys/kernel/security rw,nosuid,nodev,noexec,relatime shared:11 - securityfs securityfs rw
29 19 0:23 / /dev/shm rw,nosuid,nodev shared:7 - tmpfs tmpfs rw
30 21 0:24 / /run/lock rw,nosuid,nodev,noexec,relatime shared:9 - tmpfs tmpfs rw,size=5120k
31 17 0:25 / /sys/fs/cgroup ro,nosuid,nodev,noexec shared:12 - tmpfs tmpfs ro,mode=755
32 31 0:26 / /sys/fs/cgroup/unified rw,nosuid,nodev,noexec,relatime shared:13 - cgroup2 cgroup rw,nsdelegate
33 31 0:27 / /sys/fs/cgroup/systemd rw,nosuid,nodev,noexec,relatime shared:14 - cgroup cgroup rw,xattr,name=systemd
34 17 0:28 / /sys/fs/pstore rw,nosuid,nodev,noexec,relatime shared:15 - pstore pstore rw
35 31 0:29 / /sys/fs/cgroup/cpu,cpuacct rw,nosuid,nodev,noexec,relatime shared:17 - cgroup cgroup rw,cpu,cpuacct
36 31 0:30 / /sys/fs/cgroup/blkio rw,nosuid,nodev,noexec,relatime shared:18 - cgroup cgroup rw,blkio
37 31 0:31 / /sys/fs/cgroup/devices rw,nosuid,nodev,noexec,relatime shared:19 - cgroup cgroup rw,devices
38 31 0:32 / /sys/fs/cgroup/net_cls,net_prio rw,nosuid,nodev,noexec,relatime shared:20 - cgroup cgroup rw,net_cls,net_prio
39 31 0:33 / /sys/fs/cgroup/pids rw,nosuid,nodev,noexec,relatime shared:21 - cgroup cgroup rw,pids
40 31 0:34 / /sys/fs/cgroup/perf_event rw,nosuid,nodev,noexec,relatime shared:22 - cgroup cgroup rw,perf_event
41 31 0:35 / /sys/fs/cgroup/memory rw,nosuid,nodev,noexec,relatime shared:23 - cgroup cgroup rw,memory
42 31 0:36 / /sys/fs/cgroup/freezer rw,nosuid,nodev,noexec,relatime shared:24 - cgroup cgroup rw,freezer
43 31 0:37 / /sys/fs/cgroup/cpuset rw,nosuid,nodev,noexec,relatime shared:25 - cgroup cgroup rw,cpuset
44 18 0:38 / /proc/sys/fs/binfmt_misc rw,relatime shared:26 - autofs systemd-1 rw,fd=24,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=11412
45 17 0:8 / /sys/kernel/debug rw,relatime shared:27 - debugfs debugfs rw
46 19 0:39 / /dev/hugepages rw,relatime shared:28 - hugetlbfs hugetlbfs rw,pagesize=2M
47 19 0:16 / /dev/mqueue rw,relatime shared:29 - mqueue mqueue rw
80 26 0:42 / /tmp rw,nosuid,nodev,relatime shared:30 - tmpfs tmpfs rw
117 44 0:44 / /proc/sys/fs/binfmt_misc rw,relatime shared:31 - binfmt_misc binfmt_misc rw
259 21 0:46 / /run/user/0 rw,nosuid,nodev,relatime shared:172 - tmpfs tmpfs rw,size=205192k,mode=700
266 259 0:47 / /run/user/0/gvfs rw,nosuid,nodev,relatime shared:177 - fuse.gvfsd-fuse gvfsd-fuse rw,user_id=0,group_id=0
274 17 0:48 / /sys/fs/fuse/connections rw,relatime shared:182 - fusectl fusectl rw
# ls -al /proc/31599/cwd
lrwxrwxrwx 1 postgres postgres 0 Nov  7 09:48 /proc/31599/cwd -> /var/lib/postgresql/10/main
root@kali:~# ls -al /var/lib/postgresql/10/main
total 9
drwx------ 1 postgres postgres 200 Nov  7 09:32 .
drwxr-xr-x 1 postgres postgres  60 Oct 30 13:21 ..
drwx------ 1 postgres postgres  60 Oct 30 13:21 base
drwx------ 1 postgres postgres 360 Nov  7 09:32 global
drwx------ 2 postgres postgres   3 Oct 30 13:21 pg_commit_ts
drwx------ 2 postgres postgres   3 Oct 30 13:21 pg_dynshmem
drwx------ 4 postgres postgres  77 Oct 30 13:21 pg_logical
drwx------ 1 postgres postgres  60 Oct 30 13:21 pg_multixact
drwx------ 1 postgres postgres  60 Nov  7 09:32 pg_notify
drwx------ 2 postgres postgres   3 Oct 30 13:21 pg_replslot
drwx------ 2 postgres postgres   3 Oct 30 13:21 pg_serial
drwx------ 2 postgres postgres   3 Oct 30 13:21 pg_snapshots
drwx------ 2 postgres postgres   3 Oct 30 13:21 pg_stat
drwx------ 2 postgres postgres   3 Oct 30 13:21 pg_stat_tmp
drwx------ 2 postgres postgres  27 Oct 30 13:21 pg_subtrans
drwx------ 2 postgres postgres   3 Oct 30 13:21 pg_tblspc
drwx------ 2 postgres postgres   3 Oct 30 13:21 pg_twophase
-rw------- 1 postgres postgres   3 Oct 30 13:21 PG_VERSION
drwx------ 1 postgres postgres  60 Oct 30 13:21 pg_wal
drwx------ 1 postgres postgres  60 Oct 30 13:21 pg_xact
-rw------- 1 postgres postgres  88 Oct 30 13:21 postgresql.auto.conf
-rw------- 1 postgres postgres 130 Nov  7 09:32 postmaster.opts
-rw------- 1 postgres postgres 109 Nov  7 09:32 postmaster.pid
root@kali:~# ls -al /var/lib/postgresql/10/main/pg_commit_ts/
total 0
drwx------ 2 postgres postgres   3 Oct 30 13:21 .
drwx------ 1 postgres postgres 200 Nov  7 09:32 ..
root@kali:~# ls -al /var/lib/postgresql/10/main/pg_xact/
total 8
drwx------ 1 postgres postgres   60 Oct 30 13:21 .
drwx------ 1 postgres postgres  200 Nov  7 09:32 ..
-rw------- 1 postgres postgres 8192 Nov  7 09:42 0000

And here are the files in the underlying squashfs:
root@kali:~# ls -al /lib/live/mount/rootfs/filesystem.squashfs/var/lib/postgresql/10/main/
total 1
drwx------ 19 postgres postgres 367 Oct 30 13:21 .
drwxr-xr-x  3 postgres postgres  27 Oct 30 13:21 ..
drwx------  5 postgres postgres  74 Oct 30 13:21 base
drwx------  2 postgres postgres 822 Oct 30 13:21 global
drwx------  2 postgres postgres   3 Oct 30 13:21 pg_commit_ts
drwx------  2 postgres postgres   3 Oct 30 13:21 pg_dynshmem
drwx------  4 postgres postgres  77 Oct 30 13:21 pg_logical
drwx------  4 postgres postgres  45 Oct 30 13:21 pg_multixact
drwx------  2 postgres postgres  27 Oct 30 13:21 pg_notify
drwx------  2 postgres postgres   3 Oct 30 13:21 pg_replslot
drwx------  2 postgres postgres   3 Oct 30 13:21 pg_serial
drwx------  2 postgres postgres   3 Oct 30 13:21 pg_snapshots
drwx------  2 postgres postgres   3 Oct 30 13:21 pg_stat
drwx------  2 postgres postgres   3 Oct 30 13:21 pg_stat_tmp
drwx------  2 postgres postgres  27 Oct 30 13:21 pg_subtrans
drwx------  2 postgres postgres   3 Oct 30 13:21 pg_tblspc
drwx------  2 postgres postgres   3 Oct 30 13:21 pg_twophase
-rw-------  1 postgres postgres   3 Oct 30 13:21 PG_VERSION
drwx------  3 postgres postgres  69 Oct 30 13:21 pg_wal
drwx------  2 postgres postgres  27 Oct 30 13:21 pg_xact
-rw-------  1 postgres postgres  88 Oct 30 13:21 postgresql.auto.conf
root@kali:~# ls -al /lib/live/mount/rootfs/filesystem.squashfs/var/lib/postgresql/10/main/pg_xact/
total 8
drwx------  2 postgres postgres   27 Oct 30 13:21 .
drwx------ 19 postgres postgres  367 Oct 30 13:21 ..
-rw-------  1 postgres postgres 8192 Oct 30 13:21 0000
root@kali:~# ls -al /lib/live/mount/rootfs/filesystem.squashfs/var/lib/postgresql/10/main/pg_commit_ts/
total 0
drwx------  2 postgres postgres   3 Oct 30 13:21 .
drwx------ 19 postgres postgres 367 Oct 30 13:21 ..

Cheers,
-- 
Raphaël Hertzog ◈ Writer/Consultant ◈ Debian Developer

Discover the Debian Administrator's Handbook:
→ https://debian-handbook.info/get/
