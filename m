Return-Path: <SRS0=N6pz=6A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A83EC2BB85
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 14:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E600021927
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 14:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394450AbgDPOeE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 10:34:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:56666 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409970AbgDPOdw (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Apr 2020 10:33:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 230C7AE67;
        Thu, 16 Apr 2020 14:33:50 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id BD34F1E1250; Thu, 16 Apr 2020 16:33:49 +0200 (CEST)
Date:   Thu, 16 Apr 2020 16:33:49 +0200
From:   Jan Kara <jack@suse.cz>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH v11] ovl: Improving syncfs efficiency
Message-ID: <20200416143349.GP23739@quack2.suse.cz>
References: <20200210031009.61086-1-cgxu519@mykernel.net>
 <CAJfpegtRXwOTCtEdrg7Yie0rJ=kokYTcL+7epXsDo-JNy5fNDA@mail.gmail.com>
 <171819ad12b.c2829cd3806.7048451563188038355@mykernel.net>
 <20200416111424.GF23739@quack2.suse.cz>
 <17183432271.13c6f7c031276.6975591264470503191@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17183432271.13c6f7c031276.6975591264470503191@mykernel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu 16-04-20 21:52:27, Chengguang Xu wrote:
>  ---- 在 星期四, 2020-04-16 19:14:24 Jan Kara <jack@suse.cz> 撰写 ----
>  > On Thu 16-04-20 14:08:59, Chengguang Xu wrote:
>  > >  ---- 在 星期四, 2020-04-16 03:19:50 Miklos Szeredi <miklos@szeredi.hu> 撰写 ----
>  > >  > On Mon, Feb 10, 2020 at 4:10 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>  > >  > > +void ovl_evict_inode(struct inode *inode)
>  > >  > > +{
>  > >  > > +       struct ovl_inode *oi = OVL_I(inode);
>  > >  > > +       struct ovl_write_inode_work ovl_wiw;
>  > >  > > +       DEFINE_WAIT_BIT(wait, &oi->flags, OVL_WRITE_INODE_PENDING);
>  > >  > > +       wait_queue_head_t *wqh;
>  > >  > > +
>  > >  > > +       if (ovl_inode_upper(inode)) {
>  > >  > > +               if (current->flags & PF_MEMALLOC) {
>  > >  > > +                       spin_lock(&inode->i_lock);
>  > >  > > +                       ovl_set_flag(OVL_WRITE_INODE_PENDING, inode);
>  > >  > > +                       wqh = bit_waitqueue(&oi->flags,
>  > >  > > +                                       OVL_WRITE_INODE_PENDING);
>  > >  > > +                       prepare_to_wait(wqh, &wait.wq_entry,
>  > >  > > +                                       TASK_UNINTERRUPTIBLE);
>  > >  > > +                       spin_unlock(&inode->i_lock);
>  > >  > > +
>  > >  > > +                       ovl_wiw.inode = inode;
>  > >  > > +                       INIT_WORK(&ovl_wiw.work, ovl_write_inode_work_fn);
>  > >  > > +                       schedule_work(&ovl_wiw.work);
>  > >  > > +
>  > >  > > +                       schedule();
>  > >  > > +                       finish_wait(wqh, &wait.wq_entry);
>  > >  > 
>  > >  > What is the reason to do this in another thread if this is a PF_MEMALLOC task?
>  > > 
>  > > Some underlying filesystems(for example ext4) check the flag in
>  > > ->write_inode() and treate it as an abnormal case.(warn and return)
>  > > 
>  > > ext4_write_inode():
>  > >         if (WARN_ON_ONCE(current->flags & PF_MEMALLOC) ||
>  > >                 sb_rdonly(inode->i_sb))
>  > >                         return 0;
>  > > 
>  > > overlayfs inodes are always keeping clean even after wring/modifying
>  > > upperfile , so they are right target of kswapd  but in the point of lower
>  > > layer, ext4 just thinks kswapd is choosing a wrong dirty inode to reclam
>  > > memory.
>  > 
>  > In ext4, it isn't a big problem if ext4_write_inode() is called from
>  > kswapd. But if ext4_write_inode() is called from direct reclaim (which also
>  > sets PF_MEMALLOC) we can deadlock because we may wait for transaction
>  > commit and transaction commit may require locks (such as page lock or
>  > waiting for page writeback to complete) which are held by the task
>  > currently in direct reclaim. Your push to workqueue will silence the
>  > warning but does not solve the possible deadlock.
>  > 
>  > I'm actually not sure why you need to writeback the upper inode when
>  > reclaiming overlayfs inode. Why not leave it on flush worker on upper fs?
>  > 
> 
> Because it is the last chance we can sync dirty upper inode, I mean after
> evicting overlayfs inode we can not find the associated dirty upper inode
> from any list and that dirty upper inode will be skipped from the target
> of syncfs().

I see. But this flushing of dirty inodes on reclaim really isn't a great
idea. It can also stall reclaim (due to it being stuck waiting for IO) and
thus lead to bad behavior in low memory situations. It's better to just
skip reclaiming such inodes - but then I agree it's a difficult question
when to reclaim them. Ideally you'd need to hook into inode_lru_isolate()
but that's just too ugly (but maybe it could be done in some clean manner).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
