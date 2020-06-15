Return-Path: <SRS0=WKmv=74=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB76C433DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 15 Jun 2020 16:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E651D2067B
	for <linux-unionfs@archiver.kernel.org>; Mon, 15 Jun 2020 16:46:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJNnBVNn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgFOQqJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 15 Jun 2020 12:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbgFOQqJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jun 2020 12:46:09 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51490C061A0E;
        Mon, 15 Jun 2020 09:46:09 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id b5so15948022iln.5;
        Mon, 15 Jun 2020 09:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k22YkrargwJPaS8/mNJZ89+4ClDb+tPOx9dTghtqjUw=;
        b=KJNnBVNnv9TaqVpNYYPmu9/RPpFY9JRUnu304GQ5sIXX0pQTGk8V8FPCOpIVnKNqc1
         XQZCuODtOuiK+wZdgCy4eMyQ/+16X1tcfQEViRwPNvk25SVOcD66rvKBNyNciR3OIHRh
         yESiYcUSxlbIhKf/8x4KJq5L7Vwnclczpqpa3NL8NAbJuJztW1W7PSDJQNMnefNd4GcM
         9eEU/OhoQaw7oZRepCoCYPxAxEy+8GFKOJA60GuspfKof1qkc7+zFcmXd6li5scjL86b
         nIekirqUYyjkt5RQ/MszxMlcqVhnUF7lbd890D0co9L7XhXOflP0TZhS1C6/B/Vvr32M
         895Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k22YkrargwJPaS8/mNJZ89+4ClDb+tPOx9dTghtqjUw=;
        b=ssX39uJjp4SShuUvr+FkfdBy4uolG+MjpSM4iCwBOw99y6cX7f9yZkSMVZXm532D/W
         naTip1/SGErsZI64XRnwIFykoEBcZK02QYKBHA5EZqNGHQVmN6SO9lKN2PBX6AZepLW0
         GjAXfZ9kRthwg6ZRFhRSShArTEMtcO8ocJcH2CFGUoaA6mhUs4JmoPtfPmv2JNWFXisX
         5Wqzmt8SC3V3m28efjAgBiQBwEKp/jVDcIifOyouiDEu/TxEzooMllyCpOvHWJQ4zfBz
         DXDFWQ8hDyTIpzAFbJekNE+bnF0xJLeIZc2HLuidNXUfZ2j0DJ6JTOj4/LuPYqWDz5qQ
         qCFw==
X-Gm-Message-State: AOAM532ls+rL1Ix5mtdMcPeXI96NNURhMyssf/C2gNwhvpaBTzFqr0Ob
        HTX4/wh//X7n5XmlJmbrrezF6B2R2CJ+h9q/enKveiyM
X-Google-Smtp-Source: ABdhPJxVph+Fy/dXvind+PF1wbE545q3wtZp2SGbYL3STvGlhHw+edqYspZuYjibXZlp6BBO6Mum83mcN+5appTwpII=
X-Received: by 2002:a92:5856:: with SMTP id m83mr27520452ilb.72.1592239568696;
 Mon, 15 Jun 2020 09:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200615155645.32939-1-her0gyugyu@gmail.com>
In-Reply-To: <20200615155645.32939-1-her0gyugyu@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 15 Jun 2020 19:45:57 +0300
Message-ID: <CAOQ4uxgj9L4oiPtnBArmy_VpvRwJ2OoO+7hxDpD=07xxxA+Mow@mail.gmail.com>
Subject: Re: [PATCH] ovl: inode reference leak in "ovl_is_inuse" true case.
To:     youngjun <her0gyugyu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jun 15, 2020 at 6:57 PM youngjun <her0gyugyu@gmail.com> wrote:
>
> When "ovl_is_inuse" true case, trap inode reference not put.
>
> Signed-off-by: youngjun <her0gyugyu@gmail.com>

Fixes: 0be0bfd2de9d ("ovl: fix regression caused by overlapping layers
detection")
Cc: <stable@vger.kernel.org> # v4.19+
Reviewed-by: Amir Goldstein <amir73il@gmail.com>


> ---
>  fs/overlayfs/super.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 91476bc422f9..8837fc1ec3be 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1499,8 +1499,10 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
>
>                 if (ovl_is_inuse(stack[i].dentry)) {
>                         err = ovl_report_in_use(ofs, "lowerdir");
> -                       if (err)
> +                       if (err) {
> +                               iput(trap);
>                                 goto out;
> +                       }
>                 }
>

Urgh! I moved this ovl_is_inuse() after ovl_setup_trap() for a reason, but I did
not explain why. While we are fixing the bug, it would be nice to add a comment
above ovl_setup_trap():

/*
 * Check if lower root conflicts with this overlay layers before checking
 * if it is in-use as upperdir/workdir of "another" mount, because we do
 * not bother to check in ovl_is_inuse() if the upperdir/workdir is in fact
 * in-use by our upperdir/workdir.
 */

Thanks,
Amir.
