MIME-Version: 1.0
Date: Tue, 17 Sep 2019 15:26:28 +0200
References: <23935.36189.612024.342204@informatik.uni-koeln.de>
	<CAJfpegsk30wCJY1WaQWJOibfw35TGYxUuPBYx8v7xObJBSgTAw@mail.gmail.com>
	<23936.43370.127198.222503@informatik.uni-koeln.de>
In-Reply-To: <23936.43370.127198.222503@informatik.uni-koeln.de>
Message-ID: <CAJfpegu0FprqEkgU2rDCiu-2nr=jwzS3wNZAj6oV-DEdv+v=eQ@mail.gmail.com>
Subject: Re: can overlayfs work wit NFS v4 as lower fs?
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Thomas Lange <lange@informatik.uni-koeln.de>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Sep 17, 2019 at 11:37 AM Thomas Lange
<lange@informatik.uni-koeln.de> wrote:
>
> >>>>> On Tue, 17 Sep 2019 10:10:11 +0200, Miklos Szeredi <miklos@szeredi.hu> said:
>
>     > This is most probably about nfs4 acl support.   Does "noacl" export
>     > option fix it?
> Unfortunately it's not possible to disable acl support for NFS v4 (only in Debian?).
> That's what I read in some articles.
>
> I've added no_acl to the exports line:
> # exportfs -v
> /files/scratch  134.95.9.128/25(ro,async,wdelay,no_root_squash,no_subtree_check,no_acl,sec=sys,ro,secure,no_root_squash,no_all_squash)
>
> But this command does not show the no_acl option:
>
> # cat /proc/fs/nfs/exports
> # Version 1.1
> # Path Client(Flags) # IPs
> /files  134.95.9.128/25(ro,no_root_squash,sync,no_wdelay,no_subtree_check,v4root,uuid=9d4520b3:676a426f:92251f2f:b0e40f3b,sec=390003:390004:390005:1)
> /       134.95.9.128/25(ro,no_root_squash,sync,no_wdelay,no_subtree_check,v4root,fsid=0,uuid=9d4520b3:676a426f:92251f2f:b0e40f3b,sec=390003:390004:390005:1)
> /files/scratch  134.95.9.128/25(ro,no_root_squash,async,wdelay,no_subtree_check,uuid=9d4520b3:676a426f:92251f2f:b0e40f3b,sec=1)
>
>
> I've also added -onoacl the the mount command on client side. Still the
> same results, when I want to write to a file in overlayfs
>
> 13415 openat(AT_FDCWD, "/b/merged/etc/test1", O_WRONLY|O_CREAT|O_TRUNC, 0666) = -1 EOPNOTSUPP (Operation not supported)
>
>
> I've checked the access to the  "original" file in the lower (NFS v4
> mounted) directory, by checking the results of getfacl and nfs4_getfacl.
>
>
> NFS v3, exportfs with no_acl
> ============================
> + strace -etrace=getxattr getfacl /b/lower/etc/test1
> getxattr("/b/lower/etc/test1", "system.posix_acl_access", 0x7ffcb6b56160, 132) = -1 EOPNOTSUPP (Operation not supported)
> getfacl: Removing leading '/' from absolute path names
>
> suenner[~]# strace -etrace=getxattr nfs4_getfacl /b/lower/etc/test1
> getxattr("/b/lower/etc/test1", "system.nfs4_acl", NULL, 0) = -1 EOPNOTSUPP (Operation not supported)
>
>
>
> NFS v4 using mount -onoacl, exportfs with no_acl
> ================================================
>
> + strace -etrace=getxattr getfacl /b/lower/etc/test1
> getxattr("/b/lower/etc/test1", "system.posix_acl_access", 0x7fff39fd9cd0, 132) = -1 EOPNOTSUPP (Operation not supported)
>
>
> + strace -etrace=getxattr nfs4_getfacl /b/lower/etc/test1
> getxattr("/b/lower/etc/test1", "system.nfs4_acl", NULL, 0) = 80
> getxattr("/b/lower/etc/test1", "system.nfs4_acl", "\0\0\0\3\0\0\0\0\0\0\0\0\0\26\1\207\0\0\0\6OWNER@\0\0\0\0\0", 80) = 80
>
>
> This shows that disabling ACL in NFS v4 does not work.
> Does this disturb the behaviour of overlayfs?

The problem is that overlayfs tries to copy-up the system.nfs4_acl,
but fails (no other filesystem supports this xattr).  Similar thing
happens with "cp --preserv=xattr".

Looking back...

  https://lore.kernel.org/linux-fsdevel/CAHpGcMKHjic6L+J0qvMYNG9hVCcDO1hEpx4BiEk0ZCKDV39BmA@mail.gmail.com/

Ah, the way to disable these is to disable acl on the exported filesystem.  I.e.

mount -oremount,noacl $EXPORTED_FS

Doesn't work if that filesystem is used for other purposes that need acls.

Thanks,
Miklos
