Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALLuPvrmqNUK80S59rgAc-LG+DcFWNijXkArC81r2R8cLAU95Q@mail.gmail.com>
References: <CALLuPvoJ_Eb4C9g4ouo97MUYAbYC0yJX0qVfJzihj2EGA5tbGQ@mail.gmail.com>
 <CAOQ4uxgpMefj36c3PJUM=ejyDuDges3Yv3f5-FaHKNL1wvYJKw@mail.gmail.com>
 <CALLuPvpm5mTaQS5CgE=5U4RPK9GyfvBQd5hL_9JDLNEE=3=q3w@mail.gmail.com>
 <CAOQ4uxhTqKkU_md1t8QSs9xGnBk+qr_3tv4FH3D5Nqg8jUpbQQ@mail.gmail.com> <CALLuPvrmqNUK80S59rgAc-LG+DcFWNijXkArC81r2R8cLAU95Q@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 13 Mar 2018 13:40:36 +0200
Message-ID: <CAOQ4uxhxS6Xu08WoL2_59BiUpL6yugLkYQTmkBnxhZiVgdRZ8Q@mail.gmail.com>
Subject: Re: flock fails in overlay nfs-exported file
Content-Type: text/plain; charset="UTF-8"
To: Eddie Horng <eddiehorng.tw@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trondmy@primarydata.com>, "J. Bruce Fields" <bfields@fieldses.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Mar 13, 2018 at 10:40 AM, Eddie Horng <eddiehorng.tw@gmail.com> wrote:
> Hi Amir,
> I've confirmed that the flock scenario works with NFS3:
> (caseA, /mnt/n is mount with -overs=3)
> open("/mnt/n/foo", O_RDONLY)            = 3
> flock(3, LOCK_EX|LOCK_NB)               = 0
>
> I plan to go for NFS3 rather then change open flag, because the
> behavior comes from an Android build toolchain:
> https://android.googlesource.com/platform/art/+/master/dex2oat/dex2oat.cc,
> line 2327. It could take long time to change it.
> Thanks your nice advise about inconsistent ro/rw fd issue, I'll watch
> out for it.
>
> However, after I switch to NFS3, I got another problem by readdir(3).
> readdir(3) returns dirent->d_type = 0 (DT_UNKNOWN) to a NFS3 mount
> overlay-nfs-exported dir. Same overlay nfs share dir mount with NFS4
> returns correct d_type. Although readdir(3) states that:
> Currently, only some filesystems (among them: Btrfs, ext2,
> ext3, and ext4) have full support for returning the file type
> in d_type.  All applications must properly handle a return of
> DT_UNKNOWN.
>
> I tested ext4 shared dir by NFS3 mount, d_type works. Native access to
> overlay dir works too.
> Do you have idea where could the problem is?
>

Not really. However, there is no use of DT_UNKNOWN constant
in overlayfs code nor in nfsd code. AFAICT, both overlayfs and nfsd
just pass through the d_type they get from the layer below.
nfs client, on the other hand, does play around with d_type -
see nfs[2|3|4]_decode_dirent(), but I can't say I understand what
these functions do or why the behavior would be affected by
exported overlayfs.
d_type logic seems to be affected by readdirplus, so I would try
mounting with nordirplus/rdirplus and see how they differ.

Thanks,
Amir.
