Return-Path: <zohar@linux.vnet.ibm.com>
Message-Id: <201605310229.u4V2SXlD046121@mx0a-001b2d01.pphosted.com>
Subject: Re: [PATCH v3 1/1] ovl: setxattr: don't deadlock when called from
 ima_fix_xattr.
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Mon, 30 May 2016 22:29:18 -0400
In-Reply-To: <20160530141015.GC5758@veci.piliscsaba.szeredi.hu>
References: <1463611500.2465.22.camel@linux.vnet.ibm.com>
	 <1463725718-2461-1-git-send-email-kli@iki.fi>
	 <1463754087.2763.17.camel@linux.vnet.ibm.com>
	 <20160520162937.GU14480@ZenIV.linux.org.uk>
	 <1463763633.2763.34.camel@linux.vnet.ibm.com>
	 <CAH4bDXjHjPSYAoQB8VODcDG2MRz30ZQqtrm+x7BWG-2X8qhGAg@mail.gmail.com>
	 <20160530141015.GC5758@veci.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Krisztian Litkey <kli@iki.fi>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, Krisztian Litkey <krisztian.litkey@intel.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, 2016-05-30 at 16:10 +0200, Miklos Szeredi wrote:
> On Fri, May 20, 2016 at 11:53:18PM +0300, Krisztian Litkey wrote:
> > On Fri, May 20, 2016 at 8:00 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > > We deferred __fput() back in 2012 in order for IMA to safely take the
> > > i_mutex and write security.ima.   Writing the security.ima xattr now
> > > triggers overlayfs to write the xattr, but overlayfs doesn't
> > > differentiate between callers - as a result of userspace or as described
> > > here in __fput().   All calls to ovl_setxattr() should call vfs_sexattr,
> > > except the one triggered by __fput().   Refer to the original lockdep
> > > report -
> > > http://thread.gmane.org/gmane.linux.file-systems.union/640
> 
> Looks like more fallout from 4bacc9c9234c ("overlayfs: Make f_path always point
> to the overlay and f_inode to the underlay").
> 
> Not sure what we want here.  Doing everything on the underlying dentry/inode
> would be trivial (see attached patch).
> 
> Question is, can we get setxattr() on file opened for O_RDONLY?  If so, then
> that could fail on overlayfs (lower layer is read-only).

Normally only after a file has been modified is the xattr written.
However in "fix" mode, the xattr would be written for files opened
read-only (eg. bprm, mmap execute).

Mimi
