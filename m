Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6439BC433ED
	for <linux-unionfs@archiver.kernel.org>; Wed,  7 Apr 2021 06:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C70C6139C
	for <linux-unionfs@archiver.kernel.org>; Wed,  7 Apr 2021 06:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhDGG5P (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 02:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345953AbhDGG5O (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Apr 2021 02:57:14 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A763DC06174A
        for <linux-unionfs@vger.kernel.org>; Tue,  6 Apr 2021 23:57:05 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id x16so18279265iob.1
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Apr 2021 23:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ljcvIA6a94HS1ZTLEQkeXQa5n2SBTPk6NbZOy4yvUuA=;
        b=H/+pEx5exSmSpUjPq88THosshQQ5wMYJYz0WYEKbNSxXjEIk4ZjEEVe31npQYDr4l0
         lig9PA9Eb65Y/XT6lhZq7uGZuddpFZ9fRDyAbNgBF+H0aQnL/tlStrBsnbtywMnlOxod
         Cp37bi1itTfHzGgU8Y9aoF1WP92inI+x/8GvLU8FSoDm4KWd4qn/5hQlqETznKMiQ6RO
         UUl71WIK2AxDZaETgGbgBvotGNjSXKDUWrFr66WpzaOYxLodb61QOG7xs1U13BSF/xO4
         Kw3wGL1HQu1ISFwZPTkmuR8TcqDS+m8FYD5PYq8AGQgdgsQtyyiAmLTKzRIltcJknJ5v
         D8Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ljcvIA6a94HS1ZTLEQkeXQa5n2SBTPk6NbZOy4yvUuA=;
        b=pgyGJjfkJn04Ln4nWG5qvR8n0Y2yYf6XAEkXywGP8C408JV2qOo4P+pAcdY0vRjkQk
         eeozpxghFC0GxPd7yX+ghidMfSF9HW/juGOvTe+spUPctEEhtROLmGQquLt0XmDcl6fi
         EYeHcQr5iIgDvRMhTQmM1qLHPuaRYX46Og3kzkHIbHzz+oUC6ejRBi37mSgszbRyeond
         CwLvi5tcpu+ztCflgV69PTHeOC3vMIAvbcGKVr5rikTd5Lica06kYSjpxd3anLwii2pX
         VEyyAqbo052QtoKWpL36Ks17ZJqMaifKQtPYOVw6SVHZLZlv+LGEJQTsmQebyS9A5alS
         Vahg==
X-Gm-Message-State: AOAM530ZJLM717mlPIS+k77AOhRac2xlgTLYpdfuCcS8dRr0rBYNiNj9
        ZzXofDbnWgE7YaS1SuI52ulEFQH9mz3X+7tsoJ6095Tj
X-Google-Smtp-Source: ABdhPJzlgz6qDYRDemrom++aQQdKFF+L6A4aF9Atd0PFJmPn608Hf0qsIoMFzBTzNvnnairJs61Fo9RIX/5KeCpbK6g=
X-Received: by 2002:a5e:8d01:: with SMTP id m1mr1407451ioj.72.1617778625198;
 Tue, 06 Apr 2021 23:57:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210406120245.1338326-1-cgxu519@mykernel.net> <20210406120245.1338326-2-cgxu519@mykernel.net>
In-Reply-To: <20210406120245.1338326-2-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 7 Apr 2021 09:56:54 +0300
Message-ID: <CAOQ4uxjXUOYjMNraZ+bHMrVDFy0giUmkhTGx7qiW7Jo-bEUL-Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ovl: check actual copy-up size
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 7, 2021 at 12:04 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> In order to simplify truncate operation on the file which
> only has lower, we allow specifying larger size than lower
> file when calling ovl_copy_up_data(), so we should check
> actual copy size carefully before doing copy-up.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/copy_up.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 8b92b3ba3c46..a1a9a150405a 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -156,6 +156,9 @@ static int ovl_copy_up_data(struct ovl_fs *ofs, struct path *old,
>                 goto out_fput;
>         }
>
> +       len = (len <= i_size_read(file_inode(old_file))) ? len :
> +                               i_size_read(file_inode(old_file));

use min() please.

Thanks,
Amir.
