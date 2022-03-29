Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B89BC433F5
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Mar 2022 15:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbiC2PEg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 11:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237094AbiC2PEf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Mar 2022 11:04:35 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF40A18C0D0
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 08:02:52 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id v15so14237113qkg.8
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 08:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3IJFJreGOWFFfGKQmViSs/XpM8rqiNxSVFSxBshBg0U=;
        b=LllK7595pkySbjyVcTkL/cXK6X8g4P/0Ck/o5QjnIpQIVq120p06LqFa7Nsj9kAU6T
         aCBU0ViRiFr+OL9X1LTXay1WzoYRURMn+Z+9BFYLn5tzLj14Hxuiz9aU0Oh69D++eMxU
         kpKs4fE23cXQE421BJf0/Mzqbqn3ZwHLL2d1DHrgrp58c4yMvbvvRgklg8q0cUGEwHJH
         D2OnyTIBpCQe/CKNWKT7YZ/x1YT3HiujZrSJV4X047SO5zMr8KPQVvMYl2B97XgdMd0y
         vMxpSvMmdISpr/hDwDl6PbnUPIfj7lLne0evURBomFI33WuXyyqpb3grgXhPawJeDBOX
         jGCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3IJFJreGOWFFfGKQmViSs/XpM8rqiNxSVFSxBshBg0U=;
        b=IIpItvUSxfWz6kuqYAhT1XP94rTkaCiprQLx4wkswuBJyuk8ph9sRaCobFXd3tmaRf
         29+oEzVVphY/EKlNjGpI/cqApnMrbwBjg9WnIw6oAnvtcO09dU/m7sHRdniWCvIlSnnJ
         UGIRQOVoRXfcsI8tI6ArM6ydv4XHipUHsdnyQP4ynwJTblFuQCOT4MN5Yk5E8Q86UFmh
         KxzzPbMp5+ZKxGk0FS4gVeIULDUNdwn70VJMaIQ8mUNdxWtzRjpIX6KTi8t1n0W88x9K
         ZegNwSnKSNG+PUwpFN1c6ofUZ8Vos+2RocZ5OpFgjrj/JWHcOo8kGtwpXpO7KW/cY7SO
         3ttg==
X-Gm-Message-State: AOAM532D5L6RqvTc2QUTVCM7zhJSjSdzg43S1YO4QxCiixXTIEIqp5F3
        GCGagr6uDdCPEAzrBewLEFMrSZJ6xcy0TcY0UbE=
X-Google-Smtp-Source: ABdhPJwel5zMdv2cE5klVa4De0QksoDfB6KaSodKuOMCVq/BU7Ur/5asyf2eatNkX9id87JGTcE7zZ1woAgpyyJTlAw=
X-Received: by 2002:a37:a817:0:b0:67b:6ea0:5e9a with SMTP id
 r23-20020a37a817000000b0067b6ea05e9amr20735637qke.386.1648566171796; Tue, 29
 Mar 2022 08:02:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220329103526.1207086-1-brauner@kernel.org> <CAJfpegvrv6MTx_4sVSD_5zKtWs1KMDwbBA5egegueU87xws24Q@mail.gmail.com>
In-Reply-To: <CAJfpegvrv6MTx_4sVSD_5zKtWs1KMDwbBA5egegueU87xws24Q@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 29 Mar 2022 18:02:40 +0300
Message-ID: <CAOQ4uxjk49WPsfWgPzLqx0jDBns2MCOSb4ZhzQumyDDBifUtBw@mail.gmail.com>
Subject: Re: [PATCH 00/18] overlay: support idmapped layers
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigoca@microsoft.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Mar 29, 2022 at 3:25 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Tue, 29 Mar 2022 at 12:35, Christian Brauner <brauner@kernel.org> wrote:
> >
> > From: "Christian Brauner (Microsoft)" <brauner@kernel.org>
> >
> > Hey,
> >
> > This adds support for mounting overlay on top of idmapped layers.
>
> Looks good at first glance.
>
> I'm wondering if there's a way to deduplicate the info stored in
> ovl_entry and ovl_inode, but that can come later...
>

Yes at this point the deduplication of lowerstack elements became a bit odd,
but the final step is not obvious.

I don't think we want a variable size ovl_inode. That would be suboptimal and
make inode cache monitoring hard.

I suppose we could have lowerstack or 'stack' allocated and hanging
off ovl_inode.
At that point, dentry->d_fsdata can become just flat flags.

Thanks,
Amir.
