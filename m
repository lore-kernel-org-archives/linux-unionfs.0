Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALLuPvoJ_Eb4C9g4ouo97MUYAbYC0yJX0qVfJzihj2EGA5tbGQ@mail.gmail.com>
References: <CALLuPvoJ_Eb4C9g4ouo97MUYAbYC0yJX0qVfJzihj2EGA5tbGQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 12 Mar 2018 14:07:16 +0200
Message-ID: <CAOQ4uxgpMefj36c3PJUM=ejyDuDges3Yv3f5-FaHKNL1wvYJKw@mail.gmail.com>
Subject: Re: flock fails in overlay nfs-exported file
Content-Type: text/plain; charset="UTF-8"
To: Eddie Horng <eddiehorng.tw@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Mar 12, 2018 at 9:38 AM, Eddie Horng <eddiehorng.tw@gmail.com> wrote:
> Hello Miklos,
> I'd like to report a flock(2) problem to overlay nfs-exported files.
> The error return from flock(2) is "Bad file descriptor".
>
> Environment:
> OS: Ubuntu 14.04.2 LTS
> Kernel: 4.16.0-041600rc4-generic (from
> http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.16-rc4/)
>
> Reproduce step:
> (nfs server side)
> mount -t overlay
> -orw,lowerdir=/mnt/ro,upperdir=/mnt/u,workdir=/mnt/w,nfs_export=on,index=on
> none /mnt/m
> touch /mnt/m/foo
> (nfs client side)
> mount server:/mnt/m /mnt/n
>
> flock /mnt/n/foo
> failed to lock file '/mnt/n/foo': Bad file descriptor
>

Does not reproduce on my end. I am using v4.16-rc5, but I don't think
any of the fixes there are relevant to this failure.

This is what I have for underlying fs, overlay and nfs mount options
(index and nfs_export are on by default in my kernel):

/dev/mapper/storage-lower_layer on /base type xfs
(rw,relatime,attr2,inode64,noquota)
share on /share type overlay
(rw,relatime,lowerdir=/base/lower,upperdir=/base/upper/0,workdir=/base/upper/work0)
c800:/share on /mnt/t type nfs
(rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.91.126,mountvers=3,mountport=49494,mountproto=udp,local_lock=none,addr=192.168.91.126)

$ touch /mnt/t/foo
$ flock -x -n /mnt/t/foo echo locked
locked

Please share more information about nfs mount options and underlying filesystem

Please check if you see any relevant errors/warnings in dmesg.

Thanks,
Amir.
