Return-Path: <SRS0=S/v9=A2=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 346E7C433DF
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E96842065D
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:05:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="JgV4iOIW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgGOUF3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 16:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgGOUF3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Jul 2020 16:05:29 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC45C061755
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 13:05:28 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id lx13so3541462ejb.4
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 13:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OzMvMkfDTd6AdDcbBcuC5XpBj0GFl5PVI0hZTIk1jBI=;
        b=JgV4iOIWkhXmUuKnak4xxvx5F9mYaWgRMpBx50JocQnoyPgl3MmCbO3xBHtInTEGbT
         W3Mfh5D29JhvOg/hIeDz3WbF3iM8P8z6WT7D4G9fVXLy8Bm1Z6nh8xHgcr+zQ44jjQ7c
         VirCHPW+lwz08NclnhEYIuZK1krH79DEUBzjA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OzMvMkfDTd6AdDcbBcuC5XpBj0GFl5PVI0hZTIk1jBI=;
        b=oHv4OQs/o0LwjKXAyKSIJZ1/lLwJBweJ2bcOMJbU+MQP2a6jpDMUsGKXl/yyNwnEv5
         pZxxK983UPxH1vRlP/Mc0vqFPTCNcguihAYQzF50wvvh5JU4EzfPpdJUjAf07Wtt9zh4
         t3MwunLwH3MQn9DrMT+xQfuS88aFVvN6MM5lTSHMHKb9aPyNu/UTDrQwvz+d5zhhzDnm
         DBGypSOTE+qD7OWEXF6wJL2O3KN57ZGL3PxPYZf7bzBnRKlp8FMyGSiOA9xp5TUDAhbM
         3ugGTgiYUL1KNt7owjKHIQn3pM/8vXJIWz51AiHEkoiCVgCN1gHRiplHCtiigeM/7KI/
         Z6IA==
X-Gm-Message-State: AOAM532g63HfyGKqm+J23NPnZdVYRuqZJ8PzzNS72Vj977mD4ZKWhc14
        bCDmoFfY5wO9s+o20Ke3dOrVr56RaCyzCTVesIVsIg==
X-Google-Smtp-Source: ABdhPJzO5U3DlTpmicBVemcSpATrNNO3ZZYE88dCsRPLdTtAuewdl9mgr5QYBA2breYiN9AfhnNdPSJ8qCA7Y+31yUg=
X-Received: by 2002:a17:906:50a:: with SMTP id j10mr578245eja.113.1594843527539;
 Wed, 15 Jul 2020 13:05:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200713141945.11719-1-amir73il@gmail.com> <20200713141945.11719-3-amir73il@gmail.com>
In-Reply-To: <20200713141945.11719-3-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 15 Jul 2020 22:05:16 +0200
Message-ID: <CAJfpeguZ=7tkMYujjP2h2cGi7-2nnsab4rBTxse4jPOypm_+uw@mail.gmail.com>
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
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Applied, thanks.

Miklos
