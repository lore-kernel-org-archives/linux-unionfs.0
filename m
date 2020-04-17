Return-Path: <SRS0=qTYs=6B=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB30C2BA2B
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Apr 2020 01:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52112221E8
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Apr 2020 01:23:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="AkjIqPlR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgDQBXe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 21:23:34 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25336 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725800AbgDQBXc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Apr 2020 21:23:32 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1587086589; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=HAHSbAMpuatx9SA+ENH/VhiDxqX1ye9/wh8QNf++LB6ewPYzp/yXnKC2svbsYXORDO8lWLiii/3luli9HhF+YMrdGVHcvAjIjSjBcN6ZkxTQnSelwYS5e9ocQ7KzBTvOSLbbKBwTO1ETmpilNN+QC92nO1hKgIKbTH8jOw0YzEI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1587086589; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=iLdKseTeuqHbN3sWtTkIbO3M8mEHzSwdWG4XcPo4d00=; 
        b=Yoa8j6C/lAFRk05j4a+P7RKzFYlAHPB6R559PMjMyHLGGiSiS525SYCdCM1fg3H0gH7ZD1hlU+3DVU1llDvyvr174+6I2t7LQNXrVIfjNVRiF3IMebOXcNFtqINW4WH59HTjsIWFGA8KN1rVoq3pjGEAkYq1LnjzOS+Cgki5/JY=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1587086589;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=iLdKseTeuqHbN3sWtTkIbO3M8mEHzSwdWG4XcPo4d00=;
        b=AkjIqPlRPdIoPLM/aqd7s9bVXcI+8yxUhvEgIrXtD6cC3eRNyLBdM0HZRR5tGfYT
        So9AWG1MFIH3SrwF/Vn0TeTjJTvcqZBRPSNW1vgbfQ9BlDw4N/3gTsI4qYuY+yoSHT9
        SRBk8CQDSp4f9AoTopKQcQNFV1mDtkom313gwX9g=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1587086587008184.8565684349345; Fri, 17 Apr 2020 09:23:07 +0800 (CST)
Date:   Fri, 17 Apr 2020 09:23:07 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Jan Kara" <jack@suse.cz>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "Amir Goldstein" <amir73il@gmail.com>,
        "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <17185bb747c.ce54f2d81371.5054043296955656018@mykernel.net>
In-Reply-To: <20200416143349.GP23739@quack2.suse.cz>
References: <20200210031009.61086-1-cgxu519@mykernel.net>
 <CAJfpegtRXwOTCtEdrg7Yie0rJ=kokYTcL+7epXsDo-JNy5fNDA@mail.gmail.com>
 <171819ad12b.c2829cd3806.7048451563188038355@mykernel.net>
 <20200416111424.GF23739@quack2.suse.cz>
 <17183432271.13c6f7c031276.6975591264470503191@mykernel.net> <20200416143349.GP23739@quack2.suse.cz>
Subject: Re: [PATCH v11] ovl: Improving syncfs efficiency
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-04-16 22:33:49 Jan Kara <=
jack@suse.cz> =E6=92=B0=E5=86=99 ----
 > On Thu 16-04-20 21:52:27, Chengguang Xu wrote:
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-04-16 19:14:24 Jan K=
ara <jack@suse.cz> =E6=92=B0=E5=86=99 ----
 > >  > On Thu 16-04-20 14:08:59, Chengguang Xu wrote:
 > >  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-04-16 03:19:50 =
Miklos Szeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > >  > >  > On Mon, Feb 10, 2020 at 4:10 AM Chengguang Xu <cgxu519@mykerne=
l.net> wrote:
 > >  > >  > > +void ovl_evict_inode(struct inode *inode)
 > >  > >  > > +{
 > >  > >  > > +       struct ovl_inode *oi =3D OVL_I(inode);
 > >  > >  > > +       struct ovl_write_inode_work ovl_wiw;
 > >  > >  > > +       DEFINE_WAIT_BIT(wait, &oi->flags, OVL_WRITE_INODE_PE=
NDING);
 > >  > >  > > +       wait_queue_head_t *wqh;
 > >  > >  > > +
 > >  > >  > > +       if (ovl_inode_upper(inode)) {
 > >  > >  > > +               if (current->flags & PF_MEMALLOC) {
 > >  > >  > > +                       spin_lock(&inode->i_lock);
 > >  > >  > > +                       ovl_set_flag(OVL_WRITE_INODE_PENDING=
, inode);
 > >  > >  > > +                       wqh =3D bit_waitqueue(&oi->flags,
 > >  > >  > > +                                       OVL_WRITE_INODE_PEND=
ING);
 > >  > >  > > +                       prepare_to_wait(wqh, &wait.wq_entry,
 > >  > >  > > +                                       TASK_UNINTERRUPTIBLE=
);
 > >  > >  > > +                       spin_unlock(&inode->i_lock);
 > >  > >  > > +
 > >  > >  > > +                       ovl_wiw.inode =3D inode;
 > >  > >  > > +                       INIT_WORK(&ovl_wiw.work, ovl_write_i=
node_work_fn);
 > >  > >  > > +                       schedule_work(&ovl_wiw.work);
 > >  > >  > > +
 > >  > >  > > +                       schedule();
 > >  > >  > > +                       finish_wait(wqh, &wait.wq_entry);
 > >  > >  >=20
 > >  > >  > What is the reason to do this in another thread if this is a P=
F_MEMALLOC task?
 > >  > >=20
 > >  > > Some underlying filesystems(for example ext4) check the flag in
 > >  > > ->write_inode() and treate it as an abnormal case.(warn and retur=
n)
 > >  > >=20
 > >  > > ext4_write_inode():
 > >  > >         if (WARN_ON_ONCE(current->flags & PF_MEMALLOC) ||
 > >  > >                 sb_rdonly(inode->i_sb))
 > >  > >                         return 0;
 > >  > >=20
 > >  > > overlayfs inodes are always keeping clean even after wring/modify=
ing
 > >  > > upperfile , so they are right target of kswapd  but in the point =
of lower
 > >  > > layer, ext4 just thinks kswapd is choosing a wrong dirty inode to=
 reclam
 > >  > > memory.
 > >  >=20
 > >  > In ext4, it isn't a big problem if ext4_write_inode() is called fro=
m
 > >  > kswapd. But if ext4_write_inode() is called from direct reclaim (wh=
ich also
 > >  > sets PF_MEMALLOC) we can deadlock because we may wait for transacti=
on
 > >  > commit and transaction commit may require locks (such as page lock =
or
 > >  > waiting for page writeback to complete) which are held by the task
 > >  > currently in direct reclaim. Your push to workqueue will silence th=
e
 > >  > warning but does not solve the possible deadlock.
 > >  >=20
 > >  > I'm actually not sure why you need to writeback the upper inode whe=
n
 > >  > reclaiming overlayfs inode. Why not leave it on flush worker on upp=
er fs?
 > >  >=20
 > >=20
 > > Because it is the last chance we can sync dirty upper inode, I mean af=
ter
 > > evicting overlayfs inode we can not find the associated dirty upper in=
ode
 > > from any list and that dirty upper inode will be skipped from the targ=
et
 > > of syncfs().
 >=20
 > I see. But this flushing of dirty inodes on reclaim really isn't a great
 > idea. It can also stall reclaim (due to it being stuck waiting for IO) a=
nd
 > thus lead to bad behavior in low memory situations. It's better to just
 > skip reclaiming such inodes - but then I agree it's a difficult question
 > when to reclaim them. Ideally you'd need to hook into inode_lru_isolate(=
)
 > but that's just too ugly (but maybe it could be done in some clean manne=
r).
 >=20

How about prepare another list to organize  this kind of inode, when evicti=
ng overlay
inode we grab dirty upper inode reference, put a entry(a field point to upp=
er inode)=20
into this new list and retrun, after that periodically checking list entry =
to release(iput)
clean upper inode.

In overlayfs's syncfs(), we also need to iterate this new list after iterat=
ing oi->upper_inodes_list.

Thanks,
cgxu





