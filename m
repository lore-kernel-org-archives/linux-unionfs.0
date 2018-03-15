Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALLuPvooC7jjPRPfGc3MPKN0bX3aiN_51A_9ugs+1Sk3=sshzA@mail.gmail.com>
References: <CALLuPvpczs-UiDkoHURAu7weCHJCv9U6xKxDKck=5U85T55ukw@mail.gmail.com>
 <CALLuPvr+z_NiGVBDhOOtsahjSo0Vn9Y5wi+Pg6FDvFjKkwZPZA@mail.gmail.com>
 <CAOQ4uxi1qFM5UguMswnAWWCGNVwzNYMr_rJtN=+Bt9tUhhPFuA@mail.gmail.com>
 <1521120161.86246.4.camel@primarydata.com> <CALLuPvooC7jjPRPfGc3MPKN0bX3aiN_51A_9ugs+1Sk3=sshzA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Mar 2018 20:40:01 +0200
Message-ID: <CAOQ4uxhO6rEA+gru45ZuWc-9twRguuPRmfZmQiTfQu+QKTtM7w@mail.gmail.com>
Subject: Re: readdir returns d_type=DT_UNKNOWN to overlay exported dir (NFSv3)
Content-Type: text/plain; charset="UTF-8"
To: Eddie Horng <eddiehorng.tw@gmail.com>
Cc: Trond Myklebust <trondmy@primarydata.com>, "bfields@fieldses.org" <bfields@fieldses.org>, "miklos@szeredi.hu" <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "jlayton@kernel.org" <jlayton@kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 15, 2018 at 4:30 PM, Eddie Horng <eddiehorng.tw@gmail.com> wrote:
> Hi Trond,
> As previous post I traced nfs3_decode_dirent and found *p==xdr_zero in
> decode_post_op_attr so fattr is not actually decoded from xdr. Could
> you suggest where to trace the xdr is encoded?
>
> decode_post_op_attr()
>     p = xdr_inline_decode(xdr, 4);
>     if (*p != xdr_zero)
>        return decode_fattr3(xdr, fattr);
>
> nfs3_decode_dirent()
>     entry->d_type = DT_UNKNOWN;
>     if (entry->fattr->valid & NFS_ATTR_FATTR_V3)
>         entry->d_type = nfs_umode_to_dtype(entry->fattr->mode);
>

Eddie,

Please don't "top post".
You are right. Problem is with overlayfs on server side.
See the explanation to the problem below.


>
> 2018-03-15 21:22 GMT+08:00 Trond Myklebust <trondmy@primarydata.com>:
>> On Thu, 2018-03-15 at 15:13 +0200, Amir Goldstein wrote:
>>> On Thu, Mar 15, 2018 at 11:47 AM, Eddie Horng <eddiehorng.tw@gmail.co
>>> m> wrote:
>>> > I tried to track the difference between overlay-NFSv3 and ext4-
>>> > NFSv3
>>> > of encode_post_op_attr.
>>> > mount configuration:
>>> > none /share overlay
>>> > rw,relatime,lowerdir=/base/lower,upperdir=/base/upper,workdir=/base
>>> > /work,index=on,nfs_export=on
>>> > 0 0
>>> > localhost:/share /mnt/n nfs
>>> > rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,prot
>>> > o=tcp,timeo=600,retrans=2,sec=sys,mountaddr=127.0.0.1,mountvers=3,m
>>> > ountport=40931,mountproto=udp,local_lock=none,addr=127.0.0.1
>>> > 0 0
>>> > /dev/loop0 /share2 ext4 rw,relatime,data=ordered 0 0
>>> > localhost:/share2 /mnt/n2 nfs
>>> > rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,prot
>>> > o=tcp,timeo=600,retrans=2,sec=sys,mountaddr=127.0.0.1,mountvers=3,m
>>> > ountport=40931,mountproto=udp,local_lock=none,addr=127.0.0.1
>>> > 0 0
>>> >
>>> > file tree:
>>> > /mnt/n
>>> > > -- dirA
>>> > >   `-- bar
>>> > > -- dirL
>>> > >   `-- ro-file
>>> >
>>> > `-- foo
>>> >
>>> > /mnt/n2
>>> > `-- lost+found
>>> >
>>> > Attached log are dmesg start from "readdir /mnt/n (n2)" with nfs
>>> > and
>>> > nfsd log are enabled all by sunrpc.nfs(d)_debug. I also add a
>>> > dump_stack() in the beginning of encode_post_op_attr.
>>> >
>>> > It seems overlay and ext4 have different call flow after "nfsd:
>>> > READDIR+", there is no failure in overlay's encode_post_op_attr,
>>> > nfsd
>>> > does fill the attrs, same as ext4 but it has additional readdir
>>> > call
>>> > to child node of "/". I'm not sure if this is normal to overlay and
>>> > is
>>> > the cause of DT_UNKNOWN.
>>>
[...]
>>
>> fs/nfsd has nothing to do with ${SUBJECT}.
>>
>> If you want to trace where the DT_UNKNOWN is coming from, then you need
>> to look at the _client_ code in fs/nfs/nfs3xdr.c:nfs3_decode_dirent().
>>

The problem *is* with nfsd+overlayfs, because nfsd verifies
in compose_entry_fh() that (dchild->d_inode->i_ino == ino), but it is not.
In that case, encode_entryplus_baggage() falls back to encoding xdr_zero.
In overlayfs stat.st_ino is consistent with readdir d_ino since kernel version
v4.15 and only for all layers on the same fs.

However, there is no guaranty that inode->i_ino is the same as stat.st_ino.
Overlayfs exposes only stat.st_ino to user (as well as readdir d_ino), but
never (to my knowledge) does it expose inode->i_ino.

There was a nfsd fix for a somewhat similar problem that went into v4.16-rc1:
76c479480b9a nfsd: encode stat->mtime for getattr instead of inode->i_mtime

The solution to the problem is to either convert all references of
nfsd to i_inode
with references to st_ino, or make sure to set inode->i_ino correctly for
overlayfs inodes.

>From first glimps, the change in nfsd looks non trivial.
The change to overlayfs seems doable, but didn't look closely yet.
Will try to come up with test patch for you.

Thanks for reporting and following up with debugging!
Amir.
