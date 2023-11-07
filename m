Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82A6C4332F
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Nov 2023 19:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbjKGTyY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 14:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjKGTyY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2023 14:54:24 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6241D79
        for <linux-unionfs@vger.kernel.org>; Tue,  7 Nov 2023 11:54:21 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9a6190af24aso939929066b.0
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2023 11:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1699386860; x=1699991660; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VkTZWMBMLQYUtpSNuy5XagVZn8+B9GVBKFpPpKcdRS4=;
        b=eqc87QZVPahJ5XT4X/bPlLV4zUJeLeRzl6J2dEbou1ea6AHFYWBsbxxH1CDhUZ6o8i
         Wd5Ey7OgDOMl/bMQUaopkNI21jLpry+ynf3KydynFdrYMMnbp7fYm3Hvf3ASkRsY1MdW
         oJAcM9yQxI6kTCKCyA71oelrHy7qOPivLu6Eo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699386860; x=1699991660;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VkTZWMBMLQYUtpSNuy5XagVZn8+B9GVBKFpPpKcdRS4=;
        b=VYAXYXJNWb2HrqE7u5Zb9+ervukdQhpeFUY3pQoyqqVmsExgaKtFnUOKHrYjCLX6VS
         Qe1kX7mGC4zVVulTXCqSNz1k2JhWSvERg6hVpIwO3HMndcdWPeZCdT2OoFnoImSUgHs3
         ORIWvyD/CDYsxzzEe/LyRicgatsY74IL7uKC1qtmvdLfIrpKRl28xcXQsaF6G2XMPlDn
         n7cIGc9qxpT7wFqxdTWbbFCpIUaGl1zH3HxsvVrEsK12//71KdjuqwZqWDNCOV34/aOO
         gEwFtielNOeRy4pO00DgNW4dVhvtzoNIR3MV/9aagDTttCKb5MOCIwBZs/JBT708I9o5
         YVaQ==
X-Gm-Message-State: AOJu0YxLJz/enMbcugXav5wBh+SetaKR+qnv1HewWcg8IxnFWaF9pSQn
        23iozAK/xXZBpkn4YuuKG5OvoaXPmZWz9R5RiiI=
X-Google-Smtp-Source: AGHT+IHpXhEVuLM46TZwpoSoaWs0SXNvDgJTSdnVadNBqGrGPDnNp9oXsLc74+jjGqM08Z4IQdoNYA==
X-Received: by 2002:a17:907:9815:b0:9b2:b152:b0f2 with SMTP id ji21-20020a170907981500b009b2b152b0f2mr18466627ejc.10.1699386860341;
        Tue, 07 Nov 2023 11:54:20 -0800 (PST)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id f8-20020a170906138800b009b27d4153c0sm1409871ejc.178.2023.11.07.11.54.19
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 11:54:19 -0800 (PST)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-53d9f001b35so10286950a12.2
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2023 11:54:19 -0800 (PST)
X-Received: by 2002:a17:907:745:b0:9dd:4811:7111 with SMTP id
 xc5-20020a170907074500b009dd48117111mr13172773ejb.4.1699386858967; Tue, 07
 Nov 2023 11:54:18 -0800 (PST)
MIME-Version: 1.0
References: <20231106065045.895874-1-amir73il@gmail.com>
In-Reply-To: <20231106065045.895874-1-amir73il@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 Nov 2023 11:54:01 -0800
X-Gmail-Original-Message-ID: <CAHk-=whgCwcUGKvoZX0OSAFi9fTye3BOfOCY+wR=t7W8xS_oGQ@mail.gmail.com>
Message-ID: <CAHk-=whgCwcUGKvoZX0OSAFi9fTye3BOfOCY+wR=t7W8xS_oGQ@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs update for 6.7
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, 5 Nov 2023 at 22:50, Amir Goldstein <amir73il@gmail.com> wrote:
>
> - Overlayfs aio cleanups and fixes [1]
>
> - Overlayfs lock ordering changes [2]
>
> - Add support for nesting overlayfs private xattrs [3]
>
> - Add new mount options for appending lowerdirs [4]
>
> [1] https://lore.kernel.org/r/20230912173653.3317828-1-amir73il@gmail.com/
> [2] https://lore.kernel.org/r/20230816152334.924960-1-amir73il@gmail.com/
> [3] https://lore.kernel.org/r/cover.1694512044.git.alexl@redhat.com/
> [4] https://lore.kernel.org/r/20231030120419.478228-1-amir73il@gmail.com/

*Please* don't make me have to follow links just to see basic details.

Merge messages should stand on their own, not just point to "look,
here are the details in our lore archives". Yes, even when having
internet access is much more common, there are situations where it's
not there or is slow. Or maybe lore has issues. Or maybe people just
don't want to switch to a browser to look up details that may or may
not be relevant to them.

I copied the relevant stuff into my merge, but please don't make me do
this next time. Just give me a merge message with the details spelled
out, not some link to a cover letter for a patch series.

             Linus
