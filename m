Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A76C433EF
	for <linux-unionfs@archiver.kernel.org>; Fri,  8 Jul 2022 13:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237913AbiGHNyZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 8 Jul 2022 09:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237997AbiGHNyY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 Jul 2022 09:54:24 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34B9B12
        for <linux-unionfs@vger.kernel.org>; Fri,  8 Jul 2022 06:54:21 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id os14so7605775ejb.4
        for <linux-unionfs@vger.kernel.org>; Fri, 08 Jul 2022 06:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a5QQ4j3E4oG/6InMTTvxPnfUCgGacjOZThQuW+OrLDg=;
        b=LSgBsBf3O5yDJqXm5joE31FNwOpHZykyekquvh27HaUPqyjuYOXN/6xb7PddWhF2UG
         fURz0tb3vuEjbq8bZda9q7VTe/B+0zepKQWaT02GkknMJnKZixzCutOcoczQchTF0Vsm
         Hi/9GJNHrkfpfYBZfhDNmk65NIsklQpQEH6F4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a5QQ4j3E4oG/6InMTTvxPnfUCgGacjOZThQuW+OrLDg=;
        b=xk4diAF7AROEoe177CGUB843W4U5Kqn6exlctGmz317A1go983n4b/m1PL+Gz6QJQw
         3bx9hVxXXdhGdfv2Xb7YH3vc65USlaNvusiW01cbzMt7hHKM26Rbg4B2KU7J65a90PQC
         pXmipAwnD2fhngwp5fYe4TQHRFciue79iW+fOS9iL5tLHocQl+pGeEhSfst/8rgBhE2F
         wqTMmSn/a7+QZ8F3dWngeX4ARzp20txQ1TMv+UURQ2n3I1VFdmHBiAnWYsvCw1DWRP21
         s9GQge361+eQGdK0dHmX3AD5wBxzLUGgy4qysk/n1ZgtduTZj4QI21/ZJeXLkGbwI0je
         FF1g==
X-Gm-Message-State: AJIora/O+26O2vU5GeXL4TbL3u27T4kDJd+dvWNjSD7l7lX4T42bVfjB
        yT8v6ytaTZWwYByunFScgFEXmvyIBYqy3omG8JG+qPloKZgqwg==
X-Google-Smtp-Source: AGRyM1uI3Nu9Brlya1ycPioyBoe7me2ldV94ecKrzh/ZjwEb9lV93wQBd1KzLH9QmuLUA/ZK1Sa6gQHnFVe3Z95HDbc=
X-Received: by 2002:a17:907:3d86:b0:72a:cf0d:c5eb with SMTP id
 he6-20020a1709073d8600b0072acf0dc5ebmr3735214ejc.192.1657288460428; Fri, 08
 Jul 2022 06:54:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220706135611.257213-1-brauner@kernel.org> <CAJfpegvg4AWRSotysxvcODLxX12gVCKm7=qUquu=Mo=sFtCy7g@mail.gmail.com>
 <20220707103336.op6zxx4wgqv6enxv@wittgenstein>
In-Reply-To: <20220707103336.op6zxx4wgqv6enxv@wittgenstein>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 8 Jul 2022 15:54:09 +0200
Message-ID: <CAJfpegvS7ZzuauqbuWsUdOh=F=0=aCrd6vOKbGTMgcNYgDN4WA@mail.gmail.com>
Subject: Re: [PATCH] ovl: turn of SB_POSIXACL with idmapped layers temporarily
To:     Christian Brauner <brauner@kernel.org>
Cc:     Seth Forshee <sforshee@digitalocean.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 7 Jul 2022 at 12:33, Christian Brauner <brauner@kernel.org> wrote:
>
> On Thu, Jul 07, 2022 at 09:58:47AM +0200, Miklos Szeredi wrote:
> > On Wed, 6 Jul 2022 at 15:59, Christian Brauner <brauner@kernel.org> wrote:

> > However I don't think clearing SB_POSIXACL will do that.
> >
> > Maybe denying the operation in ovl_posix_acl_xattr_{get,set}() is the
> > right way to achieve the above?
>
> Hm, removing SB_POSIXACL in my tests fixed that completely. But we can
> add an additional check:

Strange... In my tests just clearing SB_POSIXACL will still let
overlayfs get and set ACL's.

>
>         if (!IS_POSIXACL(inode))
>                 return -EOPNOTSUPP;
>
> to both helpers additionally? Can you do that when you apply or do you
> want me to send a version with that added?

Added, also simplified ovl_has_idmapped_layers().

Pushed to #overlayfs-next  and will send to Linus next week.

Thanks,
Miklos
