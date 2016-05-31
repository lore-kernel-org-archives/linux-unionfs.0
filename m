From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/1] ovl: setxattr: don't deadlock when called from
 ima_fix_xattr.
Date: Mon, 30 May 2016 22:29:18 -0400
Message-ID: <201605310229.u4V2SaON014180@mx0a-001b2d01.pphosted.com>
References: <1463611500.2465.22.camel@linux.vnet.ibm.com>
	 <1463725718-2461-1-git-send-email-kli@iki.fi>
	 <1463754087.2763.17.camel@linux.vnet.ibm.com>
	 <20160520162937.GU14480@ZenIV.linux.org.uk>
	 <1463763633.2763.34.camel@linux.vnet.ibm.com>
	 <CAH4bDXjHjPSYAoQB8VODcDG2MRz30ZQqtrm+x7BWG-2X8qhGAg@mail.gmail.com>
	 <20160530141015.GC5758@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59061 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162701AbcEaC3e (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 30 May 2016 22:29:34 -0400
Received: from pps.filterd (m0048827.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4V2SaON014180
	for <linux-unionfs@vger.kernel.org>; Mon, 30 May 2016 22:29:33 -0400
Received: from e28smtp05.in.ibm.com (e28smtp05.in.ibm.com [125.16.236.5])
	by mx0a-001b2d01.pphosted.com with ESMTP id 238k6v2fxr-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-unionfs@vger.kernel.org>; Mon, 30 May 2016 22:29:33 -0400
Received: from localhost
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-unionfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Tue, 31 May 2016 07:59:29 +0530
In-Reply-To: <20160530141015.GC5758@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Krisztian Litkey <kli@iki.fi>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, Krisztian Litkey <krisztian.litkey@intel.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel@vger.kernel.org

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
