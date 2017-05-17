From: Amir Goldstein <amir73il@gmail.com>
Subject: [WIP][RFC] questions about overlay index dir design
Date: Thu, 18 May 2017 02:08:19 +0300
Message-ID: <CAOQ4uxgTG5JhmAb2hQF0ZoyFAfdOCSPDcScNL=8y7xJ1sXiHJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36076 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753143AbdEQXIU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 17 May 2017 19:08:20 -0400
Received: by mail-oi0-f54.google.com with SMTP id h4so34264103oib.3
        for <linux-unionfs@vger.kernel.org>; Wed, 17 May 2017 16:08:19 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>

Miklos,

I'm trying to hold back posting review of WIP, especially during rc2 time,
but I would appreciate intermediate feedback on the design of this WIP,
so you won't need to 'simplify' it too much later...

WIP is at https://github.com/amir73il/linux/commits/ovl-index-dir.
I could post patches, but I rather not spam you now unless asked.

So far it does the job of creating the non-dir upper hardlinks in index
dir and unbreaking hardlinks on copy up (ignoring concurrent copy up
of 2 lower hardlinks for now).

One thing I would appreciate feedback on is my 'simplification' of
ovl_copy_up_one/locked() using actors.
Those functions got very convoluted with the tmpfile copy up method
and now I needed to add another copy up method (indexdir), so that
seemed like the right way to go.
What do you think?

The other thing I wanted to ask and it doesn't require you looking at
any code is how to handle backward compat of mount behavior when
workdir is reused for mount with a different upperdir.

The use case may seem odd, but I already ran into it with unionmount
testsuite ./run --ov=1 and with xfstest overlay/014.
Maybe those are the only examples in the world, but maybe not...

The problem is that if workdir/index contains hardlinks to a past upper
which has been rotated to lower, bad things can happen on copy up.
What I did so far is to store origin fh of upper root in index dir.
Mount forces read-only if index dir origin does not match upper root dir.

So with current WIP the behavior is that ./run --ov=1 fails after
rotating upper:

overlayfs: failed to verify origin dir (ino=19025, ret=-116) - were
layers copied?
overlayfs: failed to create directory /upper/work/index (errno: 17);
mounting read-only
 ./run --rename /mnt/a/no_foo104 /mnt/a/no_foo105
/mnt/a/no_foo104: Unexpected error: Read-only file system

It's easy to fix the testsuite, but it is doing something that was legal before
(provide the same workdir option with different upperdir options) and now
it fails.

The alternative is to blow away the index dir and recreate it when mounting
with an unverified upperdir. This will work fine for the testsuite, but not for
the obscure users out there using the same workdir to mount with few different
upperdir (not at the same time) - do we care?

I guess the best is to blow away index dir unless user explicitly opted-in
to not blow it away, e.g. by using mount option indexdir= in place of workdir=
(mutually excl.).

Thoughts?

Amir.

------- Sneak Preview of index dir layout ---------------------

root@kvm-xfstests:~/unionmount-testsuite# ls -li /upper/0/a/
total 60
18957 -rw-r--r-- 3 daemon daemon 12 May 17 22:27 foo100
18967 -rw-r--r-- 3 daemon daemon 12 May 17 22:27 foo101
18977 -rw-r--r-- 3 daemon daemon 12 May 17 22:27 foo102
18985 -rw-r--r-- 3 daemon daemon 12 May 17 22:27 foo103
18993 -rw-r--r-- 3 daemon daemon 12 May 17 22:27 foo104
18998 -rw-r--r-- 3 daemon daemon 12 May 17 22:27 foo105
19008 -rw-r--r-- 2 daemon daemon 12 May 17 22:27 foo106
19013 -rw-r--r-- 3 daemon daemon 12 May 17 22:27 foo107
18957 -rw-r--r-- 3 daemon daemon 12 May 17 22:27 no_foo100
18967 -rw-r--r-- 3 daemon daemon 12 May 17 22:27 no_foo101
18977 -rw-r--r-- 3 daemon daemon 12 May 17 22:27 no_foo102
18985 -rw-r--r-- 3 daemon daemon 12 May 17 22:27 no_foo103
18993 -rw-r--r-- 3 daemon daemon 12 May 17 22:27 no_foo104
18998 -rw-r--r-- 3 daemon daemon 12 May 17 22:27 no_foo106
19013 -rw-r--r-- 3 daemon daemon 12 May 17 22:27 no_foo107
root@kvm-xfstests:~/unionmount-testsuite# ls -li /upper/work/index/
total 32
18957 -rw-r--r-- 3 daemon daemon 12 May 17 22:27
00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c597a48000000000000
18967 -rw-r--r-- 3 daemon daemon 12 May 17 22:27
00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c598748000000000000
18977 -rw-r--r-- 3 daemon daemon 12 May 17 22:27
00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c599448000000000000
18985 -rw-r--r-- 3 daemon daemon 12 May 17 22:27
00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c59a148000000000000
18993 -rw-r--r-- 3 daemon daemon 12 May 17 22:27
00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c59ae48000000000000
18998 -rw-r--r-- 3 daemon daemon 12 May 17 22:27
00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c59bb48000000000000
19008 -rw-r--r-- 2 daemon daemon 12 May 17 22:27
00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c59c848000000000000
19013 -rw-r--r-- 3 daemon daemon 12 May 17 22:27
00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c59d548000000000000
root@kvm-xfstests:~/unionmount-testsuite# getfattr -m overlay -d -e
hex /upper/work/index/*
getfattr: Removing leading '/' from absolute path names
# file: upper/work/index/00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c597a48000000000000
trusted.overlay.origin=0x00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c597a48000000000000

# file: upper/work/index/00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c598748000000000000
trusted.overlay.origin=0x00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c598748000000000000

# file: upper/work/index/00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c599448000000000000
trusted.overlay.origin=0x00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c599448000000000000

# file: upper/work/index/00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c59a148000000000000
trusted.overlay.origin=0x00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c59a148000000000000

# file: upper/work/index/00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c59ae48000000000000
trusted.overlay.origin=0x00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c59ae48000000000000

# file: upper/work/index/00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c59bb48000000000000
trusted.overlay.origin=0x00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c59bb48000000000000

# file: upper/work/index/00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c59c848000000000000
trusted.overlay.origin=0x00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c59c848000000000000

# file: upper/work/index/00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c59d548000000000000
trusted.overlay.origin=0x00fb210001d42610c5ec7847a48b42cc54df7fb72658ce1c59d548000000000000
