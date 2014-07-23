From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs v22 on kernel 3.15.5
Date: Wed, 23 Jul 2014 13:48:00 +0200
Message-ID: <CAJfpegs1_iTJJGvLddyF=-L9YreVCzbDL-Pum70FTO6W+MvozQ@mail.gmail.com>
References: <CAJfpeguH=BmevY+SM8HKBATS7B+htcX7_WLRiMFmypW_D-424Q@mail.gmail.com>
	<3a4b4cc25d1a8325934ba439d4777c35.squirrel@webmail.univie.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:43107 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaGWLsB (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 23 Jul 2014 07:48:01 -0400
Received: by mail-qa0-f53.google.com with SMTP id v10so1108300qac.12
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Jul 2014 04:48:00 -0700 (PDT)
In-Reply-To: <3a4b4cc25d1a8325934ba439d4777c35.squirrel@webmail.univie.ac.at>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Klaus Kreil <klaus.kreil@univie.ac.at>
Cc: linux-unionfs@vger.kernel.org

On Wed, Jul 23, 2014 at 1:40 PM, Klaus Kreil <klaus.kreil@univie.ac.at> wrote:
> >
>> Is there some hint in the dmesg output?
>>
> The messag from dmesg reads as follows:
> [    1.323319] overlayfs: failed to resolve '/.work': -2
>
> Now that I find strange because an ls -la /mnt/root_rw from the emergency
> shell started from my initramfs looks as follows:
> # ls -la /mnt/root_rw/
> total 52
> drwxr-xr-x   11 0        0             4096 Jul 21 22:57 .
> drwxr-xr-x    5 0        0                0 Jul 20 23:36 ..
> drwxr-xr-x    2 0        0             4096 Jul 20 23:26 .work
> drwxr-xr-x    2 0        0             4096 Feb 25 23:36 dev
> drwxr-xr-x    7 0        0             4096 Jul 21 22:31 etc
> drwxr-xr-x    3 0        0             4096 Mar  3 21:10 lib64
> drwx------    2 0        0            16384 Feb 25 23:28 lost+found
> drwx------    2 0        0             4096 May 29 13:01 root
> drwxr-xr-x    2 0        0             4096 Jul 21 22:30 run
> drwxrwxrwt    4 0        0             4096 Jul 21 22:31 tmp
> drwxr-xr-x    6 0        0             4096 Apr 25 18:47 var
>
> To me this shows that the directory actually exists ... although the error
> message states that it "failed to resolve" and not "No such file or
> directory" or a similar message.
>
> The mount command from within the initramfs (all on one line) looks as
> follows:
> mount -t overlayfs overlayfs -o
> lowerdir=/mnt/root_ro,upperdir=/mnt/root_rw,workdir=/.work /mnt/root
>
> and the output from the mount command (also from within the rescue-shell):
> # mount
> none on /dev type devtmpfs (0)
> none on /proc type proc (0)
> none on /sys type sysfs (0)
> /dev/xvda1 on /mnt/root_ro type ext4 (ro,noatime)
> /dev/xvda3 on /mnt/root_rw type ext4 (noatime,user_xattr,acl)
>
> So I am still somehow at loss and don't know where to go from here.
>
> Thanks again and best regards,
>
> Klaus
>
> P.S. Do you want me to move this discussion the the mailing list?
>
