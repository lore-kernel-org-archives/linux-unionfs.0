Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhxMKL1-gQdgsChG=EUNH+wVnfxrXkkO-nyas4wdfdtyQ@mail.gmail.com>
References: <CALLuPvpczs-UiDkoHURAu7weCHJCv9U6xKxDKck=5U85T55ukw@mail.gmail.com>
 <CALLuPvr+z_NiGVBDhOOtsahjSo0Vn9Y5wi+Pg6FDvFjKkwZPZA@mail.gmail.com>
 <CAOQ4uxi1qFM5UguMswnAWWCGNVwzNYMr_rJtN=+Bt9tUhhPFuA@mail.gmail.com>
 <1521120161.86246.4.camel@primarydata.com> <CALLuPvooC7jjPRPfGc3MPKN0bX3aiN_51A_9ugs+1Sk3=sshzA@mail.gmail.com>
 <CAOQ4uxhO6rEA+gru45ZuWc-9twRguuPRmfZmQiTfQu+QKTtM7w@mail.gmail.com> <CAOQ4uxhxMKL1-gQdgsChG=EUNH+wVnfxrXkkO-nyas4wdfdtyQ@mail.gmail.com>
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Fri, 16 Mar 2018 14:25:36 +0800
Message-ID: <CALLuPvpncQ7nXNb1Sg5zSUj6cqbQydB0G=d70jf=1LHYgC5WhQ@mail.gmail.com>
Subject: Re: readdir returns d_type=DT_UNKNOWN to overlay exported dir (NFSv3)
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Trond Myklebust <trondmy@primarydata.com>, "bfields@fieldses.org" <bfields@fieldses.org>, "miklos@szeredi.hu" <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "jlayton@kernel.org" <jlayton@kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

2018-03-16 5:48 GMT+08:00 Amir Goldstein <amir73il@gmail.com>:
> On Thu, Mar 15, 2018 at 8:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, Mar 15, 2018 at 4:30 PM, Eddie Horng <eddiehorng.tw@gmail.com> wrote:
> [...]
>> The problem *is* with nfsd+overlayfs, because nfsd verifies
>> in compose_entry_fh() that (dchild->d_inode->i_ino == ino), but it is not.
>> In that case, encode_entryplus_baggage() falls back to encoding xdr_zero.
>> In overlayfs stat.st_ino is consistent with readdir d_ino since kernel version
>> v4.15 and only for all layers on the same fs.
>>
>> However, there is no guaranty that inode->i_ino is the same as stat.st_ino.
>> Overlayfs exposes only stat.st_ino to user (as well as readdir d_ino), but
>> never (to my knowledge) does it expose inode->i_ino.
>>
>> There was a nfsd fix for a somewhat similar problem that went into v4.16-rc1:
>> 76c479480b9a nfsd: encode stat->mtime for getattr instead of inode->i_mtime
>>
>> The solution to the problem is to either convert all references of
>> nfsd to i_inode
>> with references to st_ino, or make sure to set inode->i_ino correctly for
>> overlayfs inodes.
>>
>> From first glimps, the change in nfsd looks non trivial.
>> The change to overlayfs seems doable, but didn't look closely yet.
>> Will try to come up with test patch for you.
>>
>
> Eddie,
>
> Please try this patch. It worked for me.
>
> Thanks,
> Amir.

Hi Amir,
The patch works like a charm in my first test, but when I switch lower
layer to different fs then upper and merged, problem comes again. The
configuration is:
/dev/loop0 /ro_mount ext4 rw,relatime,data=ordered 0 0
none /share overlay
rw,relatime,lowerdir=/ro_mount,upperdir=/base/upper,workdir=/base/work,index=on,nfs_export=on
0 0
localhost:/share /mnt/n nfs
rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=127.0.0.1,mountvers=3,mountport=40970,mountproto=udp,local_lock=none,addr=127.0.0.1
0 0

/ro_mount/
|-- lost+found
|-- ro-dir
`-- ro-file

result:
readdir: lost+found ino(b) type(0)
readdir: ro-file ino(c) type(0)
readdir: .. ino(e0001) type(0)
readdir: ro-dir ino(2003) type(0)
readdir: . ino(e0003) type(0)

ps. /ro_mount is created by:
truncate -s 1g image
mkfs.ext4 image
mount image /ro_mount

thanks,
Eddie
