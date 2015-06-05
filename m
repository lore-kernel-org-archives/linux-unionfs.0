From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 2/2] ovl: allow distributed fs as lower layer
Date: Fri, 5 Jun 2015 17:37:29 +0200
Message-ID: <20150605150939.GA2174@tucsk>
References: <1433424586-7771-1-git-send-email-miklos@szeredi.hu>
 <1433424586-7771-3-git-send-email-miklos@szeredi.hu>
 <20150605000715.GP7232@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33798 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbbFEPho (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 5 Jun 2015 11:37:44 -0400
Received: by wgv5 with SMTP id 5so59838515wgv.1
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Jun 2015 08:37:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150605000715.GP7232@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, sa-dev@rainbow.by, andre.roth@roche.com

On Fri, Jun 05, 2015 at 01:07:15AM +0100, Al Viro wrote:

> Umm...  Cosmetical point is that this
> 
> > +static bool ovl_remote(struct dentry *root)
> > +{
> > +	const struct dentry_operations *dop = root->d_op;
> > +
> > +	return dop && (dop->d_revalidate || dop->d_weak_revalidate);
> > +}
> 
> is better done as
> 	root->d_flags & (DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE)

Okay.

> 
> More interesting question is whether anything in the system relies on
> existing behaviour that follows ->d_revalidate() returning 0.

Hmm, d_invalidate() almost always follows ->d_revalidate().  Almost, becuase RCU
lookup can get aborted at that point.  We can easily stick d_invalidate() in
there for the non-RCU case.

Regular lookup also almost always follows ->d_revalidate().  Except if
allocation of new dentry fails.  So relying on this would be buggy (which is not
to say nobody does it).

>  Have you tried to mount e.g. procfs as underlying layer and torture it for a
> while?

I did try now.  Nothing bad happened during the test (parallel stat(1) of the
whole overlayed proc tree).

My laptop froze while trying to write this mail.  But it's 8 years old and when
the fan starts to make noises and the weather is hot, it does this sometimes.  I
don't think that has anything to do with overlayfs, but will do more testing...

Thanks,
Miklos
