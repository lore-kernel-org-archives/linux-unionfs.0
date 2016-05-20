From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/1] ovl: setxattr: don't deadlock when called from
 ima_fix_xattr.
Date: Fri, 20 May 2016 13:00:33 -0400
Message-ID: <1463763633.2763.34.camel@linux.vnet.ibm.com>
References: <1463611500.2465.22.camel@linux.vnet.ibm.com>
	 <1463725718-2461-1-git-send-email-kli@iki.fi>
	 <1463754087.2763.17.camel@linux.vnet.ibm.com>
	 <20160520162937.GU14480@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:51282 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbcETRBa (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 20 May 2016 13:01:30 -0400
Received: from localhost
	by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-unionfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Sat, 21 May 2016 03:01:27 +1000
In-Reply-To: <20160520162937.GU14480@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Krisztian Litkey <kli@iki.fi>, linux-unionfs@vger.kernel.org, Krisztian Litkey <krisztian.litkey@intel.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel@vger.kernel.org

On Fri, 2016-05-20 at 17:29 +0100, Al Viro wrote:
> On Fri, May 20, 2016 at 10:21:27AM -0400, Mimi Zohar wrote:
> > > +	if (mutex_is_locked(&upper->d_inode->i_mutex))
> > > +		err = __vfs_setxattr_noperm(upper, name, value, size, flags);
> > 
> > As far as I'm aware, the only time that i_mutex is taken, is during
> > __fput() when IMA writes security.ima.   Previous versions of this patch
> > checked whether the xattr being written was security.ima.  It would
> > probably be a good idea not to make that assumption here.   The question
> > is what should happen if the i_mutex is locked, but the xattr isn't
> > security.ima.  At minimum it should be audited.  Al, any comments?
> 
> ITYM "printable", and that's somewhat harder.  OK, let me try:
> 
> Anybody using ..._is_lock() kind of primitives that way ought to be
> (re)educated before they are allowed near any kind of multithreaded
> code _anywhere_.  mutex could've been held by a different thread of
> execution and dropped just as mutex_is_locked() returns.  Or at any
> subsequent point.  This is 100% bogus; one should *never* write that kind
> of code.  As in "here's your well-earned F-, better luck next semester".
> 
> I haven't seen the full patch (you've quoted only a part of that gem), but
> about the only way for it to be correct is to have it continue with
> + else
> +       err = <identical call>
> 
> 	Practically all calls of mutex_is_locked() are of form
> WARN_ON(!mutex_is_locked(...)) or equivalent thereof.  And the rest contains
> similar... wonders - for example, take a look at drivers/media/rc/imon.c;
> imon_ir_change_protocol() has this
>         if (!mutex_is_locked(&ictx->lock)) {
>                 unlock = true;
>                 mutex_lock(&ictx->lock);
>         }
> 
>         retval = send_packet(ictx);
>         if (retval)
>                 goto out;
> 
>         ictx->rc_type = *rc_type;
>         ictx->pad_mouse = false;
> 
> out:
>         if (unlock)
>                 mutex_unlock(&ictx->lock);
> Finding why it's exploitably racy is left as a trivial exercise for readers...
> 
> Folks, if you see something of that sort in the code, it's a huge red flag.
> There are legitimate uses of mutex_is_locked other than asserts, but those
> are extremely rare.

My fault for even suggesting it.

> I would need to see more context to be able to comment on the problem in
> question, but this patch is almost certainly broken.

We deferred __fput() back in 2012 in order for IMA to safely take the
i_mutex and write security.ima.   Writing the security.ima xattr now
triggers overlayfs to write the xattr, but overlayfs doesn't
differentiate between callers - as a result of userspace or as described
here in __fput().   All calls to ovl_setxattr() should call vfs_sexattr,
except the one triggered by __fput().   Refer to the original lockdep
report -    
http://thread.gmane.org/gmane.linux.file-systems.union/640

Al, any help in resolving this lockdep would be much appreciated.

Mimi
