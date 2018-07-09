Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhC2cu=MXBO82+_g2q4u6xko6X_NPkGBwO4iUPNfeGAyg@mail.gmail.com>
References: <CALLuPvo2sS4Lv02EFwcYGJyoSdFEra_7_Mj1cE239-c0JrQuJQ@mail.gmail.com>
 <CAOQ4uxhrvavKkrPLrdSPSm6fze_aaDSrEp2c2VS5OkYaU4Ti6w@mail.gmail.com>
 <100530df1e875091b22ba05bbd578bc5b53db93c.camel@kernel.org> <CAOQ4uxhC2cu=MXBO82+_g2q4u6xko6X_NPkGBwO4iUPNfeGAyg@mail.gmail.com>
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Mon, 9 Jul 2018 14:19:10 +0800
Message-ID: <CALLuPvr-ajdTwkeN1UOSxdxWsXNPLP3V-cCFtC9xgBnb+mah3g@mail.gmail.com>
Subject: Re: Leaked POSIX lock warning and crash
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>
List-ID: <linux-unionfs@vger.kernel.org>

2018-07-07 3:30 GMT+08:00 Amir Goldstein <amir73il@gmail.com>:
> No. Only need to take care to always lock overlay inode and not underlying
> inode. It says you Acked this change, but you probably don't remember ;-)
>
> c568d68341be locks: fix file locking on overlayfs
>
> Eddie,
>
> Can you try to reproduce with kernel v4.18-rc1, which includes the fix:
>
> 01b39dcc9568 ovl: use inode_insert5() to hash a newly created inode
>
> I wasn't aware that the fix is for a real life bug, but worth the check,
> because leaking locks seems somewhat related to the fix - having
> non unique inode struct for same inode number with combination of
> locks and NFS is asking for trouble.
>
> Thanks,
> Amir.

Still reproduced the Leaked message on 4.18.0-rc4+.
The use case is build android, the Leaked message seems caused by each
flock() call through the build process, but if I make a simple flock()
on a file unser
the same dir, there's no any problem or dmesg message with that. Could the
problem is caused by many files are writing concurrently in the build process?

Thanks,
Eddie
