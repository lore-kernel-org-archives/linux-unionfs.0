Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44978C7EE2E
	for <linux-unionfs@archiver.kernel.org>; Sun, 11 Jun 2023 14:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbjFKOXr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 11 Jun 2023 10:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjFKOXp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 11 Jun 2023 10:23:45 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0888DE64
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Jun 2023 07:23:42 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-970028cfb6cso631772766b.1
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Jun 2023 07:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1686493420; x=1689085420;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FNpHb/rK3DJOtlxm059dJYOe2BFwARWc9T2ggd4nxq4=;
        b=IcM4sLIqORrdt7p8vF0Mtw75TENnEd882Xv2BSvVn1E/VBhkjbnMjdst+2o2jc3+QB
         qDxO+jy2hUZ43suYtmm5HQnGu94mevUc9Bt3V85IreX8Gv7hptK2mA9JBmkFoJhnPBHm
         chwNiTG5BHP2CqdsLNgjYn+pri1eWpds/qUnA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686493420; x=1689085420;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FNpHb/rK3DJOtlxm059dJYOe2BFwARWc9T2ggd4nxq4=;
        b=b5ByA+kKdFp9MyvTAn1BeL9mWmmI3GiIEEYBL+WGC31to9Dlk1AE+P/pUQ0IVvDc8G
         35GiJ45OXu7URk6ItVTpBifaYCoVYhQZ0qNXWZpkuz3oJSWFZ2dYQsIj9cTM1P8oYgcq
         rkVNOksXJQCblSZCFdt1SzJvxB9Xz1KQH8Dbq0TxyrSUhEBxDH35xa1ZRs5Xr8Q8IGyY
         +hxi+zltNmdvtxpIKnEhRj+aWSob1Of331IO0oSZO7eDEMGl+89B/aNoQHz3iumlFnRI
         A9OZHhzUjSRAFMYImubKkY0D0FoRdxBDnUwFbrRJfCtRmzJQtHRYAE9dxDL/dykQ8pes
         wGCQ==
X-Gm-Message-State: AC+VfDymu58Ll398W9BID8pPWp3zRBTuvAWe5BVPes0W2UzlFnhhL3+K
        Y2EekDxXobrxPV6iOaDwQ/E3FYLDMt5FSswSGTbzPg==
X-Google-Smtp-Source: ACHHUZ68aBPq1+pd8t7jJX+EikgTxFy44YswKZMA9jVNwx2/ny9mH7rXqoBjmsz++ePauCw4EoCy7xdPcGN+yGjyQIA=
X-Received: by 2002:a17:907:7f28:b0:97e:32e:c1e with SMTP id
 qf40-20020a1709077f2800b0097e032e0c1emr5284630ejc.55.1686493420389; Sun, 11
 Jun 2023 07:23:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230611132732.1502040-1-amir73il@gmail.com>
In-Reply-To: <20230611132732.1502040-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Sun, 11 Jun 2023 16:23:29 +0200
Message-ID: <CAJfpegugmTqJ5rWycxxeQpVBmGTxSHucnQjP7ZwT3K3jMXNcnA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Handle notifications on overlayfs fake path files
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, 11 Jun 2023 at 15:27, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Miklos,
>
> The first solution that we discussed for removing FMODE_NONOTIFY
> from overlayfs real files using file_fake container got complicated.
>
> This alternative solution is less intrusive to vfs and all the vfs
> code should remian unaffected expect for the special fsnotify case
> that we want to fix.
>
> Thanks,
> Amir.
>
> Changes since v1:
> - Drop the file_fake container

Why?

Thanks,
Miklos
