Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6BDEB64DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 08:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjFTIs1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 04:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjFTIsZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 04:48:25 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558E6E7F
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 01:48:22 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9875c2d949eso539466266b.0
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 01:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1687250901; x=1689842901;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=razIPK/lpdfZn0t3XuiP7wMAylD2anoIuk6Yf74qblM=;
        b=OLNfNpqXqDr1cHcYeILJzVygerEzCw72/O5z/9TPkMpU1a9/Yyi1tSxKv1oCS/7Csr
         h3yUfAN66msLZcSsbJZv5YTviGrjG7UIuz81fXGxhSytfqIt0n5NKdLAHaXW6eR1peqZ
         7jUpwAkoysLx4cEqIrx8L5lFcApdRJCOfBXOU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687250901; x=1689842901;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=razIPK/lpdfZn0t3XuiP7wMAylD2anoIuk6Yf74qblM=;
        b=j6oSi7IRv5K/C+2CGewjXXSuwRhM00LQ0JIMIHVETu6YPsOLO7lP/CEaKiyaBnMpF+
         PwYb00+VypVIlk5bpFI2fqHdBsIQhBo8zHSXe2RZvDBf+sKYK/cMDRoLyvPk/E1+omIy
         cAAC/r7oIt6ysqsoOzcb2A6cy5CneCpfED+Sgra9aacp9ixwGu1fIbj0FFppCBnQB+Bo
         +FCvv1H8f7O9h55jDrqEJ2XIZStf0Tr27DHM4HhQncl9JM1UNHZXu29whTbqi5Mxtdlm
         CV92wPqLWIT9ROMxZcPyFAq0IxWi60/v2lHPxtHco0OnX2y23y7mkZnHkw1Yp04qk6PC
         uutQ==
X-Gm-Message-State: AC+VfDwEk5VjQSyOaIu+gZU4DNcIdeZcXFBRbvkz3nRf1dUOtrP8m1V+
        F2sWwSh+DTck2JBfevmBVtTGq3MS4xfIt1UmbQsvVQ==
X-Google-Smtp-Source: ACHHUZ7ZdM77oSgjmWgiS+JBX85A8nkeZK+gyK8yNWdj5jg112X6hbIlIgeBXIjuxvIszXLVK79hvAhlqeRnXsMNBEY=
X-Received: by 2002:a17:907:2d28:b0:96a:3e39:f567 with SMTP id
 gs40-20020a1709072d2800b0096a3e39f567mr13447140ejc.47.1687250900772; Tue, 20
 Jun 2023 01:48:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230617084702.2468470-1-amir73il@gmail.com> <20230617084702.2468470-5-amir73il@gmail.com>
In-Reply-To: <20230617084702.2468470-5-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 20 Jun 2023 10:48:09 +0200
Message-ID: <CAJfpegsM44b8rRhGSgUMEroyuwp_Xd16NJeT699VMAKjFfG5JA@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: store enum redirect_mode in config instead of
 a string
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 17 Jun 2023 at 10:47, Amir Goldstein <amir73il@gmail.com> wrote:

> @@ -1332,10 +1337,17 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
>         if (err) {
>                 pr_warn("failed to set xattr on upper\n");
>                 ofs->noxattr = true;
> -               if (ofs->config.index || ofs->config.metacopy) {
> -                       ofs->config.index = false;
> +               if (ovl_redirect_follow(ofs)) {
> +                       ofs->config.redirect_mode = OVL_REDIRECT_NOFOLLOW;
> +                       pr_warn("...falling back to redirect_dir=nofollow.\n");


So if there's no xattr support, then there won't be any redirects to
follow.   Is this just asserting the fact?

Should this be a separate patch?

Thanks,
Miklos
