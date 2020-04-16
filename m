Return-Path: <SRS0=N6pz=6A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410EFC352BE
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 11:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AE8D21841
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 11:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506136AbgDPL2L (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 07:28:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:48884 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506048AbgDPLQb (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Apr 2020 07:16:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B3B98AC46;
        Thu, 16 Apr 2020 11:16:26 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 925671E1250; Thu, 16 Apr 2020 13:16:26 +0200 (CEST)
Date:   Thu, 16 Apr 2020 13:16:26 +0200
From:   Jan Kara <jack@suse.cz>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH v11] ovl: Improving syncfs efficiency
Message-ID: <20200416111626.GG23739@quack2.suse.cz>
References: <20200210031009.61086-1-cgxu519@mykernel.net>
 <CAJfpegtRXwOTCtEdrg7Yie0rJ=kokYTcL+7epXsDo-JNy5fNDA@mail.gmail.com>
 <171819ad12b.c2829cd3806.7048451563188038355@mykernel.net>
 <CAJfpegstttRvDNYjs9+LaAxFjN21rYn1EWYnZDrXGAKygOj_Hg@mail.gmail.com>
 <CAJfpegsOq72aPmX8_7_wGboz81ezHqOskGgJH9ZgtTnOfRv1Bg@mail.gmail.com>
 <CAJfpegsooG8-kVkozZYf3sP_UL78nTAaqmcUyPTktTiyzSa+Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJfpegsooG8-kVkozZYf3sP_UL78nTAaqmcUyPTktTiyzSa+Kw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu 16-04-20 10:00:13, Miklos Szeredi wrote:
> On Thu, Apr 16, 2020 at 9:39 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Thu, Apr 16, 2020 at 9:21 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Thu, Apr 16, 2020 at 8:09 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
> > > >
> > > >  ---- 在 星期四, 2020-04-16 03:19:50 Miklos Szeredi <miklos@szeredi.hu> 撰写 ----
> > > >  > On Mon, Feb 10, 2020 at 4:10 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
> > >
> > > >  > > +               if (current->flags & PF_MEMALLOC) {
> > > >  > > +                       spin_lock(&inode->i_lock);
> > > >  > > +                       ovl_set_flag(OVL_WRITE_INODE_PENDING, inode);
> > > >  > > +                       wqh = bit_waitqueue(&oi->flags,
> > > >  > > +                                       OVL_WRITE_INODE_PENDING);
> > > >  > > +                       prepare_to_wait(wqh, &wait.wq_entry,
> > > >  > > +                                       TASK_UNINTERRUPTIBLE);
> > > >  > > +                       spin_unlock(&inode->i_lock);
> > > >  > > +
> > > >  > > +                       ovl_wiw.inode = inode;
> > > >  > > +                       INIT_WORK(&ovl_wiw.work, ovl_write_inode_work_fn);
> > > >  > > +                       schedule_work(&ovl_wiw.work);
> > > >  > > +
> > > >  > > +                       schedule();
> > > >  > > +                       finish_wait(wqh, &wait.wq_entry);
> > > >  >
> > > >  > What is the reason to do this in another thread if this is a PF_MEMALLOC task?
> > > >
> > > > Some underlying filesystems(for example ext4) check the flag in ->write_inode()
> > > > and treate it as an abnormal case.(warn and return)
> > > >
> > > > ext4_write_inode():
> > > >         if (WARN_ON_ONCE(current->flags & PF_MEMALLOC) ||
> > > >                 sb_rdonly(inode->i_sb))
> > > >                         return 0;
> > > >
> > > > overlayfs inodes are always keeping clean even after wring/modifying  upperfile ,
> > > > so they are right target of kswapd  but in the point of lower layer, ext4 just thinks
> > > > kswapd is choosing a wrong dirty inode to reclam memory.
> > >
> > > I don't get it.  Why can't overlayfs just skip the writeback of upper
> > > inode in the reclaim case?  It will be written back through the normal
> > > relcaim channels.
> >
> > And how do we get reclaim on overlay inode at all?   Overlay inodes
> > will get evicted immediately after their refcount drops to zero, so
> > there's absolutely no chance that memory reclaim will encounter them,
> > no?
> 
> Spoke too soon.   Obviously this case is about dentry reclaim, not
> inode reclaim.
> 
> So how about temporarily clearing PF_MEMALLOC in this case?  Doing
> this is a kernel thread doesn't seem to add any advantages.

Clearing PF_MEMALLOC will not solve the deadlock I've described in the
reply to Chengguang. Ext4 really cannot safely handle data integrity
writeback (which is what write_inode_now(inode, 1) does) from direct
reclaim.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
