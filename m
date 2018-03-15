Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALLuPvr+z_NiGVBDhOOtsahjSo0Vn9Y5wi+Pg6FDvFjKkwZPZA@mail.gmail.com>
References: <CALLuPvpczs-UiDkoHURAu7weCHJCv9U6xKxDKck=5U85T55ukw@mail.gmail.com>
 <CALLuPvr+z_NiGVBDhOOtsahjSo0Vn9Y5wi+Pg6FDvFjKkwZPZA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Mar 2018 15:13:01 +0200
Message-ID: <CAOQ4uxi1qFM5UguMswnAWWCGNVwzNYMr_rJtN=+Bt9tUhhPFuA@mail.gmail.com>
Subject: Re: readdir returns d_type=DT_UNKNOWN to overlay exported dir (NFSv3)
Content-Type: text/plain; charset="UTF-8"
To: Eddie Horng <eddiehorng.tw@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Trond Myklebust <trondmy@primarydata.com>, "J. Bruce Fields" <bfields@fieldses.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 15, 2018 at 11:47 AM, Eddie Horng <eddiehorng.tw@gmail.com> wrote:
> I tried to track the difference between overlay-NFSv3 and ext4-NFSv3
> of encode_post_op_attr.
> mount configuration:
> none /share overlay
> rw,relatime,lowerdir=/base/lower,upperdir=/base/upper,workdir=/base/work,index=on,nfs_export=on
> 0 0
> localhost:/share /mnt/n nfs
> rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=127.0.0.1,mountvers=3,mountport=40931,mountproto=udp,local_lock=none,addr=127.0.0.1
> 0 0
> /dev/loop0 /share2 ext4 rw,relatime,data=ordered 0 0
> localhost:/share2 /mnt/n2 nfs
> rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=127.0.0.1,mountvers=3,mountport=40931,mountproto=udp,local_lock=none,addr=127.0.0.1
> 0 0
>
> file tree:
> /mnt/n
> |-- dirA
> |   `-- bar
> |-- dirL
> |   `-- ro-file
> `-- foo
>
> /mnt/n2
> `-- lost+found
>
> Attached log are dmesg start from "readdir /mnt/n (n2)" with nfs and
> nfsd log are enabled all by sunrpc.nfs(d)_debug. I also add a
> dump_stack() in the beginning of encode_post_op_attr.
>
> It seems overlay and ext4 have different call flow after "nfsd:
> READDIR+", there is no failure in overlay's encode_post_op_attr, nfsd
> does fill the attrs, same as ext4 but it has additional readdir call
> to child node of "/". I'm not sure if this is normal to overlay and is
> the cause of DT_UNKNOWN.

I tried to follow nfsd readdir code to see where the difference can come
from, but nothing poped at me so far.

>
> In additional, overlay returns DT_UNKNOWN to either lower dir or merged dir.

Your test is readdir of a merged dir, the behavior could differ when readdir of
an overlayfs non merged dir.

Please send the output and dmesg of readdir of the non-merged lower dir:

/readdir/a.out /mnt/n/dirL

Please mount an NFS share of /base and send the output of the same dir:

/readdir/a.out /mnt/n_base/lower/n/dirL

Right now I speculate that the issue you report is related to
how merged dirs are iterated, but not sure exactly why.

Thanks,
Amir.
