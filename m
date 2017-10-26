From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 09/13] ovl: Set OVL_UPPERDATA flag during ovl_lookup()
Date: Thu, 26 Oct 2017 14:04:18 -0400
Message-ID: <20171026180418.GE28005@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
 <1508958575-14086-10-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxiKJdJbdBQGipQGCR5ZO=rJXbXJV+zSCwQrkBj7AF-K8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52656 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932331AbdJZSET (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 14:04:19 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiKJdJbdBQGipQGCR5ZO=rJXbXJV+zSCwQrkBj7AF-K8Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Oct 26, 2017 at 09:19:38AM +0300, Amir Goldstein wrote:
[..]
> > @@ -634,6 +653,20 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> >                                                roe->numlower, &stack, &ctr);
> >                         if (err)
> >                                 goto out_put_upper;
> > +
> > +                       err = ovl_check_metacopy(upperdentry);
> 
> You should avoid checking metacopy xattr for file types that are not
> eligable.

Sure. Will do.

Vivek
