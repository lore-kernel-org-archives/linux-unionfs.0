Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1521120161.86246.4.camel@primarydata.com>
References: <CALLuPvpczs-UiDkoHURAu7weCHJCv9U6xKxDKck=5U85T55ukw@mail.gmail.com>
 <CALLuPvr+z_NiGVBDhOOtsahjSo0Vn9Y5wi+Pg6FDvFjKkwZPZA@mail.gmail.com>
 <CAOQ4uxi1qFM5UguMswnAWWCGNVwzNYMr_rJtN=+Bt9tUhhPFuA@mail.gmail.com> <1521120161.86246.4.camel@primarydata.com>
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Thu, 15 Mar 2018 22:30:15 +0800
Message-ID: <CALLuPvooC7jjPRPfGc3MPKN0bX3aiN_51A_9ugs+1Sk3=sshzA@mail.gmail.com>
Subject: Re: readdir returns d_type=DT_UNKNOWN to overlay exported dir (NFSv3)
Content-Type: text/plain; charset="UTF-8"
To: Trond Myklebust <trondmy@primarydata.com>
Cc: "amir73il@gmail.com" <amir73il@gmail.com>, "bfields@fieldses.org" <bfields@fieldses.org>, "miklos@szeredi.hu" <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "jlayton@kernel.org" <jlayton@kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Trond,
As previous post I traced nfs3_decode_dirent and found *p==xdr_zero in
decode_post_op_attr so fattr is not actually decoded from xdr. Could
you suggest where to trace the xdr is encoded?

decode_post_op_attr()
    p = xdr_inline_decode(xdr, 4);
    if (*p != xdr_zero)
       return decode_fattr3(xdr, fattr);

nfs3_decode_dirent()
    entry->d_type = DT_UNKNOWN;
    if (entry->fattr->valid & NFS_ATTR_FATTR_V3)
        entry->d_type = nfs_umode_to_dtype(entry->fattr->mode);

thanks,
Eddie

2018-03-15 21:22 GMT+08:00 Trond Myklebust <trondmy@primarydata.com>:
> On Thu, 2018-03-15 at 15:13 +0200, Amir Goldstein wrote:
>> On Thu, Mar 15, 2018 at 11:47 AM, Eddie Horng <eddiehorng.tw@gmail.co
>> m> wrote:
>> > I tried to track the difference between overlay-NFSv3 and ext4-
>> > NFSv3
>> > of encode_post_op_attr.
>> > mount configuration:
>> > none /share overlay
>> > rw,relatime,lowerdir=/base/lower,upperdir=/base/upper,workdir=/base
>> > /work,index=on,nfs_export=on
>> > 0 0
>> > localhost:/share /mnt/n nfs
>> > rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,prot
>> > o=tcp,timeo=600,retrans=2,sec=sys,mountaddr=127.0.0.1,mountvers=3,m
>> > ountport=40931,mountproto=udp,local_lock=none,addr=127.0.0.1
>> > 0 0
>> > /dev/loop0 /share2 ext4 rw,relatime,data=ordered 0 0
>> > localhost:/share2 /mnt/n2 nfs
>> > rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,prot
>> > o=tcp,timeo=600,retrans=2,sec=sys,mountaddr=127.0.0.1,mountvers=3,m
>> > ountport=40931,mountproto=udp,local_lock=none,addr=127.0.0.1
>> > 0 0
>> >
>> > file tree:
>> > /mnt/n
>> > > -- dirA
>> > >   `-- bar
>> > > -- dirL
>> > >   `-- ro-file
>> >
>> > `-- foo
>> >
>> > /mnt/n2
>> > `-- lost+found
>> >
>> > Attached log are dmesg start from "readdir /mnt/n (n2)" with nfs
>> > and
>> > nfsd log are enabled all by sunrpc.nfs(d)_debug. I also add a
>> > dump_stack() in the beginning of encode_post_op_attr.
>> >
>> > It seems overlay and ext4 have different call flow after "nfsd:
>> > READDIR+", there is no failure in overlay's encode_post_op_attr,
>> > nfsd
>> > does fill the attrs, same as ext4 but it has additional readdir
>> > call
>> > to child node of "/". I'm not sure if this is normal to overlay and
>> > is
>> > the cause of DT_UNKNOWN.
>>
>> I tried to follow nfsd readdir code to see where the difference can
>> come
>> from, but nothing poped at me so far.
>>
>> >
>> > In additional, overlay returns DT_UNKNOWN to either lower dir or
>> > merged dir.
>>
>> Your test is readdir of a merged dir, the behavior could differ when
>> readdir of
>> an overlayfs non merged dir.
>>
>> Please send the output and dmesg of readdir of the non-merged lower
>> dir:
>>
>> /readdir/a.out /mnt/n/dirL
>>
>> Please mount an NFS share of /base and send the output of the same
>> dir:
>>
>> /readdir/a.out /mnt/n_base/lower/n/dirL
>>
>> Right now I speculate that the issue you report is related to
>> how merged dirs are iterated, but not sure exactly why.
>
> fs/nfsd has nothing to do with ${SUBJECT}.
>
> If you want to trace where the DT_UNKNOWN is coming from, then you need
> to look at the _client_ code in fs/nfs/nfs3xdr.c:nfs3_decode_dirent().
>
> --
> Trond Myklebust
> Linux NFS client maintainer, PrimaryData
> trond.myklebust@primarydata.com
