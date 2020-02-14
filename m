Return-Path: <SRS0=3MWK=4C=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ECEAC3B198
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Feb 2020 13:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B82872168B
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Feb 2020 13:50:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="gStEa7DN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgBNNu6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 08:50:58 -0500
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25394 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728437AbgBNNu6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Feb 2020 08:50:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1581688231;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=G4LBvVkSIjc25A6OYEI6MzR04VkKq5cOPvDjOxLlDY8=;
        b=gStEa7DNysPHAVIfxpGPpMGyrrzar4hien7RzftJJefkY3uwewkTw8IuNJP5BiO9
        Z5ZDS91qZeNutaFqfs9z8QoZzJTjyNccOzuR+I/n9yq7l7vplfSDkw5tpm7wfKDiEiJ
        dmCiVyPFjvXOnjhyE9snwYkawTHIPbxFgQN9YY1I=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 15816882287971005.8057685716208; Fri, 14 Feb 2020 21:50:28 +0800 (CST)
Date:   Fri, 14 Feb 2020 21:50:28 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <17043f70bb8.e83ccaf915072.7610146448137667825@mykernel.net>
In-Reply-To: <CAOQ4uxi0MLwer8-+jprx6Tn2==TZUzqS5qptQyy5ZYa+d+4uBQ@mail.gmail.com>
References: <20200210031047.61211-1-cgxu519@mykernel.net> <CAJfpegvut0xPswJfy_s5EnHR9n6db+7GK9vFs+ZO8e1H6WziHg@mail.gmail.com> <CAOQ4uxi0MLwer8-+jprx6Tn2==TZUzqS5qptQyy5ZYa+d+4uBQ@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: copy-up on MAP_SHARED
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Priority: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-02-14 05:28:10 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Thu, Feb 13, 2020 at 9:12 PM Miklos Szeredi <miklos@szeredi.hu> wrote=
:
 > >
 > > On Mon, Feb 10, 2020 at 4:11 AM Chengguang Xu <cgxu519@mykernel.net> w=
rote:
 > >
 > > >  static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 > > >  {
 > > >         struct file *realfile =3D file->private_data;
 > > >         const struct cred *old_cred;
 > > > +       struct inode *inode =3D file->f_inode;
 > > > +       struct ovl_copy_up_work ovl_cuw;
 > > > +       DEFINE_WAIT_BIT(wait, &ovl_cuw.flags, OVL_COPY_UP_PENDING);
 > > > +       wait_queue_head_t *wqh;
 > > >         int ret;
 > > >
 > > > +       if (vma->vm_flags & MAP_SHARED &&
 > > > +                       ovl_copy_up_shared(file_inode(file)->i_sb)) =
{
 > > > +               ovl_cuw.err =3D 0;
 > > > +               ovl_cuw.flags =3D 0;
 > > > +               ovl_cuw.dentry =3D file_dentry(file);
 > > > +               set_bit(OVL_COPY_UP_PENDING, &ovl_cuw.flags);
 > > > +
 > > > +               wqh =3D bit_waitqueue(&ovl_cuw.flags, OVL_COPY_UP_PE=
NDING);
 > > > +               prepare_to_wait(wqh, &wait.wq_entry, TASK_UNINTERRUP=
TIBLE);
 > > > +
 > > > +               INIT_WORK(&ovl_cuw.work, ovl_copy_up_work_fn);
 > > > +               schedule_work(&ovl_cuw.work);
 > > > +
 > > > +               schedule();
 > > > +               finish_wait(wqh, &wait.wq_entry);
 > >
 > > This just hides the bad lock dependency, it does not remove it.
 > >
 > > The solution we've come up with is arguably more complex, but it does
 > > fix this properly:  make overlay use its own address space operations
 > > in case of a shared map.
 > >
 > > Amir, I lost track, do you remember what's the status of this work?
 > >
 >=20
 > I'm afraid it is still standing at the side of the road where we left it=
...
 > I haven't had any time to work on it since.
 >=20
 > The latest WIP branch is at:
 > https://github.com/amir73il/linux/commits/ovl-aops-wip
 >=20
 > And summary of what it contains is at:
 > https://lore.kernel.org/linux-unionfs/CAJfpegsyA4SjmtAEpkMoKsvgmW0CiEwWE=
AbU7v3yJztLKmC0Eg@mail.gmail.com/
 >=20
 > Problem is, this WIP doesn't even solve the MAP_SHARED case yet,
 > but it is a big step in the direction of the design you laid out here:
 > https://lore.kernel.org/linux-unionfs/CAJfpegvJU32_9_mVh7kem0s529-8Qs02f=
PSr4ChCC3ZJ2pRhLw@mail.gmail.com/
 >=20
 > Chengguang,
 >=20
 > If you are up for the task, feel free to pick up the WIP branch
 > and bring it into shape for merging.
 > Then we can also discuss the next steps for fixing MAP_SHARED.

Thanks for the detailed information, I'll check your branch carefully later=
.

=20
 >=20
 > BTW, you did not mention why MAP_SHARED case is important
 > in your workload. I'm just curious how important is it to solve it.

I haven't received any complaint about MAP_SHARED problem yet, =20
so it seems not important as performance/space saving in our workload.
However, if we implement overlayfs' own address space, I think we can
do further improvement for copy-up based on it. (like delay/partial copy-up=
)


Thanks,
Chengguang







