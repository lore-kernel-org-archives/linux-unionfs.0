Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27574C433F5
	for <linux-unionfs@archiver.kernel.org>; Thu,  2 Dec 2021 02:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239089AbhLBDAR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 1 Dec 2021 22:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbhLBDAR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Dec 2021 22:00:17 -0500
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609CFC061574
        for <linux-unionfs@vger.kernel.org>; Wed,  1 Dec 2021 18:56:55 -0800 (PST)
Received: by mail-ua1-x930.google.com with SMTP id az37so53163411uab.13
        for <linux-unionfs@vger.kernel.org>; Wed, 01 Dec 2021 18:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=ISbXAX2IRfinLtcNWuglie3CP9+GRi5kOK4lb9s6wYA=;
        b=Hy3FYklYZTW1iIf6Dbdn50NSEVCtqfBYyviTG3xzNQQc0q+eV6I2qF/nu2BBTKLNyl
         RxSclori9bbRcht5ejwUZfW+NF/4fUmbeAs4YMswrNOocprI3dWQyA45PQkprfAmxt2f
         9GRYAKeqEr/WjFt3cwhzxbKkdg5fYYP5sM0jd45CSKUvYgvvcgqyxif5kAUb3m3IG6ja
         TMG5uBIFizq8DLTAC+HVhpI7IZnJUT31DCvHNSVNrnxPuZPwJ+4QW729b7Oe5EkYWHyP
         td0bEO6M6AZvwdFL8bVgRcyOIfepCb+5JdZAmz/W5dCUjgDOpQ0kyVYQhZn7OKavJlhB
         BE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ISbXAX2IRfinLtcNWuglie3CP9+GRi5kOK4lb9s6wYA=;
        b=La4zGXDWpPjOlsMfHQGd5x2v6yruWZdzy0wGVKDiRuPH1j5tcF+4vo8Ti3EJnZSiYc
         XO/2n8UVQmJxRVRsdP7uz0jLo68K1bGRkREvrNqKIsNpKC2tQ1IovjMWGXqjfzLroFo4
         7QPx3D2IW4tWAaGSydl9y3Iv8odvts2F//IxD7bSO99F0xRCWTeU7JTX68yACXouQtjj
         VdM2FgE/BcWGVUaP/GDl7qTthL9HrpzhI1qT02kngnajBZYAmdwaFcX3qwrr6VQU/JAf
         vvoPvmPRqgvwZ91uhjUvDiNdCmwap7fU1s8aO2YTj5CH2m4quoyZSfz+5QxRFJTKwCPC
         3vdw==
X-Gm-Message-State: AOAM5307d+GkGQ1YVblwPeczF7gXj4FwOgjLduw2dtCWhfVhcifoRVSb
        aK7dxQCJdRf8N6z3tAvCrXZ4Ee5ujpSOJGSqaFkjWd8RAJs=
X-Google-Smtp-Source: ABdhPJysld8WtMBJP1JYikM7XVO8+vpgPIfrmZX+9NG9G6HqyexmzFkXTVBgZOI9CmVrGWXP7w/iZP36DBXBYiFk/CU=
X-Received: by 2002:a67:fb41:: with SMTP id e1mr13004332vsr.28.1638413814116;
 Wed, 01 Dec 2021 18:56:54 -0800 (PST)
MIME-Version: 1.0
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Wed, 1 Dec 2021 18:56:27 -0800
Message-ID: <CADmzSSiE_XKnN3XaoP5HFV_3LOwOe9txCfbcEPAm-8B_9HkLRA@mail.gmail.com>
Subject: nfsd blocked
To:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

there is overlayfs in the middle of the stack dump, so I think this is
the place to post.   happy to post it somewhere else if directed.

currently very reproducible - 3 times in a row, rebooting both clent
and server between.

tt may be related to me setting nfsvers=3. I plan on testing this
guess, but it may be a while. hours or maybe a day or 2.

I tried to pin down the file operation client side, but that hasn't
happened yet either.

client and server Details:

server: raspberry pi v3,
pi@rpi-cb-1f-f7:~$ uname -a
Linux rpi-cb-1f-f7 5.10.63-v7+ #1488 SMP Thu Nov 18 16:14:44 GMT 2021
armv7l GNU/Linux

pi@rpi-cb-1f-f7:~$ cat /etc/exports
/srv/nfs/rpi/bullseye/root/merged
*(rw,sync,no_subtree_check,no_root_squash,fsid=2)

pi@rpi-cb-1f-f7:~$ findmnt /srv/nfs/rpi/bullseye/root/merged | cat
TARGET                            SOURCE  FSTYPE  OPTIONS
/srv/nfs/rpi/bullseye/root/merged overlay overlay
rw,relatime,lowerdir=/srv/nfs/rpi/bullseye/root/setup:/srv/nfs/rpi/bullseye/root/base,upperdir=/srv/nfs/rpi/bullseye/root/updates,workdir=/srv/nfs/rpi/bullseye/root/work,index=on,nfs_export=on

pi@rpi-cb-1f-f7:~$ findmnt  /
TARGET SOURCE         FSTYPE OPTIONS
/      /dev/mmcblk0p2 ext4   rw,noatime

client: also a pi:
pi@raspberrypi:~ $ uname -a
Linux raspberrypi 5.10.63-v8+ #1488 SMP PREEMPT Thu Nov 18 16:16:16
GMT 2021 aarch64 GNU/Linux

root@raspberrypi:~# cat /etc/fstab
# proc            /proc           proc    defaults          0       0
10.21.0.1:/srv/nfs/rpi/bullseye/root/merged / nfs defaults,auto,rw,nfsvers=3 0 0

root@raspberrypi:~# findmnt /|cat
/      10.21.0.1:/srv/nfs/rpi/bullseye/root/merged nfs
rw,relatime,vers=3,rsize=4096,wsize=4096,namlen=255,hard,nolock,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.21.0.1,mountvers=3,mountproto=tcp,local_lock=all,addr=10.21.0.1

on the client, I run
apt autoremove --assume-yes




[ 1103.834869] INFO: task nfsd:1029 blocked for more than 122 seconds.
[ 1103.834889]       Tainted: G         C        5.10.63-v7+ #1488
[ 1103.834901] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1103.834915] task:nfsd            state:D stack:    0 pid: 1029
ppid:     2 flags:0x00000000
[ 1103.834945] Backtrace:
[ 1103.834992] [<809f9df0>] (__schedule) from [<809fa7c8>] (schedule+0x68/0xe4)
[ 1103.835015]  r10:00000000 r9:86f67d4c r8:8fc134a0 r7:00000002
r6:00000001 r5:86dc4d80
[ 1103.835029]  r4:ffffe000
[ 1103.835056] [<809fa760>] (schedule) from [<8017bcac>]
(rwsem_down_write_slowpath+0x318/0x518)
[ 1103.835072]  r5:ffffe000 r4:8fc13490
[ 1103.835094] [<8017b994>] (rwsem_down_write_slowpath) from
[<809fd700>] (down_write+0x6c/0x70)
[ 1103.835116]  r10:7f0f2df4 r9:00000000 r8:8c696bb0 r7:82ba73d0
r6:85d00600 r5:8fc13490
[ 1103.835129]  r4:8fc13490
[ 1103.835195] [<809fd694>] (down_write) from [<7f6676b8>]
(ovl_dir_release+0x34/0x70 [overlay])
[ 1103.835211]  r5:8fc13490 r4:96d1eb80
[ 1103.835267] [<7f667684>] (ovl_dir_release [overlay]) from
[<803359f0>] (__fput+0x90/0x25c)
[ 1103.835286]  r7:82ba73d0 r6:000a841d r5:8fc13408 r4:85d00600
[ 1103.835307] [<80335960>] (__fput) from [<80335c24>] (delayed_fput+0x4c/0x58)
[ 1103.835328]  r9:8fc13408 r8:00000122 r7:00000100 r6:80f05008
r5:86f67e34 r4:85d00180
[ 1103.835348] [<80335bd8>] (delayed_fput) from [<80335c4c>]
(flush_delayed_fput+0x1c/0x20)
[ 1103.835363]  r5:86f67e34 r4:00000001
[ 1103.835570] [<80335c30>] (flush_delayed_fput) from [<7f0c7ec4>]
(nfsd_file_close_inode_sync+0x180/0x188 [nfsd])
[ 1103.835916] [<7f0c7d44>] (nfsd_file_close_inode_sync [nfsd]) from
[<7f0c065c>] (nfsd_unlink+0x230/0x270 [nfsd])
[ 1103.835938]  r8:ffffc000 r7:92419068 r6:86f44000 r5:937dd3b8 r4:86fa0008
[ 1103.836285] [<7f0c042c>] (nfsd_unlink [nfsd]) from [<7f0ca3f4>]
(nfsd3_proc_remove+0x80/0xd8 [nfsd])
[ 1103.836308]  r9:00000018 r8:96dd5000 r7:86f44000 r6:86fa0008
r5:86fa0000 r4:86f38000
[ 1103.836650] [<7f0ca374>] (nfsd3_proc_remove [nfsd]) from
[<7f0b973c>] (nfsd_dispatch+0xc8/0x14c [nfsd])
[ 1103.836669]  r7:96dd5014 r6:7f0f2df4 r5:86f45000 r4:86f44000
[ 1103.836856] [<7f0b9674>] (nfsd_dispatch [nfsd]) from [<809ca22c>]
(svc_process_common+0x374/0x70c)
[ 1103.836878]  r9:86f45000 r8:86f45a20 r7:86f44000 r6:80f05008
r5:00000014 r4:86f44184
[ 1103.836901] [<809c9eb8>] (svc_process_common) from [<809ca69c>]
(svc_process+0xd8/0xec)
[ 1103.836923]  r10:856abcfc r9:86f44000 r8:81016540 r7:7f100bc4
r6:816cae00 r5:bab24000
[ 1103.836937]  r4:86f44000
[ 1103.837120] [<809ca5c4>] (svc_process) from [<7f0b9100>]
(nfsd+0xf4/0x164 [nfsd])
[ 1103.837135]  r5:00057e40 r4:86f44000
[ 1103.837321] [<7f0b900c>] (nfsd [nfsd]) from [<80143790>]
(kthread+0x170/0x174)
[ 1103.837342]  r9:86f44000 r8:7f0b900c r7:86f66000 r6:00000000
r5:892b9580 r4:847acbc0
[ 1103.837364] [<80143620>] (kthread) from [<801000ec>]
(ret_from_fork+0x14/0x28)
[ 1103.837378] Exception stack(0x86f67fb0 to 0x86f67ff8)
[ 1103.837396] 7fa0:                                     00000000
00000000 00000000 00000000
[ 1103.837415] 7fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[ 1103.837434] 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[ 1103.837454]  r10:00000000 r9:00000000 r8:00000000 r7:00000000
r6:00000000 r5:80143620
[ 1103.837467]  r4:892b9580


-- 
Carl K
