Return-Path: <jlayton@kernel.org>
Message-ID: <1521037854.4552.19.camel@kernel.org>
Subject: Re: readdir returns d_type=DT_UNKNOWN to overlay exported dir
 (NFSv3)
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 14 Mar 2018 10:30:54 -0400
In-Reply-To: <1521037013.40526.8.camel@primarydata.com>
References: 
	<CALLuPvpczs-UiDkoHURAu7weCHJCv9U6xKxDKck=5U85T55ukw@mail.gmail.com>
	 <1521025377.4552.6.camel@kernel.org>
	 <1521037013.40526.8.camel@primarydata.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Trond Myklebust <trondmy@primarydata.com>, "eddiehorng.tw@gmail.com" <eddiehorng.tw@gmail.com>
Cc: "bfields@fieldses.org" <bfields@fieldses.org>, "miklos@szeredi.hu" <miklos@szeredi.hu>, "amir73il@gmail.com" <amir73il@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, 2018-03-14 at 14:16 +0000, Trond Myklebust wrote:
> On Wed, 2018-03-14 at 07:02 -0400, Jeff Layton wrote:
> > On Wed, 2018-03-14 at 16:42 +0800, Eddie Horng wrote:
> > > Hi Amir,
> > > Since the flock issue is clarified, I would like to start this new
> > > thread to discuss if we can find the cause of d_type=DT_UNKNOWN.
> > > First
> > 
> > This sounds like NOTABUG to me. As readdir(3) states:
> > 
> > Currently, only some filesystems (among them: Btrfs, ext2, ext3,
> > and ext4) have full support  for  returning  the  file  type  in
> > d_type.   All  applications  must  properly  handle  a return of
> > DT_UNKNOWN.
> > 
> > Applications that rely solely on d_type are effectively broken. You
> > always need to be able to follow up with a stat or equivalent.
> > 
> 
> Yes, but one of the main such applications is the "find" utility, which
> uses it to avoid calling stat() in order to discover the directories.
> For that reason, NFS does try to set the d_type flag when it is using
> readdirplus, and the server returns attributes for the entry in
> question. Otherwise, it is forced to default to DT_UNKNOWN.
> 

Yes, didn't mean to imply that we shouldn't try to fill these out where
we can, just that there are situations where we might not be able to do
so without taking a performance hit.

> Note that in the cases where the readdir entry has a matching dentry,
> we probably could try to do better by doing a d_lookup() and then
> filling the d_type. Is that worth doing?
> 

I like that idea. Filling out what info we can from the local cache is
almost always worthwhile.

An inode's d_type can never change, so you can just vet the fileid or fh
in the entry3 vs. the inode that comes back from d_lookup. If they match
then you can reliably fill that out.

> > > of all I tried rdirplus and nordirplus mount option but got no
> > > difference. Then I roughly trace call flow of nfs3_decode_dirent( )
> > > as
> > > below:
> > > 
> > > decode_fattr3()
> > >     fattr->mode = (be32_to_cpup(p++) & ~S_IFMT) | fmode;
> > >     fattr->valid |= NFS_ATTR_FATTR_V3;
> > > 
> > > decode_post_op_attr()
> > >     p = xdr_inline_decode(xdr, 4);
> > >     if (*p != xdr_zero)
> > >        return decode_fattr3(xdr, fattr);
> > > 
> > > nfs3_decode_dirent()
> > >     entry->d_type = DT_UNKNOWN;
> > >     if (entry->fattr->valid & NFS_ATTR_FATTR_V3)
> > >         entry->d_type = nfs_umode_to_dtype(entry->fattr->mode);
> > > 
> > > In overlay exported case, decode_post_op_attr hits *p==xdr_zero, so
> > > decode_fattr3 is not called, then d_type reamins DT_UNKNOWN in
> > > nfs3_decode_dirent. It seems nfs4_decode_dirent has very different
> > > way
> > > to decode file attr and maybe the xdr layout is quite different as
> > > well.I have not idea about how the xdr to be filled from overlay
> > > and
> > > nfsd's output. Could some of you master give a hint?
> > 
> > Very different.
> > 
> > The v3 client will sometimes issue a READDIR (just names and fileids
> > of
> > dirents) and sometimes a READDIRPLUS (same as READDIR + attributes)
> > depending on the expected size of the result and what sort of access
> > pattern the application has. If you get back DT_UNKNOWN, it's quite
> > possible that it chose to use a READDIR and therefore doesn't have
> > enough info to fill out the d_type.
> > 
> > Cheers,
> 
> -- 
> Trond Myklebust
> Linux NFS client maintainer, PrimaryData
> trond.myklebust@primarydata.com

-- 
Jeff Layton <jlayton@kernel.org>
