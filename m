Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38996 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932556AbeBULm4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Feb 2018 06:42:56 -0500
Date: Wed, 21 Feb 2018 12:42:58 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: FAILED: patch "[PATCH] ovl: hash directory inodes for fsnotify"
 failed to apply to 4.14-stable tree
Message-ID: <20180221114258.GD6555@kroah.com>
References: <151870507410538@kroah.com>
 <CAOQ4uxhBfq2_J+190kkoTcr2FDYDYrF2J99opRLdDjMDpE-8RA@mail.gmail.com>
 <20180215154431.GA26404@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180215154431.GA26404@axis.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Niklas Cassel <niklas.cassel@axis.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, stable <stable@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Feb 15, 2018 at 04:44:31PM +0100, Niklas Cassel wrote:
> On Thu, Feb 15, 2018 at 05:02:32PM +0200, Amir Goldstein wrote:
> > On Thu, Feb 15, 2018 at 4:31 PM,  <gregkh@linuxfoundation.org> wrote:
> > >
> > > The patch below does not apply to the 4.14-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > >
> > 
> > Hi Niklas,
> > 
> > The conflict resolution of this patch for v4.14 is trivial (just dropping last
> > hunk of inode.c patch), but I no means to test this right now.
> > 
> > Are you able and/or interested to test the attached backport path for
> > stable kernel v4.14?
> > 
> > I have posted an LTP test (inotify07) to test this fix if anyone else
> > is interested in testing:
> > https://github.com/linux-test-project/ltp/pull/246
> > 
> > Thanks,
> > Amir.
> 
> Hello Amir,
> 
> I have already backported+verified the fix to v4.13 in one of our internal
> trees.
> 
> Like you said, I simply dropped the last hunk of the patch that modfied
> inode.c, i.e. I simply ignored this hunk of the patch:
> 
> @@ -685,7 +702,7 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
>  		ovl_set_flag(OVL_IMPURE, inode);
>  
>  	/* Check for non-merge dir that may have whiteouts */
> -	if (S_ISDIR(realinode->i_mode)) {
> +	if (is_dir) {
>  		struct ovl_entry *oe = dentry->d_fsdata;
>  
>  		if (((upperdentry && lowerdentry) || oe->numlower > 1) ||
> 

Ok, last hunk dropped, thanks.

greg k-h
