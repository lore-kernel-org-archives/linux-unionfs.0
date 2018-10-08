Return-Path: <zohar@linux.ibm.com>
Subject: Re: PROBLEM: IMA xattrs not written on overlayfs
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Mon, 08 Oct 2018 08:54:19 -0400
In-Reply-To: <CAOQ4uxhdMD0EtjOw-T7iAVnLgE5EMjgLOF+GYGP039QA6dKH7w@mail.gmail.com>
References: <81a0a75d-bd4e-25ef-b41b-adb65ac6dee8@suse.de>
	 <1538153671.3713.4.camel@linux.ibm.com>
	 <0e1ba67f-3091-2d56-a464-07e1a8251e5e@suse.de>
	 <2170726.hUdX192fWn@linux-e202.suse.de>
	 <CAJfpegtk=OD6GVVOOtBT4Lto9x73vnSGdTMrzK-uTvStE6KxWw@mail.gmail.com>
	 <1538601501.3702.217.camel@linux.ibm.com>
	 <CAJfpegt52N==WoSQt_GMwZnOPyoV38j3r8vL95Ds0-NakVFueg@mail.gmail.com>
	 <1538668350.3702.348.camel@linux.ibm.com>
	 <20181005025733.fjlz34pph2hzcsxd@merlin>
	 <1538735635.3702.423.camel@linux.ibm.com>
	 <CAOQ4uxhdMD0EtjOw-T7iAVnLgE5EMjgLOF+GYGP039QA6dKH7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1539003259.15382.110.camel@linux.ibm.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, fvogt@suse.de, iforster@suse.de, overlayfs <linux-unionfs@vger.kernel.org>, linux-integrity@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, 2018-10-07 at 11:22 +0300, Amir Goldstein wrote:
> On Fri, Oct 5, 2018 at 1:34 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> >
> > On Thu, 2018-10-04 at 21:57 -0500, Goldwyn Rodrigues wrote:
> > > On 11:52 04/10, Mimi Zohar wrote:
> > > > On Thu, 2018-10-04 at 00:35 +0200, Miklos Szeredi wrote:
> > > >
> > > > > Right, if it's done from last fput() then it's at least not a security hole.
> > > > >
> > > > > This hack may work for some filesystems, but as you noticed, it won't
> > > > > work for overlayfs.  And  if probably won't work for a number of other
> > > > > filesystems as well: the fs can assume that f_mode & FMODE_READ will
> > > > > remain off if it was off at open time.
> > > > >
> > > > > The proper way to handle it generally is to open a separate instance
> > > > > of the same file from IMA with O_RDONLY and use that to calculate the
> > > > > hash.   There's really no point in reusing the same file and hacking
> > > > > the f_mode bits.
> > > >
> > > > Is there an appropriate low level kernel call for creating a new file
> > > > descriptor that would be appropriate?  dentry_open(), like the call in
> > > > file_clone_open(), has a lot of overhead, including the LSM calls.
> > > >  Calculating the file hash always needs to work.
> > > >
> > >
> > > Mimi,
> > >
> > > I have formulated a patch which is working for me on overlayfs. I am
> > > using dentry_open(), which I agree may have overhead. While this
> > > opens up the possibility of using it for files opened with O_DIRECT
> > > which may end up getting the file into pagecache.
> > >
> > > Subject: [PATCH] Open new file instance O_RDONLY to calculate hash
> > >
> > > Using the open struct file to calculate the hash does not work
> > > with overlayfs, because the real struct file is hidden behind the
> > > overlays struct file. So, any file->f_mode manipulations are not
> > > reflected on the real struct file. So, open the file again, read and
> > > calculate the hash.
> > >
> > > As a byproduct, we can remove all instance of f_mode manipulations
> > > and can work with O_DIRECT as well.
> > >
> > > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> >
> > By "overhead", I didn't mean it from a performance perspective, but
> > was concerned about the dentry_open() failing.  If "dentry_open" fails
> > for any reason, the file hash will not be re-calculated, causing
> > future file opens to fail.
> 
> open_with_fake_path() looks like a better fit here.
> Skips irrelevant security checks and less likely to fail.

It skips the "cred" checking, but everything else seems to be the same
including the security_ checks.

Mimi
