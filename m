Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA099EB64DA
	for <linux-unionfs@archiver.kernel.org>; Wed,  5 Jul 2023 09:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjGEJO7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 05:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbjGEJOx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Jul 2023 05:14:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709D51717
        for <linux-unionfs@vger.kernel.org>; Wed,  5 Jul 2023 02:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688548448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I9KObcq/9SecuVmm4CKMewq3+txouKYR5j2YkQYcKiE=;
        b=DidULDyYS2WTiMD8TI0QGHXXRpyZRo/3czqXZewavA0x7nNSXTKb8HANyKWKI5dnQZkMKW
        1YUPttXL7atM5bZD6oWu7yTcl9cwj8s8M4q6XxQFQOR0C7UQgQ4KCQvD4K2xB39QrjtstQ
        l9iORVfey8332RJVFgY5ZKPKj8bq144=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-Y44wNH2fN8uFJCclrpmfPw-1; Wed, 05 Jul 2023 05:14:07 -0400
X-MC-Unique: Y44wNH2fN8uFJCclrpmfPw-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3460307644cso14219625ab.2
        for <linux-unionfs@vger.kernel.org>; Wed, 05 Jul 2023 02:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688548446; x=1691140446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I9KObcq/9SecuVmm4CKMewq3+txouKYR5j2YkQYcKiE=;
        b=Kb4RnHOJEZTIgPeLUj7tBpXaVvwkQNqWa8hFBl4DLjbaLPw7e9D2ZuLNVwec5TdccF
         wIIfody8e5Cj0CxGZqPbiazhojqKx30Lp9pNDmq9gNu0FbKcPPQwCnKd9GsXcX81k+YP
         hgU6Usa/rPr3NuK8OHyBIhHtGjKL/R4+gwD703tbZVEbdZWZuJZgXtjQkDv0G/pF0kRG
         pxIEvMHofBiUdRuwt49sjKu5kEgUhfR52Hk+bfTfBPp9FgVDfAQPLRNTe/qIolLvqFHj
         xY70aThc0AQrC5Uu8VJ1OQuCNxB0rDASugnu9kLSgdsjzGTOKUmRFYXDTKRN7/8072+v
         eB6A==
X-Gm-Message-State: ABy/qLYV/WorlJ13+Fee0RBpSfVY8fXjdFaajELwbZhNSRc73cJB/ekG
        G5Ztdcporv1b3FIhVxkwypw8r9aHSwwiQ/p+286ME8gdHOQcAe48YFMd0WAvjjdRtw5qLxvacOp
        OEGHBCoHkxFdAFzh1D/fcAAh8feENsM+mk88HkdmJ1Q==
X-Received: by 2002:a92:d809:0:b0:345:6ffa:63c7 with SMTP id y9-20020a92d809000000b003456ffa63c7mr13304522ilm.32.1688548446203;
        Wed, 05 Jul 2023 02:14:06 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGKQ+5bkvgdDYPjsRcfDKzBh+CiwEjAZyS/bvVvWU80dbfQX28sQg9bP5Uj+kvZiRjbGJlXe8Ub1JjVpdx09U4=
X-Received: by 2002:a92:d809:0:b0:345:6ffa:63c7 with SMTP id
 y9-20020a92d809000000b003456ffa63c7mr13304516ilm.32.1688548445956; Wed, 05
 Jul 2023 02:14:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230626-fs-overlayfs-mount-api-param-v1-1-29afb997a19f@kernel.org>
 <CAOQ4uxiOsHEx30ERLYeLdnOdFG1rw_OnXo+rBbKCY-ZzNxV_uQ@mail.gmail.com>
 <CAL7ro1GgW-2gUhB=TBxwDAiybbQBbFabkU2tBNbBH85Q_KZWew@mail.gmail.com> <CAOQ4uxhkMYMnPL81RoWdnxCsiNtf-AbBVPcRj=hbo4vd8yp=QA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhkMYMnPL81RoWdnxCsiNtf-AbBVPcRj=hbo4vd8yp=QA@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Wed, 5 Jul 2023 11:13:54 +0200
Message-ID: <CAL7ro1FomqdO22a+=pntO5cBhDpz6hp96PVa_q6FKU7jRgunpQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: move all parameter handling into params.{c,h}
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 4, 2023 at 5:14=E2=80=AFPM Amir Goldstein <amir73il@gmail.com> =
wrote:
>
> On Mon, Jul 3, 2023 at 12:16=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om> wrote:
> >
> > On Mon, Jun 26, 2023 at 4:40=E2=80=AFPM Amir Goldstein <amir73il@gmail.=
com> wrote:
> > >
> > > On Mon, Jun 26, 2023 at 1:23=E2=80=AFPM Christian Brauner <brauner@ke=
rnel.org> wrote:
> > > >
> > > > While initially I thought that we couldn't move all new mount api
> > > > handling into params.{c,h} it turns out it is possible. So this jus=
t
> > > > moves a good chunk of code out of super.c and into params.{c,h}.
> > > >
> > > > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > > > ---
> > > >
> > >
> > > Thank you for this cleanup!
> > >
> > > Alex,
> > >
> > > I took the liberty to resolve the conflicts with your branch, see:
> > >
> > > https://github.com/amir73il/linux/commits/overlay-verity
> >
> > Thanks, I took a look at this and it seems good. Updated my branch to t=
his too.
> >
>
> FYI, I pushed this cleanup commit to overlayfs-next, so
> you can rebase overlay-verity v5 on top of that.

I rebased it and added some changes based on reviews from erics.

> I will send this cleanup to Linus, so we have a clean slate for
> the 6.6 cycle.

Thanks.

--
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

