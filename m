From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v6 14/15] ovl: Introduce read/write barriers around
 metacopy flag update
Date: Thu, 16 Nov 2017 10:13:56 -0500
Message-ID: <20171116151356.GA2937@redhat.com>
References: <20171109205019.11409-1-vgoyal@redhat.com>
 <20171109205019.11409-15-vgoyal@redhat.com>
 <CAOQ4uxhBvnFkma6qy=Be4uLDi-6aJmsgmpKGQ=XTJr8kXS0fmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54604 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934834AbdKPPN6 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Nov 2017 10:13:58 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhBvnFkma6qy=Be4uLDi-6aJmsgmpKGQ=XTJr8kXS0fmQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Nov 10, 2017 at 11:43:36AM +0200, Amir Goldstein wrote:
[..]
> > --- a/fs/overlayfs/util.c
> > +++ b/fs/overlayfs/util.c
> > @@ -267,13 +267,26 @@ bool ovl_has_upperdata(struct dentry *dentry) {
> >         if (!ovl_should_check_upperdata(dentry))
> >                 return true;
> >
> > -       return ovl_test_flag(OVL_UPPERDATA, d_inode(dentry));
> > +       if (!ovl_test_flag(OVL_UPPERDATA, d_inode(dentry)))
> > +               return false;
> > +       /*
> > +        * Pairs with smp_wmb() in ovl_copy_up_meta_inode_data(). Make sure
> > +        * if setting of OVL_UPPERDATA is visible, then effects of writes
> > +        * before that are visible too.
> > +        */
> > +       smp_rmb();
> > +       return true;
> >  }
> >
> 
> I think it is not right to have smp_rmb() is the locked path where it
> is not needed
> too costly.
> 
> We should probably have a different variant for ovl_already_copied_up_locked()
> and if OVL_UPPERDATA is set for all non-eligible cases, ovl_has_upperdata()
> can have the smp_rmb() and locked variant can just can check the flag directly.

How about adding a parameter "bool locked" to ovl_already_copied_up() and
ovl_has_upperdata(). So if locked is true, smp_rmb() will be skipped by
ovl_has_upperdata().

Vivek
