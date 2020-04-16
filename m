Return-Path: <SRS0=N6pz=6A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03ECC2BA2B
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 07:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AF2D206D5
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 07:22:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="SllIuTul"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439184AbgDPHV7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 03:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439151AbgDPHVz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Apr 2020 03:21:55 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD56C061A0C
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Apr 2020 00:21:55 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id nv1so564926ejb.0
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Apr 2020 00:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=31P3/nvqtY+bZYUKDPJ/ot46X8GBW/92AEEC0Y/sGT0=;
        b=SllIuTul79vw+qbSBn0fNmJv0u+qw3nxpXa4v9bHMaix26jUxwzjO1/bwFH29k6WGZ
         cppQS47Ic1A4YFUNShh+RBBeF05KQOgWrSDcxsGaUatyQ9zRuQUPW1fd0vQNzK6iWcH1
         UA9gUlyXshNIpwsErl5ThWTpSBuqMIFLWNrqw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=31P3/nvqtY+bZYUKDPJ/ot46X8GBW/92AEEC0Y/sGT0=;
        b=XEG+8pb9MBr6TYYjMwUBT9ubRXKvILwlmh5V+cdswpWcMtJPikvXsj0jSjC3IR4Q01
         lYVjMVb/XMy3i2PCOIcq2k43seX8OIY+M/zbLhtO/bC5vXDhT+HM1/SRX/Vu8Kb31DIs
         xOSzHsOxPbA/sDujR+QQu6fUmOzkPS65lfTx9uM7ecJTso0+MtbPliyLWNdm41E/TH0g
         kD5iJquNUYAJb8ET08YJguWAXlsYz3PKnlPmN8R6+s5yL4FxAt4Y10H2HBM4NBOpqOyF
         lD9PAQuZyExGeuTTHcV9bpnu05KqFH/+VkoovlxTVrsD+WnwXQ78tlzyenltFooJk4i+
         lCDA==
X-Gm-Message-State: AGi0Pubw7K58onIBnacxVc8SXVYbEOmGvmFL8zQknITOpkAiDu0NLqzM
        XIjNIl0HIWqM7tdGgwB+O7DhtRzzNzkT2siliKyKtyh9
X-Google-Smtp-Source: APiQypLGI0PuwuVTlmWaAvaNQxkoXFVHZBju+vrlO9aEpjOuQ2Ga/WPXSkEAXfZ+IbkjEnl8ZuFFPqKDz8UKewC3wdo=
X-Received: by 2002:a17:906:340a:: with SMTP id c10mr8586389ejb.218.1587021714111;
 Thu, 16 Apr 2020 00:21:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200210031009.61086-1-cgxu519@mykernel.net> <CAJfpegtRXwOTCtEdrg7Yie0rJ=kokYTcL+7epXsDo-JNy5fNDA@mail.gmail.com>
 <171819ad12b.c2829cd3806.7048451563188038355@mykernel.net>
In-Reply-To: <171819ad12b.c2829cd3806.7048451563188038355@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 16 Apr 2020 09:21:42 +0200
Message-ID: <CAJfpegstttRvDNYjs9+LaAxFjN21rYn1EWYnZDrXGAKygOj_Hg@mail.gmail.com>
Subject: Re: [PATCH v11] ovl: Improving syncfs efficiency
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 16, 2020 at 8:09 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-04-16 03:19:50 Miklos S=
zeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
>  > On Mon, Feb 10, 2020 at 4:10 AM Chengguang Xu <cgxu519@mykernel.net> w=
rote:

>  > > +               if (current->flags & PF_MEMALLOC) {
>  > > +                       spin_lock(&inode->i_lock);
>  > > +                       ovl_set_flag(OVL_WRITE_INODE_PENDING, inode)=
;
>  > > +                       wqh =3D bit_waitqueue(&oi->flags,
>  > > +                                       OVL_WRITE_INODE_PENDING);
>  > > +                       prepare_to_wait(wqh, &wait.wq_entry,
>  > > +                                       TASK_UNINTERRUPTIBLE);
>  > > +                       spin_unlock(&inode->i_lock);
>  > > +
>  > > +                       ovl_wiw.inode =3D inode;
>  > > +                       INIT_WORK(&ovl_wiw.work, ovl_write_inode_wor=
k_fn);
>  > > +                       schedule_work(&ovl_wiw.work);
>  > > +
>  > > +                       schedule();
>  > > +                       finish_wait(wqh, &wait.wq_entry);
>  >
>  > What is the reason to do this in another thread if this is a PF_MEMALL=
OC task?
>
> Some underlying filesystems(for example ext4) check the flag in ->write_i=
node()
> and treate it as an abnormal case.(warn and return)
>
> ext4_write_inode():
>         if (WARN_ON_ONCE(current->flags & PF_MEMALLOC) ||
>                 sb_rdonly(inode->i_sb))
>                         return 0;
>
> overlayfs inodes are always keeping clean even after wring/modifying  upp=
erfile ,
> so they are right target of kswapd  but in the point of lower layer, ext4=
 just thinks
> kswapd is choosing a wrong dirty inode to reclam memory.

I don't get it.  Why can't overlayfs just skip the writeback of upper
inode in the reclaim case?  It will be written back through the normal
relcaim channels.

Thanks,
Miklos
