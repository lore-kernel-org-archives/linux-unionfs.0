Return-Path: <SRS0=N6pz=6A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0612C352BE
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 15:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22CCB206D9
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 15:04:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="PmOcEiWe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394918AbgDPPEd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 11:04:33 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25319 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2441705AbgDPNxE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Apr 2020 09:53:04 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1587045148; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=qx+cU4WIIMnxVuMK5T1d6oN7Qgsf6aeFVXxZ/ZzyxViUAL9rKHSCWyDKwZ4etTq5bEINO1XvnzBoO5ZihqT/hETW33nzUmgcLZQD6JtCGeFm/zdvDCe46NQHu3hntaJFhoF+xFoRjtR6AZus3gtd6AHk3q9qBaGRcVyctKKtmmg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1587045148; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=xtpfVaboyWfjGirkTf1VwuFTtKAX6Z8tRwAF1xoGEY4=; 
        b=dpCG7AP6HWkthSk/iQuk3Kk2jdCxJntl8WOsElHbMqa7g3q3XcBbt+mSIhpkcV9K7CrS8XsR4nrzF4y8Wja8eGKzRJMysiDucfwF5vv6BJdPJjC63V06I/JxculfR2LV0mh3oFPJFJsK/X1hCUE+WYHYSB+aOvouEMCpgAlPjkA=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1587045148;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=xtpfVaboyWfjGirkTf1VwuFTtKAX6Z8tRwAF1xoGEY4=;
        b=PmOcEiWeOuAMexoEJ0CC2ZiH9azOw/YJ7z0x9Yr+wB6SymScZRNKGDvsM3pPusHN
        Yt53KWh1Wo+krbtzDTT6fuRN4hLc8uq30lYFm4Ltczkvd5VjKBa5KThfkbeA1ECzh1J
        BEPNFcllygvK0n1x8tVJMFmnNphMSUWNxLtkRf/k=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1587045147252606.0928836885748; Thu, 16 Apr 2020 21:52:27 +0800 (CST)
Date:   Thu, 16 Apr 2020 21:52:27 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Jan Kara" <jack@suse.cz>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "Amir Goldstein" <amir73il@gmail.com>,
        "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <17183432271.13c6f7c031276.6975591264470503191@mykernel.net>
In-Reply-To: <20200416111424.GF23739@quack2.suse.cz>
References: <20200210031009.61086-1-cgxu519@mykernel.net>
 <CAJfpegtRXwOTCtEdrg7Yie0rJ=kokYTcL+7epXsDo-JNy5fNDA@mail.gmail.com>
 <171819ad12b.c2829cd3806.7048451563188038355@mykernel.net> <20200416111424.GF23739@quack2.suse.cz>
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-04-16 19:14:24 Jan Kara <=
jack@suse.cz> =E6=92=B0=E5=86=99 ----
 > On Thu 16-04-20 14:08:59, Chengguang Xu wrote:
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-04-16 03:19:50 Miklo=
s Szeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > >  > On Mon, Feb 10, 2020 at 4:10 AM Chengguang Xu <cgxu519@mykernel.net=
> wrote:
 > >  > > +void ovl_evict_inode(struct inode *inode)
 > >  > > +{
 > >  > > +       struct ovl_inode *oi =3D OVL_I(inode);
 > >  > > +       struct ovl_write_inode_work ovl_wiw;
 > >  > > +       DEFINE_WAIT_BIT(wait, &oi->flags, OVL_WRITE_INODE_PENDING=
);
 > >  > > +       wait_queue_head_t *wqh;
 > >  > > +
 > >  > > +       if (ovl_inode_upper(inode)) {
 > >  > > +               if (current->flags & PF_MEMALLOC) {
 > >  > > +                       spin_lock(&inode->i_lock);
 > >  > > +                       ovl_set_flag(OVL_WRITE_INODE_PENDING, ino=
de);
 > >  > > +                       wqh =3D bit_waitqueue(&oi->flags,
 > >  > > +                                       OVL_WRITE_INODE_PENDING);
 > >  > > +                       prepare_to_wait(wqh, &wait.wq_entry,
 > >  > > +                                       TASK_UNINTERRUPTIBLE);
 > >  > > +                       spin_unlock(&inode->i_lock);
 > >  > > +
 > >  > > +                       ovl_wiw.inode =3D inode;
 > >  > > +                       INIT_WORK(&ovl_wiw.work, ovl_write_inode_=
work_fn);
 > >  > > +                       schedule_work(&ovl_wiw.work);
 > >  > > +
 > >  > > +                       schedule();
 > >  > > +                       finish_wait(wqh, &wait.wq_entry);
 > >  >=20
 > >  > What is the reason to do this in another thread if this is a PF_MEM=
ALLOC task?
 > >=20
 > > Some underlying filesystems(for example ext4) check the flag in
 > > ->write_inode() and treate it as an abnormal case.(warn and return)
 > >=20
 > > ext4_write_inode():
 > >         if (WARN_ON_ONCE(current->flags & PF_MEMALLOC) ||
 > >                 sb_rdonly(inode->i_sb))
 > >                         return 0;
 > >=20
 > > overlayfs inodes are always keeping clean even after wring/modifying
 > > upperfile , so they are right target of kswapd  but in the point of lo=
wer
 > > layer, ext4 just thinks kswapd is choosing a wrong dirty inode to recl=
am
 > > memory.
 >=20
 > In ext4, it isn't a big problem if ext4_write_inode() is called from
 > kswapd. But if ext4_write_inode() is called from direct reclaim (which a=
lso
 > sets PF_MEMALLOC) we can deadlock because we may wait for transaction
 > commit and transaction commit may require locks (such as page lock or
 > waiting for page writeback to complete) which are held by the task
 > currently in direct reclaim. Your push to workqueue will silence the
 > warning but does not solve the possible deadlock.
 >=20
 > I'm actually not sure why you need to writeback the upper inode when
 > reclaiming overlayfs inode. Why not leave it on flush worker on upper fs=
?
 >=20

Because it is the last chance we can sync dirty upper inode, I mean after e=
victing
overlayfs inode we can not find the associated dirty upper inode from any l=
ist and
that dirty upper inode will be skipped from the target of syncfs().

Thanks,
cgxu
