Return-Path: <zohar@linux.ibm.com>
Subject: Re: PROBLEM: IMA xattrs not written on overlayfs
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Thu, 04 Oct 2018 11:52:30 -0400
In-Reply-To: <CAJfpegt52N==WoSQt_GMwZnOPyoV38j3r8vL95Ds0-NakVFueg@mail.gmail.com>
References: <81a0a75d-bd4e-25ef-b41b-adb65ac6dee8@suse.de>
	 <1538153671.3713.4.camel@linux.ibm.com>
	 <0e1ba67f-3091-2d56-a464-07e1a8251e5e@suse.de>
	 <2170726.hUdX192fWn@linux-e202.suse.de>
	 <CAJfpegtk=OD6GVVOOtBT4Lto9x73vnSGdTMrzK-uTvStE6KxWw@mail.gmail.com>
	 <1538601501.3702.217.camel@linux.ibm.com>
	 <CAJfpegt52N==WoSQt_GMwZnOPyoV38j3r8vL95Ds0-NakVFueg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1538668350.3702.348.camel@linux.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Fabian Vogt <fvogt@suse.de>, Ignaz Forster <iforster@suse.de>, overlayfs <linux-unionfs@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, 2018-10-04 at 00:35 +0200, Miklos Szeredi wrote:

> Right, if it's done from last fput() then it's at least not a security hole.
> 
> This hack may work for some filesystems, but as you noticed, it won't
> work for overlayfs.  And  if probably won't work for a number of other
> filesystems as well: the fs can assume that f_mode & FMODE_READ will
> remain off if it was off at open time.
> 
> The proper way to handle it generally is to open a separate instance
> of the same file from IMA with O_RDONLY and use that to calculate the
> hash.   There's really no point in reusing the same file and hacking
> the f_mode bits.

Is there an appropriate low level kernel call for creating a new file
descriptor that would be appropriate?  dentry_open(), like the call in
file_clone_open(), has a lot of overhead, including the LSM calls.
 Calculating the file hash always needs to work.

Mimi
