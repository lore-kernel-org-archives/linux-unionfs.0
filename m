Return-Path: <zohar@linux.ibm.com>
Subject: Re: EVM: Permission denied with overlayfs
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Wed, 19 Dec 2018 16:02:21 -0500
In-Reply-To: <CAOQ4uxhDh3okp1nYgZXxG+2siChfT8Oq3ncH1FFhQW_zBCstzw@mail.gmail.com>
References: <12c81a49-efca-d66c-2143-ae04ca248cce@suse.de>
	 <1545174031.4178.8.camel@linux.ibm.com>
	 <1545233975.3954.8.camel@linux.ibm.com>
	 <1545238601.2916.13.camel@HansenPartnership.com>
	 <1545243311.3954.22.camel@linux.ibm.com>
	 <1545248096.2916.26.camel@HansenPartnership.com>
	 <CAOQ4uxhDh3okp1nYgZXxG+2siChfT8Oq3ncH1FFhQW_zBCstzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1545253341.3954.83.camel@linux.ibm.com>
To: Amir Goldstein <amir73il@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: iforster@suse.de, Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-integrity@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, 2018-12-19 at 22:12 +0200, Amir Goldstein wrote:
> On Wed, Dec 19, 2018 at 9:34 PM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > On Wed, 2018-12-19 at 13:15 -0500, Mimi Zohar wrote:
> > > On Wed, 2018-12-19 at 08:56 -0800, James Bottomley wrote:
> > > > On Wed, 2018-12-19 at 10:39 -0500, Mimi Zohar wrote:
> > > > > Confirmed, in linux-4.18.y d_backing_inode returns the real
> > > > > i_ino, but newer kernels do not.
> > > >
> > > > Just so we're clear, this isn't an issue with d_backing_inode(),
> > > > which hasn't changed since its introduction in 2015 and which
> > > > always returns dentry->d_inode (it was originally a helper for
> > > > unionfs which got merged even though unionfs didn't, which makes it
> > > > and the comment about upper/lower totally misleading).  The problem
> > > > is that overlayfs has changed the inode it places into d_inode.
> > > >
> > > > >   This is a problem for EVM as the i_ino is included in the HMAC
> > > > > calculation.
> > > >
> > > > Isn't the solution always to use portable signatures for
> > > > containers?
> > > > It's problematic to include inode and generation with an overlay
> > > > because if you change the metadata it gets copied up => new inode
> > > > number and generation on the upper filesystem but if we were always
> > > > using the underlying inode number and generation, the signature
> > > > would then be wrong on the copied up file.
> > > >
> > > > At base, most container images are sets of tar files, which are not
> > > > inode number preserving anyway, so even if we find a convoluted way
> > > > to fix the above, the EVM signature has to be portable because
> > > > otherwise its always wrong for container images.
> > >
> > > Ignaz's use case was mutable files, not immutable files with file
> > > signatures.
> >
> > The word "mutable" is problematic in terms of overlays.  Only the upper
> > layer is mutable, so if your EVM signed file is anywhere other than in
> > the top layer it's technically immutable.  What you get when you mutate
> > it is a copy up.  the VFS guarantee is that inode numbers are stable
> > only for the current mount and may change on a remount.  Most disk
> > backed filesystems have inode numbers encoded in their on disk inodes,
> > which is why they have far more stability than the simple VFS
> > requirement, but some filesystems can't have long term stable inode
> > numbers.  We recognise this problem in EVM with so called "portable
> > signatures" that don't include the inode number and generation.

For portable signatures, to bind the file metadata with the file data,
we've replaced the inode number and generation, with the
"security.ima" xattr.  Do we want this requirement/limitation for
overlays?

The existing EVM portable signature is an asymmetric algorithm based
signature.  Would we define a "portable" HMAC?

> > I'm interested in discussing two points
> >
> >    1. Can we actually come up with semantics where the EVM signature is
> >       always valid for overlays?
> 
> What you are looking for is a persistent and stable identifier for
> the inode object. Such a property already exists for filesystems that
> support NFS file handles.
> 
> As I wrote, you can *sometimes* rely on overlay i_ino to be consistent
> and stable (it will usually have the value of the pre copy up lower inode
> even after copy up), bug i_generation is nonsense.
> 
> You can *always* rely on overlay file handle to be a unique indetifier
> of the inode (even after mount cycle) as long as nfs_export=on and
> overlayfs supports NFS file handles (as well as the underlying layers).
> 
> 
> >    2. If the answer to 1. is "no" should we not always use portable
> >       signatures for overlay cases?
> 
> You can determine if overlayfs has exportfs ops and choose portable
> non-portable signatures per instance.
> 
> >
> > I think there are a load of nasty corner cases in 1. that make 2. far
> > more preferable, but perhaps we can begin with the use case that
> > requires non-portable signatures with overlays, because I don't think
> > I've heard it yet.
> >
> > >   Prior to 4.19, EVM was calculating and verifying the file
> > > HMAC properly.  With 4.19, it stopped working because the i_ino used
> > > in calculating the HMAC value stored in security.evm, is not the same
> > >  when verifying the HMAC value.
> >
> > Yes, but the same thing would happen on cifs or NFS or any other
> > filesystem that constructs inode numbers on the fly.  If we're not
> > proposing trying to fix them, why fix overlayfs?

Both EVM and IMA have been limited to local filesystems, originally
dependent on i_version.  Only recently has there been interest in
remote file systems.  There's a lot more than just adding a portable
EVM format to support remote filesystems.

Mimi
> 
> NFS file handles as inode identifier would work for those as well.
> 
> Thanks,
> Amir.
> 
