Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076B9EB64DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 08:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbjFTIup (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 04:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjFTIum (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 04:50:42 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0BC10D5
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 01:50:18 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-987a977f62aso351702366b.1
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 01:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1687251017; x=1689843017;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XrArOsW0ZjPvJ+qBHZcQ+UY0tQ4TElhmoo7+k7pvQEE=;
        b=Y93i7rzrKg85AasLF5Ctbzttx/qG8I6RTjnnxpj09ZBsMPFBD2wZhg5YHnxieW3zEf
         nqG8ovaT8BSMmycHrDTHmkit7EuuYdAx4hZcsH8LRTlOEPpIiqWlKAfiuY183QbNL7XO
         cKz8k1QXEpqu40+w/+HskHVmZZLw+sXhR7pWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687251017; x=1689843017;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XrArOsW0ZjPvJ+qBHZcQ+UY0tQ4TElhmoo7+k7pvQEE=;
        b=Z9GojiuBG5LAfCyadiNchCRktCOlyZZhLKUyPwU4FEHhDWgYN9HFlIyovwGwxnxfIT
         aBCZuUizmrn9hHkmH7rHzrtR0C/2HBptlw5vcnTYpZes9Glox5SA7dHgPbw3dzIzAZsX
         4lJy1CisR3h2r+GPjw0gFSCF7YgVKyEOIyCL4QsgxmBXUfDHh5Nuz5R3doCs2rfq7swj
         afj3yybwgcdPZ2KvUs0uHxwVLBzPA/iuaYChUeCcgwzM/U1+GGE0mmf9smMrpw+zMl9x
         4MmULusPSGX8nIFsIoeawW3c0Zlz3cqtqKQ1HOsTcZzPHUEs0YgXvJ/c7uxb6akoa6Kh
         29Tw==
X-Gm-Message-State: AC+VfDyZ9sSZiKqC3zMbVwFDILAXgq/hFX1gH9Hl9ahk3PRQiwGog6J9
        yIzxfRdTLinOEZ1sXy6Rpu6Ia9IaMdQHoKiQS0UBk8MrgF1zOICU3gw=
X-Google-Smtp-Source: ACHHUZ4TmjbZfaPFXWT0hkcmFGhkCVnqPQbrzhK3tvNymWkdoSMNNNYHYWhYUXi1b/ccwTg6/d6tz9Vednjl19trYOk=
X-Received: by 2002:a17:907:9814:b0:973:afe2:a01 with SMTP id
 ji20-20020a170907981400b00973afe20a01mr10736074ejc.75.1687251017025; Tue, 20
 Jun 2023 01:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230617084702.2468470-1-amir73il@gmail.com> <20230617084702.2468470-5-amir73il@gmail.com>
 <CAJfpegsM44b8rRhGSgUMEroyuwp_Xd16NJeT699VMAKjFfG5JA@mail.gmail.com>
In-Reply-To: <CAJfpegsM44b8rRhGSgUMEroyuwp_Xd16NJeT699VMAKjFfG5JA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 20 Jun 2023 10:50:05 +0200
Message-ID: <CAJfpegs6AGbXY1wZuPCp43AAJAYHbpeGxZ8S0c7h4pcVzbm-bw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: store enum redirect_mode in config instead of
 a string
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 20 Jun 2023 at 10:48, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Sat, 17 Jun 2023 at 10:47, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > @@ -1332,10 +1337,17 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
> >         if (err) {
> >                 pr_warn("failed to set xattr on upper\n");
> >                 ofs->noxattr = true;
> > -               if (ofs->config.index || ofs->config.metacopy) {
> > -                       ofs->config.index = false;
> > +               if (ovl_redirect_follow(ofs)) {
> > +                       ofs->config.redirect_mode = OVL_REDIRECT_NOFOLLOW;
> > +                       pr_warn("...falling back to redirect_dir=nofollow.\n");
>
>
> So if there's no xattr support, then there won't be any redirects to
> follow.   Is this just asserting the fact?
>
> Should this be a separate patch?

Oh, I see you are changing the ovl_redirect_dir() logic.   Ack.

Thanks,
Miklos
