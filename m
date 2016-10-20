From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [POC/RFC PATCH] overlayfs: fix data inconsistency at copy up
Date: Thu, 20 Oct 2016 16:54:08 -0400
Message-ID: <20161020205408.GB1000@redhat.com>
References: <20161012133326.GD31239@veci.piliscsaba.szeredi.hu>
 <20161020204630.GA1000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58774 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752476AbcJTUyJ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Oct 2016 16:54:09 -0400
Content-Disposition: inline
In-Reply-To: <20161020204630.GA1000@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Jeremy Eder <jeder@redhat.com>, David Howells <dhowells@redhat.com>, Ratna Bolla <rbolla@portworx.com>, Gou Rao <grao@portworx.com>, Vinod Jayaraman <jv@portworx.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>

On Thu, Oct 20, 2016 at 04:46:30PM -0400, Vivek Goyal wrote:

[..]
> > +static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *to)
> > +{
> > +	struct file *file = iocb->ki_filp;
> > +	bool isupper = OVL_TYPE_UPPER(ovl_path_type(file->f_path.dentry));
> > +	ssize_t ret = -EINVAL;
> > +
> > +	if (likely(!isupper)) {
> > +		const struct file_operations *fop = ovl_real_fop(file);
> > +
> > +		if (likely(fop->read_iter))
> > +			ret = fop->read_iter(iocb, to);
> > +	} else {
> > +		struct file *upperfile = filp_clone_open(file);
> > +
> 
> IIUC, every read of lower file will call filp_clone_open(). Looking at the
> code of filp_clone_open(), I am concerned about the overhead of this call.
> Is it significant? Don't want to be paying too much of penalty for read
> operation on lower files. That would be a common case for containers.
> 

Looks like I read the code in reverse. So if I open a file read-only,
and if it has not been copied up, I will simply call read_iter() on
lower filesystem. But if file has been copied up, then I will call
filp_clone_open() and pay the cost. And this will continue till this
file is closed by caller. 

When file is opened again, by that time it is upper file and we will
install real fop in file (instead of overlay fop).

Vivek
