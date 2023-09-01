Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D9BCA0FE1
	for <linux-unionfs@archiver.kernel.org>; Fri,  1 Sep 2023 10:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjIAKIz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 1 Sep 2023 06:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240438AbjIAKIy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 1 Sep 2023 06:08:54 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2084FC
        for <linux-unionfs@vger.kernel.org>; Fri,  1 Sep 2023 03:08:51 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id a1e0cc1a2514c-7a754db0fbcso42618241.2
        for <linux-unionfs@vger.kernel.org>; Fri, 01 Sep 2023 03:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693562931; x=1694167731; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4h2MGXwUshfv3y4lbMArWyuZ+39355gNaiJd4/uhUPI=;
        b=m0ZGAdfu+nNQdC/gdyNtTL0zIflesw4vzg6xkbVCLFXHnOH722X+V9B5z1FWIpWtka
         FWg5xvsZmUF0wV/HQyS6Mocw14rfEB+OfTN6MAB/Z1cSTKuWY+exmj8jWhJuSfH8Ea4Z
         zV2Nt+/n2xO/GuhN+JJvTCj1l0ep31KvicEuF9L+DMrdfvJHWjPlwviMVD2/W+3kTAa8
         W22ReUwGBY1shr07IHEWO8j+0ynTtowUc4AgRLqTzfgEuRTY6ETjKh2X2fxhdxBsBXhh
         5tJyxMbGWCLU28+mZhcFKBV4qgZCEjBVGHXQlv6Q46qA/eqh91Mdvl9z4oA4teZtRlEQ
         3VKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693562931; x=1694167731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4h2MGXwUshfv3y4lbMArWyuZ+39355gNaiJd4/uhUPI=;
        b=iskInW8sOzfmfygNegmIibZ8PGIAbUMXzpaYQaLfZfkK2kx4GRYaBWOMtSrMUV0sCx
         EsnaB9aF/rwaqucGRw+Z8dZ3hs9IxF0o3fUlqneszq/OzQ1VkyyNr4rZK4fRjW4zI8M2
         3iuwF+yG65XWXi7w2iM88Uue2ynvKxx1bjIVG1WWAJRqZpG9f/MkRmK66RvWIGSdmd7V
         w7xOrcDt3hGi8CxCQT8wyLhHXZ4msiLb5suTAsIBSy1Sp+2QPITPHQhxFXOqihmoIDTc
         dUGe4Wk+4Dp8cjYAzw58crvcB+npA/nv4sJCDACKDNSu2IOjLwzYMce0Acfr156ETzLI
         gxCQ==
X-Gm-Message-State: AOJu0Yw9EfiNUUJfPJaxmshplKovZW2WaUywDWllNiWYrfZXBbFiQeur
        IznsxnNLgQ4nd2FmICyEZ+IoGbnSAaIc2lyy6as=
X-Google-Smtp-Source: AGHT+IFIqIx0v3EVDrSgVllFnVm3SWZBy6ugMBMlQE7jdglR32dy9Be3qI4qejgiB0FS1sCTay31pUdY2V99GeNoe8U=
X-Received: by 2002:a05:6102:5d5:b0:44d:6320:f0c7 with SMTP id
 v21-20020a05610205d500b0044d6320f0c7mr2082756vsf.22.1693562930819; Fri, 01
 Sep 2023 03:08:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAKd=y5EeKfC6vBXh1xqTfeW6OQZiNWaZ04J1SNWxyEjY4QxhHw@mail.gmail.com>
 <CAKd=y5HZ0nJJ9XN9i6vnyhzM=COijmuSzgqJPAPFn6dguQyFQA@mail.gmail.com>
 <CAOQ4uxid-eDr2XBHo_JoPhiP99PrXj0eNKgEQXP-SOEbg4hn_Q@mail.gmail.com> <CAKd=y5Gsz1z1xSmHGyoEs+SckC=M0T7nrP7t5mvvuoWkCWkDLg@mail.gmail.com>
In-Reply-To: <CAKd=y5Gsz1z1xSmHGyoEs+SckC=M0T7nrP7t5mvvuoWkCWkDLg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 1 Sep 2023 13:08:39 +0300
Message-ID: <CAOQ4uxiQtSSHL0gLohBpRs7vwUrF5LqCLB=Oh6kSz1O-ga04Tw@mail.gmail.com>
Subject: Re: [Bug report] overlayfs: cannot rename symlink if lower filesystem
 is FUSE/NFS
To:     Ruiwen Zhao <ruiwen@google.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        Sergey Kanzhelev <skanzhelev@google.com>,
        Michael Sheinin <msheinin@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Sep 1, 2023 at 12:59=E2=80=AFAM Ruiwen Zhao <ruiwen@google.com> wro=
te:
>
> Thanks for the reply Amir! Really helps. I will try the easy fix (i.e. ig=
noring ENXIO) and test it. Meanwhile I have two questions:
>
> 1. Since ENXIO comes from ovl_security_fileattr() trying to open the syml=
ink, I was trying to find who returns ENXIO in the first place. I did some =
code search on libfuse (https://github.com/libfuse/libfuse), but cannot fin=
d ENXIO anywhere. Could it be from the kernel side? (I am trying to use thi=
s as a justification of the easy fix.)
>

I think ENXIO comes from no_open() default ->open() method.

> 2. Miklos's commit message says "The reason is that ovl_copy_fileattr() i=
s triggered due to S_NOATIME being
> set on all inodes (by fuse) regardless of fileattr." Does that mean `ovl_=
copy_fileattr` should not be triggered on symlink files but it is, and ther=
efore it is getting the errors like ENXIO and ENOTTY?
>

Miklos' comment explains why ovl_copy_fileattr() passes the gate:

        if (inode->i_flags & OVL_COPY_I_FLAGS_MASK) {

S_NOATIME is an indication that the file MAY have fileattr FS_NOATIME_FL,
but in the case of FUSE and NFS, S_NOATIME is there for another unrelated
reason.

In any case, S_NOATIME on a symlink is never an indication of fileattr,
so I think the correct solution is to add the conditions to the gate:

        if (inode->i_flags & OVL_COPY_I_FLAGS_MASK &&
           ((S_ISDIR(inode->i_mode) || S_ISREG(inode->i_mode))) {

Thanks,
Amir.
