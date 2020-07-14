Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB77C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 14:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F8F521973
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 14:52:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="d9SdgoaZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgGNOwj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 10:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgGNOwi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 10:52:38 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCCCC061755
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 07:52:38 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id b15so17483269edy.7
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 07:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C/oae/IUSvKQwJMbVXfq0zeu8F1Wp4FUo+2Pf0q6Fgc=;
        b=d9SdgoaZid/AsmxWi+FGN+zasN+TdkaIePuE3Hi4tOeot+WXkbWvz/twYbjo7NctLS
         H9jafz2TkidLDLQIPwxRG7EB93kT6izNcIWUxMCZ49stt3GbBaYZgR+0XxyU/7F3RJ0z
         UXZyC1O+xBUUqKDyCiKD4oHXbVhXUnwkzGEtc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C/oae/IUSvKQwJMbVXfq0zeu8F1Wp4FUo+2Pf0q6Fgc=;
        b=SLTAtOKf45puk6GSZt9V/iuYjzt02IrhAcDT+EQX8+2yIGASPPIAwPBvKsQdz14sb8
         NvSgQg6u2SqoeQNs8lsrOvBv5fb08r3rmriG3JxzUsXqmS5X5kxbq23g+fgQDBQbnjH7
         tE9o5fUfwN9psfLzBu0uZ/YsbQP94lASyxr1wNMw3rhHsAGVEdFcagJkCY5xBQBhHuF7
         OeHGO7jI2IjNCZJwU6To31TJfz5lNSxC3uSmqIHAqyDJFHMVslx4Wy7gS8ZDhVk1YDiW
         rhCrU9bYK5pYyMskZ1DOkqe6cvhs+DVqiJAOjMy22aSWzeXwU2BjF/X/brllu2Thu1j8
         v1Bg==
X-Gm-Message-State: AOAM533eFAd2Od3eXIeD0SUC38otnZwJBnlw3GWF3cWzf53T4aBx0nIE
        FikRkB6S92lJ6SH6USNxxPUVZA7MjASCG4hkyPC6tA==
X-Google-Smtp-Source: ABdhPJwybeXrdI5vcl9F3ui3XyVvg1KU0YZY7mFuplPlWqA55xHACSvVsxzPkB98pZwBjdYpqY19OjdtCE7RDOwCCW8=
X-Received: by 2002:a05:6402:1bdd:: with SMTP id ch29mr4955784edb.134.1594738357380;
 Tue, 14 Jul 2020 07:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200713141945.11719-1-amir73il@gmail.com> <20200713141945.11719-3-amir73il@gmail.com>
In-Reply-To: <20200713141945.11719-3-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 14 Jul 2020 16:52:26 +0200
Message-ID: <CAJfpegs46Mn_z_Gj9V_mE_nSvhkOySR7+R8m4_8Tv3g9F2TMSQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: fix mount option checks for nfs_export with no upperdir
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 13, 2020 at 4:19 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Without upperdir mount option, there is no index dir and the dependency
> checks nfs_export => index for mount options parsing are incorrect.
>
> Allow the combination nfs_export=on,index=off with no upperdir and move
> the check for dependency redirect_dir=nofollow for non-upper mount case
> to mount options parsing.

Okay, but does this combination make any sense?

Thanks,
Miklos
